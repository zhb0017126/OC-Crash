//
//  NSObject+Hook.m
//  ElectircPowerDemo
//  hook 类方法和实例方法
//  Created by 赵泓博 on 2020/4/8.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSObject+Hook.h"
#import <objc/runtime.h>
/**hook实例方法*/
void hy_swizzleInstanceMethodImplementation(Class cls, SEL originSelector, SEL swizzledSelector)
{
    if (!cls) return;

    // 获取旧method
    Method originalMethod = class_getInstanceMethod(cls, originSelector);
    /**获取新mehtod*/
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    /**将旧方法method，替换为新方法method*/
    BOOL didAddMethod =  class_addMethod(cls,
                                         originSelector,
                                         method_getImplementation(swizzledMethod),
                                         method_getTypeEncoding(swizzledMethod));


    /**是否添加成功*/
    if (didAddMethod) {
        /**新方法mehtod 替换为旧的方法method*/
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        
        /**
                1. replace 将原方法替换，返回原来的IMP
                                   2. 将新方法，替换为原方法的IMP
                                    
         */
        class_replaceMethod(cls,
                            swizzledSelector,
                            class_replaceMethod(cls,
                                                originSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod)),
                            method_getTypeEncoding(originalMethod));
        // 用此方法引起未知崩溃，原因待查
        // method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
/**hook 类方法*/
void hy_swizzleClassMethodImplementation(Class cls, SEL originSelector, SEL swizzledSelector)
{
    if (!cls) return;

        /**获取元类，类方法 是元类对象的实例方法*/
    Class metacls = objc_getMetaClass(NSStringFromClass(cls).UTF8String);

    Method originalMethod = class_getClassMethod(cls, originSelector);
    Method swizzledMethod = class_getClassMethod(cls, swizzledSelector);

    BOOL didAddMethod = class_addMethod(metacls,
                                        originSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(metacls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));

    } else {
        /**类方法可以随意替换imp*/
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



@implementation NSObject (Hook)

/**替换OC实现，*/
+ (void)hy_swizzleInstanceMethodImplementation:(SEL)originSelector withSEL:(SEL)swizzledSelector
{
    Class class = [self class];
    
    hy_swizzleInstanceMethodImplementation(class, originSelector, swizzledSelector);
}
/**替换OC实现，*/

+ (void)hy_swizzleClassMethodImplementation:(SEL)originSelector withSEL:(SEL)swizzledSelector
{
    Class class = [self class];
    
    hy_swizzleClassMethodImplementation(class, originSelector, swizzledSelector);
    
}

@end
