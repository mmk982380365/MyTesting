//
//  ZipViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/29.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "ZipViewController.h"
#import <zlib.h>
#import <AVFoundation/AVFoundation.h>

@interface ZipViewController ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSString *currentTime;

@property (nonatomic, strong) NSString *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;

@end

@implementation ZipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self startZip];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [self stop:self.stopBtn];
    self.audioPlayer = nil;
}

- (IBAction)play:(id)sender {
    self.playBtn.enabled = NO;
    self.pauseBtn.enabled = YES;
    self.stopBtn.enabled = YES;
    [self.audioPlayer play];
}

- (IBAction)pause:(id)sender {
    self.playBtn.enabled = YES;
    self.pauseBtn.enabled = NO;
    self.stopBtn.enabled = YES;
    [self.audioPlayer pause];
}

- (IBAction)stop:(id)sender {
    self.playBtn.enabled = YES;
    self.pauseBtn.enabled = NO;
    self.stopBtn.enabled = NO;
    [self.audioPlayer stop];
    self.audioPlayer.currentTime = 0;
}

-(void)timeAction:(id)timer{
    
    int total = round(self.audioPlayer.duration);
    
    int secondTotal = total % 60;
    
    total /= 60;
    
    int minutesTotal = total %60;
    
    total /= 60;
    
    int hoursTotal = total;
    
    NSString *totalStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hoursTotal,minutesTotal,secondTotal];
    
    if (![totalStr isEqualToString:self.totalTime]) {
        self.totalTime = totalStr;
        
        self.totalTimeLbl.text = totalStr;
        [self.totalTimeLbl sizeToFit];
        
    }
    
    int current = round(self.audioPlayer.currentTime);
    
    int second = current % 60;
    
    current /= 60;
    
    int minute = current % 60;
    
    current /= 60;
    
    int hour = current;
    
    NSString *currentStr = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    
    if (![currentStr isEqualToString:self.currentTime]) {
        self.currentTime = currentStr;
        
        self.currentTimeLbl.text = currentStr;
        [self.currentTimeLbl sizeToFit];
        NSLog(@"%d:%d:%d",hour,minute,second);
    }
    
    
    
    self.progressBar.progress = self.audioPlayer.currentTime/self.audioPlayer.duration;
}

-(void)startZip{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"11" ofType:@"mp3"]];
        NSData *comData = [self compressDataWithData:data];
        
        NSLog(@"com %ld da %ld",comData.length,data.length);
        
        NSData *unc = [self uncompressDaraWithData:comData];
        
        NSLog(@"%ld sss",unc.length);
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"11.mp3"];
        BOOL isSuc = [comData writeToFile:path atomically:YES];
        if (isSuc) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                __autoreleasing NSError *error = nil;
                self.audioPlayer = [[AVAudioPlayer alloc] initWithData:unc fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
                if (error) {
                    NSLog(@"%@",error);
                }else{
                    self.playBtn.enabled = YES;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
                    [self.timer fire];
                }
                
            });
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSData *)uncompressDaraWithData:(NSData *)data{
    
    if (data.length == 0) {
        return data;
    }
    
    unsigned long fullLength = data.length;
    unsigned long halfLength = data.length / 2.0;
    NSMutableData *uncompressData = [NSMutableData dataWithLength:fullLength + halfLength];
    
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)data.bytes;
    strm.avail_in = (unsigned int)data.length;
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit(&strm) != Z_OK) {
        return nil;
    }
    
    while (!done) {
        if (strm.total_out >= uncompressData.length) {
            [uncompressData increaseLengthBy:halfLength];
        }
        strm.next_out = [uncompressData mutableBytes] + strm.total_out;
        strm.avail_out = (uint)([uncompressData length] - strm.total_out);
        
        status = inflate(&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        }else if (status != Z_OK){
            break;
        }
        
        
    }
    
    if (inflateEnd(&strm) != Z_OK) {
        return nil;
    }
    
    if (done) {
        [uncompressData setLength:strm.total_out];
        return [NSData dataWithData:uncompressData];
    }
    
    
    return nil;
}

-(NSData *)compressDataWithData:(NSData *)data{
    NSData *compressedData = nil;
    
    Bytef *buf = NULL;
    uLong blen;
    
    blen = compressBound(data.length);
    if ((buf = (Bytef *)malloc(sizeof(Bytef) * blen)) == NULL) {
        NSLog(@"no men");
        return nil;
    }
    
    if (compress(buf, &blen, data.bytes, data.length) != Z_OK) {
        NSLog(@"compress Err");
        return nil;
    }
    
    compressedData = [NSData dataWithBytes:buf length:blen];
    
    return compressedData;
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
