//
//  MOResponderViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOResponderViewController.h"
#import "UIButton+Extension.h"
#import "MOResponderTestView.h"

@interface MOResponderViewController ()

@end

@implementation MOResponderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    // 响应者
    MOResponderTestView *view = [[MOResponderTestView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    [self.view addSubview:view];
    
    // 将btn绘制成六边形，并将可点区域也设置为六边形
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.drawHexagon = YES; // 是否绘制六边形
    btn.frame = CGRectMake(100, 300, 100, 100);
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    // 测试扩大点击范围
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    testButton.frame = CGRectMake(100, 450, 28, 28);
    [testButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    testButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:testButton];
}

- (void)click {
    NSLog(@"click");
}

@end
