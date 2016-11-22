//
//  GobalData.h
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicViewController.h"

@interface GobalData : NSObject

+(instancetype)data;

@property (nonatomic, strong) MusicViewController *player;

@property (nonatomic, strong) NSArray *currentPlayingArray;

@property (nonatomic, assign) BOOL canShowPlayerBtn;

@end
