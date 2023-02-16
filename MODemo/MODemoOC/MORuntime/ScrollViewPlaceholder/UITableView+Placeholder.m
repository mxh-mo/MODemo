//
//  UITableView+Placeholder.m
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <objc/runtime.h>

#import "UITableView+Placeholder.h"
#import "NSObject+Swizzling.h"

@implementation UITableView (Placeholder)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodSwizzlingWithOriginalSelector:@selector(reloadData)
                               bySwizzledSelector:@selector(mo_reloadData)];
    });
}

- (void)mo_reloadData {
    if (!self.placeholderView) {
        self.placeholderView = [[MOPlaceholderView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.placeholderView.state = self.state;
        __weak typeof(self) weakSelf = self;
        [self.placeholderView setReloadClickBlock:^{
            if (weakSelf.reloadBlock) {
                weakSelf.reloadBlock();
            }
        }];
        [self addSubview:self.placeholderView];
    } else {
        self.placeholderView.state = self.state;
    }
    [self mo_reloadData];
}

- (UIView *)placeholderView {
    return objc_getAssociatedObject(self, @selector(placeholderView));
}

- (void)setPlaceholderView:(UIView *)placeholderView {
    objc_setAssociatedObject(self, @selector(placeholderView), placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MOPlaceholderState)state {
    return [objc_getAssociatedObject(self, @selector(state)) integerValue];
}

- (void)setState:(MOPlaceholderState)state {
    if (self.placeholderView) {
        self.placeholderView.state = state;
    }
    objc_setAssociatedObject(self, @selector(state), @(state), OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)(void))reloadBlock {
    return objc_getAssociatedObject(self, @selector(reloadBlock));
}

- (void)setReloadBlock:(void (^)(void))reloadBlock {
    objc_setAssociatedObject(self, @selector(reloadBlock), reloadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
