//
//  PPTabPageScrollView.m
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "PPTabPageScrollView.h"
#import "UIView+Extensions.h"

#define kTabPageOffsetTag(x) (x+1000)

@implementation PPTabPageScrollView

#pragma mark life cycle
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       [self setUI];
    }
    return self;
}

- (void)setUI
{
    _currentPage = 0;
    _totalPage = 0;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.bounces = NO;
    [self.panGestureRecognizer addTarget:self action:@selector(scrollHandlePan:)];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView* view in self.subviews) {
        view.height = self.height;
    }
}

#pragma mark Private method
- (void)scrollHandlePan:(UIPanGestureRecognizer*)gesture
{
    static CGFloat startX;
    static CGFloat lastX;
    static CGFloat durationX;
    
    CGPoint touchPoint = [gesture locationInView:self];
    if (gesture.state ==UIGestureRecognizerStateBegan) {
        startX = touchPoint.x;
        lastX = touchPoint.x;
    }else if (gesture.state ==UIGestureRecognizerStateChanged){
        CGFloat currentX = touchPoint.x;
        durationX = currentX-lastX;
        lastX = currentX;
       if (durationX >0 && self.contentOffset.x<=0) {
            if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(scrollToLeadingEdge:)]) {
                [self.pageDelegate scrollToLeadingEdge:self];
            }
        }
    }
}

#pragma mark UIScrollViewDelegate
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastContentOffsetX = scrollView.contentOffset.x;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollViewScrolling:direction:)]) {
        ScrollviewDirection direction;
        if (_lastContentOffsetX >scrollView.contentOffset.x) {
            direction = ScrollviewDirectionLeft;
        }else if (_lastContentOffsetX <scrollView.contentOffset.x){
            direction = ScrollviewDirectionRight;
        }
        [self.pageDelegate pageScrollViewScrolling:self direction:direction];
    }
    _lastContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = (scrollView.contentOffset.x+scrollView.frame.size.width)/scrollView.frame.size.width-1;
    currentPage = MAX(currentPage, 0);
    
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollViewStoped:scrollToPage:)]) {
        [self.pageDelegate pageScrollViewStoped:self scrollToPage:currentPage];
    }
    if (currentPage ==_currentPage) {
        return;
    }
    _currentPage = currentPage;
    //topmenu scroll
    UIView* pageView = [self viewWithTag:kTabPageOffsetTag(_currentPage)];
    if (pageView && [pageView isKindOfClass:[PPTabPageView class]]) {
        if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollView:shouldReloadPageView:atPage:)]) {
            [self.pageDelegate pageScrollView:self shouldReloadPageView:pageView atPage:currentPage];
            
        }
    }
}

- (void)reloadData:(NSArray*)items
{
    NSArray* subviews = self.subviews;
    for (UIView* view in subviews) {
        view.pageInfo = nil;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _totalPage = items.count;
    self.contentSize = CGSizeMake(self.width*_totalPage, self.height);
    if (items.count > 0) {
        for (NSInteger page = 0; page < _totalPage; page++) {
            [self loadPage:page info:items[page]];
        }
   }
}

- (void)loadPage:(NSInteger)page info:(id)info
{
    if (self.pageDataSource) {
        UIView* pageView = [self.pageDataSource pageScrollView:self atPage:page];
        pageView.tag = kTabPageOffsetTag(page);
        pageView.pageInfo = info;
        pageView.frame = CGRectMake(self.width*page, 0, self.width, self.height);
        [self addSubview:pageView];
        if (page==0) {
            if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollView:shouldReloadPageView:atPage:)]) {
                [self.pageDelegate pageScrollView:self shouldReloadPageView:pageView atPage:_currentPage];
            }
            
        }
    }
}

- (void)scrollToPage:(NSInteger)page
{
    NSInteger _page = MIN(MAX(0, page), _totalPage);
    _currentPage = _page;
    [self scrollRectToVisible:CGRectMake(self.width*_page, 0, self.width, self.height) animated:YES];
    [self loadPageViewData];
}

- (void)loadPageViewData
{
    UIView* pageView = [self viewWithTag:kTabPageOffsetTag(_currentPage)];
    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(pageScrollView:shouldReloadPageView:atPage:)]) {
        [self.pageDelegate pageScrollView:self shouldReloadPageView:pageView atPage:_currentPage];
    }

}



@end
