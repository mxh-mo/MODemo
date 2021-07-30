//
//  UIButton+Extension.m
//  08_label抗压缩
//
//  Created by MikiMo on 2018/4/11.
//  Copyright © 2018年 莫小言. All rights reserved.
//
// 思路：
// 1、创建UIButton分类，重写layoutSubviews方法；
// 2、绘制六边形路径，将绘制的六边形path赋值给新建的CAShapeLayer；
// 3、将新建的CAShapeLayer覆盖self.layer.mask。
// 4、重写hitTest方法：判断点击的point是否在六边形path内。
// 具体代码如下：

#import <objc/runtime.h>

#import "UIButton+Extension.h"

@interface UIButton ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation UIButton (Extension)

// 利用runtime为category生成setter和getter
- (void)setPath:(UIBezierPath *)path {
    objc_setAssociatedObject(self, @"path", path, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIBezierPath *)path {
    return objc_getAssociatedObject(self, @"path");
}

- (void)setDrawHexagon:(BOOL)drawHexagon {
    objc_setAssociatedObject(self, @"drawHexagon", @(drawHexagon), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)drawHexagon {
    NSNumber *num = objc_getAssociatedObject(self, @"drawHexagon");
    return num.boolValue;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //  NSLog(@"drawHexagon %i", self.drawHexagon);
    if (self.drawHexagon) {
        CGFloat width = self.frame.size.width;
        CGFloat longSide = width * 0.5 * cosf(M_PI * 30 / 180);
        CGFloat shortSide = width * 0.5 * sin(M_PI * 30 / 180);
        CGFloat k = width * 0.5 - longSide;     // 为了使个边相等
        
        // 绘制六边形曲线 6个点
        self.path = [UIBezierPath bezierPath];
        [self.path moveToPoint:CGPointMake(0, longSide  + k)];
        [self.path addLineToPoint:CGPointMake(shortSide, + k)];
        [self.path addLineToPoint:CGPointMake(shortSide + shortSide + shortSide,  k)];
        [self.path addLineToPoint:CGPointMake(width, longSide + k)];
        [self.path addLineToPoint:CGPointMake(shortSide * 3, longSide * 2 + k)];
        [self.path addLineToPoint:CGPointMake(shortSide, longSide * 2 + k)];
        [self.path closePath];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [self.path CGPath];
        self.layer.mask = maskLayer;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 判断点击的point 是否在六边形内
    if (self.drawHexagon) {
        if (CGPathContainsPoint(self.path.CGPath, NULL, point, NO)) {
            return [super hitTest:point withEvent:event];
        }
        return nil;
    } else {
        
        // 扩大点击范围
        CGFloat marginWidth = (44 - CGRectGetWidth(self.frame)) / 2.0;
        CGFloat marginHeight = (44 - CGRectGetHeight(self.frame)) / 2.0;
        CGRect rectExtent = CGRectMake( -marginWidth, -marginHeight, 44, 44);
        if (CGRectContainsPoint(rectExtent, point)) {
            return self;
        }
        
        return [super hitTest:point withEvent:event];
    }
}

@end
