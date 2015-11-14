//
//  PPTapMenuView.h
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTabMenuObject.h"
#import "PPTapMenuButton.h"

@protocol PPTabMenuViewDelegate <NSObject>

@optional
- (void)clickTapMenuButton:(PPTapMenuButton*)button
                    object:(PPTabMenuObject*)object
                     index:(NSInteger)index;

@end


@interface PPTapMenuView : UIScrollView<UIScrollViewDelegate>
@property(nonatomic,assign) id<PPTabMenuViewDelegate>itemDelegate;
@property(nonatomic,strong) UIFont* font;

//add items
- (void)reloadDatas:(NSArray*)items;

- (void)setSelectedTap:(NSInteger)tab;

//scrollview联动
- (void)contentOffsetByScrollView:(UIScrollView*)scrollView;

@end
