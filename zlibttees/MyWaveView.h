//
//  MyWaveView.h
//  textanimation
//
//  Created by MaMingkun on 16/11/22.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWaveView : UIView

/**
 振幅
 */
@property (nonatomic, assign) CGFloat waveAmplitude;

/**
 周期
 */
@property (nonatomic, assign) CGFloat waveCycle;

/**
 波速
 */
@property (nonatomic, assign) CGFloat waveSpeed;

/**
 波纹高度
 */
@property (nonatomic, assign) CGFloat waveHeight;

/**
 波纹颜色
 */
@property (nonatomic, strong) UIColor *waveColor;

/**
 开始
 */
-(void)startWave;

@end
