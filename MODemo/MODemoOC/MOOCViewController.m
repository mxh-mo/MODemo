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
#import "MOViewTestViewController.h"
#import "QMTPlayerFakeSystemViewV2.h"

@interface MOOCViewController ()

/// test table view
@property (nonatomic, strong) UITableView *testTableView;

/// test table view data source
@property (nonatomic, strong) MOTableSourceDelegate *testTableSourceDelegate;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL fullScreen;
@property (nonatomic, strong) QMTPlayerFakeSystemViewV2 *fakeSystemViewV2;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MOOCViewController

#pragma mark - Override Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupDataSource];
    
//    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 59.0, 400, 200)];
//    self.imageView.image = [UIImage imageNamed:@"bg"];
//    [self.view addSubview:self.imageView];
//    
//    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    addBtn.backgroundColor = [UIColor redColor];
//    [addBtn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:addBtn];
//    addBtn.frame = CGRectMake(50, 200, 44, 44);
//    
//    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    minusBtn.backgroundColor = [UIColor blueColor];
//    [minusBtn addTarget:self action:@selector(clickMinus) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:minusBtn];
//    minusBtn.frame = CGRectMake(50, 250, 44, 44);
    
    //    [MOAlgorithmList run];
    //    runAlorithm();
    //    runAlorithmLists();
//    [self.navigationController pushViewController:[MOViewTestViewController new] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.fullScreen = YES;
    [self displayViewWithType:QMTPlayerFakeSystemViewType_Volume progress:0.5 fullScreen:self.fullScreen];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat originY = self.fullScreen ? self.view.safeAreaInsets.top : 0.0;
    CGFloat height = self.fullScreen ? 200 : CGRectGetHeight(self.view.bounds);
    self.imageView.frame = CGRectMake(0.0, originY, CGRectGetWidth(self.view.bounds), height);
}

- (void)clickAdd {
    self.progress = MIN(self.progress + 0.06, 1.0);
    [self displayViewWithType:QMTPlayerFakeSystemViewType_Volume progress:self.progress fullScreen:self.fullScreen];
}

- (void)clickMinus {
    self.progress = MAX(self.progress - 0.06, 0.0);
    [self displayViewWithType:QMTPlayerFakeSystemViewType_Volume progress:self.progress fullScreen:self.fullScreen];
}

- (void)displayViewWithType:(QMTPlayerFakeSystemViewType)type
                   progress:(CGFloat)progress
                 fullScreen:(BOOL)isFullScreen {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideFakeSystemViewV2) object:nil];
    
    UIView *superView = [self.class keyWindow];
    BOOL isMaxStyle = YES;
    if (self.fakeSystemViewV2.superview == superView) {
        [superView bringSubviewToFront:self.fakeSystemViewV2];
        isMaxStyle = NO;
    } else {
        isMaxStyle = YES;
        [self.fakeSystemViewV2 removeFromSuperview];
        [superView addSubview:self.fakeSystemViewV2];
    }
    CGFloat originY = isFullScreen ? 0.0 : self.view.window.safeAreaInsets.top;
    CGFloat height = isFullScreen ? 96.0 : 59.0;
    self.fakeSystemViewV2.frame = CGRectMake(0.0, originY, CGRectGetWidth(superView.bounds), height);

    [self.fakeSystemViewV2 displayWithType:type progress:progress fullScreen:isFullScreen maxStyle:isMaxStyle];
    [self performSelector:@selector(hideFakeSystemViewV2) withObject:nil afterDelay:1.5];
}

- (void)hideFakeSystemViewV2 {
    [self.fakeSystemViewV2 dismissWithComplete:^{
        [self.fakeSystemViewV2 removeFromSuperview];
    }];
}

#pragma mark - Getter Methods

- (QMTPlayerFakeSystemViewV2 *)fakeSystemViewV2 {
    if (!_fakeSystemViewV2) {
        QMTPlayerFakeSystemViewV2 *view = [[QMTPlayerFakeSystemViewV2 alloc] initWithFrame:CGRectZero];
        _fakeSystemViewV2 = view;
    }
    return _fakeSystemViewV2;
}

#pragma mark - Helper Methods

+ (UIWindow *)keyWindow {
    if (@available(iOS 13.0, *)) {
        __block UIWindow *keyWindow = nil;
        [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!obj.isKeyWindow) {
                return;
            }
            keyWindow = obj;
            *stop = YES;
        }];
        return keyWindow;
    } else {
        return UIApplication.sharedApplication.keyWindow;
    }
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
