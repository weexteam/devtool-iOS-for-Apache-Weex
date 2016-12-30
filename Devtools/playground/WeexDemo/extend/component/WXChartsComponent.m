/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */
#import "WXChartsComponent.h"
#import "WeexDemo-Swift.h"
#import "DayAxisValueFormatter.h"

@interface WXChartsComponent() <ChartViewDelegate>

@property (nonatomic, strong) BarChartView *chartView;

@end

@implementation WXChartsComponent

- (void)drawBarWithDataSource:(NSDictionary *)dataSource chartsModule:(WXChartsModule *)chartsModule
{
    
}

- (void)setStyleWithDataSource:(NSDictionary *)dataSource chartsModule:(WXChartsModule *)chartsModule
{
    [self drawBarStyles:dataSource];
}

- (void)renderWithDataSource:(NSDictionary *)dataSource chartsModule:(WXChartsModule *)chartsModule
{
    [self setData:dataSource xaxisCount:5 range:40];
}

- (instancetype)initWithRef:(NSString *)ref
                       type:(NSString *)type
                     styles:(NSDictionary *)styles
                 attributes:(NSDictionary *)attributes
                     events:(NSArray *)events
               weexInstance:(WXSDKInstance *)weexInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        
    }
    return self;
}

- (UIView *)loadView
{
    _chartView = [[BarChartView alloc] init];
    return _chartView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBarLineChartView:_chartView];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - event
- (void)addEvent:(NSString *)eventName
{
    
}

- (void)removeEvent:(NSString *)eventName
{
    
}

#pragma mark - private method
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.chartDescription.enabled = NO;
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = NO;
    
    // ChartYAxis *leftAxis = chartView.leftAxis;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    chartView.rightAxis.enabled = NO;
}

- (void)drawBarStyles:(NSDictionary *)dic
{
    _chartView.delegate = self;
    
    if ([dic[@"drawBarShadowEnabled"] boolValue]) {
        _chartView.drawBarShadowEnabled = YES;
    }
    _chartView.drawValueAboveBarEnabled = YES;
    
    _chartView.maxVisibleCount = 60;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.granularity = 1.0; // only intervals of 1 day
    xAxis.labelCount = 2;
    
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumFractionDigits = 0;
    leftAxisFormatter.maximumFractionDigits = 1;
//    leftAxisFormatter.negativeSuffix = @" $";
//    leftAxisFormatter.positiveSuffix = @" $";
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.enabled = YES;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
    rightAxis.labelCount = 8;
    rightAxis.valueFormatter = leftAxis.valueFormatter;
    rightAxis.spaceTop = 0.15;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 9.0;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.xEntrySpace = 4.0;
}

- (void)setData:(NSDictionary *)datas xaxisCount:(int)count range:(double)range
{
    double start = 0.0;
    
    NSArray *values = (NSArray *)datas[@"data"];
    NSMutableArray *xVals = [NSMutableArray array];
    _chartView.xAxis.axisMinimum = start;
    _chartView.xAxis.axisMaximum = start + count + 2;
    _chartView.xAxis.labelCount = values.count;
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = start; i < values.count; i++)
    {
        NSDictionary *barDatas = values[i];
        [xVals addObject:barDatas[@"x"]];
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:(double)i + 1.0 y:[barDatas[@"y"] doubleValue]]];
    }
    _chartView.xAxis.valueFormatter = [[DayAxisValueFormatter alloc] initData:xVals ForChart:_chartView];
    
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.values = yVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"The year 2017"];
        [set1 setColors:ChartColorTemplates.material];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        data.barWidth = 0.9f;
        
        _chartView.data = data;
    }
}

@end
