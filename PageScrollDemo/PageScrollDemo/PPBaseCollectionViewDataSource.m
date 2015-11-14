//
//  PPBaseCollectionViewDataSource.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "PPBaseCollectionViewDataSource.h"

@implementation PPBaseCollectionViewDataSource

-(instancetype)initWithCollectionView:(UICollectionView*)view
{
    self = [super init];
    if (self) {
        [self setCollectionView:view];
        _footerRefreshControl = [[PPRefreshFooterControl alloc]init];
        [_footerRefreshControl addTarget:self action:@selector(loadMoreRefresh) forControlEvents:UIControlEventValueChanged];
        [_collectionView addSubview:_footerRefreshControl];
    }
    return self;
}

- (void)loadMoreRefresh
{
    [self loadMoreRequest:^(BOOL result) {
        [_footerRefreshControl endRefreshing];
    }];
}

- (void)setCollectionView:(UICollectionView *)collectionView
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    [_dataSource removeAllObjects];
    _collectionView = collectionView;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView reloadData];
    
}

#pragma mark -- UICollectionViewDataSource

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataSource.count;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *datas = _dataSource[section];
    return datas.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)_collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionView被选中时调用的方法
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)_collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeZero;
}

//定义每个UICollectionView 的 section之间 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (BOOL)isEmpty
{
   return self.dataSource.count>0?NO:YES;
}

- (BOOL)isRequesting
{
    return NO;

}

- (void)destroy
{


}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isDragging = YES;
    _lastContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isDragging) {
        return;
    }
   _scrollingDicrection = [self direction:scrollView];
  //当_collectionView.contentOffset.y - _lastContentOffsetY的值为小于0的时侯表示向下滑动，大于0表示向上滑动
    if (self.dataSourceAccessory && [self.dataSourceAccessory respondsToSelector:@selector(dataSourceScrollViewScrolling:verOffset:direction:)]) {
        [self.dataSourceAccessory dataSourceScrollViewScrolling:_collectionView verOffset:_collectionView.contentOffset.y-_lastContentOffsetY direction:_scrollingDicrection];
    }
    _lastContentOffsetY = scrollView.contentOffset.y;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
     _isDragging = NO;
    if (self.dataSourceAccessory && [self.dataSourceAccessory respondsToSelector:@selector(dataSourceScrollViewScrollEnd:direction:)]) {
        [self.dataSourceAccessory dataSourceScrollViewScrollEnd:scrollView direction:_scrollingDicrection];
    }
}

- (CollectionViewScrollToDicrection)direction:(UIScrollView *)scrollView
{
    CollectionViewScrollToDicrection direction = CollectionViewScrollToBottom;
    if (_lastContentOffsetY > scrollView.contentOffset.y) {
        direction = CollectionViewScrollToTop;
    }else if (_lastContentOffsetY < scrollView.contentOffset.y){
        direction = CollectionViewScrollToBottom;
    }
    return direction;
}

#pragma mark Request
- (void)requestDatas:(id)params
            finished:(void(^)(BOOL result))block
{
    //rewrite subclass
}

- (void)refreshRequest:(void(^)(BOOL result))block
{
    //rewrite subclass
}

- (void)loadMoreRequest:(void(^)(BOOL result))block
{
    //rewrite subclass
}


@end
