//
//  MOBarChartsView.m
//  ChartsDemo
//
//  Created by 莫小言 on 2016/12/25.
//  Copyright © 2016年 moxiaoyan. All rights reserved.
//

#import "MOBarChartsView.h"
#import "MOChartsDemo-Bridging-Header.h"
#import "MOBarValueFormatter.h"

#define kSelfWidth self.frame.size.width
#define kSelfHeight self.frame.size.height

@interface MOBarChartsView ()<IChartAxisValueFormatter, IChartValueFormatter>

@property(nonatomic, assign) BOOL yIsPercent;   //y轴是否是百分比

@end

@implementation MOBarChartsView {
    BarChartView *_barChartView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig {
    _barChartView = [[BarChartView alloc] init];
    _barChartView.backgroundColor = [UIColor cyanColor];
    _barChartView.frame = CGRectMake(0, 0, kSelfWidth, kSelfHeight);
    _barChartView.dragEnabled = YES;
    _barChartView.pinchZoomEnabled = NO;   //捏合手势
    _barChartView.doubleTapToZoomEnabled = NO; //双击手势
    _barChartView.rightAxis.enabled = NO;
    _barChartView.legend.enabled = NO;
    _barChartView.chartDescription.enabled = NO;
    
    ChartXAxis *xAxis = _barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:8.f];
    xAxis.labelWidth = 10;
    xAxis.gridLineDashPhase = 0.f;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.axisMinimum = -0.8;
    xAxis.labelRotationAngle = -20;
    xAxis.gridLineDashLengths = @[@5.f, @5.f];
    xAxis.granularity = 1.0;
    
    ChartYAxis *leftAxis = _barChartView.leftAxis;
    leftAxis.axisMaximum = 100.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.axisLineWidth = 0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.valueFormatter = self;
    [self addSubview:_barChartView];
    
    // 开始设值
    NSArray *statistics = @[@(1), @(2), @(3), @(4), @(5), @(6)];
    NSArray *xValues = @[@"百度", @"腾讯", @"阿里", @"京东", @"小米", @"苹果"];
    NSMutableArray *yVals = [NSMutableArray array];
    double leftAxisMin = 0;
    double leftAxisMax = 0;
    for (int i = 0; i < statistics.count; i++) {
        NSNumber *num = statistics[i];
        double value = [num doubleValue];
        leftAxisMax = MAX(value, leftAxisMax);
        leftAxisMin = MIN(value, leftAxisMin);
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i y:value]];
    }
    CGFloat topNum = leftAxisMax * (5.0/4.0);
    _barChartView.leftAxis.axisMaximum = topNum;
    // 设置Y轴数据
    _barChartView.leftAxis.valueFormatter = self;
    
    // 设置柱形数值
    BarChartDataSet *set1 = nil;
    set1 = [[BarChartDataSet alloc] initWithEntries:yVals];
    set1.valueFormatter = self;
    set1.highlightEnabled = NO;
    [set1 setColors:@[[UIColor redColor]]];
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    data.barWidth = 0.25f;
    
    // 设置X轴数据
    if (xValues.count > 0) {
        _barChartView.xAxis.axisMaximum = xValues.count - 1 + 0.8;
        _barChartView.xAxis.labelCount = xValues.count;
        _barChartView.xAxis.valueFormatter = [[MOBarValueFormatter alloc] initWithDateArr:xValues];
    }
    _barChartView.data = data;
}

#pragma mark - 折线值

- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler {
    if (self.yIsPercent) {
        return [NSString stringWithFormat:@"%3.2f%%", value];
    }
    return [NSString stringWithFormat:@"%3.2f", value];
}

#pragma mark - y轴值

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    if (self.yIsPercent) {
        return [NSString stringWithFormat:@"%.1f%%", value];
    }
    return [NSString stringWithFormat:@"%.1f", value];
}


@end
