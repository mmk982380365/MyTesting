//
//  TodayViewController.m
//  today
//
//  Created by MaMingkun on 16/9/28.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "SystemInfo.h"
#import "ProgressView.h"

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) SystemInfo *info;

@property (nonatomic, strong) NSProcessInfo *processInfo;
@property (weak, nonatomic) IBOutlet UIProgressView *freeProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *activeProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *inactiveProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *wireProgress;
@property (weak, nonatomic) IBOutlet UILabel *freeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inactiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *wireLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.preferredContentSize = CGSizeMake(0, 500);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.info == nil) {
        self.info = [[SystemInfo alloc] init];
    }
    
    
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    
}
- (IBAction)enterApplication:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"yuukitest://"] completionHandler:^(BOOL success) {
        
    }];
}

-(void)timeAction:(id)sender{
   
    sys_info_t info = [self.info info];
    
    
    
    
    if (self.processInfo == nil) {
        self.processInfo = [[NSProcessInfo alloc] init];
    }
    
    unsigned long long total = self.processInfo.physicalMemory;
    
    self.freeProgress.progress = info.free/(float)total;
    
    self.activeProgress.progress = info.active_count/(float)total;
    
    self.inactiveProgress.progress = info.inactive/(float)total;
    
    self.wireProgress.progress = info.wire_count/(float)total;
    
    
    NSString *free;
    
    if (info.free < 1024) {
        free = [NSString stringWithFormat:@"%udB",info.free];
    }else if (info.free < 1024*1024) {
        free = [NSString stringWithFormat:@"%.1fKB",info.free/1024.0];
    }else if (info.free < 1024*1024*1024) {
        free = [NSString stringWithFormat:@"%.1fMB",info.free/1024.0/1024.0];
    }else{
        free = [NSString stringWithFormat:@"%.1fGB",info.free/1024.0/1024.0/1024.0];
    }
    
    self.freeLabel.text = [NSString stringWithFormat:@"free:%@",free];
    
    NSString *active;
    
    if (info.active_count < 1024) {
        active = [NSString stringWithFormat:@"%udB",info.active_count];
    }else if (info.active_count < 1024*1024) {
        active = [NSString stringWithFormat:@"%.1fKB",info.active_count/1024.0];
    }else if (info.active_count < 1024*1024*1024) {
        active = [NSString stringWithFormat:@"%.1fMB",info.active_count/1024.0/1024.0];
    }else{
        active = [NSString stringWithFormat:@"%.1fGB",info.active_count/1024.0/1024.0/1024.0];
    }
    
    self.activeLabel.text = [NSString stringWithFormat:@"active:%@",active];
    
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
    
    self.inactiveLabel.text = [NSString stringWithFormat:@"inactive:%@",inactive];
    
    NSString *wire;
    
    if (info.wire_count < 1024) {
        wire = [NSString stringWithFormat:@"%udB",info.wire_count];
    }else if (info.wire_count < 1024*1024) {
        wire = [NSString stringWithFormat:@"%.1fKB",info.wire_count/1024.0];
    }else if (info.wire_count < 1024*1024*1024) {
        wire = [NSString stringWithFormat:@"%.1fMB",info.wire_count/1024.0/1024.0];
    }else{
        wire = [NSString stringWithFormat:@"%.1fGB",info.wire_count/1024.0/1024.0/1024.0];
    }
    
    self.wireLabel.text = [NSString stringWithFormat:@"wired:%@",wire];
    
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
    
//    float cpu = [self.info cpu_usage];
//    self.totalLabel.text = [showed stringByAppendingString:[NSString stringWithFormat:@" CPU:%.0f%%",cpu*100]];
    
    self.totalLabel.text = showed;

//    self.infoLabel.text = showed;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
