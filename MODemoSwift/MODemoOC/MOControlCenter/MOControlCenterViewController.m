//
//  MOControlCenterViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "MOControlCenterViewController.h"

@interface MOControlCenterViewController ()
@property(nonatomic, strong) MPRemoteCommandCenter *commandCenter;
@property(nonatomic, strong) AVPlayer *avPlayer;
@property(nonatomic, strong) AVPlayerItem *avItem;
@end

@implementation MOControlCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //  btn.backgroundColor = [UIColor redColor];
    //  btn.frame = CGRectMake(100, 100, 100, 50);
    //  [btn setTitle:@"Play News" forState:UIControlStateNormal];
    //  [btn addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
    //  [self.view addSubview:btn];
    [self clickPlay];
}

/// 控制中心 控制播放音乐
- (void)clickPlay {
    [self showLockScreenInfo];
    MPNowPlayingInfoCenter *playingInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *playingInfoDict = [NSMutableDictionary dictionary];
    [playingInfoDict setObject:@"泡沫" forKey:MPMediaItemPropertyAlbumTitle];
    [playingInfoDict setObject:@"邓紫棋" forKey:MPMediaItemPropertyArtist];
    [playingInfoDict setObject:@"2000" forKey:MPMediaItemPropertyPlaybackDuration];
    [playingInfoDict setObject:@"1" forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [MPRemoteCommandCenter sharedCommandCenter].previousTrackCommand.enabled = YES;
    [MPRemoteCommandCenter sharedCommandCenter].changePlaybackPositionCommand.enabled = YES;
    [MPRemoteCommandCenter sharedCommandCenter].nextTrackCommand.enabled = YES;
    playingInfoCenter.nowPlayingInfo = playingInfoDict;
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"news" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:file];
    _avItem = [[AVPlayerItem alloc] initWithURL:url];
    [_avItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    _avPlayer = [[AVPlayer alloc] initWithPlayerItem:_avItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentAudioPlayFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:_avItem];
    [_avPlayer play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (_avPlayer.status) {
            case AVPlayerStatusFailed: {
                NSLog(@"ticpodDebug: play failed");
                //        [self currentAudioPlayFinished];
            } break;
            default: break;
        }
    }
}

- (void)showLockScreenInfo {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    if (!_commandCenter) {
        __weak typeof(self) weakSelf = self;
        MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
        _commandCenter = commandCenter;
        // 远程控制播放
        [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *_Nonnull event) {
            NSLog(@"moxiaoyan 远程控制播放");
            return MPRemoteCommandHandlerStatusSuccess;
        }];
        // 远程控制暂停
        [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *_Nonnull event) {
            NSLog(@"moxiaoyan 远程控制暂停");
            return MPRemoteCommandHandlerStatusSuccess;
        }];
    }
}

@end
