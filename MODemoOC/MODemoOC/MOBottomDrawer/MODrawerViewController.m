//
//  MODrawerViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MODrawerViewController.h"
#import "MOBottomDrawerView.h"
#import "MOLeftDrawerView.h"

@interface MODrawerViewController ()
@property (nonatomic, strong) MOBottomDrawerView *bttomView;
@property (nonatomic, strong) MOLeftDrawerView *leftView;
@end

@implementation MODrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.bttomView = [[MOBottomDrawerView alloc] initWithFrame:CGRectMake(0, kBottomMaxY, kSCREEN_WIDTH, 300)];
    self.bttomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bttomView];
    
    self.leftView = [[MOLeftDrawerView alloc] initWithFrame:CGRectMake(0, 300, kMaxX, 168)];
    self.leftView.image = [UIImage imageNamed:@"mo_drawer_bkg"];
    [self.view addSubview:self.leftView];
    
    // 点击收起
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    self.view.backgroundColor = [UIColor cyanColor];
}

- (void)tap {
    [self.leftView close];
    [self.bttomView close];
}

@end
