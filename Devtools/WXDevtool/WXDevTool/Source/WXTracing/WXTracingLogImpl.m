//
//  WXTracingLogImpl.m
//  Pods
//
//  Created by 齐山 on 2017/7/10.
//
//

#import "WXTracingLogImpl.h"
#import "WXTracingViewControllerManager.h"

@implementation WXTracingLogImpl

- (WXLogLevel)logLevel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"wxloglevel"]) {
        return [[defaults objectForKey:@"wxloglevel"] integerValue];
    }
    return WXLogLevelLog;
}
- (void)log:(WXLogFlag)flag message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
//        UITextView *textView = [WXTracingViewControllerManager sharedInstance].textView;
//        NSMutableAttributedString *attrStr = [textView.attributedText mutableCopy];
//        NSString *str = [NSString stringWithFormat:@"%@\r\n",message];
//        if(str.length>0){
//            NSMutableAttributedString *logStr = [[NSMutableAttributedString alloc]initWithString:str];
//            UIColor *color = [UIColor blackColor];
//            if([str rangeOfString:@"[warn]"].location != NSNotFound){
//                color= [UIColor colorWithRed:229/255.0 green:178/255.0 blue:32/255.0 alpha:1.0];
//            }
//            [logStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, str.length-1)];
//            [attrStr appendAttributedString:logStr];
//            
//            textView.attributedText = attrStr;
//            
//            
//        }
        NSMutableArray *messages = [WXTracingViewControllerManager sharedInstance].messages;
        [messages addObject:message];
    });
}

@end
