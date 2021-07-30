//
//  MOGCD.h
//  02.多线程
//
//  Created by mobvoi on 2020/1/15.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 队列优先级
#define DISPATCH_QUEUE_PRIORITY_HIGH 2
#define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
#define DISPATCH_QUEUE_PRIORITY_LOW (-2)
#define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN

// 优先级使用场景参考：https://hello-david.github.io/archives/4397956c.html

// 一、获取并发队列：Concurrent
// 1. GCD默认提供全局并发队列
// 队列优先级
// 任务单元的优先级

// Main Thread (interactive)
// QOS_CLASS_USER_INTERACTIVE：表示任务需要被立即执行，用来在响应事件之后更新UI，来提供好的用户体验。

// DISPATCH_QUEUE_PRIORITY_HIGH 2  (initiated)   高
// QOS_CLASS_USER_INITIATED：表示任务由UI发起异步执行。适用场景是需要及时结果同时又可以继续交互的时候。

// DISPATCH_QUEUE_PRIORITY_DEFAULT 0  (default)  默认
// QOS_CLASS_DEFAULT：表示默认优先级

// DISPATCH_QUEUE_PRIORITY_LOW (-2)   (utility)   低
// QOS_CLASS_UTILITY：表示需要长时间运行的任务，伴有用户可见进度指示器。经常会用来做计算，I/O，网络，持续的数据填充等任务。

// DISPATCH_QUEUE_PRIORITY_BACKGROUND (background)  后台
// QOS_CLASS_BACKGROUND：表示用户不会察觉的任务，使用它来处理预加载，或者不需要用户交互和对时间不敏感的任务。

// QOS_CLASS_UNSPECIFIED：表示未指明，系统根据情况进行选定QOS等级


//  dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // (扩展参数：暂时用不上)

// 2. 创建
//  dispatch_queue_t queue2 = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_CONCURRENT);

// 二、获取串行队列：Serial
// 1. 主队列：会放到主线程中执行
//  dispatch_queue_t mainQueue = dispatch_get_main_queue();
// 2. 创建：
//  dispatch_queue_t queue1 = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_SERIAL);

@interface MOGCD : NSObject

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
