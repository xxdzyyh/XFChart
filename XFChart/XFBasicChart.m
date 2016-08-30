//
//  XFBasicChart.m
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "XFBasicChart.h"

@implementation XFBasicChart

- (void)drawLineWithContext:(CGContextRef)context
                 startPoint:(CGPoint)startPoint
                   endPoint:(CGPoint)endPoint
                      color:(UIColor *)color {
    [self drawLineWithContext:context
                   startPoint:startPoint
                     endPoint:endPoint
                        color:color
                       isDash:NO];
}

- (void)drawLineWithContext:(CGContextRef)context
                 startPoint:(CGPoint)startPoint
                   endPoint:(CGPoint)endPoint
                      color:(UIColor *)color
                     isDash:(BOOL)isDash {
    
    float defaultLineWidth = [self onePixWidth];
    
    [self drawLineWithContext:context
                   startPoint:startPoint
                     endPoint:endPoint
                        color:color
                        width:defaultLineWidth
                       isDash:NO];
}

- (void)drawLineWithContext:(CGContextRef)context
                 startPoint:(CGPoint)startPoint
                   endPoint:(CGPoint)endPoint
                      color:(UIColor *)color
                      width:(float)width
                     isDash:(BOOL)isDash {
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    
    CGContextSetLineWidth(context, width);
    
    [color setStroke];
    
    if (isDash) {
        CGFloat ss[] = {0.5,2};
        
        CGContextSetLineDash(context, 0, ss, 2);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawTextWithContext:(CGContextRef)context
                       text:(NSString *)text
                     origin:(CGPoint)origin
                       font:(UIFont *)font
                      color:(UIColor *)color {
    [text drawAtPoint:origin withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    [color setFill];
    
    CGContextDrawPath(context, kCGPathFill);
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeZero
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:font}
                                       context:nil].size;
    return size;
}

- (float)onePixWidth {
    float scale = [UIScreen mainScreen].scale;
    
    return 1/scale;
}

@end
