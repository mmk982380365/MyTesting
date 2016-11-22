//
//  InterfaceController.m
//  watch Extension
//
//  Created by MaMingkun on 16/9/29.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "InterfaceController.h"
#import "SystemInfo.h"
#import "RowController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *freeLbl;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *activeLbl;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *inactiveLbl;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *wireLbl;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *totalLbl;

@property (nonatomic, strong) SystemInfo *info;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSProcessInfo *processInfo;

@end


@implementation InterfaceController


- (IBAction)play {
    [[WCSession defaultSession] sendMessage:@{
                                              @"type":@"play"
                                              }replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                                  NSLog(@"%@",replyMessage);
                                              } errorHandler:^(NSError * _Nonnull error) {
                                                  
                                              }];
    
}

- (IBAction)pause {
    [[WCSession defaultSession] sendMessage:@{
                                              @"type":@"pause"
                                              }replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                                  NSLog(@"%@",replyMessage);
                                              } errorHandler:^(NSError * _Nonnull error) {
                                                  
                                              }];
}

- (IBAction)rewind {
    [[WCSession defaultSession] sendMessage:@{
                                              @"type":@"rewind"
                                              }replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                                  NSLog(@"%@",replyMessage);
                                              } errorHandler:^(NSError * _Nonnull error) {
                                                  
                                              }];
}

- (IBAction)forward {
    [[WCSession defaultSession] sendMessage:@{
                                              @"type":@"forward"
                                              }replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                                                  NSLog(@"%@",replyMessage);
                                              } errorHandler:^(NSError * _Nonnull error) {
                                                  
                                              }];
}


-(void)infoAct{
    
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    
    
    self.info = [[SystemInfo alloc] init];
    self.processInfo = [[NSProcessInfo alloc] init];
}

-(void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex{
    NSLog(@"%d",rowIndex);
    RowController *cell = [table rowControllerAtIndex:rowIndex];
    [cell.label setTextColor:[UIColor redColor]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
//    [self.tableView setNumberOfRows:4 withRowType:@"cell"];
//    
//    for (int i = 0; i < 4; i++) {
//        RowController *cell = [self.tableView rowControllerAtIndex:i];
//        [cell.label setText:[NSString stringWithFormat:@"row = %d",i]];
//    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAct:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    
    
}

-(void)timerAct:(id)timer{
    sys_info_t info = [self.info info];
    NSString *free;
    
    if (info.free < 1024) {
        free = [NSString stringWithFormat:@"%udB",info.free];
    }else if (info.free < 1024*1024) {
        free = [NSString stringWithFormat:@"%.1fKB",info.free/1024.0];
    }else if (info.free < 1024*1024*1024) {
        free = [NSString stringWithFormat:@"%.1fMB",info.free/1024.0/1024.0];
    }else{
        free = [NSString stringWithFormat:@"%.1fMB",info.free/1024.0/1024.0/1024.0];
    }
    [self.freeLbl setText:free];
    
    NSString *active;
    
    if (info.active_count < 1024) {
        active = [NSString stringWithFormat:@"%udB",info.active_count];
    }else if (info.active_count < 1024*1024) {
        active = [NSString stringWithFormat:@"%.1fKB",info.active_count/1024.0];
    }else if (info.active_count < 1024*1024*1024) {
        active = [NSString stringWithFormat:@"%.1fMB",info.active_count/1024.0/1024.0];
    }else{
        active = [NSString stringWithFormat:@"%.1fMB",info.active_count/1024.0/1024.0/1024.0];
    }
    [self.activeLbl setText:active];
    
    NSString *inactive;
    
    if (info.inactive < 1024) {
        inactive = [NSString stringWithFormat:@"%udB",info.inactive];
    }else if (info.inactive < 1024*1024) {
        inactive = [NSString stringWithFormat:@"%.1fKB",info.inactive/1024.0];
    }else if (info.inactive < 1024*1024*1024) {
        inactive = [NSString stringWithFormat:@"%.1fMB",info.inactive/1024.0/1024.0];
    }else{
        inactive = [NSString stringWithFormat:@"%.1fGB",info.inactive/1024.0/1024.0/1024.0];
    }
    [self.inactiveLbl setText:inactive];
    
    NSString *wire;
    
    if (info.wire_count < 1024) {
        wire = [NSString stringWithFormat:@"%udB",info.wire_count];
    }else if (info.wire_count < 1024*1024) {
        wire = [NSString stringWithFormat:@"%.1fKB",info.wire_count/1024.0];
    }else if (info.wire_count < 1024*1024*1024) {
        wire = [NSString stringWithFormat:@"%.1fMB",info.wire_count/1024.0/1024.0];
    }else{
        wire = [NSString stringWithFormat:@"%.1fMB",info.wire_count/1024.0/1024.0/1024.0];
    }
    [self.wireLbl setText:wire];
    
    NSString *showed;
    if (self.processInfo.physicalMemory < 1024) {
        showed = [NSString stringWithFormat:@"total:%.1fB",(float)self.processInfo.physicalMemory];
    }else if (self.processInfo.physicalMemory < 1024*1024){
        showed = [NSString stringWithFormat:@"total:%.1fKB",self.processInfo.physicalMemory/1024.0];
    }else if (self.processInfo.physicalMemory < 1024*1024*1024) {
        showed = [NSString stringWithFormat:@"total:%.1fMB",self.processInfo.physicalMemory/1024.0/1024.0];
    }else{
        showed = [NSString stringWithFormat:@"total:%.1fGB",self.processInfo.physicalMemory/1024.0/1024.0/1024.0];
    }
    [self.totalLbl setText:showed];
    
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [self.timer invalidate];
    self.timer = nil;
}

@end



