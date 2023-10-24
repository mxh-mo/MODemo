//
//  UIViewController+Swizzling.m
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import "NSObject+Swizzling.h"

@implementation UIViewController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swapOriginSelector:@selector(viewWillDisappear:) byTargetSelector:@selector(mo_viewWillDisappear:)];
    });
}

- (void)mo_viewWillDisappear:(BOOL)animated {
    [self mo_viewWillDisappear:animated];
    // [SVProgressHUD dismiss];
    // 添加埋点等
}

@end
