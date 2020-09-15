//
//  TkimCustomAlertMnager.h
//  
//
//  Created by 赵泓博 on 2020/4/10.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TkimCustomAlert.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface TkimCustomAlertMnager : NSObject


+(instancetype)shareInstace;

-(void)add:(TkimCustomAlert*)view;

-(void)remove:(TkimCustomAlert*)view;

@end

NS_ASSUME_NONNULL_END
