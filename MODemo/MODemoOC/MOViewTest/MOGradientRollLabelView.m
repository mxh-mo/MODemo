//
//  MOGradientRollLabelView.m
//  MODemo
//
//  Created by mikimo on 2023/11/2.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "MOGradientRollLabelView.h"
#import <YYCategories/UIView+YYAdd.h>

static CGSize const QNBUALiveMatchStateResourceButtonSize = {56.0, 24.0};
static CGFloat const QNBUALiveMatchStateContentLabelHorMargin = 8.0;

@interface QNBUALiveMatchStateContentView : UIView

/// time of this match state
@property (nonatomic, strong) UILabel *timeLabel;

/// content of this match state
@property (nonatomic, strong) UILabel *contentLabel;

/// resource of thie match state (eg: image/video)
@property (nonatomic, strong) UIButton *resourceButton;

@end

@implementation QNBUALiveMatchStateContentView

#pragma mark - Override Methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UILabel *timeLabel = self.timeLabel;
    UIButton *resourceButton = self.resourceButton;
    UILabel *contentLabel = self.contentLabel;
    
    [timeLabel sizeToFit];
    timeLabel.left = 0.0;
    timeLabel.centerY = CGRectGetMidY(self.bounds);
    
    resourceButton.size = QNBUALiveMatchStateResourceButtonSize;
    resourceButton.right = CGRectGetWidth(self.bounds);
    resourceButton.centerY = CGRectGetMidY(self.bounds);
    
    [contentLabel sizeToFit];
    contentLabel.left = CGRectGetMaxX(timeLabel.frame) + QNBUALiveMatchStateContentLabelHorMargin;
    CGFloat contentHorMargin = 2.0 * QNBUALiveMatchStateContentLabelHorMargin;
    contentLabel.width = CGRectGetMinX(resourceButton.frame) - CGRectGetMaxX(timeLabel.frame) - contentHorMargin;
    contentLabel.centerY = CGRectGetMidY(self.bounds);
}

#pragma mark - Private Methods

- (void)setupViews {
    [self addSubview:self.timeLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.resourceButton];
    
    // TODO: del
    self.timeLabel.text = @"11:58";
    self.contentLabel.text = @"孙杨暂位第一，正在向金牌冲刺。孙杨暂位第一，正在向金牌冲刺";
    [self.resourceButton setTitle:@"图片" forState:UIControlStateNormal];
}

#pragma mark - Getter Methods

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
        label.textColor = [UIColor whiteColor];
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.0];
        label.textColor = [UIColor whiteColor];
        _contentLabel = label;
    }
    return _contentLabel;
}

- (UIButton *)resourceButton {
    if (!_resourceButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.0];
        [button setImage:[UIImage imageNamed:@"live_match_state_resource"] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = QNBUALiveMatchStateResourceButtonSize.height / 2.0;
        _resourceButton = button;
    }
    return _resourceButton;
}

@end

static CGFloat const QNBUALiveMatchStateContentLeftMargin = 12.0;
static CGFloat const QNBUALiveMatchStateContentHeight = 22.0;

static NSTimeInterval const QNBUALiveMatchStateAnimationDuration = 2;//0.25;

@interface MOGradientRollLabelView ()

@property (nonatomic, strong) CAGradientLayer *contentLayer;
@property (nonatomic, strong) QNBUALiveMatchStateContentView *contentView;
@property (nonatomic, strong) CAGradientLayer *animationLayer;
@property (nonatomic, strong) QNBUALiveMatchStateContentView *animationView;

@end

@implementation MOGradientRollLabelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
        [self addSubview:self.contentView];
        [self addSubview:self.animationView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startAnimation)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIView *contentView = self.contentView;
    UIView *animationView = self.animationView;

    contentView.left = QNBUALiveMatchStateContentLeftMargin;
    contentView.height = QNBUALiveMatchStateContentHeight;
    contentView.width = CGRectGetWidth(self.bounds) - 2.0 * QNBUALiveMatchStateContentLeftMargin;
    contentView.centerY = CGRectGetMidY(self.bounds);
    
    animationView.frame = contentView.frame;
    animationView.top = CGRectGetMaxY(contentView.frame) + 2.0;
}

- (void)startAnimation {
    QNBUALiveMatchStateContentView *contentView = self.contentView;
    QNBUALiveMatchStateContentView *animationView = self.animationView;
    animationView.hidden = NO;

//    CABasicAnimation *gradientAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
//    gradientAnimation.fromValue = @[@0.0, @0.0];
//    gradientAnimation.toValue = @[@0.0, @1.0];
//    gradientAnimation.duration = QNBUALiveMatchStateAnimationDuration;
//    gradientAnimation.repeatCount = 1;
//    [self.contentLayer addAnimation:gradientAnimation forKey:nil];
    
    [UIView animateWithDuration:QNBUALiveMatchStateAnimationDuration animations:^{
        animationView.centerY = CGRectGetMidY(self.bounds);
        contentView.bottom = 0.0;
//        self.contentLayer.locations = @[@0, @1];
//        self.animationLayer.locations = @[@0, @1];
    } completion:^(BOOL finished) {
        self.contentView = animationView;
        self.animationView = contentView;
        self.animationView.hidden = YES;
//        self.contentLayer.locations = @[@0, @0];
//        self.animationLayer.locations = @[@0, @0];
        [self setNeedsLayout];
    }];
}

- (QNBUALiveMatchStateContentView *)contentView {
    if (!_contentView) {
        QNBUALiveMatchStateContentView *view = [[QNBUALiveMatchStateContentView alloc] initWithFrame:CGRectZero];
        [view.layer addSublayer:self.contentLayer];
        _contentView = view;
    }
    return _contentView;
}

- (CAGradientLayer *)contentLayer {
    if (!_contentLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0.0, 1.0);
        layer.endPoint = CGPointMake(0.0, 0.0);
        layer.colors = @[(__bridge id)[[UIColor clearColor] colorWithAlphaComponent:0].CGColor,
                         (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor];
        layer.locations = @[@0, @0];
        _contentLayer = layer;
    }
    return _contentLayer;
}

- (QNBUALiveMatchStateContentView *)animationView {
    if (!_animationView) {
        QNBUALiveMatchStateContentView *view = [[QNBUALiveMatchStateContentView alloc] initWithFrame:CGRectZero];
        [view.layer addSublayer:self.animationLayer];
        view.hidden = YES;
        _animationView = view;
    }
    return _animationView;
}

- (CAGradientLayer *)animationLayer {
    if (!_animationLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.startPoint = CGPointMake(0.0, 1.0);
        layer.endPoint = CGPointMake(0.0, 0.0);
        layer.colors = @[(__bridge id)[[UIColor clearColor] colorWithAlphaComponent:0].CGColor,
                         (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor];
        layer.locations = @[@0, @0];
        _animationLayer = layer;
    }
    return _animationLayer;
}

@end
