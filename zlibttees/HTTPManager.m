//
//  HTTPManager.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "HTTPManager.h"
#import <AFNetworking.h>
#import <CommonCrypto/CommonCrypto.h>

#define INTERNET_TIMEOUT 20

@interface HTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation HTTPManager

+(instancetype)manager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
        
    });
    return _sharedObject;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = INTERNET_TIMEOUT;
        
        self.httpManager = [AFHTTPSessionManager manager];
        
//        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
//        [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json", nil]];
//        
//        self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

+(NSURLSessionDataTask *)postUrl:(NSString *)url params:(NSDictionary *)params successed:(ResponseSuccessBlock)success failed:(ResponseFailBlock)fail{
    return [[[self manager] httpManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",url);
        
//        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}

+(void)handleErrorWithCode:(NSInteger)errorCode msg:(NSString *)msg{
    
}

+(NSURLSessionDataTask *)POST:(NSString *)url params:(NSDictionary *)params successed:(ResponseSuccessBlock)success failed:(ResponseFailBlock)fail{
    NSDictionary *newParams = [self fillParams:params];
    
    NSString *apiUrl = [NSString stringWithFormat:@"%@%@",API_URL,url];
    
    return [self postUrl:apiUrl params:newParams successed:^(id responseObject) {
        NSDictionary *dict = responseObject;
        
        int status = [dict[@"showapi_res_code"] intValue];
        
        if (status == 0) {
            
            NSDictionary *body = dict[@"showapi_res_body"];
            
            if (success) {
                success(body);
            }
            
        }else{
            NSString *errorStr = dict[@"showapi_res_error"];
            [self handleErrorWithCode:status msg:errorStr];
            if (fail) {
                fail([NSError errorWithDomain:errorStr code:status userInfo:@{}]);
            }
            
        }
        
    } failed:fail];
}

+(NSDictionary *)fillParams:(NSDictionary *)params{
    
    NSMutableDictionary *newDic = [params mutableCopy];
    
    [newDic setObject:API_APPID forKey:@"showapi_appid"];
    
    
    NSCalendar *calenda = [NSCalendar currentCalendar];
    
    NSDate *date= [NSDate date];
    
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    
    [calenda getHour:&hour minute:&minute second:&second nanosecond:nil fromDate:date];
    
    NSInteger year = 0;
    NSInteger month = 0;
    NSInteger day = 0;
    
    [calenda getEra:nil year:&year month:&month day:&day fromDate:date];
    
    NSString *timeStr = [NSString stringWithFormat:@"%04ld%02ld%02ld%02ld%02ld%02ld",year,month,day,hour,minute,second];
    
    
    [newDic setObject:[NSNumber numberWithInteger:timeStr.integerValue] forKey:@"showapi_timestamp"];
    [newDic setObject:@1 forKey:@"showapi_res_gzip"];
    
    
    [newDic setObject:[self calcSign:newDic] forKey:@"showapi_sign"];
    
    
    return newDic;
}

+(NSString *)calcSign:(NSDictionary *)param{
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    
    NSArray *keyArray = [param.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    for (NSString *key in keyArray) {
        [str appendFormat:@"%@%@",key,param[key]];
    }
    
    [str appendFormat:@"%@",API_SECRET];
    
    return [self md5FromString:str];
}

+(NSString *)md5FromString:(NSString *)string{
    
    const char *cStr = [string UTF8String];
    
    unsigned char result[32];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *rs = [NSMutableString stringWithCapacity:32];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [rs appendFormat:@"%02x",result[i]];
    }
    
    return rs;
    
}

#pragma mark - main

+(NSURLSessionDataTask *)hotMusicWithTopId:(NSString *)topId successed:(ResponseSuccessBlock)success failed:(ResponseFailBlock)fail{
    NSDictionary *params = @{
                             @"topid":topId,
                             };
    return [self POST:@"213-4" params:params successed:success failed:fail];
}

@end
