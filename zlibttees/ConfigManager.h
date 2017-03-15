//
//  ConfigManager.h
//  zlibttees
//
//  Created by MaMingkun on 16/12/16.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PPSNetWorkType){
    PPSNetWorkTypeNone,
    PPSNetWorkType2G,
    PPSNetWorkType3G,
    PPSNetWorkType4G,
    PPSNetWorkType5G,  //  5G备用
    PPSNetWorkTypeWiFi,
};

@interface ConfigManager : UIViewController

+(NSString *)deviceIpAddress;

+(NSString *)getGatewayIPAddress;

+(NSArray *)getDNSsWithDomain:(NSString *)hostName;

+(NSString *)currentNetInfo;

@end
