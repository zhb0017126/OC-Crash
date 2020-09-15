//
//  NSMutableDictionary+SafeDictionary.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/9/11.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSMutableDictionary+SafeDictionary.h"
#import "MessageInfoHelper.h"
#import "NSObject+Hook.h"

@implementation NSMutableDictionary (SafeDictionary)
+(void)load
{
    [self hy_NSDictionaryProtectorSwizzleMethod];
}
+ (void)hy_NSDictionaryProtectorSwizzleMethod
{
     Class class = NSClassFromString(@"__NSDictionaryM");
    hy_swizzleInstanceMethodImplementation([class class], @selector(setObject:forKeyedSubscript:), @selector(safe_setObject:forKeyedSubscript:));
     hy_swizzleInstanceMethodImplementation([class class], @selector(setObject:forKey:), @selector(safe_setObject:forKey:));
     hy_swizzleInstanceMethodImplementation([class class], @selector(removeObjectForKey:), @selector(safe_removeObjectForKey:));
    
}

-(void)safe_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (obj && key) {
        [self safe_setObject:obj forKeyedSubscript:key];
    }else{
        [[self class] alertWithKey:key object:obj];
    }
    
}

-(void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject&&aKey) {
        [self safe_setObject:anObject forKey:aKey];
    }else{
        [[self class] alertWithKey:aKey object:anObject];
    }
}
-(void)safe_removeObjectForKey:(id)aKey
{
    if (aKey) {
        [self safe_removeObjectForKey:aKey];
    }else{
        [[self class] alertWithKey:aKey object:@"obj不存在"];
    }
    
}

+(void)alertWithKey:(id )key  object:(id)object {
    NSString *title = [NSString stringWithFormat:@"key:%@ objct:%@",key?(NSString *)key:@"key为空",object?object:@"obj为空"];
    
    NSString *massage = [NSString stringWithFormat:@"%@",[MessageInfoHelper customStackWithSymbols: [NSThread callStackSymbols]]];
     #if DEBUG
       UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                                      message:massage
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                     [alertVC addAction:[UIAlertAction actionWithTitle:@"好"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:nil]];
                     [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC
                                                                                                  animated:YES
                                                                                                completion:nil];
       #endif
}
@end
