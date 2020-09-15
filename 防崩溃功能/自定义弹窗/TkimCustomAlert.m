//
//  TkimCustomAlert.m
//
//
//  Created by 赵泓博 on 2020/3/23.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "TkimCustomAlert.h"

#import "TkimCustomAlertMnager.h"

/**选择按键字体*/
#define ACTIONFONT [UIFont systemFontOfSize:18.0f]

/**标题字体*/
#define TITLEFONT [UIFont systemFontOfSize:18.0f]
/**信息字体*/
#define MESSAGEFONT [UIFont systemFontOfSize:14.0f]

/**确认按钮颜色*/
#define CONFIRMTITLECOLOR  [UIColor blueColor]
/**取消按钮颜色*/
#define CANCELTITLECOLOR  [UIColor lightGrayColor]
/**标题颜色*/

#define TITLECOLOR [UIColor blackColor]
/**信息颜色*/
#define MESSAGECOLOR [UIColor lightGrayColor]
/**分割线颜色*/
#define SPLITECOLOR [UIColor lightGrayColor]





@interface TkimCustomAlert ()

/***/
@property (nonatomic,copy) TkimCustomAlertBlock actionBlock;

///**消失*/
//-(void)dismiss;

@end


@implementation TkimCustomAlert
-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
    
}

#pragma mark init

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                    actionBlock:(TkimCustomAlertBlock)actionBlock
            btnTitle:(NSString *)btnTitle, ... NS_REQUIRES_NIL_TERMINATION ;
{
    
  
    NSMutableArray *array = [NSMutableArray new];
    if (btnTitle){
        va_list args;
        va_start(args, btnTitle);
        NSString *buttonTitle;
        [array addObject:btnTitle];
        while ((buttonTitle = va_arg(args, NSString *))) {
            [array addObject:buttonTitle];
        }
        
        va_end(args);
    }
    return [self initWithTitle:title message:message actionBlock:actionBlock btnTitles:array];
    
}
-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                 actionBlock:(TkimCustomAlertBlock)actionBlock
                   btnTitles:(NSArray <NSString *> *)btnTitles;
{
   
    NSAssert(btnTitles.count > 0, @"btnTitles 标题数量不能为空");
    self = [[TkimCustomAlert alloc]init];
    self.actionBlock = actionBlock;
    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect viewFrame;
    CGRect titleFrame = CGRectZero;
    CGRect messageFrame = CGRectZero;
    
    CGFloat framwWidth = 280;
    CGFloat topOffset = 0;
    
    
    BOOL showTitle = NO;
    if (title.length >0) {
        showTitle = YES;
    }
    
    BOOL showMessage = NO;
    if (message.length >0) {
        showMessage = YES;
    }
    
    
    if (showTitle && showMessage) {//标题+message
           titleFrame = CGRectMake(0, 20 + topOffset, framwWidth, 20);
          messageFrame = CGRectMake(42, 52+ topOffset, 200, 36);
          viewFrame = CGRectMake(0, 0, framwWidth, 156 + topOffset);
    }else if (showTitle){//仅标题
           titleFrame = CGRectMake(0, 40+ topOffset, framwWidth, 20);
         viewFrame = CGRectMake(0, 0, framwWidth, 145 + topOffset);
    }else {//仅message
          messageFrame = CGRectMake(42, 40+ topOffset, 200, 36);
         viewFrame = CGRectMake(0, 0, framwWidth, 168 + topOffset);
    }
    
     self.frame = viewFrame;
    
   
   
    
   
     
    if (showTitle) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleFrame];
        titleLabel.textColor =  TITLECOLOR;
        titleLabel.font = TITLEFONT;
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        // titleLabel.backgroundColor = [UIColor redColor];
        [self addSubview:titleLabel];
    }

    
    if (showMessage) {
        UILabel *messageTitle = [[UILabel alloc]initWithFrame:messageFrame];
        messageTitle.textColor =  MESSAGECOLOR;
        messageTitle.font = MESSAGEFONT;
        messageTitle.text = message;
        messageTitle.textAlignment = NSTextAlignmentCenter;
        messageTitle.numberOfLines = 0;
        //messageTitle.backgroundColor = [UIColor greenColor];
        [self addSubview:messageTitle];
    }

   

    
    UIView *spliteView = [UIView new];
    spliteView.backgroundColor = SPLITECOLOR;
   
    spliteView.frame = CGRectMake(0, viewFrame.size.height -50-0.5 - topOffset, framwWidth, 0.5);
    [self addSubview:spliteView];
    
    
    CGFloat buttonSplite = 0.25;
    
    for (int i = 0; i<btnTitles.count; i++) {
        UIButton *button;
        NSString *string = btnTitles[i];
        BOOL isNeedButtonSplite = YES;
        if (i == 0) {
            if (btnTitles.count == 1) {
                button = [self confirmButtonWithTitle:string];
                button.frame = CGRectMake(0, viewFrame.size.height - 50-topOffset, viewFrame.size.width, 50);
                isNeedButtonSplite = NO;
                
            }else{
                button = [self cancelButtonWithTitle:string];
                button.frame = CGRectMake(0, viewFrame.size.height - 50- topOffset, viewFrame.size.width/2-buttonSplite, 50);
                
            }
            
        }else{
            button = [self confirmButtonWithTitle:string];
             button.frame = CGRectMake(viewFrame.size.width/2+buttonSplite, viewFrame.size.height - 50- topOffset, viewFrame.size.width/2-buttonSplite, 50);
        }
        button.tag = i;
        [self addSubview:button];
        if (isNeedButtonSplite) {
            UIView *splite = [UIView new];
            splite.backgroundColor = SPLITECOLOR;
            splite.frame = CGRectMake(button.frame.origin.x + button.frame.size.width, viewFrame.size.height -50-topOffset, 0.5, 50);
            [self addSubview:splite];
        }
    }
    
    
    
    return self;
}



-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                       image:(UIImage *)image
                    actionBlock:(TkimCustomAlertBlock)actionBlock
            btnTitle:(NSString *)btnTitle, ... NS_REQUIRES_NIL_TERMINATION ;
{
    NSMutableArray *array = [NSMutableArray new];
    if (btnTitle){
        va_list args;
        va_start(args, btnTitle);
        NSString *buttonTitle;
        [array addObject:btnTitle];
        while ((buttonTitle = va_arg(args, NSString *))) {
            [array addObject:buttonTitle];
        }
        
        va_end(args);
    }
    return [self initWithTitle:title message:message image:image actionBlock:actionBlock btnTitles:array];
    
}

-(instancetype)initWithTitle:(NSString *)title
                     message:(NSString *)message
                       image:(UIImage *)image
                    actionBlock:(TkimCustomAlertBlock)actionBlock
            btnTitles:(NSArray <NSString *> *)btnTitles;
{
   
    NSAssert(btnTitles.count > 0, @"btnTitles 标题数量不能为空");
    self = [[TkimCustomAlert alloc]init];
    self.actionBlock = actionBlock;
    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat topOffset = 121;
    CGFloat framwWidth = 292;
//    CGFloat
    CGRect viewFrame ;
    CGRect titleFrame = CGRectZero;
    CGRect messageFrame = CGRectZero;
    
    
    BOOL showTitle = NO;
    if (title.length >0) {
        showTitle = YES;
    }
    
    BOOL showMessage = NO;
    if (message.length >0) {
        showMessage = YES;
    }
    
    
    if (showTitle && showMessage) {//标题+message
           titleFrame = CGRectMake(0, 20 + topOffset, framwWidth, 20);
          messageFrame = CGRectMake(42, 52+ topOffset, 200, 36);
          viewFrame = CGRectMake(0, 0, framwWidth, 156 + topOffset);
    }else if (showTitle){//仅标题
           titleFrame = CGRectMake(0, 40+ topOffset, framwWidth, 20);
         viewFrame = CGRectMake(0, 0, framwWidth, 145 + topOffset);
    }else {//仅message
          messageFrame = CGRectMake(42, 40+ topOffset, 200, 36);
         viewFrame = CGRectMake(0, 0, framwWidth, 168 + topOffset);
    }
    self.clipsToBounds = YES;
    
     self.frame = viewFrame;
    
   
    if (image) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
           
        imageView.frame = CGRectMake(0, 0, framwWidth, topOffset);
        [self addSubview:imageView];
        
    }
   
   
    
   
     
    if (showTitle) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleFrame];
        titleLabel.textColor =  TITLECOLOR;
        titleLabel.font = TITLEFONT;
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        // titleLabel.backgroundColor = [UIColor redColor];
        [self addSubview:titleLabel];
    }

    
    if (showMessage) {
        UILabel *messageTitle = [[UILabel alloc]initWithFrame:messageFrame];
        messageTitle.textColor =  MESSAGECOLOR;
        messageTitle.font = MESSAGEFONT;
        messageTitle.text = message;
        messageTitle.textAlignment = NSTextAlignmentCenter;
        messageTitle.numberOfLines = 0;
        //messageTitle.backgroundColor = [UIColor greenColor];
        [self addSubview:messageTitle];
    }

   

    
    UIView *spliteView = [UIView new];
    spliteView.backgroundColor = SPLITECOLOR;
   
    spliteView.frame = CGRectMake(0, viewFrame.size.height -50-0.5 , framwWidth, 0.5);
    [self addSubview:spliteView];
    
    
    CGFloat buttonSplite = 0.25;
    
    for (int i = 0; i<btnTitles.count; i++) {
        UIButton *button;
        NSString *string = btnTitles[i];
        BOOL isNeedButtonSplite = YES;
        if (i == 0) {
            if (btnTitles.count == 1) {
                button = [self confirmButtonWithTitle:string];
                button.frame = CGRectMake(0, viewFrame.size.height - 50, viewFrame.size.width, 50);
                isNeedButtonSplite = NO;
                
            }else{
                button = [self cancelButtonWithTitle:string];
                button.frame = CGRectMake(0, viewFrame.size.height - 50, viewFrame.size.width/btnTitles.count-buttonSplite, 50);
                
            }
            
        }else{
            button = [self confirmButtonWithTitle:string];
            button.frame = CGRectMake(i *(viewFrame.size.width/btnTitles.count+buttonSplite), viewFrame.size.height - 50, viewFrame.size.width/btnTitles.count-buttonSplite, 50);
        }
        button.tag = i;
        [self addSubview:button];
        if (isNeedButtonSplite) {
            UIView *splite = [UIView new];
            splite.backgroundColor = SPLITECOLOR;
            splite.frame = CGRectMake(button.frame.origin.x + button.frame.size.width, viewFrame.size.height -50, 0.5, 50);
            [self addSubview:splite];
        }
    }
    
    
    
    return self;
}








#pragma mark button类型
-(UIButton *)confirmButtonWithTitle:(NSString *)title;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button setTitle:title forState:UIControlStateNormal];
     [button setTitleColor:CONFIRMTITLECOLOR forState:UIControlStateNormal];
      [button addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
     button.titleLabel.font = ACTIONFONT;
   // button.backgroundColor = [UIColor purpleColor];
     return button;
}

-(UIButton *)cancelButtonWithTitle:(NSString *)title;
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:CANCELTITLECOLOR forState:UIControlStateNormal];
     button.titleLabel.font = ACTIONFONT;
    [button addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
 //   button.backgroundColor = [UIColor orangeColor];
     
     return button;
}
#pragma mark button点击操作
-(void)confirmAction:(UIButton *)sender
{
    [self dismiss];
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
}

-(void)cancelAction:(UIButton *)sender
{
     [self dismiss];
   if (self.actionBlock) {
       self.actionBlock(sender.tag);
   }
    
}







#pragma mark action



/**显示*/
-(void)show;
{
    NSAssert([[NSThread currentThread] isMainThread], @"执行线程必须为主线程");
    [[TkimCustomAlertMnager shareInstace] add:self];;
}
/**消失*/
-(void)dismiss;
{
    [[TkimCustomAlertMnager shareInstace] remove:self];;
}


-(void)dealloc
{
   
}
@end





