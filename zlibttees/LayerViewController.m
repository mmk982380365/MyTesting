//
//  LayerViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/11/22.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "LayerViewController.h"
#import "MyWaveView.h"
#import "MyLabel.h"

@interface LayerViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;
@property (weak, nonatomic) IBOutlet UISlider *slider3;
@property (weak, nonatomic) IBOutlet UISlider *slider4;

@property (nonatomic, strong) MyWaveView *waveView;

@property (weak, nonatomic) IBOutlet MyLabel *Label;

@end

@implementation LayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.slider4.maximumValue = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    
    self.waveView = [[MyWaveView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.waveView];
    [self.waveView startWave];
    [self.view sendSubviewToBack:self.waveView];
    
//    MyLabel *label = [[MyLabel alloc] initWithFrame:CGRectMake(15, self.view.bounds.size.height - 40, self.view.bounds.size.width - 30, 40)];
    
//    label.text = @"测试标签 ♪(^∇^*)";
//    label.font = [UIFont fontWithName:@"Menlo-BoldItalic" size:25];
//    [self.view addSubview:label];
//    label.showGradientLayer = YES;
    
    self.Label.text = @"测试标签 ♪(^∇^*)";
    self.Label.font = [UIFont fontWithName:@"Menlo-BoldItalic" size:25];
    self.Label.showGradientLayer = YES;
    
}

- (IBAction)slider1Act:(UISlider *)sender {
    self.waveView.waveAmplitude = sender.value;
}

- (IBAction)slider2Act:(UISlider *)sender {
    self.waveView.waveCycle = sender.value;
}

- (IBAction)slider3Act:(UISlider *)sender {
    self.waveView.waveSpeed = sender.value;
}

- (IBAction)slider4Act:(UISlider *)sender {
    self.waveView.waveHeight = sender.value;
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
