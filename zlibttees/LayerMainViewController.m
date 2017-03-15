//
//  LayerMainViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/11/23.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "LayerMainViewController.h"
#import "LayerViewController.h"
#import "LayerEmitterViewController.h"
#import "LayerTextViewController.h"
#import "LayerAnimationViewController.h"

@interface LayerMainViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation LayerMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    
    
    self.dataArray = @[
                       @{@"title":@"文字layer",@"class":[LayerViewController class]},
                       @{@"title":@"EmitterLayer",@"class":[LayerEmitterViewController class]},
                       @{@"title":@"文字动画",@"class":[LayerTextViewController class]},
                       @{@"title":@"layer动画",@"class":[LayerAnimationViewController class]},
                       ];
    
}

#pragma mark - tableView delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    cell.textLabel.text = dict[@"title"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    Class vcClass = dict[@"class"];
    
    BaseViewController *vc = [[vcClass alloc] init];
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
