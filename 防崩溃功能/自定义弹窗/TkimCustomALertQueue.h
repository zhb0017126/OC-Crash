//
//  TkimCustomALertQueue.h
//  
//
//  Created by 赵泓博 on 2020/4/10.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TkimCustomALertQueue : NSObject
-(BOOL)pushObject:(id)obj;
-(id)popObject;
/**获取当前队尾信息*/
-(id)getQueueInfo;
-(BOOL)isEmpty;
@end

NS_ASSUME_NONNULL_END
