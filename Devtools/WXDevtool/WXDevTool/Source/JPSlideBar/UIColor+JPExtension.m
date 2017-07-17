//
//  UIColor+JPExtension.m
//  JPSlideBar
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import "UIColor+JPExtension.h"

@implementation UIColor (JPExtension)


static const char * RValueKEY = "RValueKEY";
static const char * GValueKEY = "GValueKEY";
static const char * BValueKEY = "BValueKEY";
static const char * AValueKEY = "AValueKEY";

- (void)setRValue:(CGFloat)RValue{
    objc_setAssociatedObject(self, RValueKEY, @(RValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)RValue{
    return [objc_getAssociatedObject(self, RValueKEY) floatValue];
}

- (void)setGValue:(CGFloat)GValue{
    objc_setAssociatedObject(self, GValueKEY, @(GValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)GValue{
    return [objc_getAssociatedObject(self, GValueKEY) floatValue];
}

- (void)setBValue:(CGFloat)BValue{
    objc_setAssociatedObject(self, BValueKEY, @(BValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)BValue{
    return [objc_getAssociatedObject(self, BValueKEY) floatValue];
}

- (void)setAValue:(CGFloat)AValue{
    objc_setAssociatedObject(self, AValueKEY, @(AValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)AValue{
    return [objc_getAssociatedObject(self, AValueKEY) floatValue];
}

- (void)jp_decomposeColorObjectIntoRGBValue{    // 必须是RGB值设置的颜色
    
    NSString * colorString = [NSString stringWithFormat:@"%@",self];
    if ([colorString hasPrefix:@"UIDeviceWhiteColorSpace"]) {
        NSException * excption = [NSException exceptionWithName:@"JPSlideBarException" reason:@"使用JPSlideBarStyleShowSliderAndGradientColor渐变模式时，正常/选中状态的字体颜色都必须使用RGB值初始化的UIColor对象" userInfo:nil];
    
        [excption raise];
    }
    
//    NSArray * conponents = [colorString componentsSeparatedByString:@" "];
//    CGFloat r = [conponents[1] floatValue];
//    CGFloat g = [conponents[2] floatValue];
//    CGFloat b = [conponents[3] floatValue];
//    CGFloat a = [conponents[4] floatValue];
    
    const CGFloat * conponents = CGColorGetComponents(self.CGColor);
    CGFloat r = conponents[0];
    CGFloat g = conponents[1];
    CGFloat b = conponents[2];
    CGFloat a = conponents[3];
    
    
    self.RValue = r;
    self.GValue = g;
    self.BValue = b;
    self.AValue = a;
}

@end
