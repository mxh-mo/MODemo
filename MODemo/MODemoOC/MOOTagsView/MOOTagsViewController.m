//
//  MOOTagsViewController.m
//  MODemo
//
//  Created by mikimo on 2024/9/19.
//  Copyright © 2024 Mobi Technology. All rights reserved.
//

#import "MOOTagsViewController.h"
#import "MOOTagsView.h"

/// 为了动画流畅，间距大小符合一致，列表视图左对齐，所以需要创建两个实例
@interface MOOTagsViewController () <MOOTagsViewDelegate>

/// 标签栏视图
@property (nonatomic, strong) MOOTagsView *tagBarView;

/// 标签列表视图
@property (nonatomic, strong) MOOTagsView *tagListView;

@end

@implementation MOOTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tagBarView];
    self.tagBarView.frame = CGRectMake(0.0, 100.0, CGRectGetWidth(self.view.bounds), 48.0);
    
    [self.view addSubview:self.tagListView];
    self.tagListView.frame = CGRectMake(0.0, 100.0, CGRectGetWidth(self.view.bounds), 135.0);
    
    [self reloadData]; // 加载数据
    [self foldTagsView]; // 默认折叠态
}

- (void)reloadData {
    NSArray<MOOTag *> *tags = [self mockTags];
    self.tagBarView.categories = tags;
    self.tagListView.categories = tags;
}

- (NSArray<MOOTag *> *)mockTags {
    NSArray<NSString *> *titles = @[@"全部", @"电视剧", @"电影", @"动漫", @"综艺", @"纪录片", @"少儿", @"短剧", @"短番", @"短节目", @"短视频", @"直播", @"小说"];
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:titles.count];
    __weak typeof(self) weakSelf = self;
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MOOTag *model = [[MOOTag alloc] initWithTitle:obj
                                                             clickedHandler:^(MOOTag * _Nonnull category) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.tagBarView.selectedIndex = idx;
            strongSelf.tagListView.selectedIndex = idx;
        }];
        [tags addObject:model];
    }];
    return [tags copy];
}

- (void)unfoldTagsView {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.tagBarView.alpha = 0.0;
        self.tagListView.alpha = 1.0;
    } completion:nil];
    [UIView animateWithDuration:0.1
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.tagListView.scrollView.alpha = 1.0;
    } completion:nil];
}

- (void)foldTagsView {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.tagBarView.alpha = 1.0;
        self.tagListView.alpha = 0.0;
    } completion:nil];
}

#pragma mark - MOOTagsViewDelegate

- (void)receiveTagsView:(MOOTagsView *)tagsView
                 height:(CGFloat)height {
    if (![tagsView isEqual:self.tagListView]) {
        return;
    }
    NSLog(@"receive height: %@", @(height));
    self.tagListView.frame = CGRectMake(0.0,
                                        100.0,
                                        CGRectGetWidth(self.view.bounds),
                                        height);
    [self.view setNeedsLayout];
}

- (void)receiveTagsView:(MOOTagsView *)tagsView
            clickButton:(UIButton *)button {
    if ([tagsView isEqual:self.tagBarView]) {
        [self unfoldTagsView];
    } else if ([tagsView isEqual:self.tagListView]) {
        [self foldTagsView];
    }
}

- (MOOTagsView *)tagBarView {
    if (!_tagBarView) {
        MOOTagsView *view = [[MOOTagsView alloc] initWithType:MOOTagsViewTypeBar];
        view.delegate = self;
        view.alpha = 0.0;
        _tagBarView = view;
    }
    return _tagBarView;
}

- (MOOTagsView *)tagListView {
    if (!_tagListView) {
        MOOTagsView *view = [[MOOTagsView alloc] initWithType:MOOTagsViewTypeList];
        view.scrollView.alpha = 0.0;
        view.delegate = self;
        view.alpha = 0.0;
        _tagListView = view;
    }
    return _tagListView;
}

@end
