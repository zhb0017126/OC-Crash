//
//  SafeObject.h
//  ElectircPowerDemo
//  防崩溃--给没有IMP的函数添加imp 并且归这个类执行
//  Created by 赵泓博 on 2020/4/9.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SafeObject : NSObject

+(instancetype)shareInstance;
/**添加实例方法方法*/
-(void)addFunc:(SEL)sel;
/**添加类方法*/
+ (BOOL)addClassFunc:(SEL)sel;
@end

NS_ASSUME_NONNULL_END
