//
//  MOTimerViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "YYWeakProxy.h"

#import "MOTimerViewController.h"
#import "NSTimer+MOBlock.h"
#import "MOProxy.h"

@interface MOTimerViewController ()

@property (nonatomic, strong) NSTimer *timer1; // 持有只是为了在dealloc中释放
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, strong) NSTimer *timer3;
@property (nonatomic, strong) NSTimer *timer4;
@property (nonatomic, strong) NSTimer *timer5;
@property (nonatomic, strong) NSTimer *timer6;

@property (nonatomic, strong) NSTimer *timer7;
@property (nonatomic, strong) NSInvocation *invocation7;
@property (nonatomic, strong) NSTimer *timer8;
@property (nonatomic, strong) NSInvocation *invocation8;

@property (nonatomic, strong) dispatch_source_t gcdTimer;

@property (nonatomic, strong) NSTimer *timerFirst;
@property (nonatomic, strong) NSTimer *timerSecond;

@property (nonatomic, strong) CADisplayLink *link;

@end

@implementation MOTimerViewController

+ (void)load {
    NSLog(@"load MOTimerViewController");
}

- (void)dealloc {
    NSLog(@"MOViewController dealloc");
    //  [self.timer1 invalidate];
    //  [self.timer2 invalidate];
    //  [self.timer3 invalidate];
    //  [self.timer4 invalidate];
    //  [self.timer5 invalidate];
    //  [self.timer6 invalidate];
    //  [self.timer7 in validate];
    //  [self.timer8 invalidate];
    
    //  [self.timerFirst invalidate];
    [self.timerSecond invalidate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopLink];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NSTimer];
    //  [self GCDTimer];
    //  [self displayLink];
}

- (void)displayLink {
    // CADisplayLink 适用于界面的不停重绘, 如: 视频播放的时候需要不停的获取下一帧的数据用于界面渲染
    // 不能被继承
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLink:)];
    // FPS: 帧率, 每秒刷新的最大次数, 现存的iOS设备是60HZ, [UIScreen mainScreen].maximumFramesPerSecond 得到
    // 每秒回调次数, 默认0, 跟系统FPS同步
    self.link.preferredFramesPerSecond = 30; // 每秒回调30次
    //   self.link.frameInterval = 2;
    // 默认1, 每次时间间隔 duration = FPS/frameInterval (如: 60/1 = 0.016667s 刷新1次)(最理想的状态, 如果CPU忙碌会跳过若干次回调)
    // 当值小于1时，结果不可预测(频率已经大于屏幕刷新频率了, 能否及时绘制每次计算的数值得看CPU的负载情况, 此时就会出现严重的丢帧现象)
    // iOS10之后已被弃用, 因为每次的时间间隔会根据FPS的不同而不用, 以后某台设备提升了FPS, 此时duration在不同设备上的值就不一样了
    
    [self.link setPaused:YES];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    //  [self.link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self startLink];
    NSLog(@"maximumFramesPerSecond: %ld", [UIScreen mainScreen].maximumFramesPerSecond);
    // https://developer.apple.com/documentation/quartzcore/cadisplaylink
    // https://www.jianshu.com/p/c35a81c3b9eb
    // https://www.jianshu.com/p/b2256104f76e
}

- (void)startLink {
    [self.link setPaused:NO];
}

- (void)pauseLink {
    [self.link setPaused:YES];
}

- (void)stopLink {
    [self.link invalidate]; // removeFromRunLoop, 释放target
}

- (void)displayLink:(CADisplayLink *)link {
    
    // duration: 最大屏幕刷新时间间隔, 在selector首次被调用后才会被赋值, 计算方式: duration * frameInterval
    // preferredFramesPerSecond: 显示链接的首选帧速率
    // timestamp: 上一帧时间戳
    // targetTimestamp: 下一帧时间戳
    // targetTimestamp - timestamp: 实际刷新时间间隔 (据此确定下一次需要display的内容)
    NSLog(@"---------------------------------------");
    NSLog(@"%f", link.targetTimestamp - link.timestamp);
    NSLog(@"%f", link.duration);
    NSLog(@"%ld", (long)link.preferredFramesPerSecond);
}

- (void)NSTimer {
    // http://xttxqjfg.cn/2019/02/25/NSTimer%E4%BD%BF%E7%94%A8%E8%A7%A3%E6%9E%90/
    // http://www.cocoachina.com/articles/24725
    // 所有的Timer都需要在dealloc里 invalidate 掉 (因为RunLoop强引用Timer的关系)
    // invalidate方法：会将Timer从RunLopp中移除；并释放Timer持有的资源(target、userInfo、Block)
    // invalidate方法调用必须在timer添加到的runloop所在的线程
    
    // 除了iOS10新出的3个代Block的方法，其他的都会造成内存泄露，导致持有者的dealloc不会执行
    // timer强引用了target, target又强引用了self，从而导致当前VC释放不了。
    
    // 虽说这里有个强引用环，但造成泄露的主要原因是：
    // RunLoop对Timer的强引用，导致Timer需要我们手动释放，释放最适宜的时机又是self的dealloc方法。
    // 所以我们必须要保证self的正常释放，因而最关键的强引用是target对self的这条！！！
    
    // scheduled 开头的都是默认register到当前RunLoop下的
    // timer 开头的需要自己指定RunLoop
    
    //  [self.timer1 setFireDate:[NSDate distantFuture]]; // 暂停
    //  [self.timer1 setFireDate:[NSDate date]]; // 恢复
    
    //  self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerOne) userInfo:nil repeats:YES];
    //  self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //    NSLog(@"timer 2");
    //  }]; // iOS 10
    //
    //  self.timer3 = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerThree) userInfo:nil repeats:YES];
    //  self.timer4 = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //    NSLog(@"timer 4");
    //  }]; // iOS 10
    //  [[NSRunLoop currentRunLoop] addTimer:self.timer4 forMode:NSRunLoopCommonModes];
    //
    //  self.timer5 = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:2] interval:1 target:self selector:@selector(timerFive) userInfo:nil repeats:YES];
    //  [[NSRunLoop currentRunLoop] addTimer:self.timer5 forMode:NSRunLoopCommonModes];
    //
    //  self.timer6 = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:2] interval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //    NSLog(@"timer 6");
    //  }]; // iOS 10
    //  [[NSRunLoop currentRunLoop] addTimer:self.timer6 forMode:NSRunLoopCommonModes];
    //
    //  NSMethodSignature *signature7 = [self methodSignatureForSelector:@selector(timerSeven:)];
    //  self.invocation7 = [NSInvocation invocationWithMethodSignature:signature7]; // 必须持有
    //  [self.invocation7 setSelector:@selector(timerSeven:)];
    //  [self.invocation7 setTarget:self];
    //  NSString *name7 = @"moxiaoyan7";
    //  [self.invocation7 setArgument:&name7 atIndex:2]; // 前面有两个隐藏参数
    //  self.timer7 = [NSTimer scheduledTimerWithTimeInterval:1 invocation:self.invocation7 repeats:YES];
    //
    //  NSMethodSignature *signature8 = [self methodSignatureForSelector:@selector(timerEight:)];
    //  self.invocation8 = [NSInvocation invocationWithMethodSignature:signature8];
    //  [self.invocation8 setSelector:@selector(timerEight:)];
    //  [self.invocation8 setTarget:self];
    //  NSString *name8 = @"moxiaoyan8";
    //  [self.invocation8 setArgument:&name8 atIndex:2];
    //  self.timer8 = [NSTimer timerWithTimeInterval:1 invocation:self.invocation8 repeats:YES];
    //  [[NSRunLoop currentRunLoop] addTimer:self.timer8 forMode:NSRunLoopCommonModes];
    
    // 解决方案：
    // 1、block方式添加Target-Action
    //  self.timerFirst = [NSTimer mo_scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //    NSLog(@"优化后的 first timer %@", timer.userInfo);
    //  }];
    
    // 2、代理类弱引用self + 消息转发
    MOProxy *proxy = [MOProxy alloc];
    proxy.target = self;
    //  YYWeakProxy *weakObj = [YYWeakProxy proxyWithTarget:self];
    self.timerSecond = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:proxy
                                                      selector:@selector(timerSecond:)
                                                      userInfo:@{@"name": @"cool"}
                                                       repeats:YES];
}

- (void)timerOne {
    NSLog(@"timer 1 %@", [NSThread currentThread]);
}

- (void)timerThree {
    NSLog(@"timer 3 %@", [NSThread currentThread]);
}

- (void)timerFive {
    NSLog(@"timer 5");
}

- (void)timerSeven:(NSString *)name {
    NSLog(@"timer 7 %@", name);
}

- (void)timerEight:(NSString *)name {
    NSLog(@"timer 8 %@", name);
}

- (void)timerSecond:(NSDictionary *)userInfo {
    NSLog(@"timer second %@", userInfo);
}

- (void)GCDTimer {
    // GCD 定时器(不会被RunLoop强引用)
    // GCD 一次性定时器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"GCD 一次性计时器");
        //    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        //    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        //    [runLoop run]; 还是不work
        //    [self performSelector:@selector(timerThree) withObject:nil afterDelay:2];
        // 用onMainThread代替
        [self performSelectorOnMainThread:@selector(timerThree) withObject:nil waitUntilDone:2];
    });
    
    // GCD 重复性定时器
    self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)2 * NSEC_PER_SEC);
    uint64_t duration = (uint64_t)(2.0 * NSEC_PER_SEC);
    // 参数：sourceTimer 开始时间 循环间隔 精确度(这里写的0.1s)
    dispatch_source_set_timer(self.gcdTimer, start, duration, 0.1 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.gcdTimer, ^{
        NSLog(@"GCD 重复性计时器");
        dispatch_suspend(weakSelf.gcdTimer); // 暂停
        sleep(1);
        dispatch_resume(weakSelf.gcdTimer); // 恢复
    });
    dispatch_resume(self.gcdTimer);
    // cancel 销毁，不可再使用
    //  dispatch_source_cancel(self.gcdTimer);
}

@end
