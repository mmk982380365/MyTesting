
//
//  MKActionSheet.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "MKActionSheet.h"

#define BtnHeight 46 //每个按钮的高度

#define CancleMargin 8 //取消按钮上面的间隔

//颜色制作 定义一个宏
#define PPSColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define BGColor PPSColor(237,240,242) //背景色

#define SeparatorColor PPSColor(226, 226, 226) //分割线颜色

#define normalImage [self imageWithColor:PPSColor(255,255,255)] //普通下的图片

#define highImage [self imageWithColor:PPSColor(242,242,242)] //高粱的图片
// 字体
#define HeitiLight(f) [UIFont fontWithName:@"STHeitiSC-Light" size:f]

@interface MKActionSheet ()
{
    int _tag;
}
@property (nonatomic, copy) MKActionSheetCompleteBlock completeBlock;

@property (nonatomic, strong) UIView *sheetView;

@end

@implementation MKActionSheet

- (instancetype)initWithCompletion:(MKActionSheetCompleteBlock)block cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles, ...
{
    self = [super init];
    if (self) {
        
        self.completeBlock = block;
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor blackColor];
        
        self.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverClick)];
        [self addGestureRecognizer:tap];
        
        UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
        sheetView.backgroundColor = BGColor;
        sheetView.alpha = 0.9;
        
        self.sheetView = sheetView;
        sheetView.hidden = YES;
        
        _tag = 1;
        
        NSString *curStr;
        va_list list;
        if (otherTitles) {
            [self setupBtnWithTitle:otherTitles];
            
            va_start(list, otherTitles);
            
            while ((curStr = va_arg(list, NSString *))) {
                [self setupBtnWithTitle:curStr];
            }
            va_end(list);
        }
        
        CGRect sheetViewF = sheetView.frame;
        sheetViewF.size.height = BtnHeight * _tag + CancleMargin;
        sheetView.frame = sheetViewF;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, sheetView.frame.size.height - BtnHeight, [UIScreen mainScreen].bounds.size.width, BtnHeight);
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
        [btn setTitle:cancelTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font  = HeitiLight(17);
        btn.tag = 0;
        [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [sheetView addSubview:btn];
        
        
    }
    return self;
}

-(void)show{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.sheetView];
    self.sheetView.hidden = NO;
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.sheetView.frame = sheetViewF;
    
    CGRect newSheetViewF = self.sheetView.frame;
    newSheetViewF.origin.y = [UIScreen mainScreen].bounds.size.height - self.sheetView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = newSheetViewF;
        self.alpha = 0.3;
    }];
    
}

-(void)setupBtnWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, BtnHeight * (_tag - 1), [UIScreen mainScreen].bounds.size.width, BtnHeight);
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font  = HeitiLight(17);
    btn.tag = _tag;
    [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:btn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
    line.backgroundColor = SeparatorColor;
    [btn addSubview:line];
    
    _tag++;
    
}

-(UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

-(void)coverClick{
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.sheetView.frame = sheetViewF;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.sheetView removeFromSuperview];
    }];
}

-(void)sheetBtnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        [self coverClick];
        return;
    }
    
    if (self.completeBlock) {
        self.completeBlock(self,btn.tag);
    }
    [self coverClick];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
