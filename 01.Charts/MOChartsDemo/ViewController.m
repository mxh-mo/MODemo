//
//  ViewController.m
//  MOChartsDemo
//
//  Created by moxiaoyan on 2020/12/18.
//

#import "ViewController.h"
#import "MOChartsDemo-Bridging-Header.h"
#import "MOLineChartsView.h"
#import "MOBarChartsView.h"
#import "MOPieChartsView.h"

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 折线统计图
    MOLineChartsView *lineChartsView = [[MOLineChartsView alloc] initWithFrame:CGRectMake(20, 50, kScreenWidth - 40, 150)];
    lineChartsView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:lineChartsView];
    
    // 折线统计图
    MOBarChartsView *barChartsView = [[MOBarChartsView alloc] initWithFrame:CGRectMake(20, 220, kScreenWidth - 40, 150)];
    barChartsView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:barChartsView];
    
    // 饼状统计图
    MOPieChartsView *pieChartsView = [[MOPieChartsView alloc] initWithFrame:CGRectMake(0, 390, kScreenWidth - 40, kScreenHeight - 390)];
    pieChartsView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:pieChartsView];
    
}

@end
