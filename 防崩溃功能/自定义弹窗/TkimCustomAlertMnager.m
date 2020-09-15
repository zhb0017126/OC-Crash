//
//  TkimCustomAlertMnager.m
//  
//
//  Created by 赵泓博 on 2020/4/10.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "TkimCustomAlertMnager.h"
#import "TkimCustomALertQueue.h"
#define WINDOWBACKGROUNDCOLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
@interface TkimCustomAlertMnager ()


/***/
@property (nonatomic,strong) TkimCustomALertQueue *alertQueue;
/***/
@property (nonatomic,strong) UIWindow *alertWindow;




@end

@implementation TkimCustomAlertMnager

+(instancetype)shareInstace;
{
   static TkimCustomAlertMnager *shared = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       shared = [[TkimCustomAlertMnager alloc]init];
       shared.alertWindow.windowLevel = UIWindowLevelAlert +10;
       shared.alertQueue = [TkimCustomALertQueue new];
    
   });
   return shared;
}

//-(NSString *)viewForKey:(UIView *)view
//{
//    return [NSString stringWithFormat:@"%p",view];
//}
-(void)add:(TkimCustomAlert*)view;
{
    BOOL isShowAlert = NO;
    if ([self.alertQueue isEmpty]) {
        /**空直接展示*/
        isShowAlert = YES;
    }
    [self.alertQueue pushObject:view];
    if (isShowAlert) {
        [self showALertView:view];
    }
}




-(void)remove:(TkimCustomAlert*)view;
{
    [view removeFromSuperview];
    [self.alertQueue popObject];
    if ([self.alertQueue isEmpty]) {
        [[[[UIApplication sharedApplication]delegate]window] makeKeyAndVisible];
        self.alertWindow.hidden = YES;
        
    }else{
        TkimCustomAlert *nextView = [self.alertQueue getQueueInfo];
        [self showALertView:nextView];
    }
}
-(void)showALertView:(TkimCustomAlert*)alertView;
{
    self.alertWindow.windowLevel = UIWindowLevelAlert +10;
       
    self.alertWindow.hidden = NO;
    alertView.center = self.alertWindow.center;
       [self.alertWindow addSubview:alertView];
      alertView.alpha = 0;
      [UIView animateWithDuration:0.25 animations:^{
          alertView.alpha = 1;
      } completion:^(BOOL finished) {
          alertView.alpha = 1;
      }];
}

#pragma mark queueWindow
-(UIWindow *)alertWindow
{
    if (!_alertWindow) {
        _alertWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _alertWindow.backgroundColor =WINDOWBACKGROUNDCOLOR;
        _alertWindow.hidden = NO;
    }
    return _alertWindow;
}
-(void)dealloc
{
//    NSLog(@"111111111111123123123");
}
@end

