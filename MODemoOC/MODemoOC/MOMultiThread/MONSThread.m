//
//  MONSThread.m
//  02.多线程
//
//  Created by moxiaoyan on 2020/1/16.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "MONSThread.h"

@interface MONSThread()
@property (nonatomic, assign) NSInteger totalTicketCount;
@end

@implementation MONSThread {
    NSThread *_thread1;
    NSThread *_thread2;
    NSThread *_thread3;
}

+ (instancetype)shareInstance {
    static MONSThread *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[MONSThread alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 说明
        //    [self explain];
        
        // 使用
        // 例子：
        //    [self multiWindowTicket]; // 多窗口买票
        
        //    [self performSelector];
        //    [self afterDelayNowork];  // afterDelay在子线程中未执行
        [self testClickAction]; // 多次点击, 只执行最后一次
    }
    return self;
}

#pragma mark - 多窗口买票

- (void)multiWindowTicket {
    self.totalTicketCount = 8;
    _thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    _thread1.name = @"窗口1";
    _thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    _thread2.name = @"窗口2";
    _thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    _thread3.name = @"窗口3";
    [_thread1 start];
    [_thread2 start];
    [_thread3 start];
}

- (void)saleTicket {
    while (YES) { // 模拟还有票会持续`-1`的操作
        //    @synchronized (self) { // 互斥锁：swift 用 objc_sync_enter(self) 和 objc_sync_exit(self)
        if (self.totalTicketCount > 0) {
            self.totalTicketCount--;
            NSLog(@"买了一张，还剩：%ld %@", (long)self.totalTicketCount, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:0.5];
        } else {
            NSLog(@"票买完了 %@", [NSThread currentThread]);
            break;
        }
        //    }
    }
}

- (void)explain {
    // NSThread 是iOS中轻量级的多线程，一个NSThread对象对应一条线程
    
    // 一些类方法：
    [NSThread mainThread]; // 获取主线程
    [NSThread currentThread]; // 获取当前线程
    // 阻塞当前线程，设置休眠时间，两种方式实现：
    [NSThread sleepForTimeInterval:3];
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3]];
    [NSThread exit]; // 立即终止主线程之外的所有线程(包括正在执行任务的)
    // 注意：需要在掌控所有线程状态的情况下调用此方法，否则可能会导致内存问题。
    // threadPriority相关的都已禁用，改用qualityOfService(枚举)代替
    [NSThread threadPriority]; // 获取当前线程优先级
    [NSThread setThreadPriority:0.5]; // 设置优先级：0.0~1.0；1.0优先级最高
    
    // 创建方式
    // 方法1：alloc init创建，但是需要手动开启
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(network:) object:@{@"name":@"moxiaoyan"}];
    [thread start];
    [thread setName:@"moxiaoyan"]; // 线程名称
    thread.qualityOfService = NSQualityOfServiceUserInteractive;
    //  NSQualityOfServiceUserInteractive = 0x21, // 最高优先级, 用于处理 UI 相关的任务
    //  NSQualityOfServiceUserInitiated = 0x19, // 次高优先级, 用于执行需要立即返回的任务
    //  NSQualityOfServiceUtility = 0x11, // 普通优先级，主要用于不需要立即返回的任务
    //  NSQualityOfServiceBackground = 0x09, // 后台优先级，用于处理一些用户不会感知的任务
    //  NSQualityOfServiceDefault = -1 // 默认优先级，当没有设置优先级的时候，线程默认优先级
    thread.stackSize = 8192; // 更改堆栈的大小: 必须 是4KB(1024)的倍数 && 启动线程之前设置 (创建线程是会有开销的)
    NSUInteger size = thread.stackSize / 1024; // 所占内存大小
    [thread cancel]; // 不会马上退出，做了需要退出的标记
    [thread isMainThread];  // 是否是主线程
    [thread isFinished];  // 是否已经完成
    [thread isCancelled]; // 是否已经取消
    [thread isExecuting]; // 是否正在执行中
    
    // 方法2：初始化一个子线程，特点：自动开启，是类方法
    @autoreleasepool {
        [NSThread detachNewThreadSelector:@selector(network:) toTarget:self withObject:@{@"name":@"moxiaoyan"}];
    }
    // 方法3：performSelector 隐式创建
}

#pragma mark - performSelector

- (void)performSelector {
    // 当前线程中执行
    [self performSelector:@selector(network:) withObject:@{@"name":@"moxiaoyan"}]; // 同步
    [self performSelector:@selector(network:) withObject:@{@"name":@"moxiaoyan"} withObject:@{@"name":@"moxiaoyan"}];  // 同步
    
    // 子线程中执行：(耗时操作)
    [self performSelectorInBackground:@selector(network:) withObject:@{@"name":@"moxiaoyan"}]; // 异步
    // 主线程中执行：(执行更新UI之类得操作)
    [self performSelectorOnMainThread:@selector(complete) withObject:nil waitUntilDone:YES];
    // waitUntilDone: 表示后面代码是否需要等待当前方法执行完毕
    // YES: 同步，test执行完，后面的代码才执行
    // NO: 异步，后面的代码先执行(哪怕比较费时)，test后执行
    NSLog(@"sleep 2 s");
    sleep(2);
    NSLog(@"3");
    // 指定线程中执行
    [self performSelector:@selector(network:) onThread:[NSThread mainThread] withObject:@{@"name":@"moxiaoyan"} waitUntilDone:YES];
    
    // cancel 某一个方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(afterDelay:) object:@{@"name":@"moxiaoyan"}];
    // cancel 当前对象所有perform方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // 参考：https://blog.csdn.net/jingqiu880905/article/details/82900512
}

- (void)afterDelay:(NSDictionary *)info {
    NSLog(@"afterDelay info:%@", info);
}

- (void)network:(NSDictionary *)info {
    NSLog(@"执行 %@", [NSThread currentThread]);
    NSLog(@"info: %@", info);
    sleep(2);
    NSLog(@"完成");
}

// performSelector: withObject: afterDelay:
// 1. 在子线程中不work：
// 因为默认是在当前RunLoop中添加计时器延时执行，而子线程的RunLoop默认不开启，因此不work
// 2. 会让当前函数后面的代码先执行：
// 因为该方法是异步的，会先入栈，等线程空闲了才执行
// 3. runloop run方法后代码不执行：
// 解决方法1：在执行完任务后需要用CF框架的方法结束当前loop
// 解决方法2：用runUntilDate方法，在后续时间结束当前loop

#pragma mark - afterDelayNowork

- (void)afterDelayNowork {
    // 模拟子线程里执行 afterDelay 方法
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1");
        // 解决不执行 方法1
        [self performSelector:@selector(complete) withObject:nil afterDelay:0]; // 异步
        NSLog(@"2");
        // 在子线程里获取一下runloop
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop]; // 捕获取就不会主动创建
        // 解决后面代码不执行 方法1.1
        [runLoop run]; // 如果直接用run，在执行完任务后需要用CF框架的方法结束当前loop
        // 解决后面代码不执行 方法2
        // [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        NSLog(@"3"); // 在loop结束之后才执行
    });
}

- (void)complete {
    NSLog(@"4");
    // 解决后面代码不执行 方法1.2
    CFRunLoopStop(CFRunLoopGetCurrent()); // 需要手动管理`为子线程创建的RunLoop`的生命周期
}

#pragma mark - testClickAction

- (void)testClickAction {
    // 实现：多次点击, 只执行最后一次
    [self clickAction];
    [self clickAction];
    [self clickAction];
    [self clickAction];
}

- (void)clickAction {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(afterDelay:) object:nil];
    [self performSelector:@selector(afterDelay:) withObject:nil afterDelay:2]; // 2s后执行
}

@end
