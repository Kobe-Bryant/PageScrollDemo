//
//  AppDelegate.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "AppDelegate.h"
#import "MFHomeViewController.h"
#import "MFMoreViewController.h"


#define kLeftMoreControllerWidth 290

@interface AppDelegate ()
{
    MFMoreViewController* _moreController;

}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initAllController];
    
    
    return YES;
}

#pragma mark Public method
+(AppDelegate *)appDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
 
}

#pragma mark Private method

- (void)initAllController
{
   
    _homeController = [[MFHomeViewController alloc]init];
    _navigationController  = [[MFBaseNavigationController alloc]initWithRootViewController:_homeController];
    
    _revealSideController = [[PPRevealSideViewController alloc]initWithRootViewController:_navigationController];
    [_revealSideController setDirectionsToShowBounce:PPRevealSideDirectionLeft];
    _revealSideController.options = PPRevealSideOptionsNoStatusBar|PPRevealSideOptionsShowShadows;
    _revealSideController.delegate = self;
    
    _moreController = [[MFMoreViewController alloc]init];
    MFBaseNavigationController* baseController = [[MFBaseNavigationController alloc]initWithRootViewController:_moreController];
    [_revealSideController preloadViewController:baseController forSide:PPRevealSideDirectionLeft withOffset:_revealSideController.view.frame.size.width - kLeftMoreControllerWidth];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = _revealSideController;
    [self.window makeKeyAndVisible];
    
}

- (void)showLeft
{
    CGFloat offset = _revealSideController.view.frame.size.width-kLeftMoreControllerWidth;
    [_revealSideController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:offset animated:YES];
  
}

- (void)showRight
{


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
