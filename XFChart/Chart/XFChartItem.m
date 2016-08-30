//
//  XFChartItem.m
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "XFChartItem.h"

@implementation XFChartItem

- (NSString *)note {
    if (_note == nil) {
        _note = _key;
    }
    return _note;
}

@end
