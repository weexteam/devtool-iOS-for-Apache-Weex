/**
 * Created by Weex.
 * Copyright (c) 2019, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXBonjourServiceHost : NSObject

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *hostName;
@property (nonatomic, copy, readonly) NSString *ip;
@property (nonatomic, assign, readonly) NSInteger port;
@property (nonatomic, assign, readonly) NSString *displayName;

- (instancetype)initWithResolvedService:(NSNetService *)service;

+ (instancetype)bonjourHostWithResolvedService:(NSNetService *)service;

@end

NS_ASSUME_NONNULL_END
