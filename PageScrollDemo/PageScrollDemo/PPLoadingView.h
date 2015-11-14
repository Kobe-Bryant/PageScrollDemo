//
//  PPLoadingView.h
//  PageScrollDemo
//
//  Created by patpat on 15/9/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kHideAnimationDuration = 0.25;

@interface PPLoadingView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;
@property(nonatomic,readonly)CGFloat hideAnimationDuration;

- (void)hide;

- (void)hide:(void(^)(BOOL finished))block;

+ (PPLoadingView*)showToView:(UIView*)view;

+ (PPLoadingView *)showToView:(UIView *)view text:(NSString *)text;

@end
