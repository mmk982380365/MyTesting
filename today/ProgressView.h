//
//  ProgressView.h
//  zlibttees
//
//  Created by MaMingkun on 16/9/29.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic, assign) unsigned long long free;

@property (nonatomic, assign) unsigned long long active;

@property (nonatomic, assign) unsigned long long inactive;

@property (nonatomic, assign) unsigned long long wire;

@property (nonatomic, assign) unsigned long long total;

-(void)updateData;

@end
