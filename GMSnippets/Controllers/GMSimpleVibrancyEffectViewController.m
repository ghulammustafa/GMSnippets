//
//  GMSimpleVibrancyEffectViewController.m
//  GMSnippets
//
//  Created by Mustafa on 05/03/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMSimpleVibrancyEffectViewController.h"

#import "RMUniversalAlert.h"

#define kGMBlurViewTag      998
#define kGMVibrancyViewTag  997

@interface GMSimpleVibrancyEffectViewController () {
    UIBlurEffectStyle _effectStyle;
}

@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UILabel *subheadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionBarButtonItem;

- (IBAction)actionButtonTapped:(id)sender;

@end

@implementation GMSimpleVibrancyEffectViewController

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

- (void)applyEffectWithStyle:(UIBlurEffectStyle)effectStyle {
    _effectStyle = effectStyle;
    
    UIView *blurView = [self.imageView viewWithTag:kGMBlurViewTag];
    
    if (blurView) {
        [blurView removeFromSuperview];
    }

    UIView *vibrancyView = [self.imageView viewWithTag:kGMVibrancyViewTag];
    
    if (vibrancyView) {
        [vibrancyView removeFromSuperview];
    }

    // Blue effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:effectStyle];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.tag = kGMBlurViewTag;
    
    blurEffectView.frame = self.imageView.bounds;
    [self.imageView addSubview:blurEffectView];

    // Vibrancy effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];

    vibrancyEffectView.tag = kGMVibrancyViewTag;
    vibrancyEffectView.frame = self.imageView.bounds;
    
    [self.imageView addSubview:vibrancyEffectView];
    
    // Label
    NSString *labelString = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(vibrancyEffectView.bounds, 10.0, 10.0)];
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:20.0f];
    label.text = labelString;
    
    [vibrancyEffectView.contentView addSubview:label];
}

@end
