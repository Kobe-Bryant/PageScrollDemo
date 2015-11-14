//
//  PPTapMenuButton.h
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kPPTabMenuButtonTitleLeadingSpace = 10.0f;

@interface PPTapMenuButton : UIButton
@property(nonatomic,strong) UILabel* tapTitleLbl;

- (void)setTabTitle:(NSString*)title;

- (void)setTapSelected:(BOOL)isSelected;


@end
