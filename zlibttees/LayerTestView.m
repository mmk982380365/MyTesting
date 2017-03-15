//
//  LayerTestView.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/6.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "LayerTestView.h"

@interface LayerTestView ()

@property (nonatomic, strong) CALayer *layerView;

@end

@implementation LayerTestView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor redColor];
    
    
    self.layerView.contents = (__bridge id _Nullable)([UIImage imageNamed:@"setting"].CGImage);
    self.layerView.contentsGravity = kCAGravityResizeAspect;
    self.layerView.contentsScale = [UIScreen mainScreen].scale;
    self.layerView.shadowColor = [UIColor orangeColor].CGColor;
    self.layerView.shadowOffset = CGSizeMake(10, 20);
    self.layerView.shadowRadius = 5;
    self.layerView.shadowOpacity = 1;
    [self.layer addSublayer:self.layerView];
    
}

#pragma mark - getter

-(CALayer *)layerView{
    if (_layerView == nil) {
        _layerView = [CALayer layer];
        _layerView.frame = CGRectMake(10, 15, 80, 120);
    }
    return _layerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
