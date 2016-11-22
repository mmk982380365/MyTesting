//
//  ProgressView.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/29.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@property (nonatomic, strong) UIView *freeView;

@property (nonatomic, strong) UIView *activeView;

@property (nonatomic, strong) UIView *inActiveView;

@property (nonatomic, strong) UIView *wireView;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        self.freeView = [[UIView alloc] init];
        self.freeView .backgroundColor = [UIColor greenColor];
        
        self.activeView = [[UIView alloc] init];
        self.activeView.backgroundColor = [UIColor yellowColor];
        
        self.inActiveView = [[UIView alloc] init];
        self.inActiveView.backgroundColor = [UIColor orangeColor];
        
        self.wireView = [[UIView alloc] init];
        self.wireView.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.freeView];
        [self addSubview:self.activeView];
        [self addSubview:self.inActiveView];
        [self addSubview:self.wireView];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)updateData{
    CGFloat width = self.bounds.size.width;
    
    CGFloat wireWidth = (self.wire/self.total) * width;
    CGFloat activeWidth = (self.active/self.total) * width;
    CGFloat inactiveWidth = (self.inactive/self.total) * width;
    CGFloat freeWidth = (self.free/self.total) * width;
    
    self.wireView.frame = CGRectMake(0, 0, wireWidth, self.frame.size.height);
    self.activeView.frame = CGRectMake(wireWidth, 0, activeWidth, self.frame.size.height);
    self.inActiveView.frame = CGRectMake(wireWidth + activeWidth, 0, inactiveWidth, self.frame.size.height);
    self.freeView.frame = CGRectMake(wireWidth + activeWidth + inactiveWidth, 0, freeWidth, self.frame.size.height);
    
}

@end
