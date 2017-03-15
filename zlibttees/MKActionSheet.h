//
//  MKActionSheet.h
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKActionSheet;

typedef void(^MKActionSheetCompleteBlock)(MKActionSheet *actionSheet,NSInteger clickedIndex);

@interface MKActionSheet : UIView

-(instancetype)initWithCompletion:(MKActionSheetCompleteBlock)block cancelTitle:(NSString *)cancelTitle otherTitles:(NSString *)otherTitles,... NS_REQUIRES_NIL_TERMINATION;

-(void)show;

@end
