//
//  PingViewController.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/6.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "PingViewController.h"
#import "PingServices.h"

@interface PingViewController ()

@property (nonatomic, strong) PingServices *services;

@property (weak, nonatomic) IBOutlet UITextField *hostTextView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@end

@implementation PingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)startAction:(id)sender {
    if (self.services) {
        [self.services stop];
    }
    self.stopBtn.enabled = YES;
    self.startBtn.enabled = NO;
    self.services = [PingServices startPingAddress:self.hostTextView.text callback:^(PingItem *pingItem, NSArray *pingItems) {
        
    }];
}

- (IBAction)stopAction:(id)sender {
    self.stopBtn.enabled = NO;
    self.startBtn.enabled = YES;
    [self.services stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
