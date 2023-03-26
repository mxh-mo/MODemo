//
//  MOGCD.m
//  02.多线程
//
//  Created by mobvoi on 2020/1/15.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "MOGCD.h"
#import <pthread/pthread.h>

@implementation MOGCD

/// 声明static函数
/// 声明了一个当前文件范围可用的队列：
static dispatch_queue_t current_file_queue() {
    static dispatch_queue_t mo_file_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mo_file_queue = dispatch_queue_create("com.moxiaoyan.file.queue", DISPATCH_QUEUE_SERIAL);
    });
    return mo_file_queue;
}

+ (instancetype)shareInstance {
    static MOGCD *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[MOGCD alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 异步
        //    [self asyncGlobal];     // 异步-全局并行: 开启多个线程，并发执行，不阻塞
        //    [self asyncConcurrent]; // 异步-并行: 开启多个线程，并发执行，不阻塞
        //    [self asyncMain];       // 异步-主串行: 主线程中，顺序执行，不阻塞
        //    [self asyncSerial];     // 异步-串行: 开启一个线程，顺序执行，不阻塞
        //    //  同步
        //    [self syncGlobal];      // 同步-全局并行: 在主线程中，顺序执行，阻塞
        //    [self syncConcurrent];  // 同步-并行: 在主线程中，顺序执行，阻塞
        //    [self syncMain];        // 同步-主串行: 死锁，阻塞
        //    [self syncSerial];      // 同步-串行: 主线程中，顺序执行，阻塞
        // 同步函数不具备开启线程的能力，无论是什么队列都不会开启线程；
        // 异步函数具备开启线程的能力，开启几条线程由队列决定（串行队列只会开启一条新的线程，并发队列会开启多条线程）
        
        // 需求：waiting多个异步
        // 方法1：waiting
        //    [self waitMultNetwork1];
        // 方法2：notify
        //    [self waitMultNetwork2];
        // 方法3：enter leave
        //    [self waitMultNetwork3];
        // 方法4：串行队列
        //    [self waitMultNetwork4];
        
        // 需求：waiting多个异步顺序执行 semaphore
        //  [self multipleNetwork3];
        
        // 信号量：semaphore
        // 用处1：等待异步回调
        //  [self waitAsync];
        // 用处2：为线程加锁 (性能远高于@synchronized，仅次于OSSpinLock)
        //  [self locked];
        // barrier 栅栏的使用
        //    [self barrierSync];
        //    [self barrierAsync];
        
        // 参考2：https://www.jianshu.com/p/a84c2bf0d77b
        // 参考3：https://www.cnblogs.com/yajunLi/p/6274282.html
        
//        [self apply];
        //    [self maxConcurrent]; // 用信号量控制并行线程数量
        
        // 希望异步加载实现同步效果
        //    NSDictionary *dic = [self syncLoadDic2];
        //    NSLog(@"%@", dic);

        // 将函数添加到队列中：
//        [self asyncF];
//        [self qosTest];
        
        // performSelecter:afterDelay:
//        [self performDelayTest];
        
        
    }
    return self;
}

- (void)performDelayTest {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
        [self performSelector:@selector(completion) withObject:nil afterDelay:0];
        NSLog(@"2");
    });
}

- (void)completion {
    NSLog(@"3 %@", [NSThread currentThread]);
}

- (void)qosTest {
    // 自定义队列优先级
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, -1);
    //    QOS_CLASS_USER_INTERACTIVE
    //    QOS_CLASS_USER_INITIATED
    //    QOS_CLASS_DEFAULT
    //    QOS_CLASS_UTILITY
    //    QOS_CLASS_BACKGROUND
    //    QOS_CLASS_UNSPECIFIED
    dispatch_queue_t queue1 = dispatch_queue_create("queue1", attr);
    dispatch_queue_t queue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    // 设置 q2 的优先级 跟 q1 一样
    dispatch_set_target_queue(queue2, queue1);

//    // 创建有优先级的事件
//    dispatch_queue_t queue = dispatch_queue_create("momo", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_block_t block = dispatch_block_create_with_qos_class(0, QOS_CLASS_UTILITY, -8, ^{
//
//    });
//    dispatch_async(queue, block);
}

- (void)asyncF {
    int context = 10;
    dispatch_async_f(dispatch_get_main_queue(), &context, test);
}

void test(void *context) {
    int *value = context;
    NSLog(@"value: %d", *value);
}

/// 第一种：用信号量 dispatch_semaphore
- (NSString *)syncFindDevice1 {
    NSString __block *result;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self deviceWithKey:@"mac1" result:^(NSString *value) {
        result = value;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}

/// 第二种：用派发组 dispatch_group
- (NSString *)syncFindDevice2 {
    NSString __block *result;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [self deviceWithKey:@"mac1" result:^(NSString *value) {
        result = value;
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return result;
}
- (void)deviceWithKey:(NSString *)key result:(void(^)(NSString *value))complete {
    NSDictionary *dic = @{@"mac1":@"device1"};
    complete(dic[key]);
}

#pragma mark - 异步-全局并行: 开启多个线程，并发执行，不阻塞

- (void)asyncGlobal {
    // 开启多个线程，并发执行，不阻塞
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 添加并发事件
    dispatch_async(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 不会
}

#pragma mark - 异步-并行: 开启多个线程，并发执行，不阻塞

- (void)asyncConcurrent {
    // 开启多个线程，并发执行，不阻塞
    dispatch_queue_t queue = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 不会
}

#pragma mark - 异步-主串行: 主线程中，顺序执行，不阻塞

- (void)asyncMain {
    // 主线程中，顺序执行，不阻塞
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 不会
}

#pragma mark - 异步-串行: 开启一个线程，顺序执行，不阻塞

- (void)asyncSerial {
    // 开启一个线程，顺序执行，不阻塞
    dispatch_queue_t queue = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 不会
}

#pragma mark - 同步-全局并行: 在主线程中，顺序执行，阻塞

- (void)syncGlobal {
    // 在主线程中，顺序执行，阻塞
    // (如果用async加入，不会跟sync的在一个线程里)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 不会
}

#pragma mark - 同步-并行：在主线程中，顺序执行，阻塞

- (void)syncConcurrent {
    // 在主线程中，顺序执行，阻塞
    dispatch_queue_t queue = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    NSLog(@"间隙1");
    dispatch_sync(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    NSLog(@"间隙2");
    dispatch_sync(queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 会 (因为：没有开启新线程)
    
    // 死锁：串行队列+同步任务(中再在`当前队列`里+同步)
    // 参考1：https://www.cnblogs.com/yajunLi/p/6270220.html
    //  dispatch_queue_t queue2 = dispatch_queue_create("queneName", DISPATCH_QUEUE_SERIAL);
    //  dispatch_sync(queue2, ^{
    //    NSLog(@"111111");
    //    // 不在当前队列中+：是OK的 (顺序执行) 如：dispatch_queue_t queue2 = dispatch_queue_create("quene2Name", DISPATCH_QUEUE_SERIAL);
    //    dispatch_sync(queue2, ^{
    //        NSLog(@"22222");
    //    });
    //    NSLog(@"3333333");
    //  });
    //  NSLog(@"44444444");
}

#pragma mark - 同步-主串行: 死锁，阻塞

- (void)syncMain {
    // 死锁1：主串行队列+同步任务
    // 例：之前在百度面试遇到的题
    NSLog(@"1");
    dispatch_sync(dispatch_get_main_queue(), ^{    // 串行 同步队列
        NSLog(@"2");
    });
    NSLog(@"3");
    // 输出：1
    // 3加入队列 2加入队列；FIFO：3等待2执行 而2在3的后面
    // 所以造成死锁(crash: Thread 1: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0))
}

#pragma mark - 同步-串行: 主线程中，顺序执行，阻塞

- (void)syncSerial {
    // 主线程中，顺序执行，阻塞
    dispatch_queue_t queue = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 会
}

#pragma mark - waiting 多个异步

- (void)waitMultNetwork1 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    // 等待所有异步事件执行完毕后继续执行
    NSLog(@"是否阻塞主线程"); // 会
}

#pragma mark - waiting多个异步 方法1: notify

- (void)waitMultNetwork2 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(4);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{ // 切换到主线程更新UI
        NSLog(@"都完成后，执行");
    });
    NSLog(@"是否阻塞主线程"); // 不会
}

#pragma mark - waiting多个异步 方法2：enter leave

- (void)waitMultNetwork3 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成1：%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(4);
        NSLog(@"完成2：%@", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{ // 切换到主线程更新UI
        NSLog(@"都完成后，执行");
    });
    NSLog(@"是否阻塞主线程"); // 不会
}

#pragma mark - 串行等待多个异步

- (void)waitMultNetwork4 {
    dispatch_queue_t queue = dispatch_queue_create("com.mo.queue", NULL);
    for (int i = 0; i < 3; i++) {
        dispatch_async(queue, ^{
            NSLog(@"执行%i：%@", i, [NSThread currentThread]);
            sleep(1);
            NSLog(@"完成%i：%@", i, [NSThread currentThread]);
        });
    }
    dispatch_async(queue, ^{
        NSLog(@"以上都执行完毕");
    });
}

#pragma mark - 需求：waiting多个异步顺序执行 semaphore

- (void)multipleNetwork3 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_group_async(group, queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_group_async(group, queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_group_async(group, queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"是否阻塞主线程"); // 会
}

#pragma mark - semaphore 用处1：等待异步回调

- (void)waitAsync {
    // 多个异步怎么等待！？？？？？
    //  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //  // 传入的值必须＞=0，否则返回NULL
    //  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); // 如果>0:则不会等待
    //  dispatch_async(queue, ^{
    //    NSLog(@"执行：%@", [NSThread currentThread]);
    //    sleep(2);
    //    NSLog(@"完成：%@", [NSThread currentThread]);
    //    dispatch_semaphore_signal(semaphore); // semaphore+1
    //  });
    //  NSLog(@"wait");
    //  // 会阻塞当前线程(这里是主线程)
    //  // semaphore为0，会等待timeout
    //  // 等待期间 semaphore>0 or timeout 会解除阻塞继续执行
    //  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // semaphore-1
    //  // DISPATCH_TIME_NOW : 则不会等待
    //  // dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 10); 当前时间延迟几秒
    //  NSLog(@"是否阻塞主线程"); // 会
    //  // 参考：https://www.jianshu.com/p/a84c2bf0d77b
    
    // create的value表示，最多几个资源可访问 （可以测试一下：1~3）
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务1 执行");
        sleep(1);
        NSLog(@"任务1 完成");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务2 执行");
        sleep(2);
        NSLog(@"任务2 完成");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"任务3 执行");
        sleep(1);
        NSLog(@"任务3 完成");
        dispatch_semaphore_signal(semaphore);
    });
    NSLog(@"是否阻塞主线程"); // 不会
    // 由于设定的信号值为2，先执行两个线程，等执行完一个，才会继续执行下一个，保证同一时间执行的线程数不超过2
}

#pragma mark - semaphore 用处2：为线程加锁

- (void)locked {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1); // 第1个不会wait
    for (int i = 0; i < 20; i++) {
        dispatch_async(queue, ^{
            // 相当于加锁
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 使semaphore-1
            sleep(2);
            NSLog(@"i = %d semaphore = %@", i, semaphore);
            // 相当于解锁
            dispatch_semaphore_signal(semaphore); // 使semaphore+1
        });
    }
    NSLog(@"是否阻塞主线程"); // 不会
    // 当第一个异步循环走到wait时，因为semaphore>0，所以会-1，继续执行: signal+1
    // 如果下一个循环在上一个循环结束前开始, 因为 semaphore>0, 所以会wait，直到signal+1
    // 保证了log循序输出
}

- (void)barrierSync {
    dispatch_queue_t queue = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"栅栏");
    });
    dispatch_async(queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 会
}

- (void)barrierAsync {
    dispatch_queue_t queue = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"执行1：%@", [NSThread currentThread]);
        sleep(2);
        NSLog(@"完成1：%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行2：%@", [NSThread currentThread]);
        sleep(3);
        NSLog(@"完成2：%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        NSLog(@"栅栏");
    });
    dispatch_async(queue, ^{
        NSLog(@"执行3：%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"完成3：%@", [NSThread currentThread]);
    });
    NSLog(@"是否阻塞主线程"); // 不会
}

#pragma mark - diapatch_apply

- (void)apply {
    // 往队列中添加任务，任务会重复执行n次
    // 例：处理数组
    NSArray *array = @[@"a", @"b", @"c", @"d"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(array.count, queue, ^(size_t index) {
        NSLog(@"index:%zu %@", index, array[index]);
    });
    //  dispatch_apply(1, dispatch_get_main_queue(), ^(size_t index) { // 死锁
    //    NSLog(@"dispatch_apply");
    //  });
    NSLog(@"是否阻塞主线程 dispatch_apply"); // 会
}


- (void)maxConcurrent {
    // 使用信号量来控制最大并发数(<0阻塞，>0执行)
    dispatch_queue_t concurrentQueue = dispatch_queue_create("moxiaoyan", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(concurrentQueue, ^{
            NSLog(@"start %ld, %@", (long)i, [NSThread currentThread]);
            sleep(1);
            NSLog(@"end %ld, %@", (long)i, [NSThread currentThread]);
            dispatch_semaphore_signal(semaphore);
        });
    }
}

@end
