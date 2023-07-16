//
//  MOOCViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOOCViewController.h"
#import "MOTableSourceDelegate.h"
#import "MOPerson.h"
#include "MOAlorithm.h"
#include "MOAlgorithmLists.h"
#import "MOAlgorithmList.h"

@interface MOOCViewController ()

/// test table view
@property (nonatomic, strong) UITableView *testTableView;

/// test table view data source
@property (nonatomic, strong) MOTableSourceDelegate *testTableSourceDelegate;

@end

@implementation MOOCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupDataSource];
    
    //    [MOAlgorithmList run];
    //    runAlorithm();
    //    runAlorithmLists();
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    UIEdgeInsets insets = self.view.safeAreaInsets;
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.testTableView.frame = CGRectMake(insets.left,
                                          insets.top,
                                          bounds.size.width - insets.left - insets.right,
                                          bounds.size.height - insets.top - insets.bottom);
    [self.testTableView reloadData];
}

#pragma mark - Private Methods

- (void)setupView {
    self.testTableView.dataSource = self.testTableSourceDelegate;
    self.testTableView.delegate = self.testTableSourceDelegate;
    [self.view addSubview:self.testTableView];
    self.testTableView.frame = self.view.bounds;
}

- (void)setupDataSource {
    NSArray *firstSection = @[[MOCellModel modelWithTitle:@"UIView Test" jumpVCName:@"MOViewTestViewController"],
                              [MOCellModel modelWithTitle:@"Screen Rotation" jumpVCName:@"MOScreenRotationViewController"],
                              [MOCellModel modelWithTitle:@"Water Ripple" jumpVCName:@"MOWaterRippleViewController"],
                              [MOCellModel modelWithTitle:@"CricleLoading" jumpVCName:@"MOCricleLoadingViewController"],
                              [MOCellModel modelWithTitle:@"Control Center" jumpVCName:@"MOControlCenterViewController"],
                              [MOCellModel modelWithTitle:@"UITableView Optimize" jumpVCName:@"MOTableViewOptimizeViewController"],
                              [MOCellModel modelWithTitle:@"Private API" jumpVCName:@"MOPrivateAPIViewController"],
                              [MOCellModel modelWithTitle:@"Locks" jumpVCName:@"MOLocksViewController"],
                              [MOCellModel modelWithTitle:@"MultiThread" jumpVCName:@"MOMultiThreadViewController"],
                              [MOCellModel modelWithTitle:@"KVC" jumpVCName:@"MOKVCViewController"],
                              [MOCellModel modelWithTitle:@"Runtime" jumpVCName:@"MOScreenRotationViewController"],
                              [MOCellModel modelWithTitle:@"Block" jumpVCName:@"MORuntimeViewController"],
                              [MOCellModel modelWithTitle:@"Timer" jumpVCName:@"MOTimerViewController"],
                              [MOCellModel modelWithTitle:@"Responder响应者" jumpVCName:@"MOResponderViewController"],
                              [MOCellModel modelWithTitle:@"ImageButton" jumpVCName:@"MOImageButtonViewController"],
                              [MOCellModel modelWithTitle:@"NativeNetwork" jumpVCName:@"MONativeNetworkViewController"],
                              [MOCellModel modelWithTitle:@"MenuButton" jumpVCName:@"MOMenuButtonViewController"],
                              [MOCellModel modelWithTitle:@"DrawerView" jumpVCName:@"MODrawerViewController"],
                              [MOCellModel modelWithTitle:@"UIWebViewJSBridge" jumpVCName:@"MOWebViewJSBridgeViewController"]];
    self.testTableSourceDelegate.dataSource = @[firstSection];
    [self.testTableView reloadData];
}

- (void)handleClickedCellModel:(MOCellModel *)model {
    if (model.clickedHandler) {
        model.clickedHandler(model);
    }
    UIViewController *vc = [[NSClassFromString(model.jumpVCName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getter Methods

- (UITableView *)testTableView {
    if (!_testTableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [view registerClass:[UITableViewCell class] forCellReuseIdentifier:MOTestCellIdentifier];
        _testTableView = view;
    }
    return _testTableView;
}

- (MOTableSourceDelegate *)testTableSourceDelegate {
    if (!_testTableSourceDelegate) {
        MOTableSourceDelegate *delegate = [[MOTableSourceDelegate alloc] init];
        __weak typeof(self) weakSelf = self;
        delegate.clickedCellHandler = ^(MOCellModel * _Nonnull cellModel) {
            [weakSelf handleClickedCellModel:cellModel];
        };
        _testTableSourceDelegate = delegate;
    }
    return _testTableSourceDelegate;
}

@end
