//
//  SystemInfo.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/29.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "SystemInfo.h"
#import <mach/mach.h>


@implementation SystemInfo

-(BOOL)memoryInfo:(vm_statistics_data_t *)vmStats{
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)vmStats, &infoCount);
    
    return kernReturn == KERN_SUCCESS;
    
}

-(sys_info_t)info{
    sys_info_t info;
    vm_statistics_data_t vmStats;
    if ([self memoryInfo:&vmStats]) {
        
        
        info.free = vmStats.free_count * vm_page_size;
        info.active_count = vmStats.active_count * vm_page_size;
        info.inactive = vmStats.inactive_count * vm_page_size;
        info.wire_count = vmStats.wire_count * vm_page_size;
        info.zero_fill_count = vmStats.zero_fill_count * vm_page_size;
        info.reactivations = vmStats.reactivations * vm_page_size;
        info.pageins = vmStats.pageins * vm_page_size;
        info.pageouts = vmStats.pageouts * vm_page_size;
        info.faults = vmStats.faults;
        info.cow_faults = vmStats.cow_faults;
        info.lookups = vmStats.lookups;
        info.hits = vmStats.hits;
        
    }
    
    
    return info;
}

-(void)logInfo{
    vm_statistics_data_t vmStats;
    if ([self memoryInfo:&vmStats]) {
        NSLog(@"free: %u\nactive: %u\ninactive: %u\nwire: %u\nzero fill: %u\nreactivations: %u\npageins: %u\npageouts: %u\nfaults: %u\ncow_faults: %u\nlookups: %u\nhits: %u",
              vmStats.free_count * vm_page_size,
              vmStats.active_count * vm_page_size,
              vmStats.inactive_count * vm_page_size,
              vmStats.wire_count * vm_page_size,
              vmStats.zero_fill_count * vm_page_size,
              vmStats.reactivations * vm_page_size,
              vmStats.pageins * vm_page_size,
              vmStats.pageouts * vm_page_size,
              vmStats.faults,
              vmStats.cow_faults,
              vmStats.lookups,
              vmStats.hits
              );
    }
}

@end
