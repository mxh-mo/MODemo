//
//  MOCircleLoadingView.m
//  06_WaterRipple
//
//  Created by moxiaoyan on 2019/6/24.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

#import "MOCircleLoadingView.h"

@implementation MOCircleLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self circleLoading];
    }
    return self;
}

- (void)circleLoading {
    CGFloat lineWidth = 4.0;
    UIColor *originColor = [UIColor colorWithRed:15.0/255.0 green:197.0/255.0 blue:177.0/255.0 alpha:1];
    UIColor *middleColor = [UIColor colorWithRed:15.0/155.0 green:197.0/255.0 blue:177.0/255.0 alpha:0.5];
    
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
    circleLayer.lineWidth = lineWidth;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor blackColor].CGColor;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    circleLayer.path = circlePath.CGPath;
    
    CALayer *gradientLayer = [[CAShapeLayer alloc] init];
    
    // 渐变1
    CAGradientLayer *gradient1 = [[CAGradientLayer alloc] init];
    gradient1.frame = CGRectMake(-lineWidth*2, -lineWidth*2, self.bounds.size.width/2 + lineWidth*2, self.bounds.size.height + lineWidth*3);
    gradient1.colors = @[(__bridge id)originColor.CGColor, (__bridge id)middleColor.CGColor];
    gradient1.startPoint = CGPointMake(0, 0);
    gradient1.endPoint = CGPointMake(0, 1);
    gradient1.shadowPath = circlePath.CGPath;
    
    // 渐变2
    CAGradientLayer *gradient2 = [[CAGradientLayer alloc] init];
    gradient2.frame = CGRectMake(self.bounds.size.width/2, -lineWidth*2, self.bounds.size.width/2 + lineWidth*2, self.bounds.size.height+lineWidth*3);
    gradient2.colors = @[(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)middleColor.CGColor];
    gradient2.startPoint = CGPointMake(0, 0);
    gradient2.endPoint = CGPointMake(0, 1);
    gradient2.shadowPath = circlePath.CGPath;
    
    [gradientLayer addSublayer:gradient1];
    [gradientLayer addSublayer:gradient2];
    gradientLayer.mask = circleLayer;
    
    // CABasicAnimation strokeEnd动画
    CABasicAnimation *pathAnimation = [[CABasicAnimation alloc] init];
    pathAnimation.keyPath = @"strokeEnd";
    pathAnimation.duration = 1;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue = @(0);
    pathAnimation.toValue = @(1);
    pathAnimation.repeatCount = 1;
    [circleLayer addAnimation:pathAnimation forKey:@"strokeEndAnimationcircle"];
    
    // 旋转z
    CABasicAnimation *rotateAnimation = [[CABasicAnimation alloc] init];
    rotateAnimation.keyPath = @"transform.rotation.z";
    rotateAnimation.duration = 1.0;
    rotateAnimation.repeatCount = HUGE;
    rotateAnimation.fromValue = @(0);
    rotateAnimation.toValue = @(M_PI * 2);
    rotateAnimation.beginTime = CACurrentMediaTime() + 3.0 / 4.0;
    
    [gradientLayer addAnimation:rotateAnimation forKey:@"rotateAnimationcircle"];
    gradientLayer.frame = self.bounds;
    [self.layer addSublayer:gradientLayer];
}

@end
