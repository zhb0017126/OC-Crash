//
//  CustomProxy.h
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/9/11.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomProxy : NSProxy
- (void)transformObjc:(NSObject *)objc;
@end

NS_ASSUME_NONNULL_END
