//
//  UIViewController+Utility.m
//  GMSnippets
//
//  Created by Mustafa on 16/02/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UIViewController (Utility)

+ (UIViewController *)topViewControllerForRootViewController:(UIViewController *)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [UIViewController topViewControllerForRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [UIViewController topViewControllerForRootViewController:navigationController.visibleViewController];
        
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [UIViewController topViewControllerForRootViewController:presentedViewController];
    }
    
    return rootViewController;
}

@end
