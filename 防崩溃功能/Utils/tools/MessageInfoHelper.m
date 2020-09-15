//
//  MessageInfoHelper.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/8/27.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "MessageInfoHelper.h"

@implementation MessageInfoHelper
#pragma mark 帮助函数
+ (void)handleErrorinfomationWithErorName:(NSString *)errorName errorReason:(NSString *)errorReason
{
    // 堆栈数据
    NSArray *callStackSymbolsArr     = [NSThread callStackSymbols];
    // 获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [self customStackWithSymbols:callStackSymbolsArr];
    
    if (mainCallStackSymbolMsg == nil)  mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
        
    
  
    NSString *errorPlace      = [NSString stringWithFormat:@"Error Place:%@",mainCallStackSymbolMsg];
 
    

    
    
    NSDictionary *errorInfoDic = @{
                                   @"ErrorName"        : errorName,
                                   @"ErrorReason"      : errorReason,
                                   @"ErrorPlace"       : errorPlace,
                                   @"CallStackSymbols" : callStackSymbolsArr
                                   };
    
    NSLog(@"%@",errorInfoDic);
    // 将错误信息放在字典里，用通知的形式发送出去
    dispatch_async(dispatch_get_main_queue(), ^{
        
      //  [[NSNotificationCenter defaultCenter] postNotificationName:ExcepitionHappenedNotification object:nil userInfo:errorInfoDic];
        
    });
}


/**

 */
+ (NSString *)customStackWithSymbols:(NSArray<NSString *> *)callStackSymbols
{
    // mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    // 匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    //正则
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    __block NSString *targetString = @"";
    for (int index = 2; index < callStackSymbols.count; index++) {
        
        NSString *callStackSymbol = callStackSymbols[index];
        [regularExp enumerateMatchesInString:callStackSymbol
                                     options:NSMatchingReportProgress
                                       range:NSMakeRange(0, callStackSymbol.length)
                                  usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                      
              if (result) {
                  NSString *tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range]; //匹配到的字符串
                  NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                  className           = [className componentsSeparatedByString:@"["].lastObject; //获取类名
                  NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)]; // 获取bundle
                  if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                      /**
                       ![className hasSuffix:@")"] // 不是系统类，系统类定义都带（）
                        bundle == [NSBundle mainBundle] 确定是不是mainbundle中定义的类
                       */
                      targetString = [NSString stringWithFormat:@"%@\n%@\n",targetString,tempCallStackSymbolMsg];
                      mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                      
                  }
                  *stop = YES; //本次正则判断结束后
              }
                                      
      }];
        
        //if (mainCallStackSymbolMsg.length){ break;} //这里这么写，会遍历最后的方法就跳出
        
    }
    
//    return mainCallStackSymbolMsg;
    return targetString;
}
+ (void)alertWithTitle:(NSString *)title;
{
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
      dispatch_async(dispatch_get_main_queue(), ^{
         
          
      });
     
      #endif
    
}
@end
