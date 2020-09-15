//
//  TestObject.m
//  ElectircPowerDemo
//
//  Created by 赵泓博 on 2020/4/3.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "TestObject.h"
#import <dlfcn.h>
@implementation TestObject

-(void)presentDocumentCloud {
    
    static struct dl_info app_info; // app类相关地址
        //https://blog.csdn.net/dragon101788/article/details/18673323
    //    dladdr - 获取某个地址的符号信息
       if (app_info.dli_saddr == NULL) {
           dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
       }
        // 当前类地址符号信息
       struct dl_info self_info;
       dladdr((__bridge void *)[self class], &self_info); // 获取某个符号地址信息
       
        /**
         strcmp(str1,str2)，若str1=str2，则返回零；若str1<str2，则返回负数；若str1>str2，则返回正数
         
         一般系统
         */
    NSLog(@"app_info is :%s",app_info.dli_fname);
     NSLog(@"self_info is :%s",self_info.dli_fname);
      
       if (strcmp(app_info.dli_fname, self_info.dli_fname)) {
           NSLog(@"11111");
       }else{
            NSLog(@"2222");
       }
    
    
    
    NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
    
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
   // documentPickerViewController.delegate = self;
//    [self presentViewController:documentPickerViewController animated:YES completion:nil];
     
     
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    fileName = [fileName stringByRemovingPercentEncoding];
    NSLog(@"--->>>>%@",fileName);
    if (![NSData dataWithContentsOfURL:url]) {
             //  [QMUITips showWithText:@"只能选择本文件夹下的文件"];
               return;
     }
    //在此已获取到文件，可对文件进行需求上的操作
    if ([self iCloudEnable]) {
       
    
    }
}

//- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
//
//    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
//    NSString *fileName = [array lastObject];
//    fileName = [fileName stringByRemovingPercentEncoding];
//    NSLog(@"--->>>>%@",fileName);
//    if ([self iCloudEnable]) {
////        [[NSFileManager defaultManager] downloadWithDocumentURL:url callBack:^(id obj) {
////            NSData *data = obj;
////            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"icloud" message:@"写入沙河" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
////            [alert show];
////            //写入沙盒Documents
////            NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]];
////            [data writeToFile:path atomically:YES];
////        }];
//    }
//}
-(BOOL)iCloudEnable {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *url = [manager URLForUbiquityContainerIdentifier:nil];
    if (url != nil) {
        return YES;
    }
    NSLog(@"iCloud 不可用");
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"icloud" message:@"iCloud 不可用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
    return NO;
}

@end
