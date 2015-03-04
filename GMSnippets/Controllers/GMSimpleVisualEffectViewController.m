//
//  GMSimpleVisualEffectViewController.m
//  GMSnippets
//
//  Created by Mustafa on 04/03/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMSimpleVisualEffectViewController.h"
#import "RMUniversalAlert.h"

#define kGMBlurViewTag 999

@interface GMSimpleVisualEffectViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionBarButtonItem;

- (IBAction)actionButtonTapped:(id)sender;

@end

@implementation GMSimpleVisualEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (IBAction)actionButtonTapped:(id)sender {
    [RMUniversalAlert showActionSheetInViewController:self
                                            withTitle:nil
                                              message:@"Select a blur effect"
                                    cancelButtonTitle:@"Cancel"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@[@"Extra Light Blur", @"Light Blur", @"Dark Blur"]
                   popoverPresentationControllerBlock:^(RMPopoverPresentationController *popover) {
                       // Do nothing!
                   }
                                             tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
                                                 
                                                 if (buttonIndex == alert.firstOtherButtonIndex) {
                                                     [self applyEffectWithStyle:UIBlurEffectStyleExtraLight];

                                                 } else if (buttonIndex == alert.firstOtherButtonIndex + 1) {
                                                     [self applyEffectWithStyle:UIBlurEffectStyleLight];

                                                 } else if (buttonIndex == alert.firstOtherButtonIndex + 2) {
                                                     [self applyEffectWithStyle:UIBlurEffectStyleDark];
                                                 }
                                             }];
}

#pragma mark -

- (void)applyEffectWithStyle:(UIBlurEffectStyle)effectStyle {
    UIView *blurView = [self.imageView viewWithTag:kGMBlurViewTag];
    
    if (blurView) {
        [blurView removeFromSuperview];
    }
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:effectStyle];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.tag = kGMBlurViewTag;
    
    visualEffectView.frame = self.imageView.bounds;
    [self.imageView addSubview:visualEffectView];
}

@end
