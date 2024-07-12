//
//  QMTPlayerFakeSystemViewV2.m
//  QMTPluginKitiOS
//
//  Created by mikimo on 2024/7/9.
//  Copyright © 2024 Tencent Inc. All rights reserved.
//

#import "QMTPlayerFakeSystemViewV2.h"

static NSTimeInterval const QMTPlayerFakeSystemViewInDuration = 0.5;

static CGFloat const QMTPlayerFakeSystemProgress1 = 0.33;
static CGFloat const QMTPlayerFakeSystemProgress2 = 0.66;

static CGFloat const QMTPlayerFakeSystemCapsuleVieFullWidth = 202;
static CGFloat const QMTPlayerFakeSystemCapsuleVieSmallWidth = 150.0;
static CGFloat const QMTPlayerFakeSystemCapsuleViewFullMaxHeight = 40.0;
static CGFloat const QMTPlayerFakeSystemCapsuleViewSmallMaxHeight = 28.0;
static CGFloat const QMTPlayerFakeSystemCapsuleViewMinHeight = 6.0;

@interface QMTPlayerFakeSystemViewV2()

/// 当前视图类型
@property (nonatomic, assign) QMTPlayerFakeSystemViewType type;

/// 当前进度
@property (nonatomic, assign) CGFloat progress;

/// 是小屏，否则全屏
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

/// 是最大状态，否则缩小态
@property (nonatomic, assign, getter=isMaxStyle) BOOL maxStyle;

/// 渐变背景
@property (nonatomic, strong) CAGradientLayer *gardientLayer;

/// 胶囊条视图
@property (nonatomic, strong) UIView *capsuleView;

/// 胶囊高斯模糊
@property (nonatomic, strong) UIVisualEffectView *capsuleEffectView;

/// 进图条视图
@property (nonatomic, strong) UIView *progressView;

/// 图标
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation QMTPlayerFakeSystemViewV2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.gardientLayer];
        [self addSubview:self.capsuleView];
        [self.capsuleView addSubview:self.capsuleEffectView];
        [self.capsuleView addSubview:self.progressView];
        [self.capsuleView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gardientLayer.frame = self.bounds;
    
    UIView *capsuleView = self.capsuleView;
    UIView *capsuleEffectView = self.capsuleEffectView;
    UIView *progressView = self.progressView;
    UIView *imageView = self.imageView;

    CGSize capsuleSize = CGSizeMake([self capsuleViewWidth], [self capsuleViewHeight]);
            
    CGFloat originX = (CGRectGetWidth(self.bounds) - capsuleSize.width) / 2.0;
    CGFloat radius = capsuleSize.height / 2.0;
    capsuleView.frame = CGRectMake(originX, 16.0, capsuleSize.width, capsuleSize.height);
    capsuleView.layer.cornerRadius = radius;
    capsuleEffectView.frame = capsuleView.bounds;
    
    CGFloat progressWidth = self.progress * capsuleSize.width;
    progressView.frame = CGRectMake(0.0, 0.0, progressWidth, capsuleSize.height);

    UIRectCorner corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:progressView.bounds
                                               byRoundingCorners:corner
                                                     cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc] init];
    masklayer.frame = progressView.bounds;
    masklayer.path = path.CGPath;
    progressView.layer.mask = masklayer;
    
    CGFloat imageViewOriginX = self.isFullScreen ? 16.0 : 12.0;
    CGFloat imageViewSize = self.isFullScreen ? 24.0 : 16.0;
    CGFloat imageViewOriginY = (capsuleSize.height - imageViewSize) / 2.0;
    imageView.frame = CGRectMake(imageViewOriginX, imageViewOriginY, imageViewSize, imageViewSize);
}

/// 展示视图
/// - Parameters:
///   - type: 音量 or 亮度
///   - progress: 进度
///   - fullScreen: 全屏 or 小屏
///   - maxStyle: 最大态 or 缩小态
- (void)displayWithType:(QMTPlayerFakeSystemViewType)type
               progress:(CGFloat)progress
             fullScreen:(BOOL)fullScreen
               maxStyle:(BOOL)maxStyle {
    self.type = type;
    self.progress = progress;
    self.fullScreen = fullScreen;
    self.maxStyle = maxStyle;
    if (self.isMaxStyle) {
        self.imageView.hidden = NO;
        NSString *imageName = [self.class imageNameWithType:type progress:progress];
        self.imageView.image = [UIImage imageNamed:imageName];
    } else {
        self.imageView.hidden = YES;
    }
    self.hidden = NO;
    [UIView animateWithDuration:QMTPlayerFakeSystemViewInDuration
                     animations:^{
        // TODO: mikimo 消失动画 + 缩小动画
        [self setNeedsLayout];
    }];
}

/// 消失视图
/// - Parameter complete: 消失完成回调
- (void)dismissWithComplete:(void(^)(void))complete {
    [UIView animateWithDuration:QMTPlayerFakeSystemViewInDuration
                     animations:^{
        // TODO: mikimo 消失动画
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (complete) {
            complete();
        }
    }];
}

#pragma mark - Getter Methods

- (CGFloat)capsuleViewWidth {
    if (self.isFullScreen) {
        return QMTPlayerFakeSystemCapsuleVieFullWidth;
    }
    return QMTPlayerFakeSystemCapsuleVieSmallWidth;
}

- (CGFloat)capsuleViewHeight {
    if (!self.isMaxStyle) {
        return QMTPlayerFakeSystemCapsuleViewMinHeight;
    }
    if (self.isFullScreen) {
        return QMTPlayerFakeSystemCapsuleViewFullMaxHeight;
    }
    return QMTPlayerFakeSystemCapsuleViewSmallMaxHeight;
}

- (CAGradientLayer *)gardientLayer {
    if (!_gardientLayer) {
        CAGradientLayer *gardientLayer = [CAGradientLayer layer];
        gardientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor,
                                 (__bridge id)[UIColor clearColor].CGColor];
        gardientLayer.startPoint = CGPointMake(0, 0);
        gardientLayer.endPoint = CGPointMake(0, 1);
        _gardientLayer = gardientLayer;
    }
    return _gardientLayer;
}

- (UIView *)capsuleView {
    if (!_capsuleView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        view.layer.masksToBounds = YES;
        [view addSubview:self.capsuleEffectView];
        _capsuleView = view;
    }
    return _capsuleView;
}

- (UIVisualEffectView *)capsuleEffectView {
    if (!_capsuleEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.alpha = 0.5;
        _capsuleEffectView = effectView;
    }
    return _capsuleEffectView;
}

- (UIView *)progressView {
    if (!_progressView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        _progressView = view;
    }
    return _progressView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView = view;
    }
    return _imageView;
}

#pragma mark - Helper Methods

+ (NSString *)imageNameWithType:(QMTPlayerFakeSystemViewType)type
                       progress:(CGFloat)progress {
    NSString *imageName = @"";
    if (type == QMTPlayerFakeSystemViewType_Volume) {
        if (progress == 0.0) {
//        if (QLFloatIsEqual(progress, 0.0)) {
            imageName = @"qmt_player_fake_sys_volume0";
        } else if (progress <= QMTPlayerFakeSystemProgress1) {
            imageName = @"qmt_player_fake_sys_volume1";
        } else if (progress <= QMTPlayerFakeSystemProgress2) {
            imageName = @"qmt_player_fake_sys_volume2";
        } else {
            imageName = @"qmt_player_fake_sys_volume3";
        }
    } else {
        if (progress <= QMTPlayerFakeSystemProgress1) {
            imageName = @"qmt_player_fake_sys_brightness1";
        } else if (progress <= QMTPlayerFakeSystemProgress2) {
            imageName = @"qmt_player_fake_sys_brightness2";
        } else {
            imageName = @"qmt_player_fake_sys_brightness3";
        }
    }
    return imageName;
}

@end
