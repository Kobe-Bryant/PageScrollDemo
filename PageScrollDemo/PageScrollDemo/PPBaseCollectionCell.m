//
//  PPBaseCollectionCell.m
//  PageScrollDemo
//
//  Created by patpat on 15/9/7.
//  Copyright (c) 2015年 test. All rights reserved.
//

#import "PPBaseCollectionCell.h"

@implementation PPBaseCollectionCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];

}

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);

}

@end
