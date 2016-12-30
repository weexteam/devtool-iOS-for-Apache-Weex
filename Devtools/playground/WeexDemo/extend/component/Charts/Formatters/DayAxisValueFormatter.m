//
//  DayAxisValueFormatter.m
//  ChartsDemo
//  Copyright © 2016 dcg. All rights reserved.
//

#import "DayAxisValueFormatter.h"

@implementation DayAxisValueFormatter
{
    NSArray *months;
    __weak BarLineChartViewBase *_chart;
}

- (id)initData:(NSArray *)xaisData ForChart:(BarLineChartViewBase *)chart;
{
    self = [super init];
    if (self)
    {
        self->_chart = chart;
        
        months = [NSArray arrayWithArray:xaisData];
    }
    return self;
}

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    int days = (int)value - 1;
    if (days < 0 || days > months.count - 1) {
        return nil;
    }
    return months[days];
}

@end
