//
//  PingItem.h
//  zlibttees
//
//  Created by MaMingkun on 2017/1/6.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 ping status

 - PingStatuStart: 开始
 - PingStatusFailedToSendPacket: 发送数据包失败
 - PingStatusReceievePacket: 接收到数据包
 - PingStatusReceieveUnexpectedPacket: 数据包数据错误
 - PingStatusTimeOut: 超时
 - PingStatusError: 错误
 - PingStatusFinished: 完成
 */
typedef NS_ENUM(NSInteger,PingStatus) {
    PingStatuStart,
    PingStatusFailedToSendPacket,
    PingStatusReceievePacket,
    PingStatusReceieveUnexpectedPacket,
    PingStatusTimeOut,
    PingStatusError,
    PingStatusFinished,
};

@interface PingItem : NSObject

/**
 ping www.163.com
 
 PING 163.xdwscache.ourglb0.com (183.134.24.71): 56 data bytes
 
 64 bytes from 183.134.24.71: icmp_seq=0 ttl=53 time=12.914 ms
 64 bytes from 183.134.24.71: icmp_seq=1 ttl=53 time=15.136 ms
 
 --- 163.xdwscache.ourglb0.com ping statistics ---
 2 packets transmitted, 2 packets received, 0.0% packet loss
 */

@property (nonatomic, copy) NSString *originalAddress; //163.xdwscache.ourglb0.com

@property (nonatomic, copy) NSString *IPAddress; //183.134.24.71

@property (nonatomic, assign) NSUInteger dateBytesLength; //64

@property (nonatomic, assign) double timeMilliseconds; //time

@property (nonatomic, assign) NSInteger timeToLive; //ttl

@property (nonatomic, assign) NSInteger ICMPSequence; //icmp_seq

@property (nonatomic, assign) PingStatus status; //status

@end
