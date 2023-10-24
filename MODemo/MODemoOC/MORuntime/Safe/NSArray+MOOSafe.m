//
//  NSArray+MOOSafe.m
//  MODemo
//
//  Created by mikimo on 2023/10/24.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "NSArray+MOOSafe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSArray (MOOSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArray0") swapOriginSelector:@selector(objectAtIndex:)
                                       byTargetSelector:@selector(safe_objectAtIndex:)];
    });
}

- (id)safe_objectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSLog(@"%s, index %@ beyond bounds for empty array", __FUNCTION__, @(index));
        return nil;
    }
    if (index >= self.count) {
        NSLog(@"%s, index %@ beyond bounds", __FUNCTION__, @(index));
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

@end
