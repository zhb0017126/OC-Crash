//
//  SafeObject.m
//  ElectircPowerDemo
// 防崩溃--给没有IMP的函数添加imp 并且归这个类执行
//  Created by 赵泓博 on 2020/4/9.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "SafeObject.h"
#import <objc/runtime.h>
@implementation SafeObject
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static SafeObject *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
         sharedInstance = [[self alloc] init];
    });
    return sharedInstance;;
}

-(void)addFunc:(SEL)sel;
{
    __addMethod([self class],sel);
}
/**
 default Implement

 @param target trarget
 @param cmd cmd
 @param ... other param
 @return default Implement is zero
 */
int smartFunction(id target, SEL cmd, ...) {
    return 0;
    
}

static BOOL __addMethod(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunction, funcTypeEncoding);
}

+ (BOOL)addClassFunc:(SEL)sel {
    Class metaClass = objc_getMetaClass(class_getName([SafeObject class]));
    return __addMethod(metaClass, sel);
}



@end
