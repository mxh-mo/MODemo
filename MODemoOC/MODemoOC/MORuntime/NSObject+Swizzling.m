//
//  NSObject+Swizzling.m
//  04.Runtime
//
//  Created by MikiMo on 2020/2/23.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+Swizzling.h"

@implementation NSObject (Swizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    // 原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    // 新方法
    Method swizzledMetod = class_getInstanceMethod(class, swizzledSelector);
    // 尝试添加`origin`方法
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMetod),
                                        method_getTypeEncoding(swizzledMetod));
    if (didAddMethod) { // 之前没有实现`origin`方法
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMetod);
    }
}

@end
