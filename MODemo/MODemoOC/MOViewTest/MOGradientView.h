//
//  MOGradientView.h
//  MODemo
//
//  Created by mikimo on 2024/3/26.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MOGradientView : UIView

/// 渐变 view layer
@property (nonatomic, strong, readonly) CAGradientLayer *gradientLayer;

@end

NS_ASSUME_NONNULL_END
