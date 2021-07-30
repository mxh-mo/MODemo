//
//  MOWaveTableView.m
//  07.AudioTimeSlider
//
//  Created by moxiaoyan on 2020/6/5.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "MOWaveTableView.h"
#define kLeftSpacing ([UIScreen mainScreen].bounds.size.width/2 - 60)

extern const NSInteger cellHeight;
static const NSInteger height = 18;
extern const NSInteger kAudioPlayerLineSpacing;

@interface MOWaveCell : UITableViewCell

@property (nonatomic, copy) void(^lastBlankHeight)(CGFloat height);
@property (nonatomic, strong) UILabel *lb;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSArray *points;

- (void)setIndex:(NSInteger)index points:(NSArray *)points;

@end

@implementation MOWaveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor cyanColor];
        _lb = [[UILabel alloc] initWithFrame:CGRectMake(-4, 36, 40, 20)];
        _lb.textColor = [UIColor grayColor];
        _lb.font = [UIFont systemFontOfSize:10];
        _lb.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self.contentView addSubview:_lb];
        _path = [UIBezierPath bezierPath];
    }
    return self;
}

- (void)setIndex:(NSInteger)index points:(NSArray *)points {
    _index = index;
    _points = points;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_path removeAllPoints];
    CGFloat y = _index == 0 ? ceil(cellHeight/3) + 2 : 1;
    CGFloat midX = CGRectGetMidX(rect);
    for (int i = 0; i < _points.count; i++) {
        NSNumber *n = _points[i];
        CGFloat length = n.floatValue * height;
        [_path moveToPoint:CGPointMake(midX - length, y)];
        [_path addLineToPoint:CGPointMake(midX + length, y)];
        y += kAudioPlayerLineSpacing;
    }
    if (self.lastBlankHeight) {
        self.lastBlankHeight(rect.size.height - y + kAudioPlayerLineSpacing);
    }
    _path.lineWidth = 1.0f;
    [[UIColor blueColor] set];
    [_path stroke];
}
@end

@interface MOWaveTableView () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *footerView;

@end

@implementation MOWaveTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
        self.dataSource = self;
        self.delegate = self;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self registerClass:MOWaveCell.class forCellReuseIdentifier:@"MOWaveCell"];
    }
    return self;
}

- (void)setPoints:(NSArray *)points {
    _points = points;
    [self reloadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(contentOffsetY:)]) {
        [self.scrollDelegate contentOffsetY:scrollView.contentOffset.y];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(willBeginDragging)]) {
        [self.scrollDelegate willBeginDragging];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollDelegate && [self.scrollDelegate respondsToSelector:@selector(didEndDraggingY:)]) {
        // 拖拽最终停留位置
        [self.scrollDelegate didEndDraggingY:scrollView.contentOffset.y];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // 去掉滑动惯性
    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentify = @"MOWaveCell";
    MOWaveCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (!cell) {
        cell = [[MOWaveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    NSArray *points = self.points[indexPath.row];
    [cell setIndex:indexPath.row points:points];
    if (indexPath.row == self.points.count - 1) { // 最后一个
        __weak typeof(self) weakSelf = self;
        cell.lastBlankHeight = ^(CGFloat height) {
            weakSelf.footerView.frame = CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.rightSpace - height);
            weakSelf.tableFooterView = weakSelf.footerView;
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.points.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kLeftSpacing;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor cyanColor];
    }
    return _footerView;
}

@end
