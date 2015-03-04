//
//  GMDismissSegue.m
//  GMSnippets
//
//  Created by Mustafa on 04/03/2015.
//  Copyright (c) 2015 Learning. All rights reserved.
//

#import "GMDismissSegue.h"

@implementation GMDismissSegue

- (void)perform {
    UIViewController *controller = self.sourceViewController;
    [controller.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
