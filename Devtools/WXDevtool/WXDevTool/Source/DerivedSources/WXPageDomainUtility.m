/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */

#import "WXPageDomainUtility.h"
#import <objc/runtime.h>

@implementation WXPageDomainUtility

@synthesize stopRunning;

+ (UIImage *)screencastDataScale:(float)scale
{
    return [self captureWithScale:scale];
}

+ (NSMutableDictionary *)screencastMetaDataWithScale:(float)scale
{
    NSMutableDictionary *metaDataDic = [[NSMutableDictionary alloc] initWithCapacity:6];
    [metaDataDic setObject:[NSNumber numberWithFloat:scale] forKey:@"pageScaleFactor"];
    [metaDataDic setObject:[NSNumber numberWithFloat:0] forKey:@"offsetTop"];
    [metaDataDic setObject:[NSNumber numberWithFloat:0] forKey:@"scrollOffsetX"];
    [metaDataDic setObject:[NSNumber numberWithFloat:0] forKey:@"scrollOffsetY"];
    
    return metaDataDic;
}

#pragma mark -
+ (UIImage *)captureWithScale:(float)scale
{
//    UIWindow * window = [UIApplication sharedApplication].keyWindow;
//    UIView *view = [[window subviews] objectAtIndex:0];
    UIView *view = [self getCurrentVC].view;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [self scaleImage:image toScale:scale];
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize

{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder  = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark - 
static NSThread *WXScreencastThread;
#define WX_SCREENCAST_THREAD_NAME @"com.taobao.devtool.bridge"
+ (NSThread *)screencastThread
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WXScreencastThread = [[NSThread alloc] initWithTarget:[[self class] alloc] selector:@selector(_runLoopThread) object:nil];
        [WXScreencastThread setName:WX_SCREENCAST_THREAD_NAME];
        if([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending) {
            [WXScreencastThread setQualityOfService:[[NSThread mainThread] qualityOfService]];
        } else {
            [WXScreencastThread setThreadPriority:[[NSThread mainThread] threadPriority]];
        }
        
        [WXScreencastThread start];
    });
    
    return WXScreencastThread;
}

- (void)_runLoopThread
{
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    while (!self.stopRunning) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

void WXPerformBlockOnScreencastThread(void (^block)())
{
    [WXPageDomainUtility _performBlockOnScreencastThread:block];
}

+ (void)_performBlockOnScreencastThread:(void (^)())block
{
    if ([NSThread currentThread] == [self screencastThread]) {
        block();
    } else {
        [self performSelector:@selector(_performBlockOnScreencastThread:)
                     onThread:[self screencastThread]
                   withObject:[block copy]
                waitUntilDone:NO];
    }
}


@end
