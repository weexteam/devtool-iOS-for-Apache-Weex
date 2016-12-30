//
//  DayAxisValueFormatter.h
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeexDemo-Swift.h"

@interface DayAxisValueFormatter : NSObject <IChartAxisValueFormatter>

- (id)initData:(NSArray *)xaisData ForChart:(BarLineChartViewBase *)chart;

@end
