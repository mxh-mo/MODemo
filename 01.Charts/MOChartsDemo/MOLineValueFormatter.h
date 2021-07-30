//
//  MOLineValueFormatter.h
//  MOChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import <UIKit/UIKit.h>
#import "MOChartsDemo-Bridging-Header.h"

@interface MOLineValueFormatter : NSObject <IChartAxisValueFormatter>

- (id)initWithDateArr:(NSArray *)arr;

@end
