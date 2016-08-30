//
//  XFChartData.h
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFChartItem.h"

@interface XFChartData : NSObject

@property (copy  , nonatomic) NSString *title;

@property (strong, nonatomic) NSArray  *items;

@property (strong, nonatomic) UIFont *font;

@property (strong, nonatomic) UIColor *noteColor;

@property (assign, nonatomic) BOOL showNote;

@end
