//
//  LayerTextViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/11/23.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "LayerTextViewController.h"
#import <CoreText/CoreText.h>

@interface LayerTextViewController ()

@property (nonatomic, strong) UIBarButtonItem *animateBtn;

@property (nonatomic, strong) CATextLayer *textLayer;

@property (nonatomic, strong) CAShapeLayer *penLayer;

@end

@implementation LayerTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = self.animateBtn;
    
    [self.view.layer addSublayer:self.textLayer];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"Menlo-BoldItalic", 40, NULL);
    
    CGMutablePathRef letters = CGPathCreateMutable();
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObject:(__bridge id)fontRef forKey:(__bridge id)kCTFontAttributeName];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.textLayer.string attributes:attrs];
    
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
            
        }
        
        
    }
    
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(fontRef);
    
    self.penLayer = [CAShapeLayer layer];
    self.penLayer.frame = CGRectMake(10, 400, self.view.frame.size.width - 20, 40);
    self.penLayer.path = path.CGPath;
//    self.penLayer.transform = CATransform3DMakeScale(1, -1, 1);
    self.penLayer.geometryFlipped = YES;
    self.penLayer.strokeColor = [UIColor blueColor].CGColor;
    self.penLayer.fillColor = [UIColor clearColor].CGColor;
    self.penLayer.shadowOffset = CGSizeMake(15, -15);
    self.penLayer.shadowColor = [UIColor grayColor].CGColor;
    self.penLayer.shadowRadius = 5;
    self.penLayer.shadowPath = path.CGPath;
    self.penLayer.shadowOpacity = 1;
    [self.view.layer addSublayer:self.penLayer];
    
}

-(void)startAnimate:(UIBarButtonItem *)btn{
    
    [self.penLayer removeAllAnimations];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.fromValue = @(0);
//    animation.toValue = @(1);
    
    animation.values = @[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],];
    animation.keyTimes = @[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:1.0],];
//    animation.duration = 15;
//    animation.repeatCount = CGFLOAT_MAX;
    
    
    
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"shadowOffset.height"];
    
    animation2.values = @[[NSNumber numberWithFloat:-15.0],
                         [NSNumber numberWithFloat:50.0],
                         [NSNumber numberWithFloat:-15.0],];
    animation2.keyTimes = @[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:1.0],];
//    animation2.duration = 15;
    
    group.duration = 7;
    group.repeatCount = CGFLOAT_MAX;
    group.animations = @[animation,animation2];
    
//    [self.penLayer addAnimation:animation2 forKey:@"aniasfu"];
    
    [self.penLayer addAnimation:group forKey:@"ani"];
    
}

#pragma mark - getter

-(UIBarButtonItem *)animateBtn{
    if (_animateBtn == nil) {
        _animateBtn = [[UIBarButtonItem alloc] initWithTitle:@"显示动画" style:UIBarButtonItemStyleDone target:self action:@selector(startAnimate:)];
    }
    return _animateBtn;
}

-(CATextLayer *)textLayer{
    if (_textLayer == nil) {
        _textLayer = [CATextLayer layer];
        _textLayer.frame = CGRectMake(10, 150, self.view.frame.size.width - 20, 45);
        _textLayer.foregroundColor = [UIColor redColor].CGColor;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        
        UIFont *font = [UIFont fontWithName:@"Menlo-BoldItalic" size:40];
        CGFontRef fontRef = CGFontCreateWithFontName((CFStringRef)font.fontName);
        _textLayer.font = fontRef;
        _textLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        
        _textLayer.string = @"testingtesting";
        
    }
    return _textLayer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
