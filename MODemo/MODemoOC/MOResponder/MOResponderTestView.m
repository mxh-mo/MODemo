//
//  MOResponderTestView.m
//  01.OCTest
//
//  Created by moxiaoyan on 2020/4/9.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "MOResponderTestView.h"

@interface MOView1 : UIView
@end

@implementation MOView1

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest: cyan view");
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"pointInside: cyan view");
    return [super pointInside:point withEvent:event];
}

@end

@interface MOView2 : UIView
@end

@implementation MOView2

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest: red view");
    return [super hitTest:point withEvent:event];
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"pointInside: red view");
    return [super pointInside:point withEvent:event];
}
@end

@interface MOView3 : UIView
@end

@implementation MOView3

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest: yellow view");
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"pointInside: yellow view");
    return [super pointInside:point withEvent:event];
}

@end

@interface MOView4 : UIView
@end

@implementation MOView4

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest: green view");
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"pointInside: green view");
    return [super pointInside:point withEvent:event];
}

@end

@implementation MOResponderTestView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        MOView1 *view1 = [[MOView1 alloc] initWithFrame:CGRectMake(20, 20, 160, 90)];
        view1.backgroundColor = [UIColor cyanColor];
        [self addSubview:view1];
        MOView2 *view2 = [[MOView2 alloc] initWithFrame:CGRectMake(30, 30, 70, 70)];
        view2.backgroundColor = [UIColor redColor];
        [view1 addSubview:view2];
        
        
        MOView3 *view3 = [[MOView3 alloc] initWithFrame:CGRectMake(20, 120, 60, 60)];
        view3.backgroundColor = [UIColor yellowColor];
        [self addSubview:view3];
        MOView4 *view4 = [[MOView4 alloc] initWithFrame:CGRectMake(100, 130, 100, 100)];
        view4.backgroundColor = [UIColor greenColor];
        [self addSubview:view4];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"hitTest: gray view");
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"pointInside: gray view");
    return [super pointInside:point withEvent:event];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//  NSLog(@"hitTest: view");
//  // 1、控件不允许与用户交互
//  if (self.userInteractionEnabled == NO ||
//      self.alpha <= 0.01 ||
//      self.hidden == YES) {
//    return nil;
//  }
//  // 2、点击的point不在当前控件内
//  if (![self pointInside:point withEvent:event]) {
//    return nil;
//  }
//  // 3、往后遍历每一个子控件
//  for (int i = (int)self.subviews.count - 1; i >= 0; i--) {
//    UIView *childView = self.subviews[i];
//    // 当前触控Point的坐标转换为相对于子控件的坐标
//    CGPoint childPoint = [self convertPoint:point toView:childView];
//    // 在子控件中找能响应的子控件(递归循环)，从上层找起
//    UIView *fitView = [childView hitTest:childPoint withEvent:event];
//    if (fitView) {
//      return fitView;
//    }
//  }
//  // 4、子视图中没有能响应的view，就返回自己
//  return self;
//}
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//  NSLog(@"pointInside: view");
//  return CGRectContainsPoint(self.bounds, point);
//}

@end
