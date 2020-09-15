//
//  NSMutableArray+SafeArray.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/8/27.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSMutableArray+SafeArray.h"
#import "NSObject+Hook.h"

#import "MessageInfoHelper.h"
@implementation NSMutableArray (SafeArray)
+(void)load
{
    [self hy_NSMutableArrayProtectorSwizzleMethod];
}
+ (void)hy_NSMutableArrayProtectorSwizzleMethod
{
     Class class =  NSClassFromString(@"__NSArrayM");
    
     hy_swizzleInstanceMethodImplementation([class class], @selector(objectAtIndex:), @selector(safe_objectAtIndex:));
    hy_swizzleInstanceMethodImplementation([class class], @selector(objectAtIndexedSubscript:), @selector(safe_objectAtIndexedSubscript:));
    hy_swizzleInstanceMethodImplementation([class class], @selector(insertObject:atIndex:), @selector(safe_insertObject:atIndex:));
    hy_swizzleInstanceMethodImplementation([class class], @selector(removeObjectAtIndex:), @selector(safe_removeObjectAtIndex:));
    hy_swizzleInstanceMethodImplementation([class class], @selector(setObject:atIndexedSubscript:), @selector(safe_setObject:atIndexedSubscript:));
    hy_swizzleInstanceMethodImplementation([class class], @selector(getObjects:range:), @selector(safe_getObjects:range:));
    
}
-(id)safe_objectAtIndex:(NSUInteger)index
{
    if (index > self.count||index<0) {
        [MessageInfoHelper alertWithTitle:[NSString stringWithFormat:@"数组index 越界: index: %lu",(unsigned long)index]];
        return nil;
    }else{
        return [self safe_objectAtIndex:index];
        
    }
}

-(id)safe_objectAtIndexedSubscript:(NSUInteger)index
{
    if (index > self.count||index<0) {
        [MessageInfoHelper alertWithTitle:[NSString stringWithFormat:@"数组index 越界: index: %lu",(unsigned long)index]];
        return nil;
    }else{
        return [self safe_objectAtIndexedSubscript:index];
        
    }
}
- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject == nil) {
         [MessageInfoHelper alertWithTitle:[NSString stringWithFormat:@"数组添加数据为nil"]];
    }else if (index > self.count||index<0){
         [MessageInfoHelper alertWithTitle:[NSString stringWithFormat:@"数组index 越界: index: %lu",(unsigned long)index]];
        
    }else{
        [self safe_insertObject:anObject atIndex:index];
    }
    
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index {
    if (index > self.count||index<0){
         [MessageInfoHelper alertWithTitle:[NSString stringWithFormat:@"数组index 越界: index: %lu",(unsigned long)index]];
    }else{
        [self safe_removeObjectAtIndex:index];
    }
}

- (void)safe_setObject:(id)anObject atIndexedSubscript:(NSUInteger)index {
    if (anObject == nil) {
         [MessageInfoHelper alertWithTitle:[NSString stringWithFormat:@"数组添加数据为nil"]];
    }else if (index > self.count||index<0){
         [MessageInfoHelper alertWithTitle:[NSString stringWithFormat:@"数组index 越界: index: %lu",(unsigned long)index]];
        
    }else{
        [self safe_setObject:anObject atIndexedSubscript:index];
    }
    
}
- (void)safe_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    
    if (range.location<0|| range.location > self.count) {
        
    }else if (range.location + range.length > self.count){
        
    }else{
      
    }
    
     [self safe_getObjects:objects range:range];
    
}

@end
