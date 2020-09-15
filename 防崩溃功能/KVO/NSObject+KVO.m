//
//  NSObject+KVO.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/8/28.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSObject+KVO.h"
#import "NSObject+Hook.h"

#import "MessageInfoHelper.h"
#import <objc/runtime.h>

static void(*__hook_orgin_function_removeObserver)(NSObject* self, SEL _cmd ,NSObject *observer ,NSString *keyPath) = ((void*)0);
@interface KVOProxy : NSObject{
    __unsafe_unretained NSObject *_observed;
}

/***/
@property (nonatomic,strong)NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *kvoInfoMap;
@end

@implementation KVOProxy
-(instancetype)initWithObserver:(NSObject *)observer
{
    self = [super init];
    if (self) {
        _observed = observer;
    }
    return self;;
}
- (NSMutableDictionary<NSString *,NSHashTable<NSObject *> *> *)kvoInfoMap {
    if (!_kvoInfoMap) {
        _kvoInfoMap = @{}.mutableCopy;
    }
    return  _kvoInfoMap;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // dispatch to origina observers
    NSHashTable<NSObject *> *os = self.kvoInfoMap[keyPath];
    for (NSObject  *observer in os) {
        @try {
            [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        } @catch (NSException *exception) {
            [MessageInfoHelper alertWithTitle:@"kvo"];
        }
    }
}
- (void)dealloc {
    @autoreleasepool {
        NSDictionary<NSString *, NSHashTable<NSObject *> *> *kvoinfos =  self.kvoInfoMap.copy;
        for (NSString *keyPath in kvoinfos) {
            // call original  IMP
            __hook_orgin_function_removeObserver(_observed,@selector(removeObserver:forKeyPath:),self, keyPath);
        }
    }
}


@end

@interface  NSObject (KVO)
/**<#标注#>*/
@property (nonatomic,strong) KVOProxy *kvoProxy;
@end

@implementation NSObject (KVO)

+(void)load
{
    [self hy_KVOProtectorSwizzleMethod];
}
+ (void)hy_KVOProtectorSwizzleMethod
{
    

    /**保留函数指针，给外部调用*/
    __hook_orgin_function_removeObserver = (void *)class_getMethodImplementation([self class],     @selector(safe_removeObserver:forKeyPath:));
}

#pragma mark getter
- (void)setKvoProxy:(KVOProxy *)kvoProxy {
    objc_setAssociatedObject(self, @selector(kvoProxy), kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KVOProxy *)kvoProxy {
    return objc_getAssociatedObject(self, @selector(kvoProxy));
}
- (void)safe_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    
    
    if ([observer isKindOfClass:NSClassFromString(@"RACKVOProxy")]) {
        [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }
   
    if (!self.kvoProxy) {
        @autoreleasepool {
            self.kvoProxy = [[KVOProxy alloc] initWithObserver:self];
        }
    }
    NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
   if (os.count == 0) {
       os = [[NSHashTable alloc] initWithOptions:(NSPointerFunctionsWeakMemory) capacity:0];
       [os addObject:observer];
       [self safe_addObserver:self.kvoProxy forKeyPath:keyPath options:options context:context];
       self.kvoProxy.kvoInfoMap[keyPath] = os;
       return ;
   }

   
 
}
- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    NSHashTable<NSObject *> *os = self.kvoProxy.kvoInfoMap[keyPath];
       
       if (os.count == 0) {
           [MessageInfoHelper alertWithTitle:[NSString stringWithFormat:@"target is %@  KVO remove Observer to many times.",
                                              [self class]]];
           return;
       }
       
       [os removeObject:observer];
       
       if (os.count == 0) {
           [self safe_removeObserver:observer forKeyPath:keyPath];
           
           [self.kvoProxy.kvoInfoMap removeObjectForKey:keyPath];
       }
    
}


@end
