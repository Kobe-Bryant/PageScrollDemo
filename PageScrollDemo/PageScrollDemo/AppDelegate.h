//
//  AppDelegate.h
//  PageScrollDemo
//
//  Created by patpat on 15/9/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"
#import "MFHomeViewController.h"
#import "MFBaseNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,PPRevealSideViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) PPRevealSideViewController* revealSideController;
@property (strong, nonatomic) MFBaseNavigationController *navigationController;
@property (strong, nonatomic) MFHomeViewController *homeController;

+(AppDelegate *)appDelegate;

- (void)showLeft;

- (void)showRight;





@end

