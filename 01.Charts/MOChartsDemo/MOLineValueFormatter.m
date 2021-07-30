//
//  MOLineValueFormatter.m
//  MOChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import "MOLineValueFormatter.h"

@interface MOLineValueFormatter () {
    NSArray *_dateArr;
    NSDateFormatter *_preFormatter;
    NSDateFormatter *_needFormatter;
}
@end

@implementation MOLineValueFormatter

- (id)initWithDateArr:(NSArray *)arr {
    if (self = [super init]) {
        _dateArr = [NSArray arrayWithArray:arr];
        
        _preFormatter = [[NSDateFormatter alloc] init];
        _preFormatter.dateFormat = @"yyyy-MM-dd";
        
        _needFormatter = [[NSDateFormatter alloc] init];
        _needFormatter.dateFormat = @"MM.dd";
    }
    return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    if (_dateArr.count > 0) {
        NSString *dateStr = _dateArr[(int)value];
        NSDate *date = [_preFormatter dateFromString:dateStr];
        return [_needFormatter stringFromDate:date];
    }
    return @"";
}

@end
