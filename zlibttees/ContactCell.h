//
//  ContactCell.h
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactInfo.h"

#define ContactCellHeight 45
#define ContactCellMargin 5

@interface ContactCell : UITableViewCell

@property (nonatomic, strong) ContactInfo *info;

@end
