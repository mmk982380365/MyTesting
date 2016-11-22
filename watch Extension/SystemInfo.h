//
//  SystemInfo.h
//  zlibttees
//
//  Created by MaMingkun on 16/9/29.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    unsigned int free;
    unsigned int active_count;
    unsigned int inactive;
    unsigned int wire_count;
    unsigned int zero_fill_count;
    unsigned int reactivations;
    unsigned int pageins;
    unsigned int pageouts;
    unsigned int faults;
    unsigned int cow_faults;
    unsigned int lookups;
    unsigned int hits;
} sys_info_t;

@interface SystemInfo : NSObject

-(void)logInfo;
-(sys_info_t)info;

@end
