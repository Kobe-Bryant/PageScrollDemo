//
//  PPTabPageView.h
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PPTabMenuObject.h"
#import "PPBaseCollectionViewDataSource.h"


@interface UIView (PPTabPageView)
@property(nonatomic,strong) id pageInfo;

@end

@interface PPTabPageView : UIView
@property(nonatomic,strong) UIRefreshControl* refrenshControl;
@property(nonatomic,strong) PPBaseCollectionViewDataSource* dataSource;
@property(nonatomic,strong) PPTabMenuObject* menuObject;
@property(nonatomic,strong,readonly)UICollectionView *collectionView;

-(instancetype)initWithFrame:(CGRect)frame;

- (void)addDataSource:(NSString*)classString;


@end
