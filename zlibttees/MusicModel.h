//
//  MusicModel.h
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property (nonatomic, strong) NSString *albumid;

@property (nonatomic, strong) NSString *albumname;

@property (nonatomic, strong) NSString *albumpic_big;

@property (nonatomic, strong) NSString *albumpic_small;

@property (nonatomic, strong) NSString *downUrl;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *singerid;

@property (nonatomic, strong) NSString *singername;

@property (nonatomic, strong) NSString *songid;

@property (nonatomic, strong) NSString *songname;

@property (nonatomic, assign) BOOL hasAnimated;

@end
