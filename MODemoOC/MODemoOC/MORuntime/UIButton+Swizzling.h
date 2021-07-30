//
//  UIButton+Swizzling.h
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Swizzling)

@property (nonatomic, assign) BOOL isIgnore; // 用于设置单个按钮不需要被hook
@property (nonatomic, assign) NSTimeInterval timeInterval; // 点击间隔

@end

NS_ASSUME_NONNULL_END
