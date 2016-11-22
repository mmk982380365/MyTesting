//
//  SpeechRecognizerViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/29.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "SpeechRecognizerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>
#import <CoreMedia/CoreMedia.h>

@interface SpeechRecognizerViewController ()<AVCaptureAudioDataOutputSampleBufferDelegate,SFSpeechRecognizerDelegate,SFSpeechRecognitionTaskDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) SFSpeechRecognizer *recognizer;
@property (nonatomic, strong) SFSpeechAudioBufferRecognitionRequest *req;

@end

@implementation SpeechRecognizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view, typically from a nib.
    
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

-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult{
    self.textView.text = [self.textView.text stringByAppendingString:recognitionResult.bestTranscription.formattedString];
}

-(void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task{
    NSLog(@"%@",task.error);
}

-(void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully{
    NSLog(@"sdasd");
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
