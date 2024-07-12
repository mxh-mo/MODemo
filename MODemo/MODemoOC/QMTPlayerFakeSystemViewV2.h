//
//  QMTPlayerFakeSystemViewV2.h
//  QMTPluginKitiOS
//
//  Created by mikimo on 2024/7/9.
//  Copyright © 2024 Tencent Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, QMTPlayerFakeSystemViewType) {         //模拟系统控件类型
    QMTPlayerFakeSystemViewType_Volume = 1,                       //音量
    QMTPlayerFakeSystemViewType_Brigtness = 2,                    //亮度
};

@interface QMTPlayerFakeSystemViewV2 : UIView

/// 展示视图
/// - Parameters:
///   - type: 音量 or 亮度
///   - progress: 进度
///   - fullScreen: 全屏 or 小屏
///   - maxStyle: 最大态 or 缩小态
- (void)displayWithType:(QMTPlayerFakeSystemViewType)type
               progress:(CGFloat)progress
             fullScreen:(BOOL)fullScreen
               maxStyle:(BOOL)maxStyle;

/// 消失视图
/// - Parameter complete: 消失完成回调
- (void)dismissWithComplete:(void(^)(void))complete;

@end

NS_ASSUME_NONNULL_END
