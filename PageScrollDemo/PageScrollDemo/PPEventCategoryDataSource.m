//
//  PPEventCategoryDataSource.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "PPEventCategoryDataSource.h"
#import "PPEventItemCell.h"

@interface PPEventCategoryDataSource()
{
    BOOL _isRequesting;
}
@end

@implementation PPEventCategoryDataSource

-(instancetype)initWithCollectionView:(UICollectionView *)view
{
    self = [super initWithCollectionView:view];
    if (self) {
      [view registerNib:[PPEventItemCell nib] forCellWithReuseIdentifier:[PPEventItemCell reuseIdentifier]];
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPEventItemCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:[PPEventItemCell reuseIdentifier] forIndexPath:indexPath];
      return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [PPEventItemCell  cellSizeWithWidth:collectionView.frame.size.width];
    
}

//定义每个UICollectionView 的 section之间 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

//左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
     return  nil;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastSectionIndex = [collectionView numberOfSections]-1;
    NSInteger lastRowIndex = [collectionView numberOfItemsInSection:lastSectionIndex] - 1;
    if ((indexPath.section ==lastSectionIndex) &&(indexPath.row==lastRowIndex)) {
        [self.footerRefreshControl beginRefreshing];
    }
}

- (void)requestDatas:(id)params
            finished:(void(^)(BOOL result))block
{
    if (_isRequesting) {
        block(NO);
        return;
    }
    _isRequesting = YES;
    [self performSelector:@selector(reloadData:) withObject:block afterDelay:1.0];
}

- (void)reloadData:(void(^)(BOOL result))block
{
    
    if (!_isLoadingMore) {
        [self.dataSource removeAllObjects];
    }
    if (self.collectionView.alpha < 0.1) {
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.collectionView.alpha = 1.0f;
                         } completion:nil];
    }
    _isRequesting = NO;
    NSArray* array = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"" ,nil];
    [self.dataSource addObjectsFromArray:array];
    [self.collectionView reloadData];
    block(YES);
}

- (BOOL)isRequesting
{
    return _isRequesting;
}

- (void)refreshRequest:(void(^)(BOOL result))block
{
    [self beginRequest:NO blcok:block];
}

- (void)loadMoreRequest:(void(^)(BOOL result))block
{
    [self beginRequest:YES blcok:block];
}

- (void)beginRequest:(BOOL)isLoadmore
               blcok:(void(^)(BOOL result))block
{
    if (_isRequesting) {
        block(NO);
        return;
    }
    _isLoadingMore = isLoadmore;
    [self requestDatas:nil finished:block];
}





@end
