//
//  PPTabPageView.m
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "PPTabPageView.h"
#import <objc/runtime.h>


@implementation UIView(PPTabPageView)
@dynamic pageInfo;

- (NSObject *)pageInfo {
    
    return objc_getAssociatedObject(self, @selector(pageInfo));
}

- (void)setPageInfo:(NSObject *)value {
    objc_setAssociatedObject(self, @selector(pageInfo), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation PPTabPageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addDataSource:(NSString*)classString
{
    if (!_dataSource) {
        [self loadCollectionView];
        _dataSource = [[NSClassFromString(classString) alloc] initWithCollectionView:self.collectionView];
    }
}

- (void)loadCollectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layOut = [[UICollectionViewFlowLayout alloc]init];
        layOut.minimumInteritemSpacing = 1.0f;
        [layOut setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layOut];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundView = nil;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_collectionView];
        _collectionView.alwaysBounceVertical = YES;
        
        _refrenshControl = [[UIRefreshControl alloc]init];
        [_refrenshControl addTarget:self action:@selector(pullRefresh) forControlEvents:UIControlEventValueChanged];
        [_collectionView addSubview:_refrenshControl];
    
    }
}

- (void)pullRefresh
{
    if (_dataSource) {
    [_dataSource refreshRequest:^(BOOL result) {
          [_refrenshControl endRefreshing];
     }];
        
    }else {
       [_refrenshControl endRefreshing];
    }
}


@end
