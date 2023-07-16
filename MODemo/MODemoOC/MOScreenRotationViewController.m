//
//  MOScreenRotationViewController.m
//  MODemo
//
//  Created by mikimo on 2023/7/16.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "MOScreenRotationViewController.h"
#import <Masonry/Masonry.h>
#import "MOConveniences.h"

NSString *MODeviceOrientationDescription(UIDeviceOrientation orientation) {
    switch (orientation) {
        case UIDeviceOrientationUnknown: return @"Unknown";
        case UIDeviceOrientationPortrait: return @"Portrait";
        case UIDeviceOrientationPortraitUpsideDown: return @"PortraitUpsideDown";
        case UIDeviceOrientationLandscapeLeft: return @"LandscapeLeft";
        case UIDeviceOrientationLandscapeRight: return @"LandscapeRight";
        case UIDeviceOrientationFaceUp: return @"FaceUp";
        case UIDeviceOrientationFaceDown: return @"FaceDown";
    }
}

NSString *MOInterfaceOrientationDescription(UIInterfaceOrientation orientation) {
    switch (orientation) {
        case UIInterfaceOrientationUnknown: return @"Unknown";
        case UIInterfaceOrientationPortrait: return @"Portrait";
        case UIInterfaceOrientationPortraitUpsideDown: return @"PortraitUpsideDown";
        case UIInterfaceOrientationLandscapeLeft: return @"LandscapeLeft";
        case UIInterfaceOrientationLandscapeRight: return @"LandscapeRight";
    }
}

typedef void(^MODeviceOrientationCompletion)(NSError * _Nullable error);

void MOGeometryUpdate(UIViewController *viewController,
                      UIDeviceOrientation orientation,
                      MODeviceOrientationCompletion completion) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 160000
    /* Preprocess macro for compiling on Xcode14 */
    if (@available(iOS 16.0, *)) {
        if (![viewController respondsToSelector:@selector(setNeedsUpdateOfSupportedInterfaceOrientations)]) {
            NSString *errMsg = @"viewController can't respond setNeedsUpdateOfSupportedInterfaceOrientations";
            MOLog(@"%@", errMsg);
            if (completion) {
                completion([NSError errorWithDomain:@"MODemo" code:0 userInfo:@{NSLocalizedDescriptionKey: errMsg}]);
            }
            return;
        }
        [viewController setNeedsUpdateOfSupportedInterfaceOrientations];
        [viewController.navigationController setNeedsUpdateOfSupportedInterfaceOrientations];
        
        // find scene
        NSArray<UIScene *> *scenes = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        __block UIScene *firstScene = scenes.firstObject;
        [scenes enumerateObjectsUsingBlock:^(UIScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 转屏需要使用 role = UIWindowSceneSessionRoleApplication 的Scene，当取到其他Scene时，会转屏失败
            if ([obj.session.role isEqualToString:UIWindowSceneSessionRoleApplication]) {
                firstScene = obj;
                *stop = YES;
            }
        }];
        if (![firstScene isKindOfClass:[UIWindowScene class]]) {
            NSString *errMsg = [NSString stringWithFormat:@"Unexpected first scene, scenes: %@", scenes];
            MOLog(@"%@", errMsg);
            if (completion) {
                completion([NSError errorWithDomain:@"MODemo" code:0 userInfo:@{NSLocalizedDescriptionKey: errMsg}]);
            }
            return;
        }
        UIWindowScene *windowScene = (UIWindowScene *)firstScene;
        UIInterfaceOrientationMask mask = 1 << orientation;
        UIWindowSceneGeometryPreferencesIOS *preferences = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:mask];
        __block NSError *err = nil;
        [windowScene requestGeometryUpdateWithPreferences:preferences errorHandler:^(NSError * _Nonnull error) {
            NSString *errMsg = [NSString stringWithFormat:@"request geometry error: %@", error];
            MOLog(@"%@", errMsg);
            err = [NSError errorWithDomain:@"MODemo" code:0 userInfo:@{NSLocalizedDescriptionKey: errMsg}];
            if (completion) {
                completion(error);
            }
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MOLog(@"request geometry delay callback request: %@ result: %@",
                  MODeviceOrientationDescription(orientation),
                  MOInterfaceOrientationDescription([windowScene.effectiveGeometry interfaceOrientation]));
            if (completion) {
                completion(err);
            }
        });
    } else {
        [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
        if (completion) {
            completion(nil);
        }
    }
#else
    /* Preprocess macro for compiling on Xcode13 */
    [[UIDevice currentDevice] setValue:@(orientation) forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(nil);
        }
    });
#endif
}

@interface MOScreenRotationViewController ()

@end

@implementation MOScreenRotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rotationLandspaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationLandspaceBtn setTitle:@"强制旋转到横屏" forState:UIControlStateNormal];
    [rotationLandspaceBtn addTarget:self action:@selector(clickedRotationLandspace:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationLandspaceBtn];
    [rotationLandspaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(100));
        make.width.mas_equalTo(@(200));
        make.height.mas_equalTo(@(50));
    }];
    
    UIButton *rotationPortraitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationPortraitBtn setTitle:@"强制旋转到竖屏" forState:UIControlStateNormal];
    [rotationPortraitBtn addTarget:self action:@selector(clickedRotationPortrait:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationPortraitBtn];
    [rotationPortraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(150));
        make.width.mas_equalTo(@(200));
        make.height.mas_equalTo(@(50));
    }];
}

- (void)clickedRotationLandspace:(UIButton *)sender {
    [self updateDeviceOrientation:UIDeviceOrientationLandscapeRight];
}

- (void)clickedRotationPortrait:(UIButton *)sender {
    [self updateDeviceOrientation:UIDeviceOrientationPortrait];
}

- (void)updateDeviceOrientation:(UIDeviceOrientation)orientation {
    MOLog(@"will update device orientation: %@", MODeviceOrientationDescription(orientation));
    if (orientation == UIDeviceOrientationUnknown) {
        return;
    }
    MOGeometryUpdate(self, orientation, ^(NSError * _Nullable error) {
        if (!error) {
            MOLog(@"screen orientation success: %@", MODeviceOrientationDescription(orientation));
        } else {
            MOLog(@"screen orientation fail: %@", error);
        }
    });
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
