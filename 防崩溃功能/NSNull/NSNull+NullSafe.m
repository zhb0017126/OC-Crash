//
//  NSNull+NullSafe.m
//  防崩溃功能
//
//  Created by 赵泓博 on 2020/8/18.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "NSNull+NullSafe.h"
#import "NSObject+Hook.h"
#import "NSNullSafeObject.h"
@implementation NSNull (NullSafe)
+(void)load
{
    [self hy_NSNullProtectorSwizzleMethod];
}
+ (void)hy_NSNullProtectorSwizzleMethod
{
   
    
    /**hook类方法*/
   hy_swizzleClassMethodImplementation([self class], @selector(forwardingTargetForSelector:), @selector(safeClassForwardingTargetForSelector:));
    
    
    
}
- (id)safeClassForwardingTargetForSelector:(SEL)aSelector {
    // NSNull自动替换为 对应空数据
    static NSArray *sTmpOutput = nil;
      if (sTmpOutput == nil) {
          sTmpOutput = @[@"", @0, @[], @{}];
      }
      
      for (id tmpObj in sTmpOutput) {
          if ([tmpObj respondsToSelector:aSelector]) {
              return tmpObj;
          }
      }
    
    
    
    BOOL aBool = [self respondsToSelector:aSelector];
     NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool||signatrue) {
        return [self safeClassForwardingTargetForSelector:aSelector];
    }else{
       
        
        TkimCustomAlert *alert = [[TkimCustomAlert alloc] initWithTitle:@"类方法崩溃" message:[NSString stringWithFormat:@"类名:%@ \n 方法名:%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)] actionBlock:^(NSInteger buttonIndex) {
            
        } btnTitle:@"确定", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        [alert show];
        
        NSNullSafeObject * obj = [NSNullSafeObject shareInstance];
       
        [obj addFunc:aSelector];
        return obj;
        
    }
   
    
}
@end
