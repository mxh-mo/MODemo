//
//  MOOFakeSystemView.h
//  MODemo
//
//  Created by mikimo on 2024/7/9.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 模拟系统控件类型
typedef NS_ENUM(NSInteger, MOOFakeSystemViewType) {
    MOOFakeSystemViewTypeVolume = 1, // 音量
    MOOFakeSystemViewTypeBrigtness = 2,  // 亮度
};

/// 模拟系统 音量/亮度 调节示意图
@interface MOOFakeSystemView : UIView

/// 是小屏，否则全屏
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

/// 顶部安全区域
@property (nonatomic, assign) CGFloat topSafeMargin;

/// 隐藏渐变背景
@property (nonatomic, assign) BOOL hiddenGradientBackground;

/// 展示视图
/// - Parameters:
///   - type: 类型
///   - progress: 进度
///   - isFirst: 是第一次添加到父视图上
- (void)displayWithType:(MOOFakeSystemViewType)type
               progress:(CGFloat)progress
                isFirst:(BOOL)isFirst;

/// 消失视图
/// - Parameter complete: 消失完成回调
- (void)dismissWithComplete:(void(^)(void))complete;

@end

NS_ASSUME_NONNULL_END
