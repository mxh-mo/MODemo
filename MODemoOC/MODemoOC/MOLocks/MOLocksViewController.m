//
//  MOLocksViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import <pthread.h>
#import <os/lock.h>
#import <libkern/OSAtomic.h>

#import "MOLocksViewController.h"

@interface MOLocksViewController ()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) pthread_mutex_t pthread;
@property (nonatomic, assign) os_unfair_lock_t unfairLock;

@end

@implementation MOLocksViewController {
    pthread_mutex_t mutex;
    pthread_cond_t condition;
    Boolean ready_to_go;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 同一线程多次加锁会造成死锁
    // 一般而言，锁的功能越强大，性能就会越低
    
    // 互斥锁(mutexlock)sleep-waiting: 保证共享数据操作的完整性, 锁被占用的时候会休眠, 等待锁释放的时候会唤醒
    /*
     在访问共享资源之前进行加锁，访问完成后解锁。
     加锁后，任何其他试图加锁的线程会被阻塞，直到当前线程解锁。
     解锁时，如果有1个以上的线程阻塞，那么所有该锁上的线程变为就绪状态，第一个就绪的加锁，其他的又进入休眠。
     从而实现在任意时刻，最多只有1个线程能够访问被互斥锁保护的资源。
     */
    
    // 自旋锁(spinlock)busy-waiting: 跟互斥类似, 只是资源被占用的时候, 会一直循环检测锁是否被释放(CPU不能做其他的事情)
    // 节省了唤醒睡眠线程的内核消耗(在加锁时间短暂的情况下会大大提高效率)
    
    // 读写锁(rwlock): 顾名思义 - 写的时候：读写都等待；读的时候：写等待，读无需等待
    // 适合读次数远远大于写的情况 (为了公平：写操作到来时，后面的读阻塞)
    
    // 条件锁(condlock): 线程会因为条件变量不满足而阻塞，线程也可以在释放锁时将条件变量改成某个值，从而唤醒满足条件变量的线程
    // 递归锁(recursivelock): 跟互斥类似, 但是允许同一个线程在未释放锁前，加锁N次锁, 不会引发死锁
    
    // 按目前的耗时排序
    //  [self osspinLock];            // 1. OSSpinLock 自旋锁 (会导致优先级反转，不再安全iOS10+废弃)
    // https://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/?utm_source=tuicool
    //  [self osUnfairLock];          // 1. os_unfair_lock 互斥锁 (iOS10+, 休眠)
    //  [self semaphore];             // 2. dispatch_semaphore 信号量，保证关键代码不并发执行
    //  [self pthreadMutex];          // 3. pthread_mutex 互斥锁 (苹果做出了优化, 性能不比semaphore差, 而且肯定安全)
    //  [self nsLock];                // 4. NSLock 互斥锁 (封装了pthread_mutex，type是PTHREAD_MUTEX_ERRORCHECK，也就是当同一个线程获得同一个锁的时候，会返回错误)
    //  [self nsCondition];           // 5. NSCondition 条件锁 (用pthread_cond_t实现NSLocking协议, 能实现NSLock所有功能, 封装了一个互斥锁和信号量)
    //  [self pthreadMutexRecursive]; // 6. pthread_mutex(recursive) 递归锁 需要设置PTHREAD_MUTEX_RECURSIVE
    //  [self nsRecursiveLock];       // 7. NSRecursiveLock 递归锁
    //  [self nsConditionLock];       // 8. NSConditionLock 条件锁
    //  [self synchronized];          // 9. @synchronized 互斥锁 (用pthread_mutex_t实现的) OC层面，传入一个OC对象，通过对象的哈希值来作为标识符得到互斥锁，存入到一个数组里面
    //  [self deadLock];  // 死锁
    
    //  [self POSIX_Codictions]; // POSIXConditions 条件锁：互斥锁 + 条件锁
    //  [self pthreadReadWrite]; // 读写锁
}

#pragma mark - OSSpinLock 自旋锁

- (void)osspinLock {
    // OSSpinLock iOS10+ 已废弃
    // 不再安全的OSSpinLock：https://blog.ibireme.com/2016/01/16/spinlock_is_unsafe_in_ios/
    NSArray *items = @[@"1", @"2", @"3"];
    self.items = [[NSMutableArray alloc] init];
    __block OSSpinLock osslock = OS_SPINLOCK_INIT; // 初始化
    for (int i = 0; i < items.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            OSSpinLockLock(&osslock); // 加锁
            sleep(items.count - i);
            [self.items addObject:items[i]];
            NSLog(@"%@", self.items);
            OSSpinLockUnlock(&osslock); // 解锁
        });
    }
}

#pragma mark - os_unfair_lock 互斥锁 iOS10+ (锁的是代码片段)

- (void)osUnfairLock {
    // 需要: #import <os/lock.h>
    NSArray *items = @[@"1", @"2", @"3"];
    self.items = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < items.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            os_unfair_lock_t unfairLock = &(OS_UNFAIR_LOCK_INIT); // 必须在线程里初始化
            os_unfair_lock_lock(unfairLock); // 加锁
            sleep(items.count - i);
            [self.items addObject:items[i]];
            NSLog(@"线程1 资源1: %@", self.items);
            os_unfair_lock_unlock(unfairLock); // 解锁
        });
    }
}

#pragma mark - 信号量

- (void)semaphore {
    // 初始化：value表示可以并发的线程数
    NSArray *items = @[@"1", @"2", @"3"];
    self.items = [[NSMutableArray alloc] init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < items.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 加锁
            sleep(items.count - i);
            [self.items addObject:items[i]];
            NSLog(@"%@", self.items);
            dispatch_semaphore_signal(semaphore); // 解锁
        });
    }
}

#pragma mark - pthreadMutex

- (void)pthreadMutex {
    // 需要：#import <pthread.h>
    pthread_mutex_init(&_pthread, NULL); // _pthread 不能是局部变量!!
    
    NSArray *items = @[@"1", @"2", @"3"];
    self.items = [[NSMutableArray alloc] init];
    for (int i = 0; i < items.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            pthread_mutex_lock(&_pthread); // 加锁
            sleep(items.count - i);
            [self.items addObject:items[i]];
            NSLog(@"%@", self.items);
            pthread_mutex_unlock(&_pthread); // 解锁
        });
    }
    sleep(2);
    int lockResult = pthread_mutex_trylock(&_pthread);
    if (lockResult == 0) { // 加锁成功是0, 否则错误码
        NSLog(@"lock");
        pthread_mutex_unlock(&_pthread);
    } else {
        NSLog(@"lock error:%i", lockResult);
        usleep(4); // 失败后的重试机制？？？
    }
    
    //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //    pthread_rwlock_(&_pthread); // 加锁
    //    sleep(items.count - i);
    //    [self.items addObject:items[i]];
    //    NSLog(@"%@", self.items);
    //    pthread_mutex_unlock(&_pthread); // 解锁
    //  });
}

#pragma mark - NSLock 互斥锁

- (void)nsLock {
    self.lock = [[NSLock alloc] init];
    self.lock.name = @"itemsLock";
    
    NSArray *items = @[@"1", @"2", @"3"];
    self.items = [[NSMutableArray alloc] init];
    for (int i = 0; i < items.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.lock lock]; // 加锁
            sleep(items.count - i);
            [self.items addObject:items[i]];
            NSLog(@"%@", self.items);
            [self.lock unlock]; // 解锁
            
            // 尝试加锁
            //      if ([self.lock tryLock]) {
            //        sleep(items.count - i);
            //        [self.items addObject:items[i]];
            //        NSLog(@"%@", self.items);
            //        [self.lock unlock];
            //      } else {
            //        NSLog(@"加锁失败: %i", i); // 重试方案???
            //      }
            
            // 在一段时间后，尝试加锁
            //      BOOL locked = [self.lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:4]];
            //      if (locked) {
            //        sleep(items.count - i);
            //        [self.items addObject:items[i]];
            //        NSLog(@"%@", self.items);
            //
            //        [self.lock unlock];
            //      } else {
            //        NSLog(@"加锁失败: %i", i); // 重试方案???
            //      }
        });
    }
}

#pragma mark - NSCondition 条件锁

- (void)nsCondition {
    NSCondition *lock = [[NSCondition alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start 1");
        [lock lock];
        //    [lock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]]; // 让当前线程等待一段时间
        [lock wait];
        NSLog(@"end 1");
        [lock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start 2");
        [lock lock];
        [lock wait];
        NSLog(@"end 2");
        [lock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start 3");
        sleep(2);
        //    [lock signal]; // 唤醒一个等待的线程
        [lock broadcast]; // 唤醒所有等待的线程
        NSLog(@"end 3");
    });
}

#pragma mark - pthread_mutex 支持递归

- (void)pthreadMutexRecursive {
    pthread_mutex_t plock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr); // 初始化attr, 并赋予默认
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); // 设置type为递归锁
    //  PTHREAD_MUTEX_NORMAL: 缺省类型，也就是普通锁。互斥锁不会检测死锁。
    // 当一个线程加锁以后，其余请求锁的线程将形成一个等待队列，并在解锁后先进先出原则获得锁。
    // 当一个线程解锁之前又锁上，将导致死锁。
    // 尝试解除其他线程上的锁，结果不可预测。
    // 尝试解除一个未锁定的锁，结果不可预测。
    
    //  PTHREAD_MUTEX_ERRORCHECK: 检错锁，互斥锁提供错误检查。
    // 当一个线程尝试重新锁定一个还未解开的锁时，将会返回一个错误 EDEADLK。
    // 尝试解除其他线程上的锁，将会返回一个错误。
    // 尝试解除一个未锁定的锁，将会返回一个错误。
    
    //  PTHREAD_MUTEX_RECURSIVE: 递归锁
    // 一个线程可以多次锁定一个还未解开的锁，需要相同数量的 unlock 解锁，然后另一个线程才能获的互斥锁
    // 尝试解除其他线程上的锁，将会返回一个错误。
    // 尝试解除一个未锁定的锁，将会返回一个错误。
    
    //  PTHREAD_MUTEX_DEFAULT: 适应锁, 动作最简单的锁类型，仅等待解锁后重新竞争，没有等待队列。
    // 尝试递归锁定此类型的锁，结果不可预测。
    // 尝试解除其他线程上的锁，结果不可预测。
    // 尝试解除一个未锁定的锁，结果不可预测。
    pthread_mutex_init(&plock, &attr); // 若为 pthread_mutex_init(&plock, NULL) 则会死锁
    pthread_mutexattr_destroy(&attr); // 销毁一个属性对象，在重新初始化之前该结构不能重复使用
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveMethod)(int);
        RecursiveMethod = ^(int value) {
            NSLog(@"加锁: %d", value);
            pthread_mutex_lock(&plock); // 加锁
            if (value < 5) {
                sleep(2);
                RecursiveMethod(++value); // 解锁之前又加想锁, 需要等待锁的解除，
            }
            NSLog(@"解锁: %d", value);
            pthread_mutex_unlock(&plock); // 解锁
        };
        RecursiveMethod(1);
        NSLog(@"finish");
    });
}


#pragma mark - NSRecursiveLock 递归锁

- (void)nsRecursiveLock {
    NSRecursiveLock *lock = [[NSRecursiveLock alloc] init];
    //  [lock tryLock];
    //  [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveMethod)(int);
        RecursiveMethod = ^(int value) {
            NSLog(@"加锁: %d", value);
            [lock lock]; // 加锁
            if (value < 5) {
                sleep(2);
                RecursiveMethod(++value); // 解锁之前又锁上
            }
            NSLog(@"解锁: %d", value);
            [lock unlock]; // 解锁
        };
        RecursiveMethod(1);
        NSLog(@"finish");
    });
}

#pragma mark - NSConditionLock

- (void)nsConditionLock {
    NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0]; // 设置初始标志位
    //  [cLock lock]; // 不区分条件, 可加锁就执行
    //  [cLock unlock]; // 不会清空条件, 之后满足条件的锁还会执行
    //  [cLock tryLockWhenCondition:n]; // 标志位为n时, 加锁成功
    //  [cLock unlockWithCondition:n]; // 解锁, 并设置标志位
    //  [cLock lockWhenCondition:n]; // 标志位为n时加锁, 执行之后代码
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([cLock tryLockWhenCondition:0]) {
            NSLog(@"任务1");
            [cLock unlockWithCondition:1];
        } else {
            NSLog(@"任务1 加锁失败");
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:3];
        NSLog(@"任务2");
        [cLock unlockWithCondition:2];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:1];
        NSLog(@"任务3");
        [cLock unlockWithCondition:3];
    });
}

#pragma mark - synchronized

- (void)synchronized {
    NSArray *items = @[@"1", @"2", @"3"];
    self.items = [[NSMutableArray alloc] init];
    for (int i = 0; i < items.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @synchronized (self.items) { // 加锁
                sleep(items.count - i);
                [self.items addObject:items[i]];
                NSLog(@"%@", self.items);
            }
        });
    }
}

#pragma mark - 递归死锁

- (void)deadLock {
    NSLock *lock = [[NSLock alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveMethod)(int);
        RecursiveMethod = ^(int value) {
            [lock lock];
            if (value > 0) {
                NSLog(@"加锁 %d", value);
                sleep(2);
                RecursiveMethod(value - 1); // 解锁之前又加想锁, 需要等待锁的解除，
            }
            NSLog(@"解锁 %d", value);
            [lock unlock];
        };
        RecursiveMethod(5);
    });
}

#pragma mark - POSIXConditions 条件锁 互斥锁 + 条件锁

- (void)POSIX_Codictions {
    // 线程被一个 互斥 和 条件 结合的信号来唤醒
    ready_to_go = false;
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&condition, NULL);
    
    [self waitOnConditionFunction];
    [self signalThreadUsingCondition];
    // 参考: https://juejin.im/post/5a0a92996fb9a0451f307479
}
- (void)waitOnConditionFunction {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&mutex); // Lock the mutex.
        while(ready_to_go == false) {
            NSLog(@"wait...");
            pthread_cond_wait(&condition, &mutex); // 休眠
        }
        NSLog(@"done");
        ready_to_go = false;
        pthread_mutex_unlock(&mutex);
    });
}
- (void)signalThreadUsingCondition {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&mutex); // Lock the mutex.
        ready_to_go = true;
        NSLog(@"true");
        pthread_cond_signal(&condition); // Signal the other thread to begin work.
        pthread_mutex_unlock(&mutex);
    });
}

- (void)pthreadReadWrite {
    __block pthread_rwlock_t rwLock;
    pthread_rwlock_init(&rwLock, NULL);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_rwlock_wrlock(&rwLock);
        NSLog(@"3 写 begin");
        sleep(3);
        NSLog(@"3 写 end");
        pthread_rwlock_unlock(&rwLock);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_rwlock_rdlock(&rwLock);
        NSLog(@"1 读 begin");
        sleep(1);
        NSLog(@"1 读 end");
        pthread_rwlock_unlock(&rwLock);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_rwlock_rdlock(&rwLock);
        NSLog(@"2 读 begin");
        sleep(2);
        NSLog(@"2 读 end");
        pthread_rwlock_unlock(&rwLock);
    });
}

@end
