//
//  MusicHomeViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "MusicHomeViewController.h"
#import "HotMusicViewController.h"
#import "SearchMusicViewController.h"

@interface MusicHomeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIBarButtonItem *playerItem;

//@property (nonatomic, strong) MusicBar *musicBar;

@end

@implementation MusicHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.musicBar = [[NSBundle mainBundle] loadNibNamed:@"MusicBar" owner:nil options:nil][0];
//    
//    self.musicBar.frame = CGRectMake(0, 667-40, 375, 40);
//    
//    [self.view addSubview:self.musicBar];
    
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
    self.dataArray = @[
                       @{
                           @"title":@"热门榜单",
                           @"class":[HotMusicViewController class],
                           },
                       @{
                           @"title":@"热歌曲搜索",
                           @"class":[SearchMusicViewController class],
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    Class class = dict[@"class"];
    
    BaseViewController *vc = [[class alloc] init];
    
    vc.title = dict[@"title"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
