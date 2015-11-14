//
//  MFBaseNavigationController.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "MFBaseNavigationController.h"
#import "marco.h"
#import "UIImage+Extensions.h"



@interface MFBaseNavigationController ()

@end

@implementation MFBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置Nav背景色
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationBar setTranslucent:NO];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage imageWithColor:RGB(228, 232, 230, 1.0) size:CGSizeMake(0.5,0.5)];
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
