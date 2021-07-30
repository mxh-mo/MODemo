//
//  MOPieValueFormatter.m
//  ChartsDemo
//
//  Created by 莫小言 on 2017/4/21.
//  Copyright © 2017年 moxiaoyan. All rights reserved.
//

#import "MOPieValueFormatter.h"

@implementation MOPieValueFormatter {
    NSArray *_dataArr;
    NSDictionary *_dic;
}

- (instancetype)initDataArr:(NSArray *)arr dic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _dataArr = arr;
        _dic = dic;
    }
    return self;
}

- (NSString *)stringForValue:(double)value entry:(ChartDataEntry *)entry dataSetIndex:(NSInteger)dataSetIndex viewPortHandler:(ChartViewPortHandler *)viewPortHandler {
    PieChartDataEntry *en = (PieChartDataEntry *)entry;
    return  [NSString stringWithFormat:@" %@ %3.2f%%",en.label, value];
}

@end
