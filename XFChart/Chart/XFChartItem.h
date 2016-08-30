//
//  XFChartItem.h
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFChartItem : NSObject

@property (copy  , nonatomic) NSString *key;

@property (copy  , nonatomic) NSString *value;

/**
 *  填充颜色
 */
@property (strong, nonatomic) UIColor  *color;

/**
 *  是否显示注解
 */
@property (assign, nonatomic) BOOL shouldShowNote;
/**
 *  注解的颜色
 */
@property (strong, nonatomic) UIColor  *noteColor;

/**
 *  注解的内容，如果显示注解，但是没有设置note，将会使用key作为注解文字
 */
@property (copy  , nonatomic) NSString *note;

/**
 *  注解字体
 */
@property (copy  , nonatomic) UIFont   *font;

@end
