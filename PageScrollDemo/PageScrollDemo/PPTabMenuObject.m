//
//  PPTabMenuObject.m
//  FDSlideBarDemo
//
//  Created by patpat on 15/8/27.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "PPTabMenuObject.h"

@implementation PPTabMenuObject

+ (NSArray*)reformer:(NSArray*)datas
{
    NSMutableArray* results = [NSMutableArray array];
    for (NSInteger idx = 0; idx <datas.count; idx++) {
        NSDictionary* item = datas[idx];
        PPTabMenuObject* obj = [[PPTabMenuObject alloc]init];
        obj.name = item[@"name"];
        [results addObject:obj];
    }
    return results;
}

@end
