//
//  MOMultiThreadViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOMultiThreadViewController.h"
#import "MOGCD.h"
#import "MOOperationQueue.h"
#import "MONSThread.h"

@interface MOMultiThreadViewController ()
@end

@implementation MOMultiThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // GCD：C，生命周期：自动管理
    // 优点：线程安全；跟block结合，代码简洁；更接近底层，高效；
    // 缺点：基于C实现
    
    // NSOperation：OC，生命周期：自动管理
    // 优点：线程安全；比GCD多了一些简单实用得功能(比如：优先顺序、结合queue使用可随时取消已经设定要执行得任务); 提高了代码的复用度
    // 缺点：基于GCD封装，更高级，抽象；更加面向对象；
    
    // NSThread：OC，生命周期：程序猿管理
    // 优点：比前两种更轻量级；可以睡眠和唤醒；简单易用可直接操作线程对象
    // 缺点：非线程安全，需要加锁，性能低；需要管理生命周期；
    // 底层是Pthread，基于C实现
    
    UIButton *gcdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gcdBtn setTitle:@"GCD" forState:UIControlStateNormal];
    [gcdBtn setFrame:CGRectMake(20, 120, 200, 50)];
    gcdBtn.backgroundColor = [UIColor redColor];
    [gcdBtn addTarget:self action:@selector(clickGCD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdBtn];
    
    UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operationBtn setTitle:@"NSOperation" forState:UIControlStateNormal];
    operationBtn.frame = CGRectMake(20, 200, 200, 50);
    operationBtn.backgroundColor = [UIColor redColor];
    [operationBtn addTarget:self action:@selector(clickNSOperation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:operationBtn];
    
    UIButton *threadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [threadBtn setTitle:@"NSThread" forState:UIControlStateNormal];
    threadBtn.frame = CGRectMake(20, 300, 200, 50);
    threadBtn.backgroundColor = [UIColor redColor];
    [threadBtn addTarget:self action:@selector(clickNSThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:threadBtn];
    
    //  [MOGCD shareInstance];
    //  [MOOperationQueue shareInstance];
    //  [MONSThread shareInstance];
}

- (void)clickGCD {
    [MOGCD shareInstance];
}

- (void)clickNSOperation {
    [MOOperationQueue shareInstance];
}

- (void)clickNSThread {
    [MONSThread shareInstance];
}

@end
