//
//  HotMusicViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "HotMusicViewController.h"
#import "HotDetailViewController.h"

@interface HotMusicViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIBarButtonItem *playerItem;

@end

@implementation HotMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createData];
    
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
-(void)createData{
    self.dataArray =@[
                      @{
                          @"title":@"欧美",
                          @"type":@"3",
                          },
                      @{
                          @"title":@"内地",
                          @"type":@"5",
                          },
                      @{
                          @"title":@"港台",
                          @"type":@"6",
                          },
                      @{
                          @"title":@"韩国",
                          @"type":@"16",
                          },
                      @{
                          @"title":@"日本",
                          @"type":@"17",
                          },
                      @{
                          @"title":@"民谣",
                          @"type":@"18",
                          },
                      @{
                          @"title":@"摇滚",
                          @"type":@"19",
                          },
                      @{
                          @"title":@"销量",
                          @"type":@"23",
                          },
                      @{
                          @"title":@"热歌",
                          @"type":@"26",
                          },
                      ];
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *title = self.dataArray[indexPath.row][@"title"];
    
    cell.textLabel.text = title;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    NSString *title = self.dataArray[indexPath.row][@"title"];
    HotDetailViewController *detail = [[HotDetailViewController alloc] init];
    detail.title = title;
    detail.type = self.dataArray[indexPath.row][@"type"];
    [self.navigationController pushViewController:detail animated:YES];
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
