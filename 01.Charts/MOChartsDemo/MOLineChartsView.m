//
//  MOLineChartsView.m
//  ChartsDemo
//
//  Created by 莫小言 on 2016/12/25.
//  Copyright © 2016年 moxiaoyan. All rights reserved.
//

#import "MOLineChartsView.h"
#import "MOChartsDemo-Bridging-Header.h"
#import "MOLineValueFormatter.h"

#define kSelfWidth self.frame.size.width
#define kSelfHeight self.frame.size.height

@interface MOLineChartsView ()<IChartAxisValueFormatter,IChartValueFormatter>

@property(nonatomic, assign) BOOL yIsPercent; //y轴是否为百分比显示

@end

@implementation MOLineChartsView {
    LineChartView *_linechartView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig {
    _linechartView = [[LineChartView alloc] init];
    _linechartView.backgroundColor = [UIColor cyanColor];
    _linechartView.frame = CGRectMake(0, 0, kSelfWidth, kSelfHeight);
    _linechartView.dragEnabled = YES;
    _linechartView.pinchZoomEnabled = NO;   //捏合手势
    _linechartView.doubleTapToZoomEnabled = NO; //双击手势
    _linechartView.scaleYEnabled = NO;  //取消Y轴缩放
    _linechartView.legend.form = ChartLegendFormLine;   //说明图标
    _linechartView.chartDescription.enabled = NO; //不显示描述label
    _linechartView.rightAxis.enabled = NO;  //隐藏右Y轴
    [_linechartView animateWithXAxisDuration:0.5];  //赋值动画时长
    [self addSubview:_linechartView];
    
    // 设置左Y轴
    ChartYAxis *leftAxis = _linechartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = 100.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.axisLineWidth = 0;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    
    // 设置X轴
    ChartXAxis *xAxis = _linechartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.axisMinimum = -0.3;
    xAxis.granularity = 1.0;
    xAxis.drawAxisLineEnabled = YES;    //是否画x轴线
    xAxis.drawGridLinesEnabled = NO;   //是否画网格
    xAxis.gridLineDashLengths = @[@5.f, @5.f];
    
    // 设置X轴数据
    NSArray *xValues = @[@"2016-11-13",
                         @"2016-11-20",
                         @"2016-11-27",
                         @"2016-12-04",
                         @"2016-12-18",
                         @"2016-12-25"];
    if (xValues.count > 0) {
        _linechartView.xAxis.axisMaximum = (double)xValues.count - 1 + 0.3;
        _linechartView.xAxis.valueFormatter = [[MOLineValueFormatter alloc] initWithDateArr:xValues];
        // 这里将代理赋值为一个类的对象, 该对象需要遵循IChartAxisValueFormatter协议, 并实现其代理方法(我们可以对需要显示的值进行各种处理, 这里对日期进行格式处理)(当然下面的各代理也都可以这样写)
    }
    
    // 设置折线数据
    // 这里模拟了3条折线
    NSArray *legendTitles = @[@"已入住", @"已出租", @"总工位数"];
    NSArray *statistics = @[
        @[[NSNumber numberWithLong:255],
          [NSNumber numberWithLong:355],
          [NSNumber numberWithLong:477],
          [NSNumber numberWithLong:578],
          [NSNumber numberWithLong:798],
          [NSNumber numberWithLong:800],
        ],
        @[[NSNumber numberWithLong:100],
          [NSNumber numberWithLong:150],
          [NSNumber numberWithLong:200],
          [NSNumber numberWithLong:250],
          [NSNumber numberWithLong:350],
          [NSNumber numberWithLong:400],
        ],
        @[[NSNumber numberWithLong:500],
          [NSNumber numberWithLong:600],
          [NSNumber numberWithLong:700],
          [NSNumber numberWithLong:800],
          [NSNumber numberWithLong:1000],
          [NSNumber numberWithLong:1200],
        ]
    ];
    NSArray *colors = @[[UIColor blueColor], [UIColor blackColor], [UIColor redColor]]; // 折线颜色数组
    NSMutableArray *dataSets = [[NSMutableArray alloc] init]; //数据集数组
    
    // 这样写的好处是, 无论你传多少条数据, 都可以处理展示
    for (int i = 0; i < statistics.count; i++) {
        // 循环创建数据集
        LineChartDataSet *set = [self drawLineWithArr:statistics[i]  title:legendTitles[i] color:colors[i]];
        if (set) {
            [dataSets addObject:set];
        }
    }
    
    // 赋值数据集数组
    if (dataSets.count > 0) {
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        _linechartView.data = data;
    }
}

#pragma mark - 根据数据数组 title color 创建折线set

- (LineChartDataSet *)drawLineWithArr:(NSArray *)arr title:(NSString *)title color:(UIColor *)color {
    if (arr.count == 0) {
        return nil;
    }
    // 处理折线数据
    NSMutableArray *statistics = [NSMutableArray array];
    double leftAxisMin = 0;
    double leftAxisMax = 0;
    for (int i = 0; i < arr.count; i++) {
        NSNumber *num = arr[i];
        double value = [num doubleValue];
        leftAxisMax = MAX(value, leftAxisMax);
        leftAxisMin = MIN(value, leftAxisMin);
        [statistics addObject:[[ChartDataEntry alloc] initWithX:i y:value]];
    }
    CGFloat topNum = leftAxisMax * (5.0/4.0);
    _linechartView.leftAxis.axisMaximum = topNum;
    if (leftAxisMin < 0) {
        CGFloat minNum = leftAxisMin * (5.0/4.0);
        _linechartView.leftAxis.axisMinimum = minNum ;
    }
    
    // 设置Y轴数据
    _linechartView.leftAxis.valueFormatter = self; //需要遵IChartAxisValueFormatter协议
    
    // 设置折线数据
    LineChartDataSet *set1 = nil;
    set1 = [[LineChartDataSet alloc] initWithEntries:statistics label:title];
    set1.mode = LineChartModeCubicBezier;   // 弧度mode
    [set1 setColor:color];
    [set1 setCircleColor:color];
    set1.lineWidth = 1.0;
    set1.circleRadius = 3.0;
    set1.valueColors = @[color];
    set1.valueFormatter = self; //需要遵循IChartValueFormatter协议
    set1.valueFont = [UIFont systemFontOfSize:9.f];
    return set1;
}

#pragma mark - IChartValueFormatter delegate (折线值)

- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler {
    if (self.yIsPercent) {
        return [NSString stringWithFormat:@"%.2f%%", value];
    }
    return [NSString stringWithFormat:@"%.f", value];
}

#pragma mark - IChartAxisValueFormatter delegate (y轴值) (x轴的值写在DateValueFormatter类里, 都是这个协议方法)

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    if (self.yIsPercent) {
        return [NSString stringWithFormat:@"%.1f%%", value];
    }
    if (ABS(value) > 1000) {
        return [NSString stringWithFormat:@"%.1fk", value/(double)1000];
    }
    return [NSString stringWithFormat:@"%.f", value];
}

@end
