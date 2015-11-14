//
//  PPTapMenuButton.m
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "PPTapMenuButton.h"
#import "UIView+Extensions.h"


@implementation PPTapMenuButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        _tapTitleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tapTitleLbl.font = [UIFont systemFontOfSize:14];
        _tapTitleLbl.textColor = [UIColor blackColor];
        _tapTitleLbl.textAlignment = NSTextAlignmentCenter;
        _tapTitleLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:_tapTitleLbl];
        [self setTapSelected:NO];
    }
    
    return self;
}

-(void)setTabTitle:(NSString *)title
{
    _tapTitleLbl.text = title;
    [_tapTitleLbl sizeToFit];
    _tapTitleLbl.width = _tapTitleLbl.width+10;
    self.width = _tapTitleLbl.width+20.0;
    _tapTitleLbl.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)setTapSelected:(BOOL)isSelected
{
    if (isSelected) {
        _tapTitleLbl.textColor = [UIColor redColor];
      }else {
        _tapTitleLbl.textColor = [UIColor blackColor];
      }
}


@end
