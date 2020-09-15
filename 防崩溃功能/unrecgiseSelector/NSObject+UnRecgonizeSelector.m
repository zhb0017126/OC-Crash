//
//  NSObject+UnRecgonizeSelector.m
//  ElectircPowerDemo
//
//  Created by 赵泓博 on 2020/4/8.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSObject+UnRecgonizeSelector.h"
#import "NSObject+Hook.h"
#import <objc/runtime.h>
#import "SafeObject.h"
#import <dlfcn.h>


// 打印异常信息的标记
#define ExcepitionHappenedEnd   @"================================================================"
#define ExcepitionHappenedStart @"========================⚠️⚠️⚠️⚠️⚠️⚠️⚠️========================="
@implementation NSObject (UnRecgonizeSelector)
+(void)load
{
    [NSObject hy_UnrecognizedSelectorProtectorSwizzleMethod];
}

//+(BOOL)resolveClassMethod:(SEL)sel
//{
//    return [super resolveClassMethod:sel];
//}
+ (void)hy_UnrecognizedSelectorProtectorSwizzleMethod
{
    /**hook实例方法*/
    hy_swizzleInstanceMethodImplementation([self class], @selector(methodSignatureForSelector:), @selector(safeMethodSignatureForSelector:));
    hy_swizzleInstanceMethodImplementation([self class], @selector(forwardInvocation:), @selector(safeForwardInvocation:));
    
  // hy_swizzleInstanceMethodImplementation([self class], @selector(forwardingTargetForSelector:), @selector(safeInstaceForwardingTargetForSelector:));
    /**hook类方法*/
   hy_swizzleClassMethodImplementation([self class], @selector(forwardingTargetForSelector:), @selector(safeClassForwardingTargetForSelector:));
    
    
    
}
-(id)safeInstaceForwardingTargetForSelector:(SEL)aSelector{
    BOOL aBool = [self respondsToSelector:aSelector];
        NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
       
       if (aBool||signatrue) {
           return [self safeClassForwardingTargetForSelector:aSelector];
       }else{
          //  NSLog(@"class::::%@:%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector));
           
           TkimCustomAlert *alert = [[TkimCustomAlert alloc] initWithTitle:@"实例方法崩溃" message:[NSString stringWithFormat:@"类名:%@ \n 方法名:%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)] actionBlock:^(NSInteger buttonIndex) {
               
           } btnTitle:@"确定", nil];

           [alert show];
           
           SafeObject * obj = [SafeObject shareInstance];
          
           [obj addFunc:aSelector];
           return obj;
           
       }
}
#pragma mark 兼容类方法
- (id)safeClassForwardingTargetForSelector:(SEL)aSelector {
    
    
    
    
    BOOL aBool = [self respondsToSelector:aSelector];
     NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool||signatrue) {
        return [self safeClassForwardingTargetForSelector:aSelector];
    }else{
       //  NSLog(@"class::::%@:%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector));
        
        TkimCustomAlert *alert = [[TkimCustomAlert alloc] initWithTitle:@"类方法崩溃" message:[NSString stringWithFormat:@"类名:%@ \n 方法名:%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)] actionBlock:^(NSInteger buttonIndex) {
            
        } btnTitle:@"确定", nil];

        [alert show];
        
        SafeObject * obj = [SafeObject shareInstance];
       
        [obj addFunc:aSelector];
        return obj;
        
    }
   
    
}


#pragma mark  实例方法处理
- (NSMethodSignature *)safeMethodSignatureForSelector:(SEL)aSelector
{
    /**此时self 是实例self 不是外部self*/
    NSMethodSignature *methodSignature = [self safeMethodSignatureForSelector:aSelector];
    if (methodSignature) return methodSignature;

    
    IMP originIMP   = class_getMethodImplementation([NSObject class], @selector(methodSignatureForSelector:));
    
    IMP currentClassIMP = class_getMethodImplementation([self class],     @selector(methodSignatureForSelector:));
    // 如果子类重载了该方法，则返回nil
    if (originIMP != currentClassIMP) return nil;
    
    // - (void)xxxx
    
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    // v  void  返回值
    // @ self  objc_msgsend(id self @selector) 默认参数1
    // : @selector  objc_msgsend(id self @selector) 默认参数2
    // 空 表示该方法无携带带参数
}
- (void)safeForwardInvocation:(NSInvocation *)invocation
{
    NSString *reason = [NSString stringWithFormat:@"class:[%@] not found selector:(%@) calssinfo:%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector),self];

    NSLog(@"instace  %@,%@",NSStringFromClass(self.class),NSStringFromSelector(invocation.selector));

    NSException *exception = [NSException exceptionWithName:@"Unrecognized Selector"
                                                     reason:reason
                                                   userInfo:nil];
    
    
//    TkimCustomAlert *alert = [[TkimCustomAlert alloc] initWithTitle:@"实例法崩溃" message:[NSString stringWithFormat:@"类名:%@ \n 方法名:%@",NSStringFromClass([self class]),NSStringFromSelector(invocation.selector)] actionBlock:^(NSInteger buttonIndex) {
//
//    } btnTitle:@"确定", nil];
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//    });
//    [alert show];
    
    [[self class] handleErrorWithException:exception];

   
}

#pragma mark 帮助函数
+ (void)handleErrorWithException:(NSException *)exception
{
    // 堆栈数据
    NSArray *callStackSymbolsArr     = [NSThread callStackSymbols];
    // 获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [self getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    
    if (mainCallStackSymbolMsg == nil)  mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
        
    
    NSString *errorName   = exception.name;
    NSString *errorReason = exception.reason;
    // errorReason 可能为 -[__NSCFConstantString avoidCrashCharacterAtIndex:]: Range or index out of bounds
    errorReason           = [errorReason stringByReplacingOccurrencesOfString:@"avoidCrash" withString:@""];
    
    
    // 拼接错误信息
    NSString *errorPlace      = [NSString stringWithFormat:@"Error Place:%@",mainCallStackSymbolMsg];
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n",ExcepitionHappenedStart, errorName, errorReason, errorPlace];
    logErrorMessage           = [NSString stringWithFormat:@"%@\n\n%@\n\n",logErrorMessage,ExcepitionHappenedEnd];
    
  //  NSlog(@"%@",logErrorMessage);
    
#if DEBUG
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:errorName
                                                                     message:errorReason
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"好"
                                                style:UIAlertActionStyleDefault
                                              handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC
                                                                                 animated:YES
                                                                               completion:nil];
#endif
    NSDictionary *errorInfoDic = @{
                                   @"ErrorName"        : errorName,
                                   @"ErrorReason"      : errorReason,
                                   @"ErrorPlace"       : errorPlace,
                                   @"Exception"        : exception,
                                   @"CallStackSymbols" : callStackSymbolsArr
                                   };
    NSLog(@"%@",errorInfoDic);
    // 将错误信息放在字典里，用通知的形式发送出去
    dispatch_async(dispatch_get_main_queue(), ^{
      //  [[NSNotificationCenter defaultCenter] postNotificationName:ExcepitionHappenedNotification object:nil userInfo:errorInfoDic];
    });
}

/**
 简化堆栈信息

 @param callStackSymbols 详细堆栈信息
 @return 简化之后的堆栈信息
 */
+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols
{
    // mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    // 匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    for (int index = 2; index < callStackSymbols.count; index++) {
        
        NSString *callStackSymbol = callStackSymbols[index];
        NSLog(@"callStackSymbol>>>>>>>>%@",callStackSymbol);
        [regularExp enumerateMatchesInString:callStackSymbol
                                     options:NSMatchingReportProgress
                                       range:NSMakeRange(0, callStackSymbol.length)
                                  usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                      
                                      if (result) {
                                          NSString *tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];

                                          NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                                          className           = [className componentsSeparatedByString:@"["].lastObject;
                                          
                                          NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                                          
                                          if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                                              mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                                              
                                          }
                                          
                                          *stop = YES;
                                      }
                                      
                                  }];
        
        if (mainCallStackSymbolMsg.length) break;
        
    }
    
    NSLog(@"mainCallStackSymbolMsg>>>>>>>%@",mainCallStackSymbolMsg);
    return mainCallStackSymbolMsg;
}

@end
/**
 static struct dl_info app_info;
 if (app_info.dli_saddr == NULL) {
     dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
 }
 struct dl_info self_info;
 dladdr((__bridge void *)[self class], &self_info);
 
 //    ignore system class
 if (strcmp(app_info.dli_fname, self_info.dli_fname)) {
      return [self safeClassForwardingTargetForSelector:aSelector];
 }else{
     
     NSLog(@"13123123");
 }
 
 if ([self isKindOfClass:[NSNumber class]] && [NSString instancesRespondToSelector:aSelector]) {
     NSNumber *number = (NSNumber *)self;
     NSString *str = [number stringValue];
     return str;
 } else if ([self isKindOfClass:[NSString class]] && [NSNumber instancesRespondToSelector:aSelector]) {
     NSString *str = (NSString *)self;
     NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
     NSNumber *number = [formatter numberFromString:str];
     return number;
 }
 
 {
     去除系统类hook*
    static struct dl_info app_info; // app类相关地址
     //https://blog.csdn.net/dragon101788/article/details/18673323
 //    dladdr - 获取某个地址的符号信息
    if (app_info.dli_saddr == NULL) {
        dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
    }
     // 当前类地址符号信息
    struct dl_info self_info;
    dladdr((__bridge void *)[self class], &self_info); // 获取某个符号地址信息
    
     /**
      strcmp(str1,str2)，若str1=str2，则返回零；若str1<str2，则返回负数；若str1>str2，则返回正数
      
      一般系统
      *
   NSLog(@"app_info is :%@",@(app_info.dli_fname));
 //  NSLog(@"self_info is :%@",@(self_info.dli_fname));
    
     if (strcmp(app_info.dli_fname, self_info.dli_fname)) {
         
     }else{
        
     }
 //   if (strcmp(app_info.dli_fname, self_info.dli_fname)) {
 //        return [self safeInstaceForwardingTargetForSelector:aSelector];
 //   }
      /*去除系统类结束
     
   
     return nil;
     
     
 }
 */
