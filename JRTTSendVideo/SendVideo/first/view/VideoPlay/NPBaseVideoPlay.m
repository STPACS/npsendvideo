//
//  NPBaseVideoPlay.m
//  JRTTSendVideo
//
//  Created by mac on 2020/4/6.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPBaseVideoPlay.h"

@interface NPBaseVideoPlay() {
    NSInteger videoId;
    CMTime time;
    UIImageView *positionImage;
}
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, assign) BOOL loop;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, assign) BOOL autoPlay;

@end

@implementation NPBaseVideoPlay


+(NPBaseVideoPlay *)shareVideoPlay {
    
    static NPBaseVideoPlay *videoPlayer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoPlayer = [[NPBaseVideoPlay alloc]init];
        [videoPlayer addNotification];
    });
    return videoPlayer;
}

- (void)videoUrl:(NSURL *)url autoplay:(BOOL)autoplay {
    
    self.autoPlay = autoplay;
    
    [self playWithUrl:url view:self];

}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self playWithUrl:url view:self];
}

- (void)playWithUrl:(NSURL *)url view:(UIView *)view {
    if (url == nil) {
        return;
    }
    [self createBaseView:view];
    if (self.avPlayer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
    }
    AVAsset *videoAsset = [AVAsset assetWithURL:url];
    [videoAsset loadValuesAsynchronouslyForKeys:@[@"duration",@"tracks",@"commonMetadata"] completionHandler:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            AVPlayerItem *playItem = [AVPlayerItem playerItemWithAsset:videoAsset];
            if (!self.avPlayer) {
                self.avPlayer = [AVPlayer playerWithPlayerItem:playItem];
                [self.avPlayer setActionAtItemEnd:AVPlayerActionAtItemEndPause];
                AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
                playerLayer.frame = self.baseView.frame;
                playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                [self.baseView.layer addSublayer:playerLayer];
            }else {
                [self.avPlayer replaceCurrentItemWithPlayerItem:playItem];
            }
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(runLoopTheVideo:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
            if (self.autoPlay) {
                [self.avPlayer play];
            }
        });
    }];
}

- (void)createBaseView:(UIView *)view {
    if (!self.baseView) {
        self.baseView = [[UIView alloc]initWithFrame:view.bounds];
        [view addSubview:_baseView];
    }
}

- (void)runLoopTheVideo:(NSNotification *)noti{
    if (![[noti object] isEqual:self.avPlayer.currentItem]) {
        return;
    }
    if (self.loop) {
        AVPlayerItem *p = [noti object];
        [p seekToTime:kCMTimeZero];
        [self.avPlayer play];
    }else {
        
    }
}

//停止
- (void)stopPlay {
    [self.avPlayer pause];
    self.avPlayer = nil;
    videoId = 0;
    [self.baseView removeFromSuperview];
    self.baseView = nil;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reginActionNotifacion) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)becomActiveNotification {
    
}

- (void)reginActionNotifacion {
    if (self.avPlayer) {
        [self.avPlayer pause];
        time = self.avPlayer.currentTime;
    }
    
}

- (void)editValue:(CGFloat)time{
    
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(time, self.avPlayer.currentItem.duration.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
  

}

- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _playBtn;
}

@end
