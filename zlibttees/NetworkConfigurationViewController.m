//
//  NetworkConfigurationViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/12/16.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "NetworkConfigurationViewController.h"
#import "ConfigManager.h"

@interface NetworkConfigurationViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NetworkConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *address = [ConfigManager deviceIpAddress];
    NSLog(@"ip:%@",address);
    NSString *gateAddress = [ConfigManager getGatewayIPAddress];
    NSLog(@"gate:%@",gateAddress);
//    NSArray *dnsArray = [ConfigManager getDNSsWithDomain:@"http://api.denter.cn/"];
//    NSLog(@"%@",dnsArray);
    
    NSString *network = [ConfigManager currentNetInfo];
    
    NSString *showedString = [NSString stringWithFormat:@"当前网络ip地址:%@\n当前网关地址:%@\n当前网络:%@",address,gateAddress,network];
    self.textView.text = showedString;
    
    
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
