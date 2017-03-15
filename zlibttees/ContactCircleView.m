//
//  ContactCircleView.m
//  zlibttees
//
//  Created by MaMingkun on 2017/1/5.
//  Copyright © 2017年 MaMingkun. All rights reserved.
//

#import "ContactCircleView.h"
#import "ContactCell.h"

@interface ContactCircleView ()

@property (nonatomic, assign) CGFloat colorPoint;

@end

@implementation ContactCircleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(NSString *)getNotationFromString:(NSString *)string{
    NSMutableString *str = [string mutableCopy];
    
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}

-(float)calculateColorWithString:(NSString *)string{
    if (string.length == 0) {
        return 0.1;
    }
    
    float value = 0;
    
    if (string.length > 1) {
        NSString *firstStr = [string substringWithRange:NSMakeRange(0, 1)];
        NSString *secondStr = [string substringWithRange:NSMakeRange(1, 1)];
        NSString *firstNotation = [self getNotationFromString:firstStr];
        NSString *secondNotation = [self getNotationFromString:secondStr];
        NSUInteger count = firstNotation.length + secondNotation.length;
        if (count > 10) {
            count -= 10;
            value = count / 10.0;
        }else{
            value = count / 10.0;
        }
    }else{
        NSString *firstStr = [string substringWithRange:NSMakeRange(0, 1)];
        NSString *firstNotation = [self getNotationFromString:firstStr];
        NSUInteger count = firstNotation.length;
        if (count > 10) {
            count -= 10;
            value = count / 10.0;
        }else{
            value = count / 10.0;
        }
    }
    
    return value;
    
}

-(NSString *)subStringWithLength:(int)length string:(NSString *)string{
    NSString *copyString = [string copy];
    
    NSMutableString *realStr = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0; i < copyString.length; i++) {
        if (length == 0) {
            break;
        }
        
//        unichar ch = [copyString characterAtIndex:0];
//        if (0x4e00 < ch && ch < 0x9fff) {
//            
//        }
        
        [realStr appendString:[copyString substringWithRange:NSMakeRange(i, 1)]];
        length = length - 1;
        
    }
    return [realStr copy];
}

-(CGSize)calculateLabelSizeWithString:(NSString *)string{
    UILabel *lbl = [[UILabel alloc] init];
    lbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:self.frame.size.width/3.0];
    lbl.text = string;
    [lbl sizeToFit];
    return lbl.frame.size;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float redValue = [self calculateColorWithString:self.title];
    
    CGContextSetRGBFillColor(ctx, redValue, 0.5, 0.5, 1);
    
    CGContextAddArc(ctx, self.frame.size.width / 2.0, self.frame.size.height / 2.0, self.frame.size.width / 2.0, 0, 2 * M_PI, 0);
    CGContextDrawPath(ctx, kCGPathFill);
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:self.frame.size.width/3.0],
                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                 };
    CGSize size = [self calculateLabelSizeWithString:self.title];
    CGFloat X = (self.frame.size.width - size.width) / 2.0;
    CGFloat Y = (self.frame.size.height - size.height) / 2.0;
    [self.title drawInRect:CGRectMake(X, Y, self.frame.size.width, self.frame.size.height) withAttributes:attributes];
}

#pragma mark - setter

-(void)setTitle:(NSString *)title{
    _title = [self subStringWithLength:2 string:title];
    [self setNeedsDisplay];
}

@end
