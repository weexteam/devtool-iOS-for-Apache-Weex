/**
 * Created by Weex.
 * Copyright (c) 2019, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXBonjourServiceController.h"

static NSString *const WXBonjourControllerServiceType = @"_weex._tcp.";

#define WXBonjourControllerServiceStatusUnresolved [NSNumber numberWithInteger:1]
#define WXBonjourControllerServiceStatusResolved [NSNumber numberWithInteger:2]

@interface WXBonjourServiceController () <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (nonatomic, strong) NSNetServiceBrowser *browser;
@property (nonatomic, strong) NSMutableArray<NSNetService *> *bonjourServices;
@property (nonatomic, copy) WXBonjourControllerServiceHandler completion;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *serviceStatuses;

@end

@implementation WXBonjourServiceController

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WXBonjourServiceController* sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WXBonjourServiceController alloc] init];
    });
    
    return sharedInstance;
}

- (void)searchForDebuggersWithCompletion:(WXBonjourControllerServiceHandler)completion {
    [self stopSearch];
    
    self.completion = completion;
    self.bonjourServices = [NSMutableArray array];
    self.serviceStatuses = [NSMutableDictionary dictionary];
    
    self.browser = [[NSNetServiceBrowser alloc] init];
    self.browser.delegate = self;
    self.browser.includesPeerToPeer = YES; // For ad-hoc networks where multicast DNS is disabled
    [self.browser searchForServicesOfType:WXBonjourControllerServiceType inDomain:@""];
}

- (void)stopSearch {
    [self.browser stop];
    self.browser = nil;
    self.completion = nil;
    self.bonjourServices = nil;
    self.serviceStatuses = nil;
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    // Only search once
    if (!moreComing) {
        [browser stop];
        self.browser = nil;
    }
    
    [self.bonjourServices addObject:service];
    self.serviceStatuses[service.name] = WXBonjourControllerServiceStatusUnresolved;
    
    service.delegate = self;
    [service resolveWithTimeout:10];
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    self.serviceStatuses[sender.name] = WXBonjourControllerServiceStatusResolved;
    
    // invoke completion handler after all services are resolved
    if (!self.browser && ![self.serviceStatuses.allValues containsObject:WXBonjourControllerServiceStatusUnresolved]) {
        NSMutableArray<WXBonjourServiceHost *> *hosts = [NSMutableArray array];
        for (NSNetService *service in self.bonjourServices) {
            [hosts addObject:[WXBonjourServiceHost bonjourHostWithResolvedService:service]];
        }
        self.completion([hosts copy]);
        
        [self stopSearch];
    }
}

@end
