//
//  GobalData.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "GobalData.h"

@implementation GobalData

+(instancetype)data
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
    });
    return _sharedObject;
}

@end
