//
//  UINavigationBar+SizeableHeight.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "UINavigationBar+SizeableHeight.h"

@implementation UINavigationBar (SizeableHeight)

-(void)in_setTranslationY:(CGFloat)translationY{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

-(void)in_setScrollViewAlpha:(CGFloat)alpha{
    
    [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.alpha = alpha;
    }];
    
    [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL * _Nonnull stop) {
        view.alpha = alpha;
    }];
    
    UIView *titleView = [self valueForKey:@"_titleView"];
    titleView.alpha = alpha;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            obj.alpha = alpha;
            *stop = YES;
        }
    }];
    
}

@end
