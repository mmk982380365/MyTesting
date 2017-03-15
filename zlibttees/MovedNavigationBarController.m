//
//  MovedNavigationBarController.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "MovedNavigationBarController.h"
#import "UINavigationBar+SizeableHeight.h"

@interface MovedNavigationBarController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MovedNavigationBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)setNavigationBarTransformProgress:(CGFloat)progress{
    [self.navigationController.navigationBar in_setTranslationY:-44*progress];
    [self.navigationController.navigationBar in_setScrollViewAlpha:1-progress];
}

#pragma mark - tableView delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"index:%ld",indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y + 64;
    if (offset > 0) {
        if (offset >= 44) {
            [self setNavigationBarTransformProgress:1];
        }else{
            [self setNavigationBarTransformProgress:offset/44.0];
        }
    }else{
        [self setNavigationBarTransformProgress:0];
        self.navigationController.navigationBar.backIndicatorImage = [[UIImage alloc] init];
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
