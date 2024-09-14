//
//  MOOFakeSysViewController.m
//  MODemo
//
//  Created by mikimo on 2024/9/14.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

#import "MOOFakeSysViewController.h"
#import "MOOFakeSystemView.h"

static const CGFloat gMOOFakeSystemViewHorHeight = 96.0;
static const CGFloat gMOOFakeSystemViewVerHeight = 60.0;

@interface MOOFakeSysViewController ()

/// 背景图
@property (nonatomic, strong) UIImageView *imageView;

/// 进度值
@property (nonatomic, assign) CGFloat progress;

/// 是否为全屏
@property (nonatomic, assign) BOOL fullScreen;

/// 模拟系统 音量/亮度 视图
@property (nonatomic, strong) MOOFakeSystemView *fakeSystemView;

@end

@implementation MOOFakeSysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 模拟播放器背景
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.image = [UIImage imageNamed:@"moo_miss_wang"];
    [self.view addSubview:self.imageView];
    /// 数值加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = [UIColor redColor];
    [addBtn setTitle:@"加" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    addBtn.frame = CGRectMake(50, 200, 44, 44);
    /// 数值减按钮
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.backgroundColor = [UIColor blueColor];
    [minusBtn setTitle:@"减" forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(clickMinus) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:minusBtn];
    minusBtn.frame = CGRectMake(50, 250, 44, 44);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 这里写死了初始值（TODO: 根据自己业务情况设置）
    [self displayViewWithType:[self viewType]
                     progress:0.5
                   fullScreen:self.fullScreen];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat originY = self.fullScreen ? 0.0 : self.view.safeAreaInsets.top;
    CGFloat height = self.fullScreen ? CGRectGetHeight(self.view.bounds) : 200.0;
    self.imageView.frame = CGRectMake(0.0, originY, CGRectGetWidth(self.view.bounds), height);
}

/// 点击加按钮
- (void)clickAdd {
    self.progress = MIN(self.progress + 0.06, 1.0);
    [self displayViewWithType:[self viewType]
                     progress:self.progress
                   fullScreen:self.fullScreen];
}

/// 点击减按钮
- (void)clickMinus {
    self.progress = MAX(self.progress - 0.06, 0.0);
    [self displayViewWithType:[self viewType]
                     progress:self.progress
                   fullScreen:self.fullScreen];
}

- (void)displayViewWithType:(MOOFakeSystemViewType)type
                   progress:(CGFloat)progress
                 fullScreen:(BOOL)isFullScreen {
    [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                             selector:@selector(hideFakeSystemView)
                                               object:nil];

    // 判断是否为第一次
    UIWindow *keyWindow = [self.class keyWindow];
    BOOL isFirst = self.fakeSystemView.superview != keyWindow;
    if (isFirst) {
        [self.fakeSystemView removeFromSuperview];
        [keyWindow addSubview:self.fakeSystemView];
    } else {
        [keyWindow bringSubviewToFront:self.fakeSystemView];
    }
    CGFloat topSafeMargin = [self topSafeMarginWithFullScreen:isFullScreen];
    CGFloat height = self.fakeSystemView.isFullScreen ? gMOOFakeSystemViewHorHeight : gMOOFakeSystemViewVerHeight;
    self.fakeSystemView.fullScreen = isFullScreen;
    self.fakeSystemView.topSafeMargin = topSafeMargin;
    self.fakeSystemView.hiddenGradientBackground = NO;
    self.fakeSystemView.frame = CGRectMake(0.0, 0.0,
                                             CGRectGetWidth(keyWindow.bounds),
                                             height + topSafeMargin);
    self.fakeSystemView.hidden = NO;
    [self.fakeSystemView displayWithType:type 
                                  progress:progress
                                   isFirst:isFirst];
    
    /// 无操作 0.7s 后消失
    [self performSelector:@selector(hideFakeSystemView)
               withObject:nil
               afterDelay:0.7];
}

- (void)hideFakeSystemView {
    __weak typeof(self) weakSelf = self;
    [self.fakeSystemView dismissWithComplete:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf removeFakeView];
    }];
}

- (void)removeFakeView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                             selector:@selector(hideFakeSystemView)
                                               object:nil];
    self.fakeSystemView.hidden = YES;
    [self.fakeSystemView removeFromSuperview];
}

- (CGFloat)topSafeMarginWithFullScreen:(BOOL)isFullScreen {
    UIWindow *keyWindow = [self.class keyWindow];
    CGFloat topSafeMargin = isFullScreen ? keyWindow.safeAreaInsets.top : [self.class statusBarHeight] + CGRectGetHeight(self.navigationController.navigationBar.frame);
    return topSafeMargin;
}

// TODO: 根据业务场景设置
- (MOOFakeSystemViewType)viewType {
    return MOOFakeSystemViewTypeBrigtness;
}

// TODO: 根据业务场景设置
- (BOOL)fullScreen {
    if (CGRectGetWidth(self.view.bounds) < CGRectGetHeight(self.view.bounds)) {
        return NO;
    }
    return YES;
}

#pragma mark - Getter Methods

- (MOOFakeSystemView *)fakeSystemView {
    if (!_fakeSystemView) {
        MOOFakeSystemView *view = [[MOOFakeSystemView alloc] initWithFrame:CGRectZero];
        _fakeSystemView = view;
    }
    return _fakeSystemView;
}

#pragma mark - Helper Methods

+ (UIWindow *)keyWindow {
    if (@available(iOS 13.0, *)) {
        __block UIWindow *keyWindow = nil;
        [UIApplication.sharedApplication.windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, 
                                                                              NSUInteger idx,
                                                                              BOOL * _Nonnull stop) {
            if (!obj.isKeyWindow) {
                return;
            }
            keyWindow = obj;
            *stop = YES;
        }];
        return keyWindow;
    } else {
        // 需要兼容 iOS 13 以下的 添加
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIApplication.sharedApplication.keyWindow;
#pragma clang diagnostic pop
    }
}

+ (CGFloat)statusBarHeight {
    if (@available(iOS 13.0, *)) {
        UIScene *windowScene = UIApplication.sharedApplication.connectedScenes.allObjects.firstObject;
        if ([windowScene isKindOfClass:[UIWindowScene class]]) {
            CGFloat statusBarHeight = ((UIWindowScene *)windowScene).statusBarManager.statusBarFrame.size.height;
            return statusBarHeight;
        }
    } else {
        // 需要兼容 iOS 13 以下的 添加
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIApplication.sharedApplication.statusBarFrame.size.height;
#pragma clang diagnostic pop
    }
    return 0.0;
}

@end
