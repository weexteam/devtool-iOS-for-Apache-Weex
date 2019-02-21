/**
 * Created by Weex.
 * Copyright (c) 2019, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXBonjourServiceHost.h"

@implementation WXBonjourServiceHost

- (NSString *)displayName {
    return [NSString stringWithFormat:@"%@ (%@:%i)", self.hostName, self.ip, (int)self.port];
}

- (instancetype)initWithResolvedService:(NSNetService *)service {
    self = [super init];
    if (self) {
        NSDictionary *recordDictionary = [NSNetService dictionaryFromTXTRecordData:service.TXTRecordData];
        NSString *ipString = [[NSString alloc] initWithData:recordDictionary[@"ip"] encoding:NSUTF8StringEncoding];
        NSString *channelID = [[NSString alloc] initWithData:recordDictionary[@"channelId"] encoding:NSUTF8StringEncoding];
        
        _url = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%i/debugProxy/native/%@", ipString, (int)service.port, channelID]];
        _hostName = service.name;
        _ip = ipString;
        _port = service.port;
    }
    return self;
}

+ (instancetype)bonjourHostWithResolvedService:(NSNetService *)service {
    return [[WXBonjourServiceHost alloc] initWithResolvedService:service];
}

@end
