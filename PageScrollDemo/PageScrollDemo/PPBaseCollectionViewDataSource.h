//
//  PPBaseCollectionViewDataSource.h
//  PageScrollDemo
//
//  Created by patpat on 15/9/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPRefreshFooterControl.h"

@protocol PPBaseCollectionViewDataSourceAccessory;

typedef enum {
 
  CollectionViewScrollToTop,
  CollectionViewScrollToBottom
    
}CollectionViewScrollToDicrection;


@interface PPBaseCollectionViewDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    CollectionViewScrollToDicrection _scrollingDicrection;
    BOOL _isLoadingMore;
    BOOL _isDragging;
    CGFloat _lastContentOffsetY;
}

@property(nonatomic,strong) NSMutableArray* dataSource;
@property(nonatomic,assign) UICollectionView* collectionView;
@property(nonatomic,assign) id<PPBaseCollectionViewDataSourceAccessory>dataSourceAccessory;
@property(nonatomic,strong) PPRefreshFooterControl* footerRefreshControl;


-(instancetype)initWithCollectionView:(UICollectionView*)view;

- (void)setCollectionView:(UICollectionView *)collectionView;

- (void)requestDatas:(id)params
            finished:(void(^)(BOOL result))block;

- (void)refreshRequest:(void(^)(BOOL result))block;

- (void)loadMoreRequest:(void(^)(BOOL result))block;

- (BOOL)isEmpty;

- (BOOL)isRequesting;

- (void)destroy;

@end

@protocol PPBaseCollectionViewDataSourceAccessory<NSObject>

@optional

- (void)dataSourceScrollViewScrolling:(UIScrollView*)scrollView
                            verOffset:(CGFloat)verOffset
                            direction:(CollectionViewScrollToDicrection)direction;

- (void)dataSourceScrollViewScrollEnd:(UIScrollView *)scrollView
                            direction:(CollectionViewScrollToDicrection)direction;


@end











