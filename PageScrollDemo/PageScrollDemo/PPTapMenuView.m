//
//  PPTapMenuView.m
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "PPTapMenuView.h"
#import "UIView+Extensions.h"


static CGFloat const kPPTabMenuViewHeight = 49.0f;
static CGFloat const kPPTabMenuViewLineHeight = 2.0f;


@implementation PPTapMenuView
{
    BOOL _isSelecting;
    NSMutableArray *_menudatas;
    UIImageView *topMenuImage;
    UILabel *_lineLbl;
    NSInteger _selectedTab;
    CGFloat _itemSpace;
    CGFloat _tabLeadingSpace;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        topMenuImage = [[UIImageView alloc]init];
        [self setUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        topMenuImage = [[UIImageView alloc]init];
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    _menudatas = [NSMutableArray array];
    _font = [UIFont systemFontOfSize:16.0];
    _selectedTab = 0;
    _itemSpace = 0.0;
    _tabLeadingSpace = kPPTabMenuButtonTitleLeadingSpace;
    self.height = kPPTabMenuViewHeight;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    self.delegate = self;
    self.backgroundColor = [UIColor whiteColor];

}

- (void)loadItems:(NSArray*)datas
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_menudatas removeAllObjects];
    [_menudatas addObjectsFromArray:datas];
    
    _lineLbl = [[UILabel alloc]initWithFrame:CGRectZero];
    _lineLbl.contentMode = UIViewContentModeRedraw;
    _lineLbl.clipsToBounds = YES;
    _lineLbl.backgroundColor = [UIColor redColor];
    [self addSubview:_lineLbl];
    CGFloat itemMinWidth = 10.0; //default value
    CGFloat marginLeft = _itemSpace;
    CGRect frame = CGRectMake(marginLeft, 0, itemMinWidth, self.height);
    for (int i = 0; i<_menudatas.count; i++) {
        PPTabMenuObject* menuObj = _menudatas[i];
        if (!menuObj) {
            continue;
       }
        if (i==0) {
            marginLeft+=_tabLeadingSpace;
        }
        frame.origin.x = marginLeft;
        PPTapMenuButton* button = [PPTapMenuButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:frame];
        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [button setTabTitle:menuObj.name];
        button.tag = i;
        [self addSubview:button];
        marginLeft+=(button.width+_itemSpace);
        if (button.tag ==_selectedTab) {
            [self setTapSelected:button];
        }
        
    }

    CGFloat contentSizeWidth = marginLeft +_tabLeadingSpace;
    
    if (contentSizeWidth < self.width) //不足一屏处理
    {
    //
        
    }else {
        self.contentSize = CGSizeMake(contentSizeWidth, self.height);
        [self bringSubviewToFront:_lineLbl];
    }
}

//设置title高亮，line的位置，滚动self
- (void)setTapSelected:(PPTapMenuButton*)btn
{
  
    [self setTitleHighlighted:btn];
    [self setLineFrameWithButton:btn];
    CGFloat x = btn.x -30.0;
    if (btn.tag ==0) {
        x = 0;
    }
    [self scrollRectToVisible:CGRectMake(x, 0, self.width, self.height) animated:YES];
}

//更新line的位置和宽度
- (void)updateLine:(UIScrollView*)scrollView
{
    NSInteger currentPage = MAX(0, (NSInteger)scrollView.contentOffset.x/scrollView.width);
    CGFloat scrollViewOffset = scrollView.contentOffset.x - (currentPage*scrollView.width);
    PPTapMenuButton *menuButton = [self menuButtonWithTag:currentPage];
    CGFloat menuButtonWidth = menuButton.width+_itemSpace;
    CGFloat startX = menuButton.x;
    
    if (currentPage ==0) {
        startX = 0.0F;
        menuButtonWidth+=_tabLeadingSpace;
    }
    
    //计算滚动的比例
    CGFloat offsetRate = menuButtonWidth/scrollView.width;
    //根据scrollView滚动的距离偏移，计算menu需要滚动的距离
    CGFloat menuOffset = offsetRate*scrollViewOffset;
    CGFloat menuItemOffSet = 30.0f;
    
    if (scrollViewOffset!=0) {
     
    [self scrollRectToVisible:CGRectMake(startX+menuOffset-menuItemOffSet,0,self.width,self.height) animated:NO];
    
        PPTapMenuButton* nextMenuButton = [self menuButtonWithTag:currentPage+1];
        
        CGFloat withDifferentce = nextMenuButton.tapTitleLbl.width - menuButton.tapTitleLbl.width;
        CGFloat lineOffsetRate = withDifferentce/menuButtonWidth;
        
        //line 滚动的距离
        CGFloat lineOffset = lineOffsetRate*menuOffset;

        if (currentPage==0) {
            startX = _itemSpace;
        }
        CGFloat lineStartX = startX+menuOffset+_tabLeadingSpace;
   
        //获取menubutton的tabTitleLbl在self上的位置，因为line是和button里的tabTitleLbl对齐的
        CGRect menuButtonFrame = [menuButton convertRect:menuButton.tapTitleLbl.frame toView:self];
        
        //防止出现line移动时偏移了，比如移动到第一页时会出现这种情况
        if (lineStartX <menuButtonFrame.origin.x) {
            lineStartX = menuButtonFrame.origin.x;
        }
        //设置line的位置和宽度，都会随着移动改变
        _lineLbl.frame = CGRectMake(lineStartX,menuButtonFrame.origin.y+menuButtonFrame.size.height+2.0,menuButton.tapTitleLbl.width+lineOffset,kPPTabMenuViewLineHeight);
        
        
   }else {
    
       //scrollViewOffset为0说明都正好滚动到page上，对tab,line的位置都直接重新设置，防止之前的滚动出现的偏移
       
       //设置self滚动到的位置
       if (currentPage == 0) {
           [self scrollRectToVisible:self.bounds animated:YES];
       }else{
           [self scrollRectToVisible:CGRectMake(menuButton.x-menuOffset,0,self.width,self.height) animated:YES];
       }
       
       //设置line的位置
       CGRect menuButtonframe = [menuButton convertRect:menuButton.tapTitleLbl.frame toView:self];
       [UIView animateWithDuration:0.1 animations:^{
           _lineLbl.frame = CGRectMake(menuButtonframe.origin.x,menuButtonframe.origin.y+menuButtonframe.size.height+2,menuButtonframe.size.width,kPPTabMenuViewLineHeight);
       }];
   
    }
}

- (void)setTitleHighlighted:(PPTapMenuButton*)btn
{
    for (PPTapMenuButton* button in self.subviews) {
        if ([button isKindOfClass:[PPTapMenuButton class]]) {
            [button setTapSelected:NO];
        }
    }
    _selectedTab = btn.tag;
    [btn setTapSelected:YES];
}

- (void)setLineFrameWithButton:(PPTapMenuButton*)btn
{
    _isSelecting = YES;
    CGRect menuButtonFrame = [btn convertRect:btn.tapTitleLbl.frame toView:self];
    CGRect lineFrame = CGRectMake(menuButtonFrame.origin.x, menuButtonFrame.origin.y+menuButtonFrame.size.height+2, menuButtonFrame.size.width, kPPTabMenuViewLineHeight);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _lineLbl.frame = lineFrame;
    } completion:^(BOOL finished) {
        _lineLbl.frame = lineFrame;
        _isSelecting = NO;
        
    }];
}

- (void)clickItem:(PPTapMenuButton*)btn
{
    if (_selectedTab !=btn.tag) {
        [self setTapSelected:btn];
        if (self.itemDelegate && [self.itemDelegate respondsToSelector:@selector(clickTapMenuButton:object:index:)]) {
            [self.itemDelegate clickTapMenuButton:btn object:_menudatas[btn.tag] index:btn.tag];
        }
        
    }
}

#pragma mark public methods
- (void)reloadDatas:(NSArray*)items
{
    _itemSpace = 0.0f;
    [self loadItems:items];
}

- (void)setSelectedTap:(NSInteger)tab
{
    if (_selectedTab!=tab) {
        PPTapMenuButton* menuBtn = [self menuButtonWithTag:tab];
        if (menuBtn) {
            [self setTapSelected:menuBtn];
        }
    }
}

- (void)contentOffsetByScrollView:(UIScrollView*)scrollView
{
    if (_isSelecting) {
        return;
    }
    [self updateTitleHighlighted:scrollView];
    [self updateLine:scrollView];
}

- (void)updateTitleHighlighted:(UIScrollView*)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/scrollView.width;
    PPTapMenuButton* btn = [self menuButtonWithTag:currentPage];
    if (btn) {
        [self setTitleHighlighted:btn];
    }
}

- (PPTapMenuButton*)menuButtonWithTag:(NSInteger)tag
{
    for (PPTapMenuButton* subView in self.subviews) {
        if ([subView isKindOfClass:[PPTapMenuButton class]] && subView.tag ==tag) {
            return subView;
        }
    }
    return nil;
}

@end
