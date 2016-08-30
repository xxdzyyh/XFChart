//
//  XFRingChart.h
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "XFBasicChart.h"

@interface XFRingChart : XFBasicChart

@property (assign, nonatomic) float outRadius;
@property (assign, nonatomic) float inRadius;

/** 饼图中心 */
@property (assign, nonatomic) CGPoint circleCenter;

// 弧度，单位为π，默认π/18
@property (assign, nonatomic) float itemBlankWidth;

@end
