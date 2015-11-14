//
//  PPTabPageScrollView.h
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTabPageView.h"

typedef enum {
  
    ScrollviewDirectionRight,
    ScrollviewDirectionLeft

}ScrollviewDirection;

@protocol PPTabPageScrollViewDataSource,PPTabPageScrollViewDelegate;



@interface PPTabPageScrollView : UIScrollView<UIScrollViewDelegate>
{
    CGFloat _lastContentOffsetX;
    NSInteger _totalPage;
    NSInteger _currentPage;
}

@property (nonatomic,assign)id<PPTabPageScrollViewDataSource>pageDataSource;
@property (nonatomic,assign)id<PPTabPageScrollViewDelegate>pageDelegate;

//reload add data
- (void)reloadData:(NSArray*)items;

//scroll to page
- (void)scrollToPage:(NSInteger)page;

@end

@protocol PPTabPageScrollViewDataSource <NSObject>

/**
 *  设置在page的pageview
 *
 *  @param scrollView PPTabPageScrollView对象
 *  @param page       页码
 *
 *  @return 传入的pageview
 */
- (UIView*)pageScrollView:(PPTabPageScrollView*)scrollView
                   atPage:(NSInteger)page;
@end


@protocol PPTabPageScrollViewDelegate <NSObject>


- (void)pageScrollViewScrolling:(PPTabPageScrollView*)scrollView
                      direction:(ScrollviewDirection)direction;

- (void)pageScrollViewStoped:(PPTabPageScrollView *)scrollView
                scrollToPage:(NSInteger )page;

- (void)pageScrollView:(PPTabPageScrollView *)scrollView
  shouldReloadPageView:(UIView *)pageView
                atPage:(NSInteger)page;


/**
 *  scrollview滚动到左边的边界
 *
 *  @param scrollView PPTabPageScrollView对象
 */
- (void)scrollToLeadingEdge:(PPTabPageScrollView *)scrollView;







@end





