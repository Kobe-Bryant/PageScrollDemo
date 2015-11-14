//
//  PPLoadingView.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "PPLoadingView.h"

@implementation PPLoadingView
@synthesize animationImageView;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initConfigure];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfigure];
    }
    return self;
}

- (void)initConfigure
{
    _hideAnimationDuration = kHideAnimationDuration;
    self.backgroundColor = [UIColor clearColor];
    [self addObserver];
}

- (void)hide
{
    [self hide:nil];
}

-(void)hide:(void (^)(BOOL))block
{
  [UIView animateWithDuration:_hideAnimationDuration animations:^{
      self.alpha = 0.0;
  } completion:^(BOOL finished) {
      [self removeFromSuperview];
      if (finished && block) {
          block(finished);
      }
    }];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (PPLoadingView*)showToView:(UIView*)view
{
    return [self showToView:view text:@""];

}

- (void)restartAnimation
{
    [self.animationImageView.layer removeAnimationForKey:@"rotationAnimation"];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * -2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 100000;
    [self.animationImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

+ (PPLoadingView *)showToView:(UIView *)view text:(NSString *)text
{
    PPLoadingView *loading=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PPLoadingView class]) owner:self options:nil] lastObject];
    [loading restartAnimation];
     [loading setFrame:view.bounds];
    [view addSubview:loading];
    return loading;
}








@end
