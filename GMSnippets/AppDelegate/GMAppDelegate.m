//
//  GMAppDelegate.m
//  GMSnippets
//
//  Created by Mustafa on 31/07/2014.
//  Copyright (c) 2014 Learning. All rights reserved.
//

#import "GMAppDelegate.h"
#import "GMViewController.h"

#import "UIViewController+Utility.h"

#pragma mark -

@implementation GMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    GMViewController *viewController = [[GMViewController alloc] initWithNibName:@"GMViewController" bundle:nil];
    viewController.title = @"Operations";
    
    self.navigationController = [[GMNavigationViewController alloc] initWithRootViewController:viewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    // For reference (only)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSLog(@"Directory Path: %@", directoryPath);
    
    NSString *privateDirectoryName = @"Private Directory";
    NSString *privateDirectoryPath = [directoryPath stringByAppendingPathComponent:privateDirectoryName];
    NSLog(@"Private Directory: %@", privateDirectoryPath);
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

#pragma mark -

@implementation GMAppDelegate (Rotation)

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    NSUInteger orientations = UIInterfaceOrientationMaskAllButUpsideDown;

    if (self.window.rootViewController) {
        id presentedViewController = [UIViewController topViewControllerForRootViewController:self.window.rootViewController];

        if (presentedViewController) {
            orientations = [presentedViewController supportedInterfaceOrientations];
        }
        
//        if ([presentedViewController respondsToSelector:@selector(shouldDisableAutorotate)]) {
//            BOOL disableAutorotation = [presentedViewController shouldDisableAutorotate];
//            
//            if (disableAutorotation) {
//                orientations = [presentedViewController supportedInterfaceOrientations];
//            }
//        }
    }

    return orientations;
}

@end