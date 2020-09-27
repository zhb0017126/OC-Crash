//
//  ViewController.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/7/17.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "ViewController.h"

#import "TestObject.h"
#import "CustomProxy.h"
#import "TimerTestViewController.h"
#import "KVOTestViewController.h"
#import <dlfcn.h>
@interface ViewController ()<UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate,UITableViewDelegate,UITableViewDataSource>
/**<#标注#>*/
@property (nonatomic,strong) UITableView *tabelView;
/**<#标注#>*/
@property (nonatomic,strong) NSMutableArray *titleArrays;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
    
    self.tabelView.delegate = self;
    
    self.tabelView.dataSource = self;
    [self.view addSubview:self.tabelView];
    
    self.titleArrays = @[@"实例方法",@"类方法",@"NSNull",@"NSMutableArray-index获取越界",@"NSMutableArray-index插入越界",@"NSMutableArray-index移除越界",@"NSDictionary-key为空",@"NSDictionary-value为空",@"NSTimer",@"KVO",@"NSNotification"].mutableCopy;
    
    [self.tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    

    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArrays.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.titleArrays objectAtIndex:indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [self.titleArrays objectAtIndex:indexPath.row];
//     [@"实例方法",@"类方法",@"NSNull",@"NSMutableArray-index越界",@"NSMutableArray-index获取越界",@"NSMutableArray-index插入越界",@"NSMutableArray-index移除越界",@"NSTimer",@"KVO"].mutableCopy;
    if ([string isEqualToString:@"实例方法"]) {
       // [[TestObject new] testSomoth];
    
        TestObject *obj =  [TestObject new];
        CustomProxy *proxy =[CustomProxy alloc];
        [proxy transformObjc:obj];
        [proxy performSelector:@selector(testSomoth) withObject:nil];
        
    
    }else if ([string isEqualToString:@"类方法"]){
        [TestObject getTestClassString];
    }else if ([string isEqualToString:@"NSNull"]){
        NSMutableArray *array = [NSMutableArray array];
        NSNull *null = [NSNull new];
        [array addObject:null];
       // [[array objectAtIndex:0] setValue:@"afds" forKey:@"asdfa"];
        //NSUnknownKeyException
        
        NSString *string = [array objectAtIndex:0];
        [string substringToIndex:0];
        
    }else if ([string isEqualToString:@"NSMutableArray-index获取越界"]){
        NSMutableArray *mutable = [NSMutableArray arrayWithObjects:@"1", nil];
               [mutable objectAtIndex:3];
    }else if ([string isEqualToString:@"NSMutableArray-index插入越界"]){
        NSMutableArray *mutable = [NSMutableArray arrayWithObjects:@"1", nil];
        [mutable insertObject:@"3" atIndex:10];
    }else if ([string isEqualToString:@"NSMutableArray-index移除越界"]){
        NSMutableArray *mutable = [NSMutableArray arrayWithObjects:@"1", nil];
        [mutable removeObjectAtIndex:99];
    }else if ([string isEqualToString:@"NSDictionary-key为空"]){
        NSString *key = nil;
        NSDictionary *dictionary = @{key:@"sss"};
    }else if ([string isEqualToString:@"NSDictionary-value为空"]){
        NSString *obj = nil;
//        NSDictionary *dictionary = @{@"keyStr":obj};
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:obj forKey:@"keyString"];
    }else if ([string isEqualToString:@"NSTimer"]){
        [self.navigationController pushViewController:[TimerTestViewController new] animated:YES];
    }else if ([string isEqualToString:@"KVO"]){
         [self.navigationController pushViewController:[KVOTestViewController new] animated:YES];
    }
        

   
    
}














@end
