//
//  MyWaveView.m
//  textanimation
//
//  Created by MaMingkun on 16/11/22.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "MyWaveView.h"

@interface MyWaveView ()
{
    CGFloat _height;
    CGFloat _width;
}

/**
 偏移
 */
@property (nonatomic, assign) CGFloat offsetX;

/**
 频率
 */
@property (nonatomic, assign) CGFloat waveRate;

/**
 计时器
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/**
 波纹图层
 */
@property (nonatomic, strong) CAShapeLayer *waveLayer;

/**
 背景图层
 */
@property (nonatomic, strong) CAShapeLayer *backLayer;

/**
 文字图层
 */
@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation MyWaveView


#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)initData{
    /**
     Asin (rt + x)
     A: waveAmplitude
     r: waveRate
     x: offsetX
     */
    
    //振幅
    self.waveAmplitude = 30.0f;
    //周期
    self.waveCycle = 200.0f;
    //频率
    self.waveRate = 2 * M_PI / self.waveCycle;
    //偏移
    self.offsetX = 0.0f;
    //高度
    self.waveHeight = 300.f;
    //速度
    self.waveSpeed = 0.2f;
    //颜色
    self.waveColor = [UIColor redColor];
    _height = self.frame.size.height;
    _width = self.frame.size.width;
    
}

#pragma mark - setter

-(void)setWaveCycle:(CGFloat)waveCycle{
    _waveCycle = waveCycle;
    _waveRate = 2 * M_PI / _waveCycle;
}

-(void)setWaveHeight:(CGFloat)waveHeight{
    _waveHeight = waveHeight;
    NSString *text = [NSString stringWithFormat:@"%.2f%%",_waveHeight/_height * 100];
    _textLayer.string = text;
}

-(void)startWave{
    if (_displayLink) {
        return;
    }
    if (self.waveLayer == nil) {
        _waveLayer = [CAShapeLayer layer];
        _waveLayer.fillColor = self.waveColor.CGColor;
        [self.layer addSublayer:_waveLayer];
    }
    if (self.backLayer == nil) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.frame = self.bounds;
        _backLayer.fillColor = [UIColor yellowColor].CGColor;
        _backLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_backLayer];
    }
    if (self.textLayer == nil) {
        _textLayer = [CATextLayer layer];
        _textLayer.foregroundColor = [UIColor blackColor].CGColor;
        _textLayer.alignmentMode = kCAAlignmentJustified;
        _textLayer.wrapped = YES;
        _textLayer.frame = CGRectMake((_width - 150)/2.0, (_height - 40)/2.0, 150, 40);
        UIFont *font = [UIFont systemFontOfSize:40];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        _textLayer.font = fontRef;
        _textLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        NSString *text = [NSString stringWithFormat:@"%.2f%%",_waveHeight/_height * 100];
        _textLayer.string = text;
        _textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:_textLayer];
        _backLayer.mask = _textLayer;
    }
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)getCurrentWave:(CADisplayLink *)displayLink{
    self.offsetX += self.waveSpeed;
    if (self.waveHeight > _height - self.waveAmplitude) {
        self.waveHeight = _height - self.waveAmplitude;
    }
    [self setCurrentWaveLayerPath];
}

-(void)setCurrentWaveLayerPath{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat currentWavePointY = _height - self.waveHeight;
    CGPathMoveToPoint(path, NULL, 0, currentWavePointY);
    
    //正弦公式
    for (float x = 0.0f; x <= _width; x++) {
        CGFloat y = self.waveAmplitude * sin(self.waveRate * x + self.offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    CGPathAddLineToPoint(path, NULL, _width, _height);
    CGPathAddLineToPoint(path, NULL, 0, _height);
    CGPathCloseSubpath(path);
    self.waveLayer.path = path;
    CGMutablePathRef backPath = CGPathCreateMutableCopy(path);
    self.backLayer.path = backPath;
    CGPathRelease(path);
    CGPathRelease(backPath);
    
}

#pragma mark - 停止

-(void)reset{
    [self stopWave];
    [_waveLayer removeFromSuperlayer];
    _waveLayer = nil;
}

-(void)stopWave{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)dealloc
{
    [self reset];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
