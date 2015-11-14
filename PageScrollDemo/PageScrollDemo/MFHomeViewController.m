//
//  MFHomeViewController.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/6.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "MFHomeViewController.h"
#import "PPTapMenuView.h"
#import "UIView+Extensions.h"
#import "PPTabPageScrollView.h"
#import "UIView+Extensions.h"
#import "AppDelegate.h"
#import "PPTabMenuObject.h"
#import "PPBaseCollectionViewDataSource.h"
#import "PPEventCategoryDataSource.h"
#import "PPLoadingView.h"


@interface MFHomeViewController ()<PPTabPageScrollViewDataSource,PPTabPageScrollViewDelegate,PPTabMenuViewDelegate,PPBaseCollectionViewDataSourceAccessory>
{
    PPTapMenuView* _topTabMenuView;
    NSArray* _datas;
    PPTabPageScrollView* _tapPageScrollView;
    CGFloat _pageContentHeight;
}
@end


@implementation MFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"test";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightItems];
    
    _topTabMenuView = [[PPTapMenuView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_topTabMenuView];
    _topTabMenuView.itemDelegate = self;
    _topTabMenuView.backgroundColor = [UIColor greenColor];
    
    _tapPageScrollView = [[PPTabPageScrollView alloc]initWithFrame:CGRectMake(0, _topTabMenuView.height, _topTabMenuView.width, self.view.height-_topTabMenuView.height-64.0)];
    _tapPageScrollView.pageDataSource = self;
    _tapPageScrollView.pageDelegate = self;
    _tapPageScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tapPageScrollView];
    _pageContentHeight = _tapPageScrollView.height;
    [self setData];
}

- (void)setData
{
    NSMutableArray* lists = [NSMutableArray array];
    NSArray* values = @[@"All",@"Upcoming",@"Last Chance",@"Upcoming",@"All",@"Upcoming",@"Last Chance",@"Upcoming",@"All"];
    NSArray* keys = @[@"name",@"name",@"name",@"name",@"name",@"name",@"name",@"name",@"name"];
    for (int i = 0; i <9; i++) {
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        [dic setObject:values[i] forKey:keys[i]];
        [lists addObject:dic];
    }
    NSArray* datas = [PPTabMenuObject reformer:lists];
    [_topTabMenuView reloadDatas:datas];
    [_topTabMenuView setSelectedTap:0];
    [_tapPageScrollView reloadData:datas];
}

#pragma mark  PPTabPageScrollViewDataSource
- (UIView*)pageScrollView:(PPTabPageScrollView*)scrollView
                   atPage:(NSInteger)page
{
    PPTabPageView* pageView = [[PPTabPageView alloc]initWithFrame:CGRectZero];
    return pageView;
}

#pragma mark PPTabPageScrollViewDelegate
- (void)pageScrollView:(PPTabPageScrollView *)scrollView
  shouldReloadPageView:(UIView *)pageView
                atPage:(NSInteger)page
{
    if (pageView && [pageView isKindOfClass:[PPTabPageView class]]) {
        PPTabPageView *_pageView = (PPTabPageView *)pageView;
        if (pageView.pageInfo) {
            PPTabMenuObject* menuObject =_pageView.pageInfo;
            PPBaseCollectionViewDataSource* dataSource = _pageView.dataSource;
            if (!dataSource) {
                NSString* classString = NSStringFromClass([PPEventCategoryDataSource class]);
                [_pageView addDataSource:classString];
                dataSource = _pageView.dataSource;
            }
            if (!dataSource.isEmpty || dataSource.isRequesting) {
                return;
            }
            dataSource.dataSourceAccessory = self;
            PPLoadingView* loadingView = [PPLoadingView showToView:_pageView];
            [dataSource requestDatas:menuObject.name finished:^(BOOL result) {
                [loadingView hide];
            }];
        }
    }
}

- (void)scrollToLeadingEdge:(PPTabPageScrollView *)scrollView
{
    [self leftItemClickAction:nil];
}

- (void)pageScrollViewStoped:(PPTabPageScrollView *)scrollView
                scrollToPage:(NSInteger )page
{
    [_topTabMenuView setSelectedTap:page];
    
}

- (void)pageScrollViewScrolling:(PPTabPageScrollView*)scrollView
                      direction:(ScrollviewDirection)direction
{
    NSLog(@"direction =%d",direction);//0 right/1 left
    [_topTabMenuView contentOffsetByScrollView:scrollView];
    [self viewsAnimationDirection:CollectionViewScrollToTop]; //只要一滚动就还原tab menu的位置

}

- (void)clickTapMenuButton:(PPTapMenuButton*)button
                    object:(PPTabMenuObject*)object
                     index:(NSInteger)index
{
     [_tapPageScrollView scrollToPage:index];
}

#pragma mark PPBaseCollectionViewDataSourceAccessory

- (void)dataSourceScrollViewScrolling:(UIScrollView*)scrollView
                            verOffset:(CGFloat)verOffset
                            direction:(CollectionViewScrollToDicrection)direction
{
    //当verOffset的值为小于0的时侯表示向下滑动，大于0表示向上滑动
    //一开始就往下滑的时候就不做任何处理
    if (scrollView.contentOffset.y < 0) {
        return;
    }
    if (direction ==CollectionViewScrollToTop) {
        _topTabMenuView.y = MIN(0.0, _topTabMenuView.y-verOffset);
    }else {
        _topTabMenuView.y = MAX(_topTabMenuView.y - verOffset, -_topTabMenuView.height);
    }
    _tapPageScrollView.y = MAX(0, _topTabMenuView.y+_topTabMenuView.height);
    _tapPageScrollView.height = _pageContentHeight+ABS(_topTabMenuView.y);


}

- (void)dataSourceScrollViewScrollEnd:(UIScrollView *)scrollView
                            direction:(CollectionViewScrollToDicrection)direction
{
    [self viewsAnimationDirection:direction];
}

//滚动scrollview的时候，tabmenuview改变位置，tabpage改变高度和位置
- (void)viewsAnimationDirection:(CollectionViewScrollToDicrection)direction
{
    if (direction ==CollectionViewScrollToTop &&_topTabMenuView.y==0) {
        return;
    }
   [UIView animateWithDuration:0.08 animations:^{
       _topTabMenuView.y = (direction == CollectionViewScrollToTop)?0.0f:-_topTabMenuView.height;
       _tapPageScrollView.y = MAX(0, (_topTabMenuView.y+_topTabMenuView.height));
       _tapPageScrollView.height = _pageContentHeight+ABS(_topTabMenuView.y);
       
   }];
}

#pragma mark Private methods
- (void)setRightItems
{
    UIImage *image = [UIImage imageNamed:@"reveal_icon_more"];
    UIButton *leftBtn = [UIButton createButton:CGRectMake(0,0,21.0,21.0) action:@selector(leftItemClickAction:) delegate:self normalImage:image highlightedImage:image];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

- (void)leftItemClickAction:(UIButton*)btn
{
    [[AppDelegate appDelegate] showLeft];
}


@end
