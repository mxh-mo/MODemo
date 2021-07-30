//
//  NSTimer+MOBlock.m
//  00.OCDemo
//
//  Created by MikiMo on 2020/7/11.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "NSTimer+MOBlock.h"

@implementation NSTimer (MOBlock)

+ (NSTimer *)mo_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void(^)(NSTimer *timer))block {
    return [self scheduledTimerWithTimeInterval:ti
                                         target:self // 类对象无需回收，所以不用担心
                                       selector:@selector(blockInvoke:)
                                       userInfo:[block copy] // 需要copy到堆中，否则会被释放
                                        repeats:yesOrNo];
}

+ (void)blockInvoke:(NSTimer *)timer {
    void(^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
