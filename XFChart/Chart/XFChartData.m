//
//  XFChartData.m
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "XFChartData.h"

@implementation XFChartData

- (UIColor *)noteColor {
    if (_noteColor == nil) {
        _noteColor = [UIColor colorWithRed:0.804 green:0.804 blue:0.804 alpha:1.00];
    }
    return _noteColor;
}

- (UIFont *)font {
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:11];
    }
    return _font;
}

@end
