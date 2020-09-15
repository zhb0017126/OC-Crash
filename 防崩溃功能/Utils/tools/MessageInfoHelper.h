//
//  MessageInfoHelper.h
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/8/27.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TkimCustomAlert.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageInfoHelper : NSObject
+ (void)handleErrorWithException:(NSException *)exception;
+ (NSString *)customStackWithSymbols:(NSArray<NSString *> *)callStackSymbols;
+ (void)alertWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
