//
//  UITableView+Placeholder.h
//  04.Runtime
//
//  Created by moxiaoyan on 2020/2/24.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOPlaceholderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Placeholder)

@property (nonatomic, assign) MOPlaceholderState state;
@property (nonatomic, strong) MOPlaceholderView *placeholderView;
@property (nonatomic, copy) void(^reloadBlock)(void);

@end

NS_ASSUME_NONNULL_END
