//
//  MOBarValueFormatter.h
//  KubanManager
//
//  Created by 莫小言 on 2016/12/15.
//  Copyright © 2016年 kuban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOChartsDemo-Bridging-Header.h"

@interface MOBarValueFormatter : NSObject <IChartAxisValueFormatter>

- (id)initWithDateArr:(NSArray *)arr;

@end
