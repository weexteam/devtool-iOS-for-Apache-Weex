/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXDebugDomainController.h"
#import "WXDevToolType.h"
#import "WXDebuggerUtility.h"
#import <WeexSDK/WeexSDK.h>

#define SYNCRETURN @"WxDebug.syncReturn"

@implementation WXDebugDomainController {
    WXJSCallNativeModule _nativeModuleBlock;
}

@dynamic domain;

+ (WXDebugDomainController *)defaultInstance {
    static WXDebugDomainController *defaultInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultInstance = [[WXDebugDomainController alloc] init];
    });
    return defaultInstance;
}

+ (Class)domainClass {
    return [WXDebugDomain class];
}

+ (NSDictionary *)getLogLevelMap {
    NSDictionary *logLevelEnumToString =
    @{
      @"all":@(WXLogLevelDebug),
      @"error":@(WXLogLevelError),
      @"warn":@(WXLogLevelWarning),
      @"info":@(WXLogLevelInfo),
      @"log":@(WXLogLevelLog),
      @"debug":@(WXLogLevelDebug),
      @"off":@(WXLogLevelOff)
      };
    return logLevelEnumToString;
}

- (void)debugDomainRegisterCallNativeModule:(WXJSCallNativeModule)callNativeModuleBlock {
    _nativeModuleBlock = callNativeModuleBlock;
}

#pragma mark - WXCommandDelegate
- (void)domain:(WXDynamicDebuggerDomain *)domain enableWithCallback:(void (^)(id error))callback {
    [WXDevToolType setDebug:YES];
    [WXSDKEngine restart];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshInstance" object:nil];
    callback(nil);
}

- (void)domain:(WXDynamicDebuggerDomain *)domain disableWithCallback:(void (^)(id error))callback {
    [WXDevToolType setDebug:NO];
    [WXSDKEngine restart];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshInstance" object:nil];
    callback(nil);
}

- (void)domain:(WXDebugDomain *)domain sendLogLevel:(NSString *)level withCallback:(void (^)(id error))callback {
    NSDictionary *logLevelMap = [WXDebugDomainController getLogLevelMap];
    WXLogLevel wxLogLevel = [[logLevelMap objectForKey:level] integerValue];
    [WXLog setLogLevel:wxLogLevel];
    callback(nil);
}

- (void)domain:(WXDebugDomain *)domain setInspectorMode:(NSString *)mode withCallback:(void (^)(id error))callback {
    if ([mode isEqualToString:@"native"]) {
        [WXDebugger setVDom:NO];
    } else if ([mode isEqualToString:@"vdom"]) {
        [WXDebugger setVDom:YES];
    }
}

- (void)domain:(WXDynamicDebuggerDomain *)domain refreshCallback:(void (^)(id error))callback {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshInstance" object:nil];
    });
    callback(nil);
}

- (void)domain:(WXDynamicDebuggerDomain *)domain reloadCallback:(void (^)(id error))callback {
    dispatch_async(dispatch_get_main_queue(), ^{
        [WXSDKEngine restart];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshInstance" object:nil];
    });
}

- (void)domain:(WXDynamicDebuggerDomain *)domain enableNetwork:(BOOL)enable networkCallback:(void (^)(id error))callback {
    WXDebugger *debugger = [WXDebugger defaultInstance];
    if (enable) {
        [debugger enableNetworkTrafficDebugging];
        [debugger forwardAllNetworkTraffic];
    }
}

- (void)domain:(WXDynamicDebuggerDomain *)domain callNativeModule:(NSDictionary *)data callBack:(void (^)(NSDictionary *result, id error))callback; {
    NSArray *args = [data objectForKey:@"args"];
    NSString *method = [data objectForKey:@"method"];
    NSString *syncId = [data objectForKey:@"syncId"];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setObject:SYNCRETURN forKey:@"method"];
    NSError *error = nil;
    if ([method isEqualToString:@"callNativeModule"]) {
        NSString *instanceIdString = args[0] ? : @"";
        NSString *moduleNameString = args[1] ? : @"";
        NSString *methodNameString = args[2] ? : @"";
        NSArray *argsArray = args[3] ? : [NSArray array];
        NSDictionary *optionsDic = args[4] ? : [NSDictionary dictionary];
        
        WXLog(@"callNativeModule...%@,%@,%@,%@", instanceIdString, moduleNameString, methodNameString, argsArray);
        
        NSInvocation *invocation = _nativeModuleBlock(instanceIdString, moduleNameString, methodNameString, argsArray, optionsDic);
        id object = [WXDebuggerUtility switchInvocationReture:invocation];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:syncId forKey:@"syncId"];
        if (object) {
            [params setObject:object forKey:@"ret"];
        }else {
            error = [[NSError alloc] init];
        }
        [result setObject:params forKey:@"params"];
    }
    callback(result, error);
}

@end
