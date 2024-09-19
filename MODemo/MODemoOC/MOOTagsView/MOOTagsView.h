//
//  MOOTagsView.h
//  MODemo
//
//  Created by mikimo on 2024/9/14.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MOOTag;
@class MOOTagsView;

typedef void(^MOOTagClickedHandler)(MOOTag *tag);

@interface MOOTag : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;

/// 点击回调
@property (nonatomic, copy) MOOTagClickedHandler clickedHandler;

/// 缓存自适应尺寸
@property (nonatomic, assign) CGSize size;

/// 布局
@property (nonatomic, assign) CGRect frame;

/// 指定初始化方法
- (instancetype)initWithTitle:(NSString *)title
               clickedHandler:(MOOTagClickedHandler)clickedHandler NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

// 标签视图类型
typedef NS_ENUM(NSUInteger, MOOTagsViewType) {
    MOOTagsViewTypeBar, // 标签栏，支持横滑
    MOOTagsViewTypeList, // 标签列表，显示所有数据，不支持滑动
};

@protocol MOOTagsViewDelegate <NSObject>

/// 高度回调
- (void)receiveTagsView:(MOOTagsView *)tagsView
                 height:(CGFloat)height;

/// 点击 展开/收起 按钮 回调
- (void)receiveTagsView:(MOOTagsView *)tagsView
            clickButton:(UIButton *)button;

@end

@interface MOOTagsView : UIView

/// 标签数据源
@property (nonatomic, strong) NSArray<MOOTag *> *categories;

/// 当期选中
@property (nonatomic, assign) NSUInteger selectedIndex;

/// 事件代理
@property (nonatomic, weak) id<MOOTagsViewDelegate> delegate;

/// 滑动视图
@property (nonatomic, readonly) UIScrollView *scrollView;

/// 指定初始方法
- (instancetype)initWithType:(MOOTagsViewType)type NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
