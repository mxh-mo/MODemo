//
//  NSMutableArray+Swizzling.m
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <objc/runtime.h>

#import "NSMutableArray+Swizzling.h"
#import "NSObject+Swizzling.h"

/*
 类      真身
 NSArray __NSArrayI
 NSMutableArray __NSArrayM
 NSDictionary __NSDictionaryI
 NSMutableDictionary __NSDictionaryM
 */

@implementation NSMutableArray (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // objc_getClass("__NSArrayM") 没有用 [self class] 处理，是因为运行时用了`类簇` 运行时正在的类是前者
//        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(addObject:) bySwizzledSelector:@selector(safeAddObject:)];
//        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(insertObject:atIndex:) bySwizzledSelector:@selector(safeInsertObject:atIndex:)];
//        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(objectAtIndex:) bySwizzledSelector:@selector(safeObjectAtIndex:)];
//        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(removeObjectAtIndex:) bySwizzledSelector:@selector(safeRemoveObjectAtIndex:)];
//        [objc_getClass("__NSArrayM") swapOriginSelector:@selector(removeObject:) bySwizzledSelector:@selector(safeRemoveObject:) ];
    });
}

- (void)safeAddObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s can add nil object into NSMutableArray", __FUNCTION__);
    } else {
        [self safeAddObject:obj];
    }
}

- (void)safeRemoveObject:(id)obj {
    if (obj == nil) {
        NSLog(@"%s call -removeObject:, but argument obj is nil", __FUNCTION__);
        return;
    }
    [self safeRemoveObject:obj];
}

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject == nil) {
        NSLog(@"%s can't insert nil into NSMutableArray", __FUNCTION__);
    } else if (index > self.count) {
        NSLog(@"%s index is invalid", __FUNCTION__);
    } else {
        [self safeInsertObject:anObject atIndex:index];
    }
}

- (id)safeObjectAtIndex:(NSUInteger)index {
    if (self.count == 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return nil;
    }
    if (index > self.count) {
        NSLog(@"%s index out of bounds in array", __FUNCTION__);
        return nil;
    }
    return [self safeObjectAtIndex:index];
}

- (void)safeRemoveObjectAtIndex:(NSUInteger)index {
    if (self.count <= 0) {
        NSLog(@"%s can't get any object from an empty array", __FUNCTION__);
        return;
    }
    if (index >= self.count) {
        NSLog(@"%s index out of bound", __FUNCTION__);
        return;
    }
    [self safeRemoveObjectAtIndex:index];
}

@end
