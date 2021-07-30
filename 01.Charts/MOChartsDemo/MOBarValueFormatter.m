//
//  MOBarValueFormatter.m
//  KubanManager
//
//  Created by 莫小言 on 2016/12/15.
//  Copyright © 2016年 kuban. All rights reserved.
//

#import "MOBarValueFormatter.h"

@implementation MOBarValueFormatter{
    NSArray *_dateArr;
}

- (id)initWithDateArr:(NSArray *)arr {
    if (self = [super init]) {
        _dateArr = [NSArray arrayWithArray:arr];
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    return _dateArr[(int)value];
}



@end
