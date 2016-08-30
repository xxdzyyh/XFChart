//
//  XFBasicChart.h
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFChartData.h"

@interface XFBasicChart : UIView

@property (assign, nonatomic) UIEdgeInsets chartInsets;

@property (strong, nonatomic) XFChartData *chartData;

- (void)strokeChart;


- (void)drawLineWithContext:(CGContextRef)context
                 startPoint:(CGPoint)startPoint
                   endPoint:(CGPoint)endPoint
                      color:(UIColor *)color;

- (void)drawLineWithContext:(CGContextRef)context
                 startPoint:(CGPoint)startPoint
                   endPoint:(CGPoint)endPoint
                      color:(UIColor *)color
                      width:(float)width
                     isDash:(BOOL)isDash;



- (void)drawCircleWithContext:(CGContextRef)context
                       radius:(CGFloat)radius
                       center:(CGPoint)center
                        color:(UIColor *)color;

- (void)drawTextWithContext:(CGContextRef)context
                       text:(NSString *)text
                     origin:(CGPoint)origin
                       font:(UIFont *)font
                      color:(UIColor *)color;

- (CGSize)sizeWithString:(NSString *)string
                    font:(UIFont *)font;
@end
