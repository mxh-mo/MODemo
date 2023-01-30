//
//  NSTimer+MOBlock.h
//  00.OCDemo
//
//  Created by MikiMo on 2020/7/11.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (MOBlock)

+ (NSTimer *)mo_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void(^)(NSTimer *timer))block;

@end

NS_ASSUME_NONNULL_END
