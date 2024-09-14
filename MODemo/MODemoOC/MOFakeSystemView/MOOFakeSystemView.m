//
//  MOOFakeSystemView.m
//  MODemo
//
//  Created by mikimo on 2024/7/9.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

#import "MOOFakeSystemView.h"

static NSTimeInterval const MOOFakeSystemViewSmallDuration = 0.4;
static NSTimeInterval const MOOFakeSystemViewIconDuration = 0.2;
static NSTimeInterval const MOOFakeSystemViewInOutDuration = 0.3;

static CGFloat const MOOFakeSystemProgress1 = 0.33;
static CGFloat const MOOFakeSystemProgress2 = 0.66;

static CGFloat const MOOFakeSystemCapsuleVieFullWidth = 202;
static CGFloat const MOOFakeSystemCapsuleVieSmallWidth = 150.0;
static CGFloat const MOOFakeSystemCapsuleViewFullMaxHeight = 40.0;
static CGFloat const MOOFakeSystemCapsuleViewSmallMaxHeight = 28.0;
static CGFloat const MOOFakeSystemCapsuleViewMinHeight = 6.0;

typedef NS_ENUM(NSUInteger, MOOFakeSystemViewState) {
    MOOFakeSystemViewStateDismiss,            // 消失
    MOOFakeSystemViewStateHoldMaxStyle,       // 需要保持最大态
    MOOFakeSystemViewStateMaxStyle,           // 最大态
    MOOFakeSystemViewStateMinAnimation,       // 缩小动画中
    MOOFakeSystemViewStateMinStyle,           // 缩小态
    MOOFakeSystemViewStateDismissAnimation,   // 消失动画中
};

@interface MOOFakeSystemView()

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

/// 所有图标 <imageName, UIImage>
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIImage *> *imageDict;

/// 当前视图类型
@property (nonatomic, assign) MOOFakeSystemViewType type;

/// 当前进度
@property (nonatomic, assign) CGFloat progress;

/// 视图当前状态
@property (nonatomic, assign) MOOFakeSystemViewState state;

/// dismiss 动画来事件时，需要将状态回退到上一个
@property (nonatomic, assign) MOOFakeSystemViewState preState;

@end

@implementation MOOFakeSystemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _state = MOOFakeSystemViewStateHoldMaxStyle;
        _imageDict = [NSMutableDictionary dictionaryWithCapacity:7];
        self.userInteractionEnabled = NO;
        [self.layer addSublayer:self.gardientLayer];
        [self addSubview:self.capsuleView];
        [self.capsuleView addSubview:self.capsuleEffectView];
        [self.capsuleView addSubview:self.progressView];
        [self.capsuleView addSubview:self.imageView];
    }
    return self;
}

- (void)setHiddenGradientBackground:(BOOL)hiddenGradientBackground {
    _hiddenGradientBackground = hiddenGradientBackground;
    self.gardientLayer.hidden = _hiddenGradientBackground;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.gardientLayer.frame = self.bounds;
    [self updateSubViewLayout];
}

- (void)updateSubViewLayout {
    CGSize capsuleSize = CGSizeMake([self capsuleViewWidth], [self capsuleViewHeight]);
    CGFloat originX = (CGRectGetWidth(self.bounds) - capsuleSize.width) / 2.0;
    self.capsuleView.frame = CGRectMake(originX, 16.0 + self.topSafeMargin, capsuleSize.width, capsuleSize.height);
    self.capsuleView.layer.cornerRadius = capsuleSize.height / 2.0;
    self.capsuleEffectView.frame = self.capsuleView.bounds;
    
    CGFloat progressWidth = self.progress * capsuleSize.width;
    self.progressView.frame = CGRectMake(0.0, 0.0, progressWidth, capsuleSize.height);
    
    CGFloat imageViewOriginX = self.isFullScreen ? 16.0 : 8.0;
    CGFloat imageViewSize = self.isFullScreen ? 32.0 : 20.0;
    CGFloat imageViewOriginY = ([self capsuleViewHeight] - imageViewSize) / 2.0;
    self.imageView.frame = CGRectMake(imageViewOriginX, imageViewOriginY, imageViewSize, imageViewSize);
}

/// 展示视图
- (void)displayWithType:(MOOFakeSystemViewType)type
               progress:(CGFloat)progress
                isFirst:(BOOL)isFirst {
    void (^updateData)(void) = ^void () {
        self.progress = progress;
        self.type = type;
        self.imageView.image = [self currentImage];
        if (self.state != MOOFakeSystemViewStateMinAnimation) {
            BOOL isMaxStyle = self.state == MOOFakeSystemViewStateHoldMaxStyle || self.state == MOOFakeSystemViewStateMaxStyle;
            self.imageView.alpha = isMaxStyle ? 1.0 : 0.0;
        }
    };
    if (isFirst || self.type != type) { /// 1、展示 maxStyle
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(releaseMaxStyle) object:nil];
        [self performSelector:@selector(releaseMaxStyle) withObject:nil afterDelay:0.5]; /// max style 至少保持 0.5s
        self.state = MOOFakeSystemViewStateHoldMaxStyle;
        updateData();
        [self updateSubViewLayout];
        [self setNeedsLayout];
        self.imageView.alpha = 1.0;
    } else if (self.state == MOOFakeSystemViewStateMaxStyle) {  /// 2. 处于 maxStyle && 不需要保持：开始缩小动画
        self.state = MOOFakeSystemViewStateMinAnimation;
        updateData();
        [self startSmallAnimation];
    } else { /// 3、需要保持 maxStyle 或 处于minStyle：直接改进度
        updateData();
        CGSize capsuleSize = CGSizeMake([self capsuleViewWidth], [self capsuleViewHeight]);
        CGFloat progressWidth = self.progress * capsuleSize.width;
        self.progressView.frame = CGRectMake(0.0, 0.0, progressWidth, capsuleSize.height);
    }
    if (self.alpha < 1.0) { /// 兼容消失时收到事件
        if (self.state == MOOFakeSystemViewStateDismissAnimation) {
            self.state = self.preState;
        }
        [UIView animateWithDuration:MOOFakeSystemViewInOutDuration
                         animations:^{
            self.alpha = 1;
        } completion:nil];
    }
}

/// 消失视图
/// - Parameter complete: 消失完成回调
- (void)dismissWithComplete:(void(^)(void))complete {
    self.preState = self.state;
    self.state = MOOFakeSystemViewStateDismissAnimation;
    [UIView animateWithDuration:MOOFakeSystemViewInOutDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        if (self.state != MOOFakeSystemViewStateDismissAnimation) {
            return;
        }
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.state != MOOFakeSystemViewStateDismissAnimation) {
            return;
        }
        self.state = MOOFakeSystemViewStateDismiss;
        if (complete) {
            complete();
        }
    }];
}

#pragma mark - Private Methods

- (void)releaseMaxStyle {
    self.state = MOOFakeSystemViewStateMaxStyle;
}

- (void)startSmallAnimation {
    [UIView animateWithDuration:MOOFakeSystemViewIconDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.imageView.alpha = 0.0;
    } completion:nil];
    [UIView animateWithDuration:MOOFakeSystemViewSmallDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.alpha = 1;
        [self updateSubViewLayout];
        [self setNeedsLayout];
    } completion:^(BOOL finished) {
        self.state = MOOFakeSystemViewStateMinStyle;
    }];
}

#pragma mark - Getter Methods

- (CGFloat)capsuleViewWidth {
    if (self.isFullScreen) {
        return MOOFakeSystemCapsuleVieFullWidth;
    }
    return MOOFakeSystemCapsuleVieSmallWidth;
}

- (CGFloat)capsuleViewHeight {
    BOOL maxStyle = self.state == MOOFakeSystemViewStateHoldMaxStyle ||
                    self.state == MOOFakeSystemViewStateMaxStyle;
    if (!maxStyle) {
        return MOOFakeSystemCapsuleViewMinHeight;
    }
    if (self.isFullScreen) {
        return MOOFakeSystemCapsuleViewFullMaxHeight;
    }
    return MOOFakeSystemCapsuleViewSmallMaxHeight;
}

- (UIImage *)currentImage {
    NSString *imageName = [self.class imageNameWithType:self.type progress:self.progress];
    UIImage *image = self.imageDict[imageName];
    if (!image) {
        image = [UIImage imageNamed:imageName];
        [self.imageDict setValue:image forKey:imageName];
    }
    return image;
}

- (CAGradientLayer *)gardientLayer {
    if (!_gardientLayer) {
        CAGradientLayer *gardientLayer = [CAGradientLayer layer];
        gardientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor,
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

+ (NSString *)imageNameWithType:(MOOFakeSystemViewType)type
                       progress:(CGFloat)progress {
    NSString *imageName = @"";
    if (type == MOOFakeSystemViewTypeVolume) {
        if (progress < DBL_EPSILON) {
            imageName = @"moo_fake_sys_volume0";
        } else if (progress <= MOOFakeSystemProgress1) {
            imageName = @"moo_fake_sys_volume1";
        } else if (progress <= MOOFakeSystemProgress2) {
            imageName = @"moo_fake_sys_volume2";
        } else {
            imageName = @"moo_fake_sys_volume3";
        }
    } else {
        if (progress <= MOOFakeSystemProgress1) {
            imageName = @"moo_fake_sys_brightness1";
        } else if (progress <= MOOFakeSystemProgress2) {
            imageName = @"moo_fake_sys_brightness2";
        } else {
            imageName = @"moo_fake_sys_brightness3";
        }
    }
    return imageName;
}

@end
