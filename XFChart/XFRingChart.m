//
//  XFRingChart.m
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "XFRingChart.h"
#import "XFChartItem.h"

@implementation XFRingChart

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self loadDefaultValue];
    }
    return self;
}

- (void)loadDefaultValue {
    _itemBlankWidth = 0;
    
    float w = CGRectGetWidth(self.frame);
    float h = CGRectGetHeight(self.frame);
    
    _outRadius  = MIN(w, h)/2.0*0.38;
    _inRadius   = _outRadius - 12;
    _circleCenter = self.center;
}

- (void)drawRect:(CGRect)rect {
    // 绘制注解
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGFloat lastBegin = 0;
    
    NSUInteger count = self.chartData.items.count;
    
    id totalValue = [self.chartData valueForKeyPath:@"items.@sum.value"];
    
    // 注解的另一个端点都落在一个圆上
    float w = CGRectGetWidth(self.frame);
    float h = CGRectGetHeight(self.frame);
    
    float space = (MIN(w, h)/2-self.outRadius)/2;
    
    if (space > MIN(w, h)/10 ) {
        space = MIN(w, h)/10;
    }
    
    CGFloat maxRadius = self.outRadius + space;
    
    
    for (int i=0; i<count; i++) {
        XFChartItem *item = self.chartData.items[i];
        
        // 计算item.value所占的弧度
        CGFloat currentArc = item.value.floatValue/[totalValue floatValue] * (M_PI * 2 - _itemBlankWidth * count);
        
        // 弧的中点对应的弧度
        CGFloat midArc = lastBegin+currentArc/2;
        
        CGPoint begin = CGPointMake(self.circleCenter.x+sin(midArc)*self.outRadius, self.circleCenter.y-cos(midArc)*self.outRadius);
        
        CGPoint end = CGPointMake(self.circleCenter.x + sin(midArc) * maxRadius, self.circleCenter.y - cos(midArc)*maxRadius);
        
        // 注解斜线
        UIColor *color = item.color;
        
        if (color == nil) {
            color = self.chartData.noteColor;
        }
        
        [self drawLineWithContext:contex startPoint:begin endPoint:end color:color];
        
        UIFont *font = item.font;
        
        if (font == nil) {
            font = self.chartData.font;
        }
        
        // 注解文字
        CGSize size = [self sizeWithString:item.note font:font];

        NSLog(@"%f",midArc);
        
        CGPoint textOrigin = end;
        
        // 按数学象限
        if (midArc<M_PI_2) {
            // 第一象限
            textOrigin = CGPointMake(end.x+5,end.y-size.height/2);
        } else if (midArc<M_PI) {
            // 第二象限
            textOrigin = CGPointMake(end.x,end.y);
        } else if (midArc<1.5*M_PI) {
            // 第三象限
            textOrigin = CGPointMake(end.x-size.width+2,end.y);
        } else {
            // 第四象限
            textOrigin = CGPointMake(end.x-size.width/2, end.y-size.height-2);
        }
        
        [self drawTextWithContext:contex text:item.note origin:textOrigin font:font color:color];
        
        lastBegin += _itemBlankWidth + currentArc;
    }
}

// 绘制扇形
- (void)strokeChart {
    // 动画开始前，应当移除之前的layer
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    CGFloat lastBegin = -M_PI/2;
    CGFloat radius = (self.outRadius+self.inRadius)/2.0;

    NSUInteger count = self.chartData.items.count;
    
    id totalValue = [self.chartData valueForKeyPath:@"items.@sum.value"];
    
    for (int i=0; i<count; i++) {
        XFChartItem *item = self.chartData.items[i];
        
        // 计算item.value所占的弧度
        CGFloat currentArc = item.value.floatValue/[totalValue floatValue] * (M_PI * 2 - _itemBlankWidth * count);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        [path addArcWithCenter:self.circleCenter
                        radius:radius
                    startAngle:lastBegin
                      endAngle:lastBegin+currentArc
                     clockwise:YES];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        layer.strokeColor = item.color.CGColor;
        layer.fillColor = nil;
        layer.lineWidth = self.outRadius-self.inRadius;
        layer.lineCap = kCALineCapButt;
        layer.path = path.CGPath;
        
        [self.layer addSublayer:layer];
        
        lastBegin += (currentArc + self.itemBlankWidth);
    }
}

@end
