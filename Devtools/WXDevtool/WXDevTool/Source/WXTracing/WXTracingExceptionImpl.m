//
//  WXTracingExceptionImpl.m
//  Pods
//
//  Created by 齐山 on 2017/7/10.
//
//

#import "WXTracingExceptionImpl.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import "WXTracingViewControllerManager.h"
#import <WeexSDK/WXUtility.h>
#import <WeexSDK/WXSDKManager.h>
#import "WXTracingManager.h"

WX_PlUGIN_EXPORT_HANDLER(WXTracingExceptionImpl,WXJSExceptionProtocol)

@implementation WXTracingExceptionImpl

- (void)onJSException:(WXJSExceptionInfo*) exception
{
    dispatch_async(dispatch_get_main_queue(), ^{
        WXTracingTask *task = [WXTracingManager getTracingData];
        UITextView *textView = [WXTracingViewControllerManager sharedInstance].textView;
        NSMutableAttributedString *attrStr = [textView.attributedText mutableCopy];
        NSString *strTmp = [NSString stringWithFormat:@"<weex>[exception]bundleJSType:%@\r\n%@\r\n",task.bundleJSType,exception.description];
        if(strTmp.length>0){
            NSMutableAttributedString *exceptionStr = [[NSMutableAttributedString alloc]initWithString:strTmp];
            [exceptionStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, strTmp.length)];
            [attrStr appendAttributedString:exceptionStr];
            textView.attributedText = attrStr;
            
            
        }
    });
    
}


@end
