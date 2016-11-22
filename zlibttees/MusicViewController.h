//
//  MusicViewController.h
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "BaseViewController.h"
#import "MusicModel.h"

@interface MusicViewController : BaseViewController

@property (nonatomic, strong) MusicModel *music;

-(void)remoteControl:(UIEvent *)event;

@end
