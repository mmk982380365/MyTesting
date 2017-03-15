//
//  NaviViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/29.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "NaviViewController.h"
#import "SpeechRecognizerViewController.h"
#import "ZipViewController.h"
#import "MusicHomeViewController.h"
#import "OpenGLViewController.h"
#import "ObjLoaderViewController.h"
#import "LayerMainViewController.h"
#import "NetworkConfigurationViewController.h"
#import "ContactViewController.h"
#import "PingViewController.h"
#import <zlibttees-swift.h>

@interface NaviViewController () <UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Home Pages";
    
    
    [self initVc];
    
}

-(void)initVc{
    NSDictionary *speech = @{
                             @"title":@"语音识别",
                             @"class":[SpeechRecognizerViewController class],
                             };
    
    NSDictionary *zip = @{
                          @"title":@"压缩测试",
                          @"class":[ZipViewController class],
                          };
    
    NSDictionary *music = @{
                            @"title":@"音乐播放器",
                            @"class":[MusicHomeViewController class],
                            };
    
    NSDictionary *openGL = @{
                             @"title":@"OpenGL ES 2.0",
                             @"class":[OpenGLViewController class],
                             };
    
    NSDictionary *objLoader = @{
                             @"title":@"Obj文件读取",
                             @"class":[ObjLoaderViewController class],
                             };
    
    NSDictionary *layerTest = @{
                                @"title":@"图层动画",
                                @"class":[LayerMainViewController class],
                                };
    
    NSDictionary *networkConfig = @{
                                @"title":@"网络信息",
                                @"class":[NetworkConfigurationViewController class],
                                };
    
    NSDictionary *contact = @{
                              @"title":@"联系人",
                              @"class":[ContactViewController class],
                              };
    
    NSDictionary *pingTool = @{
                               @"title":@"ping小工具",
                               @"class":[PingViewController class],
                               };
    NSDictionary *puzzle = @{
                             @"title":@"开关灯小谜题",
                             @"class":[PuzzleViewController class],
                             };
    
    NSDictionary *metal = @{
                            @"title":@"Metal Testing",
                            @"class":[MySceneViewController class],
                            };
    
    self.dataArray = @[speech,zip,music,openGL,objLoader,layerTest,networkConfig,contact,pingTool,puzzle,metal];
    
    [self.tableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class class = self.dataArray[indexPath.row][@"class"];
    
    BaseViewController *vc = [[class alloc] init];
    vc.title = self.dataArray[indexPath.row][@"title"];
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
