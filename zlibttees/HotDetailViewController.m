//
//  HotDetailViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "HotDetailViewController.h"
#import "MusicCell.h"

@interface HotDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIBarButtonItem *playerItem;

@end

@implementation HotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
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
-(void)loadData{
    [HTTPManager hotMusicWithTopId:self.type successed:^(id responseObject) {
        NSDictionary *bean = responseObject[@"pagebean"];
        NSArray *dataArray = [MusicModel mj_objectArrayWithKeyValuesArray:bean[@"songlist"]];
        
        NSLog(@"%@",dataArray);
        
        self.dataArray = dataArray;
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:nil options:nil][0];
    }
    
    MusicModel *music = self.dataArray[indexPath.row];
    
    cell.music = music;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    MusicModel *music = self.dataArray[indexPath.row];
//    
//    if (music.hasAnimated == NO) {
//        music.hasAnimated = YES;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0, 0, 1)];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)];
        animation.duration = 0.25;
        [cell.layer addAnimation:animation forKey:@"ani"];
//    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MusicModel *music = self.dataArray[indexPath.row];
    
    if ([GobalData data].currentPlayingArray != self.dataArray) {
        [GobalData data].currentPlayingArray = self.dataArray;
    }
    
    MusicViewController *vc = [GobalData data].player;
    
    if (vc == nil) {
        vc = [[MusicViewController alloc] init];
        [GobalData data].player = vc;
        [GobalData data].canShowPlayerBtn = YES;
    }
    
    vc.music = music;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
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
