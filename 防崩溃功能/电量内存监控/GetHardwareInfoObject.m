//
//  GetHardwareInfoObject.m
//  ElectircPowerDemo
//
//  Created by 赵泓博 on 2020/3/17.
//  Copyright © 2020 zhaohongbo. All rights reserved.
//

#import "GetHardwareInfoObject.h"
#import <mach/mach.h>
#import <UIKit/UIKit.h>
@implementation GetHardwareInfoObject

-(BOOL)shouldPreceedWithMinLevel:(NSUInteger) minlevel
{
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    UIDeviceBatteryState state = device.batteryState;
    
    /**电量充足*/
    if (state ==UIDeviceBatteryStateFull || state == UIDeviceBatteryStateCharging ) {
        return YES;
    }
    
    /**获取当前电量*/
    NSUInteger batterlevel = (NSUInteger)(device.batteryLevel *100);
    
    if (batterlevel >= minlevel) {
        return YES;
    }
    
    
    return NO;
}


/**获取已使用的内存*/
vm_size_t getUseMemroy(){
    
    task_basic_info_t info;
    
    mach_msg_type_number_t size = sizeof(info);
    
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    
    if (kerr == KERN_SUCCESS) {
        return info->resident_size;
    }else{
         return 0;
    }
    
   
}

/**获取空闲内存*/

vm_size_t getFreeMemroy(){
    mach_port_t host = mach_host_self();
    mach_msg_type_number_t size = sizeof(vm_statistics_data_t)/sizeof(integer_t);
    
    vm_size_t pagsize;
    
    vm_statistics_data_t vmstat;
    
    host_page_size(host, &pagsize);
    host_statistics(host, HOST_VM_INFO, (host_info_t)&vmstat, &size);
    
    return vmstat.free_count *pagsize;
    
}
/**APPCPU使用率*/
-(float)appCPUUsage
{
    kern_return_t kr;
    task_info_data_t info;
    mach_msg_type_number_t infoCount = TASK_INFO_MAX;
    
    
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)info, &infoCount);
    
    if (kr != KERN_SUCCESS) {
        return  -1; /**获取失败*/
    }
    
    thread_array_t thread_list;
    mach_msg_type_number_t thread_count;
    thread_info_data_t thinfo;
    mach_msg_type_number_t thread_info_count;
    thread_basic_info_t basic_info_th;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    
   if (kr != KERN_SUCCESS) {
        return  -1; /**获取失败*/
    }
    
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j< thread_count; j++) {
        thread_info_count  = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return  -1; /**获取失败*/
        }
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags &TH_FLAGS_IDLE)) {
            tot_cpu += basic_info_th->cpu_usage /(float)TH_USAGE_SCALE *100.0;
        }
    }
    
    vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count *sizeof(thread_t));
    
    return tot_cpu;
    
}


@end
