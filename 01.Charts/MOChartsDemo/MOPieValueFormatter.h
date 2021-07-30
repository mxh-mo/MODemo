//
//  MOPieValueFormatter.h
//  ChartsDemo
//
//  Created by 莫小言 on 2017/4/21.
//  Copyright © 2017年 moxiaoyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOChartsDemo-Bridging-Header.h"

@interface MOPieValueFormatter : NSObject <IChartValueFormatter>

- (instancetype)initDataArr:(NSArray *)arr dic:(NSDictionary *)dic;

@end
