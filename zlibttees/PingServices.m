//
//  PingServices.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/6.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "PingServices.h"
#import "SimplePing.h"

@interface PingServices () <SimplePingDelegate>

@property (nonatomic, strong) SimplePing *simplePing;

@property (nonatomic, copy) PingCallback callback;

@property (nonatomic, strong) NSTimer *timer;



@end

@implementation PingServices

+(instancetype)startPingAddress:(NSString *)address callback:(PingCallback)callback{
    PingServices *services = [[self alloc] init];
    
    SimplePing *simplePing = [[SimplePing alloc] initWithHostName:address];
    
    services.simplePing = simplePing;
    services.callback = callback;
    
    simplePing.delegate = services;
    
    [simplePing start];
    
    
    
    return services;
}

-(void)stop{
    [self.simplePing stop];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)timeAction:(NSTimer *)timer{
    [self.simplePing sendPingWithData:nil];
}

#pragma mark - simplePing delegate

-(void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address{
    NSLog(@"start ping:%@",address);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
}

-(void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error{
    NSLog(@"error:%@",error);
}

-(void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    NSLog(@"send packet");
}

-(void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error{
    NSLog(@"send packet error:%@",error);
}

-(void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber{
    NSLog(@"receieve packet:%@",packet);
}

-(void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet{
    NSLog(@"receieve unexpected packet:%@",packet);
}

@end
