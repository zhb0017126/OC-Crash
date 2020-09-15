//
//  NSDictionary+SafeDictionary.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/8/27.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSDictionary+SafeDictionary.h"


#import "MessageInfoHelper.h"
#import "NSObject+Hook.h"

@implementation NSDictionary (SafeDictionary)
+(void)load
{
    [self hy_NSDictionaryProtectorSwizzleMethod];
}
+ (void)hy_NSDictionaryProtectorSwizzleMethod
{
  hy_swizzleClassMethodImplementation([self class], @selector(dictionaryWithObjects:forKeys:count:), @selector(safeDictionaryWithObjects:forKeys:count:));
       
    
}
+(instancetype)safeDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt
{
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            [self alertWithKey:tmpKey object:tmpItem];
            continue;
        }
        newObjects[index] = objects[i];
        newkeys[index] = keys[i];
        index++;
    }
  
   return  [self safeDictionaryWithObjects:newObjects forKeys:newkeys count:index];
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
