//
//  PingServices.h
//  zlibttees
//
//  Created by MaMingkun on 2017/1/6.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PingItem.h"

typedef void(^PingCallback)(PingItem *pingItem, NSArray *pingItems);

@interface PingServices : NSObject

+(instancetype)startPingAddress:(NSString *)address callback:(PingCallback)callback;

-(void)stop;

@end
