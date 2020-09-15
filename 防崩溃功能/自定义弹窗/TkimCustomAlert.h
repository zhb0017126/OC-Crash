//
//  TkimCustomAlert.h
//  
//
//  Created by 赵泓博 on 2020/3/23.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^TkimCustomAlertBlock)(NSInteger buttonIndex);
@interface TkimCustomAlert : UIView

/**
 @method initWithTitle:message:actionBlock:btnTitle:
 @abstract 标题-消息类型alert弹窗创建方法
 @param title 标题字符串，可为空
 @param message 消息字符串，可为空
 @param actionBlock 点击回调block
 @param btnTitle 弹窗点击标题，多个标题用","逗号隔开
 @return 返回TkimCustomAlert 实例，调用show 方法展示
 */

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                    actionBlock:(TkimCustomAlertBlock)actionBlock
            btnTitle:(NSString *)btnTitle, ... NS_REQUIRES_NIL_TERMINATION ; ;

/**
@method initWithTitle:message:actionBlock:btnTitles:
@abstract 标题-消息类型alert弹窗创建方法
@param title 标题字符串，可为空
@param message 消息字符串，可为空
@param actionBlock 点击回调block
@param btnTitles 弹窗点击标题，多个标题数组
@return 返回TkimCustomAlert 实例，调用show 方法展示
*/
-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                    actionBlock:(TkimCustomAlertBlock)actionBlock
            btnTitles:(NSArray <NSString *> *)btnTitles;

/**
@method initWithTitle:message:actionBlock:btnTitle:
@abstract 图片-标题-消息类型alert弹窗创建方法
@param title 标题字符串，可为空
@param message 消息字符串，可为空
@param image 图片实例，可为空
@param actionBlock 点击回调block
@param btnTitle 弹窗点击标题，多个标题用","逗号隔开
@return 返回TkimCustomAlert 实例，调用show 方法展示
*/
-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                       image:(UIImage *)image
                    actionBlock:(TkimCustomAlertBlock)actionBlock
            btnTitle:(NSString *)btnTitle, ... NS_REQUIRES_NIL_TERMINATION ; ;

/**
@method initWithTitle:message:actionBlock:btnTitles:
@abstract 标题-消息类型alert弹窗创建方法
@param title 标题字符串，可为空
@param message 消息字符串，可为空
@param image 图片实例，可为空
@param actionBlock 点击回调block
@param btnTitles 弹窗点击标题，多个标题数组
@return 返回TkimCustomAlert 实例，调用show 方法展示
*/
-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                       image:(UIImage *)image
                    actionBlock:(TkimCustomAlertBlock)actionBlock
            btnTitles:(NSArray <NSString *> *)btnTitles;

/**
 @method show
 @abstract 弹窗显示方法，由TkimCustomAlert 实例调用
 */
-(void)show;




@end

NS_ASSUME_NONNULL_END
