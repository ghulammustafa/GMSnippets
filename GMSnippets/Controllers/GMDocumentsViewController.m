//
//  GMDocumentsViewController.m
//  GMSnippets
//
//  Created by Mustafa on 02/12/2014.
//  Copyright (c) 2014 Learning. All rights reserved.
//

#import "GMDocumentsViewController.h"

#import "AFNetworking.h"
#import "TOWebViewController.h"
#import "MBProgressHUD.h"

#define kGMUIDocumentInteractionController NO
#define kGMFileURLString @"http://partners.adobe.com/public/developer/en/xml/AdobeXMLFormsSamples.pdf"

#pragma mark -

@interface GMDocumentsViewController () <UIDocumentInteractionControllerDelegate> {
    UIStatusBarStyle _currentStatusBarStyle;
}

@property (nonatomic) BOOL allowReadonlyAccess;

- (IBAction)showDocument:(id)sender;

@end

#pragma mark -

@implementation GMDocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.allowReadonlyAccess = !kGMUIDocumentInteractionController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Action methods

- (IBAction)showDocument:(id)sender {
    NSString *fileURLString = kGMFileURLString;
    [self downloadFile:fileURLString];
}

#pragma mark Helper methods

- (void)downloadFile:(NSString *)filePath {
    NSString *encodedFilePath = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedFilePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[url lastPathComponent]];
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    
    __weak typeof(self)weakSelf = self;
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
    progressHUD.labelText = NSLocalizedString(@"Downloading File...", nil);
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        /// DEBUG_NSLog(@"bytesRead: %lu, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", (unsigned long)bytesRead, totalBytesRead, totalBytesExpectedToRead);
        progressHUD.progress = totalBytesRead/totalBytesExpectedToRead;
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        /// DEBUG_NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        
        if (!error) {
            NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
            long long fileSize = [fileSizeNumber longLongValue];
            [weakSelf openFile:fullPath];
            
        } else {
            /// DEBUG_NSLog(@"ERR: %@", [error description]);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        /// DEBUG_NSLog(@"ERR: %@", [error description]);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    [operation start];
}

- (void)openFile:(NSString *)filePath {
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];
    
    if (self.allowReadonlyAccess) {
        // The only readon for using TOWebViewController instead of UIDocumentInteractionController is to restruct the operations that a user can perform i.e. copy, print, etc
        TOWebViewController *viewController = [[TOWebViewController alloc] initWithURL:targetURL];
        viewController.title = [filePath lastPathComponent];
        viewController.navigationButtonsHidden = YES;
        viewController.showPageTitles = NO;
        viewController.disableContextualPopupMenu = YES;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];        
        [self presentViewController:navigationController animated:YES completion:nil];
        
    } else {
        // Important Note: Only local files are supported!
        UIDocumentInteractionController *documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:targetURL];
        documentInteractionController.delegate = self;
        
        BOOL present = [documentInteractionController presentPreviewAnimated:YES];
        
        if (!present) {
            // Allow user to open the file in external editor (if possible)
            CGRect rect = CGRectMake(0.0, 0.0, self.view.frame.size.width, 10.0f);
            present = [documentInteractionController presentOpenInMenuFromRect:rect inView:self.view animated:YES];
            
            if (!present) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Cannot preview or open the selected file"
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

#pragma mark -
#pragma mark UIDocumentInteractionControllerDelegate methods

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

// Preview presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller {
    _currentStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    [[UIApplication sharedApplication] setStatusBarStyle:_currentStatusBarStyle animated:NO];
}

// Options menu presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller {
    _currentStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller {
    [[UIApplication sharedApplication] setStatusBarStyle:_currentStatusBarStyle animated:NO];
}

// Open in menu presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
    _currentStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    [[UIApplication sharedApplication] setStatusBarStyle:_currentStatusBarStyle animated:NO];
}

@end
