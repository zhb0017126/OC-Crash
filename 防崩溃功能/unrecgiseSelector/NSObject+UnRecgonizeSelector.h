//
//  NSObject+UnRecgonizeSelector.h
//  ElectircPowerDemo
//  
//  Created by 赵泓博 on 2020/4/8.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "TkimCustomAlert.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (UnRecgonizeSelector)
+ (void)hy_UnrecognizedSelectorProtectorSwizzleMethod;
@end

NS_ASSUME_NONNULL_END
