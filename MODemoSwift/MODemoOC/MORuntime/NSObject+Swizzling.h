//
//  NSObject+Swizzling.h
//  04.Runtime
//
//  Created by MikiMo on 2020/2/23.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Swizzling)

+ (void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
