//
//  MOPlaceholderView.m
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "MOPlaceholderView.h"

@interface MOPlaceholderView ()
@property (nonatomic, strong) UIButton *reloadButton;
@end

@implementation MOPlaceholderView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self createUI];
}

- (void)createUI {
    self.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self addSubview:self.reloadButton];
    self.state = MOPlaceholderNormalState;
}

- (void)setState:(MOPlaceholderState)state {
    _state = state;
    switch (_state) {
        case MOPlaceholderNormalState:
            self.hidden = YES;
            break;
        case MOPlaceholderLoadingState:
            self.hidden = NO;
            [_reloadButton setBackgroundImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
            [self.reloadButton setTitle:@"Loading..." forState: UIControlStateNormal];
            break;
        case MOPlaceholderNoNetworkState:
            self.hidden = NO;
            [_reloadButton setBackgroundImage:[UIImage imageNamed:@"mo_no_network"] forState:UIControlStateNormal];
            [self.reloadButton setTitle:@"网络不太好，点击重新加载" forState: UIControlStateNormal];
            break;
        case MOPlaceholderNoDataState:
            self.hidden = NO;
            [_reloadButton setBackgroundImage:[UIImage imageNamed:@"mo_no_data"] forState:UIControlStateNormal];
            [self.reloadButton setTitle:@"暂无数据，点击重新加载!" forState: UIControlStateNormal];
            break;
        default: break;
    }
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.frame = CGRectMake(0, 0, 150, 150);
        _reloadButton.center = self.center;
        _reloadButton.layer.cornerRadius = 75.0;
        [_reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_reloadButton setBackgroundImage:[UIImage imageNamed:@"mo_no_data"] forState:UIControlStateNormal];
        [self.reloadButton setTitle:@"暂无数据，点击重新加载!" forState: UIControlStateNormal];
        [_reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(200, -50, 0, -50)];
        [_reloadButton addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = _reloadButton.frame;
        rect.origin.y -= 50;
        _reloadButton.frame = rect;
    }
    return _reloadButton;
}

- (void)reloadClick:(UIButton *)button {
    if (self.reloadClickBlock) {
        self.reloadClickBlock();
    }
}

@end
