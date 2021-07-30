//
//  MOTitleLineView.h
//  MOTitleLineView
//
//  Created by MikiMo on 15/12/17.
//  Copyright © 2015年 莫小言. All rights reserved.
//

#import <UIKit/UIKit.h>

// title 对齐type
typedef NS_ENUM(NSUInteger, MOTitleLineViewType) {
    MOTitleLineViewTypeLeft,
    MOTitleLineViewTypeCenter
};

//声明协议
@protocol MOTitleLineViewDelegate <NSObject>

// 标题按钮点击事件 从0开始
- (void)selectedIndex:(NSUInteger)index;

@end

@interface MOTitleLineView : UIView

@property(nonatomic, strong) NSArray *titles; //标题数组
@property(nonatomic, assign) NSUInteger currentIndex; //当前选中的按钮 从0开始
@property(nonatomic, assign) NSInteger buttonMargin;  //button左右边距
@property(nonatomic, assign) NSInteger lineBottomMargin;  //line跟底部间距
@property(nonatomic, assign) NSInteger lineMargin;  //line跟 button width 的缩进距离
@property(nonatomic, weak) id<MOTitleLineViewDelegate> delegate;

- (instancetype)initWithType:(MOTitleLineViewType)type normalColor:(UIColor *) normalColor selectedColor:(UIColor *)selectedColor font:(UIFont *)font;

+ (MOTitleLineView *)titleAndLineViewWithType:(MOTitleLineViewType)type normalColor:(UIColor *) normalColor selectedColor:(UIColor *)selectedColor font:(UIFont *)font;

// 外界需要改变当前scrollView的frame
- (void)updateSize:(CGSize)size;

// 外界需要UI改变 不调用代理方法
- (void)changeIndex:(NSInteger)index;

@end

