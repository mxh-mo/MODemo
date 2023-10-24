//
//  NSDictionary+MOOSafe.m
//  MODemo
//
//  Created by mikimo on 2023/10/24.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "NSDictionary+MOOSafe.h"

@implementation NSDictionary (MOOSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [objc_getClass("__NSArray0") swapOriginSelector:@selector(objectAtIndex:)
//                                       byTargetSelector:@selector(safe_objectAtIndex:)];
    });
}

//- (id)objectForKey:(id)aKey {
//    
//}

@end
