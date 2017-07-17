//
//  JPSlideBarConst.h
//  JPSlideBar
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JPSlideBarConst : NSObject


UIKIT_EXTERN const CGFloat    JPSlideBarMaxScaleValur;
UIKIT_EXTERN const CGFloat    JPSlideBarItemSpacing;
UIKIT_EXTERN const CGFloat    JPSlideBarHeight;
UIKIT_EXTERN const CGFloat    JPSlideBarItemBroadening;
UIKIT_EXTERN NSString * const JPSlideBarCurrentIndex;
UIKIT_EXTERN NSString * const JPSlideBarScrollViewContentOffsetX;
UIKIT_EXTERN NSString * const JPSlideBarChangePageNotification;


#define JColor_RGB_Float(R,G,B)   ([UIColor colorWithRed:(R) green:(G) blue:(B) alpha:1])
#define JColor_RGB(R,G,B)         ([UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0])


#define JPSlideBarScaleDValue   (JPSlideBarMaxScaleValur - 1)
#define JPScreen_Width          [UIScreen mainScreen].bounds.size.width
#define JPScreen_Height         [UIScreen mainScreen].bounds.size.height
#define JPSlider_Font           [UIFont systemFontOfSize:18]
#define JPNotificationCenter    [NSNotificationCenter defaultCenter]


#ifdef  DEBUG
#define JKLog(...) NSLog(__VA_ARGS__)
#else
#define JKLog(...)
#endif


// 转弱转换的宏，主要用于self强弱转换，不支持点语法
#ifndef    Weak
#if __has_feature(objc_arc)
#define Weak(object) __weak __typeof__(object) weak##object = object;
#else
#define Weak(object) autoreleasepool{} __block __typeof__(object) block##object = object;
#endif
#endif
#ifndef    Strong
#if __has_feature(objc_arc)
#define Strong(object) __typeof__(object) object = weak##object;
#else
#define Strong(object) try{} @finally{} __typeof__(object) object = block##object;
#endif
#endif
@end
