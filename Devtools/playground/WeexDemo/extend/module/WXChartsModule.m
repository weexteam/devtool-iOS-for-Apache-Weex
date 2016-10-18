/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXChartsModule.h"
#import "WXChartsComponent.h"
#import <WeexSDK/WeexSDK.h>

@interface WXChartsModule()

@end

@implementation WXChartsModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(drawBar:dataSource:))
WX_EXPORT_METHOD(@selector(setStyle:dataSource:))
WX_EXPORT_METHOD(@selector(render:dataSource:))

- (void)drawBar:(NSString *)ref dataSource:(NSDictionary *)dataSource
{
    [self performBlockWithCanvas:ref block:^(WXChartsComponent *chartsComponent) {
        [chartsComponent drawBarWithDataSource:dataSource chartsModule:self];
    }];
}
                 
- (void)setStyle:(NSString *)ref dataSource:(NSDictionary *)dataSource
{
    [self performBlockWithCanvas:ref block:^(WXChartsComponent *chartsComponent) {
        [chartsComponent setStyleWithDataSource:dataSource chartsModule:self];
    }];
}

- (void)render:(NSString *)ref dataSource:(NSDictionary *)dataSource
{
    [self performBlockWithCanvas:ref block:^(WXChartsComponent *chartsComponent) {
        [chartsComponent renderWithDataSource:dataSource chartsModule:self];
    }];
}
                 
#pragma mark - private method
- (void)performBlockWithCanvas:(NSString *)elemRef block:(void (^)(WXChartsComponent *))block
{
    if (!elemRef) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    WXPerformBlockOnComponentThread(^{
        WXChartsComponent *chartComponent = (WXChartsComponent *)[weakSelf.weexInstance componentForRef:elemRef];
        if (!chartComponent) {
            return;
        }
        
        [weakSelf performSelectorOnMainThread:@selector(doBlock:) withObject:^() {
            block(chartComponent);
        } waitUntilDone:NO];
    });
}

- (void)doBlock:(void (^)())block
{
    block();
}


@end


