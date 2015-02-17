//
//  GMNavigationViewController.m
//  GMSnippets
//
//  Created by Mustafa on 16/02/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMNavigationViewController.h"

@interface GMNavigationViewController ()

@end

@implementation GMNavigationViewController

//- (BOOL)shouldAutorotate {
//    id currentViewController = self.topViewController;
//    
//    if ([currentViewController respondsToSelector:@selector(shouldDisableAutorotate)]) {
//        return ![currentViewController shouldDisableAutorotate];
//    }
//    
//    return YES;
//}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
