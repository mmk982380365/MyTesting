//
//  SearchMusicViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "SearchMusicViewController.h"

@interface SearchMusicViewController ()

@property (nonatomic, strong) UIBarButtonItem *playerItem;

@end

@implementation SearchMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)playAct:(id)sender{
    [self presentViewController:[GobalData data].player animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([GobalData data].canShowPlayerBtn) {
        if (self.playerItem == nil) {
            self.playerItem = [[UIBarButtonItem alloc] initWithTitle:@"播放器" style:UIBarButtonItemStylePlain target:self action:@selector(playAct:)];
            self.navigationItem.rightBarButtonItem = self.playerItem;
        }
        
    }
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
