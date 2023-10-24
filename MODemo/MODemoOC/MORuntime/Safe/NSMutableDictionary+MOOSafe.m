//
//  NSMutableDictionary+MOOSafe.m
//  MODemo
//
//  Created by mikimo on 2023/10/24.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "NSMutableDictionary+MOOSafe.h"
#import <objc/runtime.h>
#import "NSObject+Swizzling.h"

@implementation NSMutableDictionary (MOOSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSDictionaryM") swapOriginSelector:@selector(setObject:forKey:)
                                            byTargetSelector:@selector(safe_setObject:forKey:)];
        [objc_getClass("__NSDictionaryM") swapOriginSelector:@selector(removeObjectForKey:)
                                            byTargetSelector:@selector(safe_removeObjectForKey:)];
    });
}

- (void)safe_setObject:(id)anObject 
                forKey:(id<NSCopying>)aKey {
    if (!aKey) {
        NSLog(@"%s, key cannot be nil", __FUNCTION__);
        return;
    }
    if (!anObject) {
        NSLog(@"%s, object cannot be nil (key: %@)", __FUNCTION__, aKey);
        return;
    }
    [self safe_setObject:anObject forKey:aKey];
}

- (void)safe_removeObjectForKey:(id)aKey {
    if (!aKey) {
        NSLog(@"%s, key cannot be nil", __FUNCTION__);
        return;
    }
    [self safe_removeObjectForKey:aKey];
}

@end
