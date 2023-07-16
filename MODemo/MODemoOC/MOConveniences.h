//
//  MOConveniences.h
//  MODemo
//
//  Created by mikimo on 2023/7/16.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MOLog(FORMAT, ...)\
do { \
    NSLog(@"[%@ %@(%@)]: %s", [NSString stringWithUTF8String:__FILE__],\
                              [NSString stringWithUTF8String:__PRETTY_FUNCTION__],\
                              @(__LINE__),\
                              [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
} while(0)
