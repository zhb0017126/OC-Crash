//
//  TimerTestViewController.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/9/12.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "TimerTestViewController.h"

@interface TimerTestViewController ()
/**<#标注#>*/
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation TimerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}
-(void)action {
    NSLog(@"timer +++++");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
