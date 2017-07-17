//
//  UIColor+JPExtension.h
//  JPSlideBar
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UIColor (JPExtension)

@property (nonatomic, assign)CGFloat RValue;
@property (nonatomic, assign)CGFloat GValue;
@property (nonatomic, assign)CGFloat BValue;
@property (nonatomic, assign)CGFloat AValue;

/**
 *  将color分解成RGB值,并用runtime增加R、G、BValue属性
 */
- (void)jp_decomposeColorObjectIntoRGBValue;

@end
