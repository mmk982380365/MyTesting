//
//  MyLabel.m
//  textanimation
//
//  Created by MaMingkun on 16/11/22.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "MyLabel.h"
#import <CoreText/CoreText.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface MyLabel ()
{
    CAGradientLayer *gradientLayer;
}
@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation MyLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer addSublayer:self.textLayer];
        
        [self setDefault];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.textLayer];
        [self setDefault];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.layer addSublayer:self.textLayer];
    [self setDefault];
    
}

-(void)setDefault{
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:12];
    self.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - setter

-(void)setShowGradientLayer:(BOOL)showGradientLayer{
    if (_showGradientLayer != showGradientLayer) {
        _showGradientLayer = showGradientLayer;
        if (showGradientLayer) {
            gradientLayer =  [CAGradientLayer layer];
            [gradientLayer setColors:[NSArray arrayWithObjects:
                                      (id)[UIColorFromRGB(0x000000) CGColor],
                                      (id)[UIColorFromRGB(0xFFD700) CGColor],
                                      (id)[UIColorFromRGB(0x000000) CGColor],
                                      (id)[UIColorFromRGB(0xFFD700) CGColor],
                                      (id)[UIColorFromRGB(0x000000) CGColor],
                                      (id)[UIColorFromRGB(0xFFD700) CGColor],
                                      (id)[UIColorFromRGB(0x000000) CGColor],
                                      (id)[UIColorFromRGB(0xFFD700) CGColor],
                                      (id)[UIColorFromRGB(0x000000) CGColor],
                                      (id)[UIColorFromRGB(0xFFD700) CGColor],
                                      (id)[UIColorFromRGB(0x000000) CGColor],
                                      (id)[[UIColor clearColor] CGColor],
                                      nil]];
            gradientLayer.frame = self.textLayer.bounds;
            [gradientLayer setLocations:[NSArray arrayWithObjects:
                                         [NSNumber numberWithFloat:0.0],
                                         [NSNumber numberWithFloat:0.1],
                                         [NSNumber numberWithFloat:0.2],
                                         [NSNumber numberWithFloat:0.3],
                                         [NSNumber numberWithFloat:0.4],
                                         [NSNumber numberWithFloat:0.5],
                                         [NSNumber numberWithFloat:0.6],
                                         [NSNumber numberWithFloat:0.7],
                                         [NSNumber numberWithFloat:0.8],
                                         [NSNumber numberWithFloat:0.9],
                                         [NSNumber numberWithFloat:1.0],
                                         nil]];
            
            [gradientLayer setStartPoint:CGPointMake(0, 0)];
            [gradientLayer setEndPoint:CGPointMake(1, 1)];
            [self.textLayer removeFromSuperlayer];
            
            gradientLayer.mask = self.textLayer;
            [self.layer addSublayer:gradientLayer];
            
            
        }else{
            self.textLayer.mask = nil;
            [gradientLayer removeFromSuperlayer];
            [self.layer addSublayer:self.textLayer];
        }
    }
}

-(void)setFont:(UIFont *)font{
    if (_font != font) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)[font fontName], font.pointSize, NULL);
        self.textLayer.font = fontRef;
        self.textLayer.fontSize = font.pointSize;
        CFRelease(fontRef);
    }
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment{
    if (_textAlignment != textAlignment) {
        _textAlignment = textAlignment;
        NSString *alignment;
        switch (textAlignment) {
            case NSTextAlignmentLeft:
            {
                alignment = kCAAlignmentLeft;
            }
                break;
            case NSTextAlignmentRight:
            {
                alignment = kCAAlignmentRight;
            }
                break;
            case NSTextAlignmentCenter:
            {
                alignment = kCAAlignmentCenter;
            }
                break;
            case NSTextAlignmentNatural:
            {
                alignment = kCAAlignmentNatural;
            }
                break;
            case NSTextAlignmentJustified:
            {
                alignment = kCAAlignmentJustified;
            }
                break;
                
            default:
            {
                alignment = kCAAlignmentJustified;
            }
                break;
        }
        
        self.textLayer.alignmentMode = alignment;
        
    }
}

-(void)setTextColor:(UIColor *)textColor{
    if (_textColor != textColor) {
        self.textLayer.foregroundColor = textColor.CGColor;
    }
}

-(void)setText:(NSString *)text{
    if (_text != text) {
        _text = [text copy];
        
        self.textLayer.string = text;
        
    }
}

-(CATextLayer *)textLayer{
    if (_textLayer == nil) {
        _textLayer = [CATextLayer layer];
        _textLayer.frame = self.bounds;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _textLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
