//
//  ViewController.m
//  XFChart
//
//  Created by wangxuefeng on 16/8/29.
//  Copyright © 2016年 wangxuefeng. All rights reserved.
//

#import "ViewController.h"
#import "XFChartData.h"
#import "XFChartItem.h"
#import "XFRingChart.h"

#define k_COLOR_STOCK @[[UIColor colorWithRed:1.000 green:0.783 blue:0.371 alpha:1.000], [UIColor colorWithRed:1.000 green:0.562 blue:0.968 alpha:1.000],[UIColor colorWithRed:0.313 green:1.000 blue:0.983 alpha:1.000],[UIColor colorWithRed:0.560 green:1.000 blue:0.276 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000]]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    XFChartData *data = [XFChartData new];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        XFChartItem *item = [XFChartItem new];
        
        item.key = [NSString stringWithFormat:@"key%d",i];
        item.value = [NSString stringWithFormat:@"%d",arc4random()%10+1];
        item.color = k_COLOR_STOCK[i];
        
        [temp addObject:item];
    }
    
    data.items = temp;
    
    XFRingChart *chart = [[XFRingChart alloc] initWithFrame:self.view.bounds];
    
    chart.chartData = data;
    
    [chart strokeChart];
    
    [self.view addSubview:chart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
