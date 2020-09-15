//
//  TkimCustomALertQueue.m
//  
//
//  Created by 赵泓博 on 2020/4/10.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "TkimCustomALertQueue.h"
@interface TkimCustomALertQueue ()
/***/
@property (nonatomic,strong) NSMutableArray *array;
@end

@implementation TkimCustomALertQueue
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;;
}
-(BOOL)pushObject:(id)obj
{
    
    if (obj) {
        [self.array addObject:obj];
        return YES;
    }else{
        return NO;
    }
}
-(id)popObject;
{
    id obj = nil; ;
    if (self.array.count >0) {
        obj =  [self.array objectAtIndex:0];
        [self.array removeObjectAtIndex:0];
    }
    return obj;
}
-(id)getQueueInfo;
{
    id obj = nil; ;
       if (self.array.count >0) {
           obj =  [self.array objectAtIndex:0];
       }
       return obj;
}
-(BOOL)isEmpty;
{
    return self.array.count == 0;
}
@end
