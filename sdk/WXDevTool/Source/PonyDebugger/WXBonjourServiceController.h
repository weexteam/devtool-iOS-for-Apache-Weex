/**
 * Created by Weex.
 * Copyright (c) 2019, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>
#import "WXBonjourServiceHost.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^WXBonjourControllerServiceHandler)(NSArray<WXBonjourServiceHost *> *hosts);

@interface WXBonjourServiceController : NSObject

+ (instancetype)sharedInstance;

- (void)searchForDebuggersWithCompletion:(WXBonjourControllerServiceHandler)completion;

@end

NS_ASSUME_NONNULL_END
