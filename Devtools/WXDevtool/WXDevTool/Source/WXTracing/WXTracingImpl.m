//
//  WXTracingImpl.m
//  Pods
//
//  Created by 齐山 on 2017/8/8.
//
//

#import "WXTracingImpl.h"
#import "WXDebugger.h"
#import "WXTracingUtility.h"
#import "WXTracingViewControllerManager.h"

@implementation WXTracingImpl

- (void)commitTracingInfo:(WXTracingTask *)task
{
    [WXTracingViewControllerManager showButton];
    if([WXTracingUtility isRemoteTracing] && task){
        [[WXDebugger defaultInstance] sendEventWithName:@"WxDebug.sendTracingData" parameters:@{@"data":[WXTracingUtility formatTask:task]}];
    }
}

- (void)commitTracingSummaryInfo:(NSDictionary *)info
{
    if([WXTracingUtility isRemoteTracing] && info){
        [[WXDebugger defaultInstance] sendEventWithName:@"WxDebug.sendSummaryInfo" parameters:@{@"summaryInfo":info}];
    }
}

@end
