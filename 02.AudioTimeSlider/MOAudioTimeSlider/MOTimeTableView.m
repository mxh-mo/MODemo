//
//  MOTimeTableView.m
//  07.AudioTimeSlider
//
//  Created by moxiaoyan on 2020/6/5.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "MOTimeTableView.h"
#define kLeftSpacing ([UIScreen mainScreen].bounds.size.width/2 - 60)
extern const NSInteger cellHeight;
extern const NSInteger kAudioPlayerLineSpacing;

@interface MOTimeCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UILabel *lb;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIBezierPath *path;

@end
@implementation MOTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _path = [UIBezierPath bezierPath];
        _lb = [[UILabel alloc] initWithFrame:CGRectMake(-4, 36, 40, 20)];
        _lb.textColor = [UIColor grayColor];
        _lb.font = [UIFont systemFontOfSize:10];
        _lb.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self.contentView addSubview:_lb];
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, ceil(cellHeight/3))];
        _view.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view];
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    NSInteger n = 30 * _index;
    NSInteger m = n / 60;
    NSInteger s = n % 60;
    _lb.text = [NSString stringWithFormat:@"%02d:%02d", m, s];
    [_view setHidden:(index != 0)];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [_path removeAllPoints];
    CGFloat y = 1;
    for (int i = 0; i < 15; i++) {
        static CGFloat height = 3;
        if (i % 5 == 0) {
            height = 5;
        } else {
            height = 3;
        }
        [_path moveToPoint:CGPointMake(0, y)];
        [_path addLineToPoint:CGPointMake(height, y)];
        y += kAudioPlayerLineSpacing * 2;
    }
    _path.lineWidth = 1.0f;
    [[UIColor grayColor] set];
    [_path stroke];
}

@end

@interface MOTimeTableView () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation MOTimeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.transform = CGAffineTransformMakeRotation(-M_PI/2);
        self.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self registerClass:MOTimeCell.class forCellReuseIdentifier:@"MOTimeCell"];
        [self reloadData];
    }
    return self;
}

- (void)setPoints:(NSArray *)points {
    _points = points;
    [self reloadData];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentify = @"MOTimeCell";
    MOTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (!cell) {
        cell = [[MOTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    cell.index = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.points.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kLeftSpacing;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

@end
