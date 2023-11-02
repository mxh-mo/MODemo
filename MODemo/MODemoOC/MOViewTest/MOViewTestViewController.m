//
//  MOViewTestViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import <Masonry/Masonry.h>

#import "MOViewTestViewController.h"
#import "MOTitleLineView.h"
#import "MOFollowLightView.h"
#import "MOGradientRollLabelView.h"

@interface MOViewTestViewController () <MOTitleLineViewDelegate>

@end

@implementation MOViewTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    // UILabel 耐压缩 测试
    [self labelCompressionResistance];
    // segment view
    [self titleAndLineView];
    // 追光动效
    [self followLightView];
    // 渐变滚动label
//    [self gradientRollLabelView];
}

- (void)gradientRollLabelView {
    MOGradientRollLabelView *view = [[MOGradientRollLabelView alloc] initWithFrame:CGRectMake(50, 150, 300, 48)];
    [self.view addSubview:view];
}

#pragma mark - 追光动效

- (void)followLightView {
    CGRect imageFrame = CGRectMake(20, 220, 300, 188);
    CGFloat borderWidth = 10.0;
    MOFollowLightView *view = [[MOFollowLightView alloc] initWithFrame:CGRectMake(imageFrame.origin.x - borderWidth,
                                                                                  imageFrame.origin.y - borderWidth,
                                                                                  imageFrame.size.width + borderWidth * 2,
                                                                                  imageFrame.size.height + borderWidth * 2)];
    [self.view addSubview:view];
}

#pragma mark - titleAndLineView

- (void)titleAndLineView {
    MOTitleLineView *_titleView = [MOTitleLineView titleAndLineViewWithType:MOTitleLineViewTypeLeft normalColor:[UIColor lightGrayColor] selectedColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:14]];
    _titleView.frame = CGRectMake(12, 150, self.view.frame.size.width - 24, 50);
    _titleView.delegate = self;
    _titleView.buttonMargin = 10;
    _titleView.lineBottomMargin = 10;
    _titleView.lineMargin = 4;
    [self.view addSubview:_titleView];
    _titleView.backgroundColor = [UIColor redColor];
    
    _titleView.titles = @[@"swift", @"Objective-C", @"iOS", @"Android", @"Windows", @"macOS"];
    
    _titleView.frame = CGRectMake(12, 150, self.view.frame.size.width - 24, 50);
    // titleView的frame修改后, 需要更新scrollView的frame
    [_titleView updateSize:_titleView.frame.size];
}

#pragma mark - MOTitleLineViewDelegate

- (void)selectedIndex:(NSUInteger)index {
    NSLog(@"selectedIndex:%lu", (unsigned long)index);
}

// MARK: - UILabel 耐压缩 测试

- (void)labelCompressionResistance {
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:leftLabel];
    leftLabel.text = @"人做的阿唉";
    //    [leftLabel sizeToFit];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightLabel];
    rightLabel.text = @"1234567890";
    //    [rightLabel sizeToFit];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.height.equalTo(@(20));
        make.left.equalTo(self.view).offset(10);
        //        make.right.mas_lessThanOrEqualTo(rightLabel.mas_left);
        make.right.equalTo(rightLabel.mas_left).offset(-20);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        //        make.left.mas_greaterThanOrEqualTo(leftLabel.mas_right);
        make.left.equalTo(leftLabel.mas_right).offset(20);
        make.right.equalTo(self.view).offset(-10);
        make.centerY.equalTo(leftLabel);
    }];
    
    // UILayoutPriorityRequired 1000
    // UILayoutPriorityDefaultHigh 750
    // UILayoutPriorityDefaultLow 250
    // UILayoutPriorityFittingSizeLevel 50
    // 抗压缩力 默认750
    // 抗拉伸力 默认250
    
    // 降低left的 抗压缩力
    [leftLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    // 提高right的 抗压缩力
    [rightLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    // 降低left的 抗拉伸力
    [leftLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
    
    // 降低right的 抗拉伸力
    [rightLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
}

@end
