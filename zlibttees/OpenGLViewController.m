//
//  OpenGLViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/11/9.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "OpenGLViewController.h"
#import "OpenGLView.h"

@interface OpenGLViewController ()

@property (nonatomic, strong) OpenGLView *glView;

@end

@implementation OpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.glView = [[OpenGLView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.glView];
    
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
