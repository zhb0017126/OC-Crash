//
//  NSObject+Hook.h
//  ElectircPowerDemo
//  hook 类方法和实例方法
//  Created by 赵泓博 on 2020/4/8.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TkimCustomAlert.h"
NS_ASSUME_NONNULL_BEGIN
/**
 交换某个类的两个实例方法

 @param cls              要交换的类
 @param originSelector   原方法
 @param swizzledSelector 要交换的方法
 */
void hy_swizzleInstanceMethodImplementation( Class cls, SEL originSelector, SEL swizzledSelector );

/**
 交换某个类的两个类方法
 
 @param cls              要交换的类
 @param originSelector   原方法
 @param swizzledSelector 要交换的方法
 */
void hy_swizzleClassMethodImplementation( Class cls, SEL originSelector, SEL swizzledSelector );

@interface NSObject (Hook)

@end

NS_ASSUME_NONNULL_END
