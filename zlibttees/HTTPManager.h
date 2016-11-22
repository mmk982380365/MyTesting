//
//  HTTPManager.h
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseSuccessBlock)(id responseObject);

typedef void(^ResponseFailBlock)(NSError *error);

@interface HTTPManager : NSObject

+(instancetype)manager;

+(NSURLSessionDataTask *)hotMusicWithTopId:(NSString *)topId successed:(ResponseSuccessBlock)success failed:(ResponseFailBlock)fail;

@end
