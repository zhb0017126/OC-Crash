//
//  NSTimer+SafeTimer.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/9/12.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSTimer+SafeTimer.h"
#import <objc/runtime.h>
#import "NSArray+SafeArray.h"
#import "NSObject+Hook.h"

#import "MessageInfoHelper.h"
@interface NSTimerProxy : NSObject
@property (nonatomic, weak) NSTimer *sourceTimer;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL aSelector;
/***/
@property (nonatomic,copy) void(^targetBlock)(NSTimer * _Nonnull);
//(void (^)(NSTimer * _Nonnull));
@end

@implementation NSTimerProxy
/**
 1. weak target   timer不会强引用。而一旦target释放，timer没有释放，就会引发崩溃，此处是在调用的时候，检测是否timer还在调用。
 2.NSTimerProxy 本身是通过关联绑定的类。所以timer释放后，在delloc里面会自动释放
 */
- (void)trigger:(id)userinfo  {
    id strongTarget = self.target;
    if (strongTarget && ([strongTarget respondsToSelector:self.aSelector])) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:self.aSelector withObject:userinfo];
#pragma clang diagnostic pop
    } else {
        NSTimer *sourceTimer = self.sourceTimer;
        if (sourceTimer) {
            [sourceTimer invalidate];
        }
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error target is %@ method is %@, reason : an object dealloc not invalidate Timer.",[self class], NSStringFromSelector(self.aSelector)];
       
    }
}


@end

@interface NSTimer ()
/**解耦target*/
@property (nonatomic,strong) NSTimerProxy *timerProxy;
@end

@implementation NSTimer (SafeTimer)
+(void)load
{
    [self hy_NSArrayProtectorSwizzleMethod];
}
+ (void)hy_NSArrayProtectorSwizzleMethod
{
  
  hy_swizzleClassMethodImplementation([self class], @selector(timerWithTimeInterval:target:selector:userInfo:repeats:), @selector(safe_timerWithTimeInterval:target:selector:userInfo:repeats:));
    hy_swizzleClassMethodImplementation([self class], @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:), @selector(safe_scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:));

   
   
    
}
- (void)setTimerProxy:(NSTimerProxy *)timerProxy {
    objc_setAssociatedObject(self, @selector(timerProxy), timerProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimerProxy *)timerProxy {
    return objc_getAssociatedObject(self, @selector(timerProxy));
}



+ (NSTimer *)safe_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
{
    if (yesOrNo) {
        NSTimer *timer =  nil ;
        @autoreleasepool {
            NSTimerProxy *proxy = [NSTimerProxy new];
            proxy.target = aTarget;
            proxy.aSelector = aSelector;
            timer.timerProxy = proxy;
            timer = [[self class] safe_timerWithTimeInterval:ti target:proxy selector: @selector(trigger:) userInfo:userInfo repeats:yesOrNo];
            proxy.sourceTimer = timer;
        }
        return  timer;
    }
    return[[self class] safe_timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];

}

+ (NSTimer *)safe_scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
{
    if (yesOrNo) {
        NSTimer *timer =  nil ;
        @autoreleasepool {
            NSTimerProxy *proxy = [NSTimerProxy new];
            proxy.target = aTarget;
            proxy.aSelector = aSelector;
            timer.timerProxy = proxy;
            timer = [[self class] safe_scheduledTimerWithTimeInterval:ti target:proxy selector: @selector(trigger:) userInfo:userInfo repeats:yesOrNo];
            proxy.sourceTimer = timer;
        }
        return  timer;
    }
    return[[self class] safe_scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    
}

@end
