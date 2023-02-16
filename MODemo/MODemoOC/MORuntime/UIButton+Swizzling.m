//
//  UIButton+Swizzling.m
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <objc/runtime.h>

#import "UIButton+Swizzling.h"
#import "NSObject+Swizzling.h"
#define defaultInterval 1 // 默认时间间隔

@implementation UIButton (Swizzling)

+ (void)load {
    //  static dispatch_once_t onceToken;
    //  dispatch_once(&onceToken, ^{
    //    [self methodSwizzlingWithOriginalSelector:@selector(sendAction:to:forEvent:) bySwizzledSelector:@selector(mo_SendAction:to:forEvent:)];
    //  });
}

// 当按钮点击事件 sendAction 时将会执行 mo_SendAction
- (void)mo_SendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.isIgnore) { // 不需要被hook
        [self mo_SendAction:action to:target forEvent:event];
        return;
    }
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        if (self.isIgnoreEvent) {
            return;
        } else {
            self.timeInterval = self.timeInterval == 0 ? defaultInterval : self.timeInterval; // 是否自定义，否则用默认值
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
    }
    // 此处 methodA 和 methodB方法IMP互换了，实际上执行 sendAction；所以不会死循环
    self.isIgnoreEvent = YES;
    [self mo_SendAction:action to:target forEvent:event]; // 执行系统的原有方法
}

- (void)resetState {
    [self setIsIgnoreEvent:NO];
}

- (BOOL)isIgnore {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsIgnore:(BOOL)isIgnore {
    objc_setAssociatedObject(self, @selector(isIgnore), @(isIgnore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
