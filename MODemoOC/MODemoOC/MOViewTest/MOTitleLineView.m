//
//  MOTitleLineView.m
//  MOTitleLineView
//
//  Created by MikiMo on 15/12/17.
//  Copyright © 2015年 莫小言. All rights reserved.
//

#import "MOTitleLineView.h"
#define kBaseTag (10000)
#define kSelfHeight (self.frame.size.height)
#define kSelfWidth (self.frame.size.width)
#define kCenterTypeBtnWidth (kSelfWidth / self.titles.count)

@interface MOTitleLineView () <UIScrollViewDelegate>

@property(nonatomic, assign) MOTitleLineViewType type;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *line;
@property(nonatomic, strong) UIColor *normalColor;
@property(nonatomic, strong) UIColor *selectedColor;
@property(nonatomic, strong) UIFont *font;

@end

@implementation MOTitleLineView

+ (MOTitleLineView *)titleAndLineViewWithType:(MOTitleLineViewType)type normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor font:(UIFont *)font {
    return [[MOTitleLineView alloc] initWithType:type normalColor:normalColor selectedColor:selectedColor font:font];
}

- (instancetype)initWithType:(MOTitleLineViewType)type normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor font:(UIFont *)font {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.type = type;
        self.normalColor = normalColor;
        self.selectedColor = selectedColor;
        self.font = font;
        _currentIndex = 0;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)setTitles:(NSArray *)titlesArray {
    _titles = titlesArray;
    [self createTitleButton];
}

- (void)createTitleButton {
    // 移除scrollView上的buttons
    while (self.scrollView.subviews.count) {
        [self.scrollView.subviews.lastObject removeFromSuperview];
    }
    CGFloat scrollWidth = 0;
    if (self.type == MOTitleLineViewTypeCenter) {
        self.scrollView.scrollEnabled = NO;
        self.scrollView.contentSize = self.scrollView.frame.size;
    }
    
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = self.font;
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        btn.tag = i + kBaseTag;
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.type == MOTitleLineViewTypeCenter) {
            btn.frame = CGRectMake(i * kCenterTypeBtnWidth, 0, kCenterTypeBtnWidth, kSelfHeight - 2);
        } else {
            CGFloat width = [self widthOfLineWithTitle:self.titles[i] font:self.font] + 2*self.buttonMargin;
            btn.frame = CGRectMake(scrollWidth, 0, width, kSelfHeight - 2);
            scrollWidth += width; //所有标题自适应宽度和
        }
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(scrollWidth, kSelfHeight);
    [self.scrollView addSubview:self.line];
    // 设置默认选中的按钮
    UIButton *btn = [self.scrollView viewWithTag:_currentIndex + kBaseTag];
    btn.selected = !btn.selected;
    [self changedOffsentWithBtn:btn];
    
    // 代理执行协议方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:_currentIndex];
    }
}

- (void)changedOffsentWithBtn:(UIButton *)btn {
    CGFloat width;
    if (self.type == MOTitleLineViewTypeCenter) {
        width = kSelfWidth / self.titles.count;
    } else {
        width = [self widthOfLineWithTitle:[btn titleForState:UIControlStateNormal] font:self.font];
    }
    // 改变line的位置
    // 根据当前btn中心,算出line的x
    CGFloat x = btn.center.x - width / 2;
    [UIView animateWithDuration:0.2 animations:^{
        self.line.frame = CGRectMake(x + self.lineMargin, kSelfHeight - 2 - self.lineBottomMargin, width - 2*self.lineMargin, 2);
    }];
    
    // 判断scrollView 是否需要滑动
    CGFloat startX = CGRectGetMinX(btn.frame);
    CGFloat endX = CGRectGetMaxX(btn.frame);
    if (startX < self.scrollView.contentOffset.x) {
        if (btn.tag - kBaseTag != 0) {
            UIButton *formerBtn = [self.scrollView viewWithTag:btn.tag - 1];
            [self.scrollView setContentOffset:CGPointMake(CGRectGetMinX(formerBtn.frame), 0) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    CGFloat maxOffset = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (endX > self.scrollView.contentOffset.x + self.scrollView.frame.size.width) {
        if (startX > maxOffset) {
            [self.scrollView setContentOffset:CGPointMake(maxOffset, 0) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(startX - 10, 0) animated:YES];
        }
    }
}

#pragma mark - left button的点击方法

- (void)clickButton:(UIButton *)sender {
    // 如果点击的是当前选中的按钮, 跳出该方法
    if (sender.tag == _currentIndex + kBaseTag) {
        return;
    }
    // 取消上一个选中
    UIButton *formerBtn = [self.scrollView viewWithTag:_currentIndex + kBaseTag];
    formerBtn.selected = !formerBtn.selected;
    
    // 选中当前点击的btn
    _currentIndex = sender.tag - kBaseTag;
    sender.selected = !sender.selected;
    [self changedOffsentWithBtn:sender];
    
    // 代理执行协议方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:_currentIndex];
    }
}

#pragma mark - 外界需要改变当前view的frame

- (void)updateSize:(CGSize)size {
    self.scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.scrollView layoutIfNeeded];
    UIButton *btn = [self.scrollView viewWithTag:_currentIndex + kBaseTag];
    if ([btn isKindOfClass:UIButton.class]) {
        [self changedOffsentWithBtn:btn];
    }
}

#pragma mark - 外界需要UI改变 不调用代理方法

- (void)changeIndex:(NSInteger)index {
    UIButton *btn = [self.scrollView viewWithTag:index + kBaseTag];
    if (!btn) {
        return;
    }
    btn.selected = !btn.selected;
    
    // 获得上一个按钮
    UIButton *formerBtn = [self.scrollView viewWithTag:_currentIndex + kBaseTag];
    formerBtn.selected = !formerBtn.selected;
    
    // 当前按钮 指定为 点击的按钮
    _currentIndex = index;
    
    [self changedOffsentWithBtn:btn];
}

#pragma mark -- 自适应宽度

- (CGFloat)widthOfLineWithTitle:(NSString *)title font:(UIFont *)font {
    // line的显示范围
    CGSize size = CGSizeMake(MAXFLOAT, 2);
    // 设置要显示的文本样式
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    // 根据文本内容,文本样式 计算line的frame
    CGRect frame = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    // 返回line的宽度
    return frame.size.width;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView addSubview:self.line];
    }
    return _scrollView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = self.selectedColor;
    }
    return _line;
}

@end
