//
//  MOOTagsView.m
//  MODemo
//
//  Created by mikimo on 2024/9/14.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

#import "MOOTagsView.h"

static CGFloat const MOOTagsViewTopPadding = 4.0;
static CGFloat const MOOTagsViewPadding = 16.0;
static CGFloat const MOOTagsViewItemHeight = 28.0;
static CGFloat const MOOTagsViewFoldBtnTopMarginBarType = 10.0;
static CGFloat const MOOTagsViewFoldBtnLeftMarginBarType = 3.0;
static CGFloat const MOOTagsViewFoldBtnLeftMarginListType = 12.0;
static CGFloat const MOOTagsViewFoldButtonSize = 16.0;
static CGFloat const MOOTagsViewMaskWidth = 24.0;
static NSUInteger const MOOTagsViewButtonBaseTag = 10000;

@implementation MOOTag

- (instancetype)initWithTitle:(NSString *)title
               clickedHandler:(MOOTagClickedHandler)clickedHandler {
    self = [super init];
    if (self) {
        _title = [title copy];
        _clickedHandler = [clickedHandler copy];
    }
    return self;
}

- (CGSize)size {
    if (CGSizeEqualToSize(_size, CGSizeZero)) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = self.title;
        label.font = [UIFont systemFontOfSize:12.0];
        CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, MOOTagsViewItemHeight)];
        _size = CGSizeMake(size.width + 32.0, MOOTagsViewItemHeight);
    }
    return _size;
}

@end

@interface MOOTagsView()

/// 视图类型（展开/收起）
@property (nonatomic, assign) MOOTagsViewType type;

/// 滑动视图
/// 为什么没有使用 collectionView？因为 bar 和 list 样式的 尺寸 和 间距 无法对齐，导致动画不流畅（list样式的item需要左对齐）
@property (nonatomic, strong) UIScrollView *scrollView;

/// 展开/收起 按钮
@property (nonatomic, strong) UIButton *foldButton;

/// 渐变蒙层（for bar）
@property (nonatomic, strong) CAGradientLayer *maskLayer;

/// 缓存按钮
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;

/// 选中的tag
@property (nonatomic, assign) CGFloat selectedTag;

@end

@implementation MOOTagsView

- (instancetype)initWithType:(MOOTagsViewType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _type = type;
        _selectedTag = MOOTagsViewButtonBaseTag;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.foldButton];
        if (self.type == MOOTagsViewTypeBar) {
            [self.layer addSublayer:self.maskLayer];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIScrollView *scrollView = self.scrollView;
    UIButton *foldButton = self.foldButton;
    CGFloat contentWidth = CGRectGetWidth(self.bounds);
    CGFloat contentHeight = CGRectGetHeight(self.bounds);
    if (self.type == MOOTagsViewTypeBar) {
        /// 滑动视图右侧 距离 容器右侧的宽度
        CGFloat btnLeftToContentRight = MOOTagsViewPadding + MOOTagsViewFoldButtonSize + MOOTagsViewFoldBtnLeftMarginBarType;
        
        scrollView.frame = CGRectMake(0.0,
                                      MOOTagsViewTopPadding,
                                      contentWidth - btnLeftToContentRight,
                                      contentWidth - MOOTagsViewPadding);
        
        foldButton.frame = CGRectMake(contentWidth - btnLeftToContentRight,
                                      MOOTagsViewFoldBtnTopMarginBarType,
                                      MOOTagsViewFoldButtonSize,
                                      MOOTagsViewFoldButtonSize);
        
        CAGradientLayer *maskLayer = self.maskLayer;
        maskLayer.frame = CGRectMake(CGRectGetMinX(foldButton.frame) - MOOTagsViewMaskWidth,
                                     0.0,
                                     MOOTagsViewMaskWidth,
                                     contentHeight);
    } else {
        scrollView.frame = CGRectMake(0.0,
                                      MOOTagsViewTopPadding,
                                      contentWidth,
                                      contentHeight - MOOTagsViewTopPadding - MOOTagsViewFoldBtnLeftMarginListType);
        foldButton.frame = CGRectMake(contentWidth - MOOTagsViewPadding - MOOTagsViewFoldButtonSize,
                                      contentHeight - MOOTagsViewPadding - MOOTagsViewFoldButtonSize,
                                      MOOTagsViewFoldButtonSize, MOOTagsViewFoldButtonSize);
    }
}

- (void)setCategories:(NSArray<MOOTag *> *)categories {
    _categories = [categories copy];
    [self reloadData];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.selectedIndex = selectedIndex;
        });
    }
    
    UIButton *preButton = [self.scrollView viewWithTag:self.selectedIndex + MOOTagsViewButtonBaseTag];
    [self updateButton:preButton toSelected:NO];
    UIButton *curButton = [self.scrollView viewWithTag:selectedIndex + MOOTagsViewButtonBaseTag];
    [self updateButton:curButton toSelected:YES];
    _selectedIndex = selectedIndex;
    
    if (self.type == MOOTagsViewTypeBar) {
        [self scrollToSelectedButton:curButton];
    }
}

#pragma mark - Private Methods

/// 滑动到选中的按钮
- (void)scrollToSelectedButton:(UIButton *)button {
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    CGFloat contentWidth = self.scrollView.contentSize.width;
    CGFloat centerX = CGRectGetMidX(button.frame) - (width / 2.0);
    if (centerX < 0.0) {
        centerX = 0.0;
    } else if (centerX > contentWidth - width) {
        centerX = contentWidth - width;
    }
    [self.scrollView setContentOffset:CGPointMake(centerX, 0.0) animated:YES];
}

- (void)reloadData {
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }
    [self.scrollView.subviews enumerateObjectsWithOptions:NSEnumerationReverse
                                               usingBlock:^(__kindof UIView * _Nonnull obj,
                                                            NSUInteger idx,
                                                            BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    __block CGFloat contentWidth = MOOTagsViewPadding;
    __block CGFloat itemOriginY = 0.0;
    __weak typeof(self) weakSelf = self;
    [self.categories enumerateObjectsUsingBlock:^(MOOTag * _Nonnull obj,
                                                  NSUInteger idx,
                                                  BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIButton *button = nil;
        if (idx < strongSelf.buttons.count) {
            button = [strongSelf.buttons objectAtIndex:idx];
        } else {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0];
            button.layer.cornerRadius = MOOTagsViewItemHeight / 2.0;
            button.layer.masksToBounds = YES;
            [strongSelf.buttons addObject:button]; // 缓存按钮避免频繁创建
        }
        [button setTitle:obj.title forState:UIControlStateNormal];
        [strongSelf updateButton:button toSelected:idx == strongSelf.selectedIndex];
        [button addTarget:strongSelf action:@selector(clickedButton:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = MOOTagsViewButtonBaseTag + idx;
        
        CGRect frame = CGRectZero;
        if (strongSelf.type == MOOTagsViewTypeBar) {
            frame = CGRectMake(contentWidth, 0.0, obj.size.width, obj.size.height);
            contentWidth += obj.size.width + MOOTagsViewPadding;
        } else {
            // 按钮右侧X轴坐标值
            CGFloat maxX = contentWidth + obj.size.width + MOOTagsViewPadding;
            if (idx == strongSelf.categories.count - 1) { // 若为最后一个，需要给收起按钮留空间
                maxX += MOOTagsViewFoldBtnLeftMarginListType + MOOTagsViewFoldButtonSize;
            }
            if (maxX > CGRectGetWidth(strongSelf.bounds)) { // 若超出宽度，则另起一行
                contentWidth = MOOTagsViewPadding;
                itemOriginY += MOOTagsViewItemHeight + MOOTagsViewPadding;
            }
            frame = CGRectMake(contentWidth, itemOriginY, obj.size.width, obj.size.height);
            contentWidth += obj.size.width + MOOTagsViewPadding;
        }
        button.frame = frame;
        obj.frame = frame;
        
        [strongSelf.scrollView addSubview:button];
    }];
    
    CGFloat contentHeight = itemOriginY + MOOTagsViewItemHeight;
    self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
    
    [self callbackHeightIfNeed];
}

- (void)callbackHeightIfNeed {
    if (self.type != MOOTagsViewTypeList) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(receiveTagsView:height:)]) {
        return;
    }
    // 回调高度，使其自适应高度
    CGFloat height = self.scrollView.contentSize.height + MOOTagsViewTopPadding + MOOTagsViewPadding;
    [self.delegate receiveTagsView:self height:height];
}

- (void)updateButton:(UIButton *)button toSelected:(BOOL)selected {
    if (selected) {
        [button setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.1];
    } else {
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    }
}

- (void)clickedButton:(UIButton *)sender {
    NSUInteger clickedIdex = sender.tag - MOOTagsViewButtonBaseTag;
    if (self.selectedIndex == clickedIdex) {
        return;
    }
    if (clickedIdex >= self.categories.count) {
        return;
    }
    MOOTag *clickTag = [self.categories objectAtIndex:clickedIdex];
    if (clickTag.clickedHandler) {
        clickTag.clickedHandler(clickTag);
    }
    self.selectedIndex = clickedIdex;
}

- (void)clickedArrowButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(receiveTagsView:clickButton:)]) {
        [self.delegate receiveTagsView:self clickButton:sender];
    }
}

#pragma mark - Getter Methods

- (NSMutableArray<UIButton *> *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:self.categories.count];
    }
    return _buttons;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectZero];
        view.showsVerticalScrollIndicator = NO;
        view.showsVerticalScrollIndicator = NO;
        _scrollView = view;
    }
    return _scrollView;
}

- (UIButton *)foldButton {
    if (!_foldButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(clickedArrowButton:)
         forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"moo_arrow"];
        if (self.type == MOOTagsViewTypeList) {
            image = [UIImage imageWithCGImage:image.CGImage
                                        scale:1.0
                                  orientation:UIImageOrientationDown];
        }
        [button setImage:image forState:UIControlStateNormal];
        _foldButton = button;
    }
    return _foldButton;
}

- (CAGradientLayer *)maskLayer {
    if (!_maskLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.colors = @[(__bridge id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor,
                         (__bridge id)[UIColor colorWithWhite:1.0 alpha:1.0].CGColor];
        layer.startPoint = CGPointMake(0.0, 0.0);
        layer.endPoint = CGPointMake(1.0, 0.0);
        _maskLayer = layer;
    }
    return _maskLayer;
}

@end
