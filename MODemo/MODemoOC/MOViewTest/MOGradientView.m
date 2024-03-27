//
//  MOGradientView.m
//  MODemo
//
//  Created by mikimo on 2024/3/26.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

#import "MOGradientView.h"

@interface MOGradientView ()

/// 渐变 view layer
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation MOGradientView

#pragma mark - Overriden Methods

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.gradientLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}

#pragma mark - Getter Methods

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

@end
