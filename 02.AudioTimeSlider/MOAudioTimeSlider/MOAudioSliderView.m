//
//  MOAudioSliderView.m
//  07.AudioTimeSlider
//
//  Created by moxiaoyan on 2020/6/3.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "MOAudioSliderView.h"
#import <AVFoundation/AVFoundation.h>
#import "MOTimeTableView.h"
#import "MOWaveTableView.h"
#define kLeftSpacing ([UIScreen mainScreen].bounds.size.width/2 - 60)
NSInteger const cellHeight = 120;
NSInteger const kAudioPlayerLineSpacing = 4;

@interface MOAudioSliderView()<MOTableViewDelegate>

@property (nonatomic, strong) NSArray *points;
@property (nonatomic, strong) NSURL *playURL;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) MOTimeTableView *timeView; // 时间刻度View
@property (nonatomic, strong) MOWaveTableView *waveView; // 音量Lines View
@property (nonatomic, strong) UIImageView *pointerImgV;  // 中间指针
@property (nonatomic, strong) NSMutableArray *pointArrays; // [每30秒points]数组

@end

@implementation MOAudioSliderView

- (void)dealloc {
    [_player removeTimeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame playUrl:(NSURL *)playUrl points:(NSArray *)points {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        self.playURL = playUrl;
        self.points = points;
    }
    return self;
}

- (void)setupView {
    self.timeView = [[MOTimeTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.timeView.frame = CGRectMake(0, 0, self.frame.size.width, 20);
    [self addSubview:self.timeView];
    
    self.waveView = [[MOWaveTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.waveView.frame = CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 20);
    self.waveView.scrollDelegate = self;
    [self addSubview:self.waveView];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"transcript_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"transcript_pause"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(playBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.frame = CGRectMake(10, 30, 44, 44);
    [self addSubview:self.playBtn];
    
    self.pointerImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"transcript_pointer"]];
    self.pointerImgV.frame = CGRectMake(kLeftSpacing + 34, 10, 16, self.frame.size.height - 10);
    [self addSubview:self.pointerImgV];
    CGFloat rightSpace = self.frame.size.width - CGRectGetMidX(self.pointerImgV.frame);
    self.timeView.rightSpace = rightSpace;
    self.waveView.rightSpace = rightSpace;
}

// 因为时间刻度显示问题，为了把label放在中间，所以第一个section左边空出了10s，每个section画30s的数据
// 刻度的每个间隔是2s，也就是需要可以画2条线（kAudioPlayerLineSpacing:每条线的间距；每个刻度的就*2）
- (void)setPoints:(NSArray *)points {
    _points = points;
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:_points];
    self.pointArrays = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    while (tempArray.count > 0) {
        if (index == 0) {
            if (tempArray.count >= 20) { // section0 数据
                [self.pointArrays addObject:[tempArray subarrayWithRange:NSMakeRange(0, 20)]];
                [tempArray removeObjectsInRange:NSMakeRange(0, 20)];
            }
        } else {
            if (tempArray.count >= 30) {
                [self.pointArrays addObject:[tempArray subarrayWithRange:NSMakeRange(0, 30)]];
                [tempArray removeObjectsInRange:NSMakeRange(0, 30)];
            } else {
                [self.pointArrays addObject:[tempArray copy]];
                [tempArray removeAllObjects];
            }
        }
        index++;
    }
    self.timeView.points = self.pointArrays;
    self.waveView.points = self.pointArrays;
}

- (void)playBtnAction {
    self.playBtn.selected = !self.playBtn.isSelected;
    if (self.playBtn.isSelected) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] initWithURL:self.playURL];
        __weak typeof(self) weakSelf = self;
        [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float currentTime = weakSelf.player.currentTime.value / weakSelf.player.currentTime.timescale;
            [weakSelf.waveView setContentOffset:CGPointMake(0, currentTime * kAudioPlayerLineSpacing)];
        }];
    }
    return _player;
}

#pragma mark - 收到播放结束通知

- (void)didPlayToEnd {
    self.playBtn.selected = NO;
}

#pragma mark - MOTableViewDelegate

- (void)contentOffsetY:(CGFloat)y {
    // 让时间刻度View跟谁波形View滑动(保持一致的偏移)
    [self.timeView setContentOffset:CGPointMake(0, y) animated:NO];
}

- (void)willBeginDragging {
    // 滑动时必须暂停Player，否则 PeriodicTimeObserver 回调里的操作会跟滑动冲突
    [self.player pause];
}

- (void)didEndDraggingY:(CGFloat)y {
    // 拖拽结束后，根据偏移计算时间，设置播放进度
    CGFloat second = y / kAudioPlayerLineSpacing;
    [self.player seekToTime:CMTimeMakeWithSeconds(second, NSEC_PER_SEC)];
    if (self.playBtn.selected) { // 如果是播放状态则开始播放
        [self.player play];
    }
}

@end
