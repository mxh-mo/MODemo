//
//  MOPlaceholderView.h
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MOPlaceholderState) {
  MOPlaceholderNormalState,
  MOPlaceholderLoadingState,
  MOPlaceholderNoNetworkState,
  MOPlaceholderNoDataState,
};

@interface MOPlaceholderView : UIView

@property (nonatomic, assign) MOPlaceholderState state;
@property (nonatomic, copy) void(^reloadClickBlock)(void);

@end

NS_ASSUME_NONNULL_END
