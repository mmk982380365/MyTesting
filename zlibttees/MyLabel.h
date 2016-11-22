//
//  MyLabel.h
//  textanimation
//
//  Created by MaMingkun on 16/11/22.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLabel : UIView

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) BOOL showGradientLayer;

@end
