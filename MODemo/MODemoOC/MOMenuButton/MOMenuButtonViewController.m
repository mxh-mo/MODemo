//
//  MOMenuButtonViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOMenuButtonViewController.h"
#import "MODemo-Swift.h"
#define kImgNamed(str) [UIImage imageNamed:str]

@interface MOMenuButtonViewController () <KYButtonDelegate>

@end

@implementation MOMenuButtonViewController {
    KYButton *_button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    // Do any additional setup after loading the view, typically from a nib.
    _button = [[KYButton alloc] initWithFrame:CGRectMake(200, 400, 100, 100)];
    [_button setBackgroundImage:[UIImage imageNamed:@"icon_add_circle"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"icon_add_circle_highlight"] forState:UIControlStateHighlighted];
    _button.kyDelegate = self;
    //  _button.fabTitleColor = [UIColor cyanColor];
    [_button addWithTitle:@"普通帖" titleColor:UIColor.blueColor image:kImgNamed(@"icon_add_circle_text") highlightImage:kImgNamed(@"icon_add_circle_text_highlight") handle:^(KYButtonCells *btn) {
        NSLog(@"1");
    }];
    [_button addWithTitle:@"需求帖" titleColor:UIColor.blueColor image:kImgNamed(@"icon_add_circle_demand") highlightImage:kImgNamed(@"icon_add_circle_demand_highlight") handle:^(KYButtonCells *btn) {
        NSLog(@"2");
    }];
    [self.view addSubview:_button];
}

#pragma mark - KYButtonDelegate

- (void)openKYButton:(KYButton *)button {
    [_button setBackgroundImage:[UIImage imageNamed:@"icon_add_circle_open"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"icon_add_circle_open_highlight"] forState:UIControlStateHighlighted];
}

- (void)closeKYButton:(KYButton *)button {
    [_button setBackgroundImage:[UIImage imageNamed:@"icon_add_circle"] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageNamed:@"icon_add_circle_highlight"] forState:UIControlStateHighlighted];
}

@end
