//
//  MusicViewController.m
//  zlibttees
//
//  Created by MaMingkun on 16/9/30.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "MusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MusicViewController ()
{
    id timeObserver;
    UIBackgroundTaskIdentifier taskId;
}
@property (nonatomic, strong) AVPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *MusicTitle;

@property (weak, nonatomic) IBOutlet UIImageView *musicPic;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLbl;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;

@property (weak, nonatomic) IBOutlet UIButton *rewindBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) NSURL *playerUrl;

@property (nonatomic, assign) BOOL isNew;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *visual;


@end

@implementation MusicViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
            {
                self.playBtn.enabled = NO;
            }
                break;
            case AVPlayerStatusReadyToPlay:
            {
                self.playBtn.enabled = YES;
                [self configureNowPlayingCenter];
                
            }
                break;
            case AVPlayerStatusFailed:
            {
                self.playBtn.enabled = YES;
            }
                break;
                
            default:
                break;
        }
    }
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(void)configureNowPlayingCenter{
//    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:0];
//    
//    [info setObject:self.music.songname forKey:MPMediaItemPropertyTitle];
//    [info setObject:self.music.singername forKey:MPMediaItemPropertyArtist];
//    
//    float current = CMTimeGetSeconds(self.player.currentTime);
//    
//    [info setObject:@(current) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];;
//    
//    [info setObject:@1 forKey:MPNowPlayingInfoPropertyPlaybackRate];
//    
//    float total = CMTimeGetSeconds(self.player.currentItem.duration);
//    
//    [info setObject:@(total) forKey:MPMediaItemPropertyPlaybackDuration];
//    //        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
//    
//    
//    
//    
//    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.music.albumpic_big] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
       
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:0];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(320, 320) requestHandler:^UIImage * _Nonnull(CGSize size) {
            return image;
        }];
        [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
        [info setObject:self.music.songname forKey:MPMediaItemPropertyTitle];
        [info setObject:self.music.singername forKey:MPMediaItemPropertyArtist];
        
        float current = CMTimeGetSeconds(self.player.currentTime);
        
        [info setObject:@(current) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];;
        
        [info setObject:@1 forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        float total = CMTimeGetSeconds(self.player.currentItem.duration);
        
        [info setObject:@(total) forKey:MPMediaItemPropertyPlaybackDuration];
        //        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
        
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view sendSubviewToBack:self.visual];
    [self.view sendSubviewToBack:self.backgroundView];
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app startBg];
   
    
//    UIBackgroundTaskIdentifier newTask = UIBackgroundTaskInvalid;
//    
//    newTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        
//    }];
//    
//    if (newTask != UIBackgroundTaskInvalid && taskId != UIBackgroundTaskInvalid) {
//        [[UIApplication sharedApplication] endBackgroundTask:taskId];
//    }
//    
//    taskId = newTask;
    
    [self.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    
    AVPlayerItem *newItem = [AVPlayerItem playerItemWithURL:self.playerUrl];
    self.player = [AVPlayer playerWithPlayerItem:newItem];

    
    [newItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    __weak typeof(self) ws = self;
    timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(newItem.duration);
        
        if (current) {
            ws.progressBar.progress = current/total;
            
            int sec = (int)total%60;
            total /= 60;
            ws.totalTimeLbl.text = [NSString stringWithFormat:@"%02.f:%02d",total,sec];
            
            
            
            
            int second = (int)current%60;
            current/=60;
            
            ws.currentTimeLbl.text = [NSString stringWithFormat:@"%02.f:%02d",current,second];
            
        }
        
    }];
    
    
    
    
//    self.isNew = NO;
    
    [self play:self.playBtn];
    
    
    self.MusicTitle.text = self.music.songname;
    [self.musicPic sd_setImageWithURL:[NSURL URLWithString:self.music.albumpic_big]];
    self.playerUrl = [NSURL URLWithString:self.music.url];
    [self.backgroundView sd_setImageWithURL:[NSURL URLWithString:self.music.albumpic_big]];
    self.playBtn.selected = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishPlayed:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlEventFromWatch:) name:@"WatchNote" object:nil];
}

-(void)controlEventFromWatch:(NSNotification *)note{
    NSDictionary *info = note.object;
    
    if ([info[@"type"] isEqualToString:@"play"]) {
        [self.player play];
        self.playBtn.selected = YES;
    }else if ([info[@"type"] isEqualToString:@"pause"]) {
        [self.player pause];
        self.playBtn.selected = NO;
    }else if ([info[@"type"] isEqualToString:@"rewind"]) {
        [self rewind:self.rewindBtn];
    }else if ([info[@"type"] isEqualToString:@"forward"]) {
        [self forward:self.forwardBtn];
    }
    
}

-(void)remoteControl:(UIEvent *)event{
    
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        {
            [self.player play];
            self.playBtn.selected = YES;
        }
            break;
        case UIEventSubtypeRemoteControlPause:
        {
            [self.player pause];
            self.playBtn.selected = NO;
        }
            break;
            case UIEventSubtypeRemoteControlNextTrack:
        {
            [self forward:self.forwardBtn];
        }
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
        {
            [self rewind:self.rewindBtn];
        }
            break;
            
        case UIEventSubtypeRemoteControlTogglePlayPause:
        {
            if (self.player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
                [self.player play];
                self.playBtn.selected = YES;
            }else if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
                [self.player pause];
                self.playBtn.selected = NO;
            }
        }
            break;
        default:
            break;
    }
    [self configureNowPlayingCenter];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)playerFinishPlayed:(NSNotification *)note{
    [self forward:self.forwardBtn];
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)play:(UIButton *)sender {
    
    if (self.isNew) {
        self.isNew = NO;
        __autoreleasing NSError *error;
        
        self.progressBar.progress = 0;
        
        AVPlayerItem *newItem = [AVPlayerItem playerItemWithURL:self.playerUrl];
        
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [newItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.player replaceCurrentItemWithPlayerItem:newItem];
        if (timeObserver) {
            [self.player removeTimeObserver:timeObserver];
           
            __weak typeof(self) ws = self;
            timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                float current = CMTimeGetSeconds(time);
                float total = CMTimeGetSeconds(newItem.duration);
                
                if (current) {
                    ws.progressBar.progress = current/total;
                    
                    int sec = (int)total%60;
                    total /= 60;
                    ws.totalTimeLbl.text = [NSString stringWithFormat:@"%02.f:%02d",total,sec];
                    
                    int second = (int)current%60;
                    current/=60;
                    
                    ws.currentTimeLbl.text = [NSString stringWithFormat:@"%02.f:%02d",current,second];
                    
                }
                
            }];
        }
        
        
        if (!error) {
            sender.selected = NO;
        }else{
            NSLog(@"%@",error);
            return;
        }
        
    }
    
    if (sender.isSelected == NO) {
        sender.selected = YES;
        
        
        [self.player play];
    }else{
        sender.selected = NO;
        [self.player pause];
    }
}

- (IBAction)rewind:(id)sender {
    NSInteger currentIndex = [[GobalData data].currentPlayingArray indexOfObject:self.music];
    
    NSInteger newIndex = currentIndex-1;
    
    if (currentIndex == 0) {
        newIndex = [GobalData data].currentPlayingArray.count - 1;
    }
    self.music = [GobalData data].currentPlayingArray[newIndex];
}

- (IBAction)forward:(id)sender {
    NSInteger currentIndex = [[GobalData data].currentPlayingArray indexOfObject:self.music];
    
    
    
    if (currentIndex == NSNotFound){
        
        for (MusicModel *listMusic in [GobalData data].currentPlayingArray) {
            if ([listMusic.songid isEqualToString:self.music.songid]) {
                currentIndex = [[GobalData data].currentPlayingArray indexOfObject:listMusic];
            }
        }
    }
    NSInteger newIndex = currentIndex+1;
    if (currentIndex == [GobalData data].currentPlayingArray.count - 1) {
        //最后一个
        newIndex = 0;
    }
    
    self.music = [GobalData data].currentPlayingArray[newIndex];
    
    NSLog(@"%ld",currentIndex);
    
}

-(void)setMusic:(MusicModel *)music{
    if ([music.songid isEqualToString:_music.songid]) {
        return;
    }
    if (_music != music) {
        _music = music;
        self.playerUrl = [NSURL URLWithString:music.url];
        if (self.isViewLoaded) {
            self.MusicTitle.text = music.songname;
            [self.musicPic sd_setImageWithURL:[NSURL URLWithString:music.albumpic_big]];
            [self.backgroundView sd_setImageWithURL:[NSURL URLWithString:music.albumpic_big]];
            self.currentTimeLbl.text = @"00:00";
            
            
            
            self.isNew = YES;
            [self play:self.playBtn];
        }
        
        
        
        
    }
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
