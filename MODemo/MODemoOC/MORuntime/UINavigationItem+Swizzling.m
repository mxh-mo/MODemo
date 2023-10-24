//
//  UINavigationItem+Swizzling.m
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <objc/runtime.h>

#import "UINavigationItem+Swizzling.h"
#import "NSObject+Swizzling.h"

static char *kCustomBackButtonKey;

@implementation UINavigationItem (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swapOriginSelector:@selector(backBarButtonItem)
                               byTargetSelector:@selector(sure_backBarButtonItem)];
    });
}

- (UIBarButtonItem *)sure_backBarButtonItem {
    UIBarButtonItem *backItem = [self sure_backBarButtonItem];
    if (backItem) {
        return backItem;
    }
    backItem = objc_getAssociatedObject(self, &kCustomBackButtonKey);
    if (!backItem) {
        backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
        objc_setAssociatedObject(self, &kCustomBackButtonKey, backItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return backItem;
}

@end
