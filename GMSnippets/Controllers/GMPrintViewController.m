//
//  GMPrintViewController.m
//  GMSnippets
//
//  Created by Mustafa on 02/12/2014.
//  Copyright (c) 2014 Learning. All rights reserved.
//

#import "GMPrintViewController.h"

#import "RMUniversalAlert.h"

#define kGMWebPageURLString @"http://www.apple.com/startpage/index.html"

#pragma mark -

@interface GMPrintViewController () <UIPrintInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *htmlString;
@property (strong, nonatomic) NSString *documentName;

@end

#pragma mark -

@implementation GMPrintViewController

#pragma mark -
#pragma mark View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add right bar button
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                    target:self
                                                                                    action:@selector(actionButtonTapped:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    // Load HTML
    NSString *urlString = kGMWebPageURLString;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Action methods

- (void)actionButtonTapped:(id)sender {
    [RMUniversalAlert showActionSheetInViewController:self
                                            withTitle:@"Action"
                                              message:@"Choose the action you want the take."
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@[@"Print RAW HTML", @"Print UIWebView"]
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
                                                         [self printHTML:nil];
                                                         
                                                     } else if (otherButtonIndex == 1) {
                                                         [self printWebPage:nil];
                                                     }
                                                 }
                                             }];

}

- (void)printHTML:(id)sender {
    NSString *urlString = kGMWebPageURLString;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSError *error = nil;
    NSString *htmlString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    
    self.documentName = @"Web Page";
    self.htmlString = htmlString;
    
    [self printContent:nil];
}

- (IBAction)printContent:(id)sender {
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = self.documentName;
    pic.printInfo = printInfo;
    
    UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:self.htmlString];
    htmlFormatter.startPage = 0;
    htmlFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    pic.printFormatter = htmlFormatter;
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [pic presentFromBarButtonItem:sender animated:YES completionHandler:completionHandler];
    } else {
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
}

- (void)printWebPage:(id)sender {
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];

    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"FAILED! due to error in domain %@ with error code %ld",
                  error.domain, (long)error.code);
        }
    };
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Web Page";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    controller.printInfo = printInfo;
    controller.showsPageRange = YES;
    
    UIViewPrintFormatter *viewFormatter = [self.webView viewPrintFormatter];
    viewFormatter.startPage = 0;
    controller.printFormatter = viewFormatter;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [controller presentFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES completionHandler:completionHandler];
        
    } else {
        [controller presentAnimated:YES completionHandler:completionHandler];
    }
}

#pragma mark -

#pragma mark -
#pragma mark UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}


#pragma mark -
#pragma mark UIPrintInteractionControllerDelegate methods

//- (UIViewController *)printInteractionControllerParentViewController:(UIPrintInteractionController *)printInteractionController {
//    return nil;
//}
//
//- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray *)paperList {
//    return nil;
//}

- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __FUNCTION__);
}

- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __FUNCTION__);
}

- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __FUNCTION__);
}

- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __FUNCTION__);
}

- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __FUNCTION__);
}

- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController {
    NSLog(@"%s", __FUNCTION__);
}

//- (CGFloat)printInteractionController:(UIPrintInteractionController *)printInteractionController cutLengthForPaper:(UIPrintPaper *)paper  {
//}

@end
