//
//  ViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/28.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "ViewController.h"
#import <zlib.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>
#import <CoreMedia/CoreMedia.h>

@interface ViewController () <AVCaptureAudioDataOutputSampleBufferDelegate,SFSpeechRecognizerDelegate,SFSpeechRecognitionTaskDelegate>

@property (nonatomic, strong) AVPlayerViewController *player;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) SFSpeechRecognizer *recognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *req;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@end

@implementation ViewController

-(void)initVoice{
    if (self.captureSession) {
//        [self.captureSession startRunning];
    }else{
        self.captureSession = [[AVCaptureSession alloc] init];
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        if (audioDevice) {
            __autoreleasing NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
            if (!error) {
                if ([self.captureSession canAddInput:input]) {
                    [self.captureSession addInput:input];
                }
            }
            
            AVCaptureAudioDataOutput *output = [[AVCaptureAudioDataOutput alloc] init];
            
            [output setSampleBufferDelegate:self queue:dispatch_queue_create("audio", NULL)];
            if ([self.captureSession canAddOutput:output]) {
                [self.captureSession addOutput:output];
                [output connectionWithMediaType:AVMediaTypeAudio];
            }
            
//            [self.captureSession startRunning];
        }
        
        
    }
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    [self.req appendAudioSampleBuffer:sampleBuffer];
}


- (IBAction)startAct:(id)sender {
    self.startBtn.enabled = NO;
    self.stopBtn.enabled = YES;
    self.req = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    [self.captureSession startRunning];
    
}


- (IBAction)stopAct:(id)sender {
    self.startBtn.enabled = YES;
    self.stopBtn.enabled = NO;
    
    [self.captureSession stopRunning];
    [self.req endAudio];
    [self.recognizer recognitionTaskWithRequest:self.req delegate:self];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
//
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Ingress" ofType:@"ipa"]];
//    NSData *comData = [self compressDataWithData:data];
//    
//    NSLog(@"com %ld da %ld",comData.length,data.length);
//   
//    NSData *unc = [self uncompressDaraWithData:comData];
//    
//    NSLog(@"%ld sss",unc.length);
//    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"1."];
//    BOOL isSuc = [comData writeToFile:path atomically:YES];
//    if (isSuc) {
////        self.player = [[AVPlayerViewController alloc] init];
////        self.player.view.frame = self.view.bounds;
////        NSURL *url = [NSURL fileURLWithPath:path];
////        AVPlayer *player = [AVPlayer playerWithURL:url];
////        
////        self.player.player = player;
////        
////        [self.view addSubview:self.player.view];
//        
//        
//    }
    
    self.textView.adjustsFontForContentSizeCategory = YES;
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textView.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
    
    [self initVoice];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.recognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    
    
    
    
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"11" ofType:@"mp3"]];
//    SFSpeechURLRecognitionRequest *req = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
//    
//    [self.recognizer recognitionTaskWithRequest:req resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@",error);
//        }else{
//            self.textView.text = [self.textView.text stringByAppendingString:result.bestTranscription.formattedString];
//        }
//    }];
    
    
}

-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult{
    self.textView.text = [self.textView.text stringByAppendingString:recognitionResult.bestTranscription.formattedString];
}

-(void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task{
    NSLog(@"%@",task.error);
}

-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully{
    NSLog(@"sdasd");
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
+(NSData*) gzipData: (NSData*)pUncompressedData //压缩
{
    /*
     Special thanks to Robbie Hanson of Deusty Designs for sharing sample code
     showing how deflateInit2() can be used to make zlib generate a compressed
     file with gzip headers:
     http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html
     */
    
    if (!pUncompressedData || [pUncompressedData length] == 0)
    {
        NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
        return nil;
    }
    
    z_stream zlibStreamStruct;
    zlibStreamStruct.zalloc     = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
    zlibStreamStruct.zfree      = Z_NULL; // that when we call deflateInit2 they will be
    zlibStreamStruct.opaque     = Z_NULL; // updated to use default allocation functions.
    zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
    zlibStreamStruct.next_in    = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
    zlibStreamStruct.avail_in   = [pUncompressedData length]; // Number of input bytes left to process
    
    int initError = inflateInit(&zlibStreamStruct);
    if (initError != Z_OK)
    {
        NSString *errorMsg = nil;
        switch (initError)
        {
            case Z_STREAM_ERROR:
                errorMsg = @"Invalid parameter passed in to function.";
                break;
            case Z_MEM_ERROR:
                errorMsg = @"Insufficient memory.";
                break;
            case Z_VERSION_ERROR:
                errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
                break;
            default:
                errorMsg = @"Unknown error code.";
                break;
        }
        NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
//        [errorMsg release];
        return nil;
    }
    
    // Create output memory buffer for compressed data. The zlib documentation states that
    // destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
    NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];
    
    int n1 = [compressedData length];
    NSLog(@"==== %d",n1);
    
    int deflateStatus;
    do
    {
        // Store location where next byte should be put in next_out
        zlibStreamStruct.next_out = (Bytef *)[compressedData mutableBytes] + zlibStreamStruct.total_out;
        
        // Calculate the amount of remaining free space in the output buffer
        // by subtracting the number of bytes that have been written so far
        // from the buffer's total capacity
        zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        
        /* deflate() compresses as much data as possible, and stops/returns when
         the input buffer becomes empty or the output buffer becomes full. If
         deflate() returns Z_OK, it means that there are more bytes left to
         compress in the input buffer but the output buffer is full; the output
         buffer should be expanded and deflate should be called again (i.e., the
         loop should continue to rune). If deflate() returns Z_STREAM_END, the
         end of the input stream was reached (i.e.g, all of the data has been
         compressed) and the loop should stop. */
        deflateStatus = inflate(&zlibStreamStruct, Z_NO_FLUSH);
        
    } while ( deflateStatus == Z_OK );
    
    deflateEnd(&zlibStreamStruct);
    int n = zlibStreamStruct.total_out;
    NSLog(@"==== %d",n);
    [compressedData setLength: zlibStreamStruct.total_out];
    NSLog(@"%s: Compressed file from %d KB to %d KB", __func__, [pUncompressedData length]/1024, [compressedData length]/1024);
    
    return compressedData;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
