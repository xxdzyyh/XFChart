//
//  XFRingChart.m
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "XFRingChart.h"
#import "XFChartItem.h"

@interface XFRingChart ()

@property (strong, nonatomic) NSMutableArray *highLightLayers;
@property (strong, nonatomic) CAShapeLayer *highLightLayer;

@end

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
    _inRadius   = _outRadius - 10;
    _circleCenter = CGPointMake(w/2,h/2);
}

- (void)setCanTap:(BOOL)canTap {
    [super setCanTap:canTap];
    if (canTap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [self addGestureRecognizer:tap];
    }
}

- (void)tap:(UITapGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:self];
    // 选中了扇形
    // 计算到圆心的距离
    float dx = (p.x-self.center.x);
    float dy = (p.y-self.center.y);
    
    float distance = sqrtf(dx*dx+dy*dy);
    
    if (self.inRadius <= distance && distance <= self.outRadius) {
        // 选中了环形
        for (CAShapeLayer *layer in self.layer.sublayers) {

            UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:layer.path];
            
            if ([path containsPoint:p]) {
                int index = layer.name.intValue;

                if (index > 0) {
                    
                    NSLog(@"Bingo %d",index);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.highLightLayer removeFromSuperlayer];
                        
                        self.highLightLayer = self.highLightLayers[index-1];
                        
                        [self.layer addSublayer:self.highLightLayer];
                    });
                }
            }
        }
        
    }

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
    
    if (self.centerTitle.length > 0) {
        CGSize size = [self sizeWithString:self.centerTitle font:[UIFont systemFontOfSize:10]];
        
        CGPoint origin = CGPointMake(self.circleCenter.x-size.width/2, self.circleCenter.y-size.height/2);
        
        [self drawTextWithContext:contex
                             text:self.centerTitle
                           origin:origin
                             font:[UIFont systemFontOfSize:10]
                            color:[UIColor colorWithRed:0.627 green:0.686 blue:0.725 alpha:1.00]];
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
        
        // layer没有tag，用下name来做标记，点击会用到
        // 设置默认不从0开始，避开默认值
        layer.name = [NSString stringWithFormat:@"%d",i+1];
        
        // 为什么要设置strokeColor和lineWidth，
        // 因为path是一个标准的扇形，就是是CAShape是一个标准的扇形，
        // 如果使用fillColor的话，最终得到的就是一个扇形
        layer.fillColor = nil;
        layer.strokeColor = item.color.CGColor;
        layer.lineWidth = self.outRadius-self.inRadius;
        
        
        layer.lineCap = kCALineCapButt;
        layer.path = path.CGPath;
        
        [self.layer addSublayer:layer];

        if (self.canTap) {
            float highRadius = self.outRadius+(self.outRadius-self.inRadius)/3.0;
            
            CAShapeLayer *highLayer = [CAShapeLayer layer];
            
            UIBezierPath *path1 = [UIBezierPath bezierPath];
            
            [path1 addArcWithCenter:self.circleCenter
                            radius:(highRadius+self.inRadius)/2
                        startAngle:lastBegin
                          endAngle:lastBegin+currentArc
                         clockwise:YES];
            highLayer.fillColor = nil;
            highLayer.strokeColor = item.color.CGColor;
            highLayer.lineWidth = self.outRadius-self.inRadius;
            highLayer.lineCap = kCALineCapButt;
            highLayer.path = path1.CGPath;
            
            highLayer.shadowPath = path1.CGPath;
            
            [self.highLightLayers addObject:highLayer];
        }
        
         lastBegin += (currentArc + self.itemBlankWidth);
    }
}


#pragma mark - setter & getter

- (NSMutableArray *)highLightLayers {
    if (_highLightLayers == nil) {
        _highLightLayers = [NSMutableArray array];
    }
    return _highLightLayers;
}

@end
