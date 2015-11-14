//
//  PPEventItemCell.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "PPEventItemCell.h"

@implementation PPEventItemCell

- (void)awakeFromNib {


}

+ (CGSize)cellSizeWithWidth:(CGFloat)width
{
    //event image比例  75:34 = 75:34
    //bottom view比例  75:12 = 25:4
    CGFloat imageHeight = width/75.0*34.0;
    CGFloat bottomViewHeight = width/75.0*12.0;
    return CGSizeMake(width,imageHeight+bottomViewHeight);
}

@end
