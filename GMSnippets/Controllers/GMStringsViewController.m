//
//  GMStringsViewController.m
//  GMSnippets
//
//  Created by Mustafa on 04/03/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMStringsViewController.h"

#import "RMUniversalAlert.h"

@interface GMStringsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;

@end

@implementation GMStringsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    NSString *htmlString = @"&#63743; &amp; &#38; &lt; &gt; &trade; &copy; &hearts; &clubs; &spades; &diams;";
    self.inputTextView.text = htmlString;
    
    // Add action bar button
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                  target:self
                                                                                  action:@selector(actionButtonTapped:)];
    self.navigationItem.rightBarButtonItem = actionButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (IBAction)actionButtonTapped:(id)sender {
    [self.view endEditing:YES];
    
    [RMUniversalAlert showActionSheetInViewController:self
                                            withTitle:nil
                                              message:@"Select an action to perform"
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@[@"Convert HTML to Text", @"Convert Text to HTML"]
                   popoverPresentationControllerBlock:^(RMPopoverPresentationController *popover) {
                       // Do nothing!
                   } tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {

                       if (buttonIndex == alert.firstOtherButtonIndex) {
                           self.outputTextView.attributedText = [self attributedStringFromHTML:self.inputTextView.text];

                       } else if (buttonIndex == alert.firstOtherButtonIndex + 1) {
                           self.outputTextView.text = [self htmlStringFromAttributedString:self.inputTextView.attributedText];
                       }
                   }];
}

#pragma mark -

- (NSAttributedString *)attributedStringFromHTML:(NSString *)htmlString {
    NSData *stringData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:stringData
                                                                            options:options
                                                                 documentAttributes:NULL
                                                                              error:NULL];
    
    return attributedString;
}

- (NSString *)htmlStringFromAttributedString:(NSAttributedString *)attributedString {
    NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
    NSData *htmlData = [attributedString dataFromRange:NSMakeRange(0, attributedString.length) documentAttributes:documentAttributes error:NULL];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    return htmlString;
}

@end
