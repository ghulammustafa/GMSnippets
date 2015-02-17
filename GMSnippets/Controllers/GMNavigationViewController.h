//
//  GMNavigationViewController.h
//  GMSnippets
//
//  Created by Mustafa on 16/02/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -

@protocol GMNavigationViewControllerRotation <NSObject>

@optional

- (BOOL)shouldDisableAutorotate;

@end

#pragma mark -

@interface GMNavigationViewController : UINavigationController

@end
