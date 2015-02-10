//
//  GMCrasherViewController.m
//  GMSnippets
//
//  Created by Mustafa on 10/02/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMCrasherViewController.h"


#pragma mark -

@interface GMCrasherViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *triggerCrashButton;
@property (weak, nonatomic) IBOutlet UIButton *emailCrashReportButton;
@property (weak, nonatomic) IBOutlet UITextView *summaryTextView;

- (IBAction)triggerCrashButtonTapped:(id)sender;
- (IBAction)emailCrashReportButtonTapped:(id)sender;

@end


#pragma mark -

@implementation GMCrasherViewController

#pragma mark -
#pragma mark NSObject methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        // Initialization
    }
    
    return self;
}

- (void)dealloc {
    // Cleanup
}


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup SuperLogger
    [SuperLogger sharedInstance];
    [[SuperLogger sharedInstance] redirectNSLogToDocumentFolder];
    [SuperLogger sharedInstance].mailTitle = @"Crash Report";
    [SuperLogger sharedInstance].mailContect = @"";
    [SuperLogger sharedInstance].mailRecipients = @[@"support@company.com"];

    // Setup crash reporter
    // Developer's Note: In the "real world" (in actual application), this setup should be performed on application launch
    [self setupCrashReporter];
    
    // SuperLogger integration
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"SuperLogger"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(showSuperLogger:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark -
#pragma mark IBAction methods

- (IBAction)showSuperLogger:(id)sender {
    [self presentViewController:[[SuperLogger sharedInstance] getListView]
                       animated:YES
                     completion:nil];
}

- (IBAction)triggerCrashButtonTapped:(id)sender {
    [RMUniversalAlert showActionSheetInViewController:self
                                            withTitle:@"Action"
                                              message:@"Choose the action you want the take."
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@[@"Assert Crash",
                                                        @"Release Crash",
                                                        @"Bad Access Crash",
                                                        @"Range Exception Crash",
                                                        @"NSException Crash"]
                   popoverPresentationControllerBlock:nil
                                             tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
                                                 
                                                 if (buttonIndex == alert.cancelButtonIndex) {
                                                     NSLog(@"Cancel button tapped");
                                                     
                                                 } else if (buttonIndex == alert.destructiveButtonIndex) {
                                                     NSLog(@"Delete button tapped");
                                                     
                                                 } else if (buttonIndex >= alert.firstOtherButtonIndex) {
                                                     NSInteger otherButtonIndex = (long)buttonIndex - alert.firstOtherButtonIndex;
                                                     NSLog(@"Other Button Index %ld", otherButtonIndex);
                                                     
                                                     if (otherButtonIndex == 0) {
                                                         [self triggerAssertCrash];
                                                         
                                                     } else if (otherButtonIndex == 1) {
                                                         [self triggerReleaseCrash];
                                                         
                                                     } else if (otherButtonIndex == 2) {
                                                         [self triggerBadAccessCrash];
                                                         
                                                     } else if (otherButtonIndex == 3) {
                                                         [self triggerRangeExceptionCrash];
                                                         
                                                     } else if (otherButtonIndex == 4) {
                                                         [self triggerGenericExceptionCrash];
                                                     }
                                                 }
                                             }];
}

- (IBAction)emailCrashReportButtonTapped:(id)sender {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"log.crash"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    if (fileData) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        [picker setSubject:@"Crash Report"];
        [picker setToRecipients:@[@"support@company.com"]];
        [picker addAttachmentData:fileData mimeType:@"application/text" fileName:@"log.crash"];
        [picker setToRecipients:[NSArray array]];
        [picker setMessageBody:@"" isHTML:NO];
        [picker setMailComposeDelegate:self];
        
        @try {
            [self presentViewController:picker animated:YES completion:nil];
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
    
    } else {
        [RMUniversalAlert showAlertInViewController:self
                                          withTitle:@"Email"
                                            message:@"No crash log found"
                                  cancelButtonTitle:@"OK"
                             destructiveButtonTitle:nil
                                  otherButtonTitles:nil
                                           tapBlock:NULL];
    }
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark PLCrashReporter methods

//
// Setup a crash reporter
//
- (void)setupCrashReporter {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    
    // Check if we previously crashed
    if ([crashReporter hasPendingCrashReport]) {
        [self handleCrashReport];
    }
    
    // Enable the Crash Reporter
    if (![crashReporter enableCrashReporterAndReturnError:&error]) {
        NSLog(@"Warning: Could not enable crash reporter: %@", error);
    }
}

//
// Called to handle a pending crash report.
//
- (void)handleCrashReport {
    NSMutableString *log = [NSMutableString string];
    
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError:&error];
    
    if (crashData == nil) {
        NSLog(@"Warning: Could not load crash report: %@", error);
        [log appendFormat:@"Warning: Could not load crash report: %@\n", error];
        
    } else {
        // We could send the report from here, but we'll just print out
        // some debugging info instead
        PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];
        
        if (report == nil) {
            NSLog(@"Warning: Could not parse crash report");
            [log appendString:@"Warning: Could not parse crash report\n"];
            
        } else {
            NSString *humanReadable = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];

            NSLog(@"Last crashed on %@", report.systemInfo.timestamp);
            NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name, report.signalInfo.code, report.signalInfo.address);
            NSLog(@"\n%@", humanReadable);

            [log appendFormat:@"Last crashed on: %@\n", report.systemInfo.timestamp];
            [log appendFormat:@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")\n", report.signalInfo.name, report.signalInfo.code, report.signalInfo.address];
            [log appendFormat:@"\n%@\n", humanReadable];

            // Write to disk
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"log.crash"];
            
            NSError *error = nil;
            BOOL returnValue = [humanReadable writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            if (returnValue) {
                NSLog(@"Report written to disk successfully: %@", filePath);
                [log appendFormat:@"Report written to disk successfully: %@", filePath];

            } else if (error) {
                NSLog(@"Warning: Error occurred while writing file to disk.\nError: %@ \nFile Path: %@", [error localizedDescription], filePath);
                [log appendFormat:@"Warning: Error occurred while writing file to disk.\nError: %@ \nFile Path: %@", [error localizedDescription], filePath];
            }
            
            // Send report to server (if required, in-case of "auto")
            // Do whatever!

            // Purge the report
            // [crashReporter purgePendingCrashReport];
        }
    }
    
    // Show log summary
    [self logString:log];
    
    return;
}

- (void)logString:(NSString *)summary {
    NSMutableString *output = [NSMutableString stringWithFormat:@"%@\n\n%@\n", [NSDate date], summary];
    self.summaryTextView.text = [NSString stringWithFormat:@"%@%@", output, self.summaryTextView.text];
    
    [self.summaryTextView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (void)triggerReleaseCrash {
    /* Trigger a crash */
    CFRelease(NULL);
}

- (void)triggerRangeExceptionCrash {
    /* Trigger a crash */
    NSArray *array = [NSArray array];
    [array objectAtIndex:23];
}

- (void)triggerAssertCrash {
    assert(NO);
}

- (void)triggerBadAccessCrash {
    int* p = 0;
    *p = 0;
}

- (void)triggerGenericExceptionCrash {
    @throw [NSException exceptionWithName:NSGenericException reason:@"" userInfo:nil];
}

@end
