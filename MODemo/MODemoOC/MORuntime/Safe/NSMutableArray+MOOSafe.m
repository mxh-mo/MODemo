//
//  NSMutableArray+MOOSafe.m
//  MODemo
//
//  Created by mikimo on 2023/10/24.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "NSMutableArray+MOOSafe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSMutableArray (MOOSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(addObject:)
                                       byTargetSelector:@selector(safe_addObject:)];
        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(insertObject:atIndex:)
                                       byTargetSelector:@selector(safe_insertObject:atIndex:)];
        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(removeObjectAtIndex:)
                                       byTargetSelector:@selector(safe_removeObjectAtIndex:)];
        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(replaceObjectAtIndex:withObject:)
                                       byTargetSelector:@selector(safe_replaceObjectAtIndex:withObject:)];
    });
}

- (void)safe_addObject:(id)anObject {
    if (!anObject) {
        NSLog(@"%s, object cannot be nil", __FUNCTION__);
        return;
    }
    [self safe_addObject:anObject];
}

- (void)safe_insertObject:(id)anObject 
                  atIndex:(NSUInteger)index {
    if (!anObject) {
        NSLog(@"%s, object cannot be nil", __FUNCTION__);
        return;
    }
    if (index > self.count) {
        NSLog(@"%s, index %@ beyond bounds", __FUNCTION__, @(index));
        return;
    }
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        NSLog(@"%s, index %@ beyond bounds", __FUNCTION__, @(index));
        return;
    }
    [self safe_removeObjectAtIndex:index];
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index 
                       withObject:(id)anObject {
    if (!anObject) {
        NSLog(@"%s, object cannot be nil", __FUNCTION__);
        return;
    }
    if (index >= self.count) {
        NSLog(@"%s, index %@ beyond bounds", __FUNCTION__, @(index));
        return;
    }
    [self safe_replaceObjectAtIndex:index withObject:anObject];
}

@end
