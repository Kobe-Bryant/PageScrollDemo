//no
//  PPRefreshFooterControl.h
//  PageScrollDemo
//
//  Created by patpat on 15/9/8.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPRefreshFooterControl : UIControl
{
    BOOL _isLoading;
    

}
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) UILabel* tipLbl;
@property(nonatomic,strong) UIImageView* animationImageView;

//开始刷新
- (void)beginRefreshing;

//结束刷新
- (void)endRefreshing;


@end
