//
//  NSArray+SafeArray.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/8/18.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSArray+SafeArray.h"
#import "NSObject+Hook.h"
#import "MessageInfoHelper.h"
@implementation NSArray (SafeArray)
+(void)load
{
    [self hy_NSArrayProtectorSwizzleMethod];
}
+ (void)hy_NSArrayProtectorSwizzleMethod
{
  Class class =  NSClassFromString(@"__NSSingleObjectArrayI");
  hy_swizzleInstanceMethodImplementation([class class], @selector(initWithObjects:count:), @selector(singleArrayInitWithObjects:count:));
    
  class =  NSClassFromString(@"__NSArrayI");
  hy_swizzleInstanceMethodImplementation([class class], @selector(initWithObjects:count:), @selector(iArrayInitWithObjects:count:));
    
  class =  NSClassFromString(@"__NSArray0");
  hy_swizzleInstanceMethodImplementation([class class], @selector(initWithObjects:count:), @selector(array0InitWithObjects:count:));
   
  class =  NSClassFromString(@"__NSPlaceholderArray");
  hy_swizzleInstanceMethodImplementation([class class], @selector(initWithObjects:count:), @selector(placeholderArrayInitWithObjects:count:));
    
}

-(void)alertWithIndex:(NSUInteger)index
{
   NSString *massage = [NSString stringWithFormat:@"%@",[MessageInfoHelper customStackWithSymbols: [NSThread callStackSymbols]]];
  #if DEBUG
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"数组第%lu位数据为nil",(unsigned long)index]
                                                                                   message:massage
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                  [alertVC addAction:[UIAlertAction actionWithTitle:@"好"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
                  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC
                                                                                               animated:YES
                                                                                             completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        
    });
   
    #endif
}
- (instancetype)array0InitWithObjects:(const id  _Nonnull __unsafe_unretained * )objects count:(NSUInteger)cnt;
{
    NSInteger newObjsIndex = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt]; //定义新数组？为什么要用__unsafe_unretained 类似weak 但是由于无weak表操作，所以会出现野指针问题。但本次无对应问题。
    for (int i = 0; i < cnt; i++) { //遍历赋值
        id objc = objects[i];
        if (objc == nil) {
            [self alertWithIndex:cnt];
            continue;
        }
        newObjects[newObjsIndex++] = objc;

    }

    return [self array0InitWithObjects:newObjects count:newObjsIndex];
}

- (instancetype)iArrayInitWithObjects:(const id  _Nonnull __unsafe_unretained * )objects count:(NSUInteger)cnt;
{
    NSInteger newObjsIndex = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    for (int i = 0; i < cnt; i++) {
        id objc = objects[i];
        if (objc == nil) {
             [self alertWithIndex:cnt];
            continue;
        }
        newObjects[newObjsIndex++] = objc;

    }
    return [self iArrayInitWithObjects:newObjects count:newObjsIndex];
}


- (instancetype)singleArrayInitWithObjects:(const id  _Nonnull __unsafe_unretained * )objects count:(NSUInteger)cnt;
{
    NSInteger newObjsIndex = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    for (int i = 0; i < cnt; i++) {
        id objc = objects[i];
        if (objc == nil) {
            [self alertWithIndex:cnt];
            continue;
        }
        newObjects[newObjsIndex++] = objc;

    }

    return [self singleArrayInitWithObjects:newObjects count:newObjsIndex];
}



- (instancetype)placeholderArrayInitWithObjects:(const id  _Nonnull __unsafe_unretained * )objects count:(NSUInteger)cnt;
{
    NSInteger newObjsIndex = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    for (int i = 0; i < cnt; i++) {
        id objc = objects[i];
        if (objc == nil) {
            [self alertWithIndex:cnt];
            continue;
        }
        newObjects[newObjsIndex++] = objc;

    }

    return [self placeholderArrayInitWithObjects:newObjects count:newObjsIndex];
}

@end
