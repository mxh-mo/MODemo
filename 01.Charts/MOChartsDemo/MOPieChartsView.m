//
//  MOPieChartsView.m
//  ChartsDemo
//
//  Created by 莫小言 on 2016/12/25.
//  Copyright © 2016年 moxiaoyan. All rights reserved.
//

#import "MOPieChartsView.h"
#import "MOChartsDemo-Bridging-Header.h"
#import "MOPieValueFormatter.h"
#define kSelfWidth self.frame.size.width
#define kSelfHeight self.frame.size.height

@implementation MOPieChartsView {
    PieChartView *_pieChartView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self uiConfig];
    }
    return self;
}

- (void)uiConfig {
    _pieChartView = [[PieChartView alloc] init];
    _pieChartView.backgroundColor = [UIColor cyanColor];
    _pieChartView.frame = CGRectMake(0, 0, kSelfWidth, kSelfHeight);
    _pieChartView.holeRadiusPercent = 0.4; // 中间空心半径比
    _pieChartView.transparentCircleRadiusPercent = 0;
    _pieChartView.chartDescription.enabled = NO;
    _pieChartView.transparentCircleRadiusPercent = 50;  //透明度
    [_pieChartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];
    
    ChartLegend *l = _pieChartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.formSize = 10;
    l.font = [UIFont systemFontOfSize:10];
    [self addSubview:_pieChartView];
    
    // 开始设值
    NSDictionary *statistics = @{
        @"初步接洽":[NSNumber numberWithLong:0],
        @"需求确定":[NSNumber numberWithLong:11],
        @"方案报价":[NSNumber numberWithLong:8],
        @"谈判审核":[NSNumber numberWithLong:3],
    };
    NSMutableArray *values = [NSMutableArray array];
    
    //累加总数, 为了算百分比
    double total = 0;
    for (NSNumber *num in statistics.allValues) {
        total += [num doubleValue];
    }
    
    // 循环字典数组 创建data
    for (NSString *str in statistics.allKeys) {
        NSNumber *value = statistics[str];
        if ([value intValue] != 0) {
            [values addObject:[[PieChartDataEntry alloc] initWithValue:[value doubleValue]/total*100 label:str]];
        }
    }
    
    // 循环data数组 创建Set
    if (values.count > 0) {
        PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithEntries:values label:@""];
        dataSet.sliceSpace = 2.0;
        dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
        
        //设置饼块颜色数组
        dataSet.colors = @[[UIColor blueColor], [UIColor brownColor], [UIColor redColor], [UIColor orangeColor]];
        
        PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
        [data setValueFormatter:[[MOPieValueFormatter alloc] initDataArr:statistics.allKeys dic:statistics]];
        [data setValueFont:[UIFont systemFontOfSize:10]];
        [data setValueTextColor:UIColor.blackColor];
        
        _pieChartView.data = data;
        [_pieChartView highlightValues:nil];
    }
}


@end
