//
//  PPRefreshFooterControl.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/8.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "PPRefreshFooterControl.h"

static CGFloat const   kRefreshControlHeight    = 50.0f;

@implementation PPRefreshFooterControl

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.enabled = YES;
    
    _tipLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    [_tipLbl setText:@"Loading more"];
    _tipLbl.textColor = [UIColor blackColor];
    [_tipLbl setBackgroundColor:[UIColor clearColor]];
    [_tipLbl setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_tipLbl];
    [_tipLbl sizeToFit];
    
    UIImage* image = [UIImage imageNamed:@"loading_gray"];
    _animationImageView = [[UIImageView alloc]initWithImage:image];
    [self addSubview:_animationImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)startAnimation
{
    if (self.hidden) {
        return;
    }
    
    CABasicAnimation* rotationAnimation = (CABasicAnimation*)[_animationImageView.layer animationForKey:@"rotationAnimation"];
    if (!rotationAnimation) {
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * -2.0 ];
        rotationAnimation.duration = 1;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = 100000;
        [_animationImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
}

- (void)endAnimation
{
  [UIView animateWithDuration:0.25 animations:^{
      self.alpha = 0.0;
      
  } completion:^(BOOL finished) {
      [_animationImageView.layer removeAnimationForKey:@"rotationAnimation"];
      _isLoading = NO;
      self.hidden = YES;
    }];
}

- (void)beginRefreshing
{
    
    
    
    
    
    
}

- (void)endRefreshing
{
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}



@end
