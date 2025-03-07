//
//  MOOLocalizableViewController.m
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import "MOOLocalizableViewController.h"
#import "MOOLocalizableManager.h"
#import <Masonry/Masonry.h>

@interface MOOLocalizableViewController ()

@property (nonatomic, strong) UIButton *englishButton;

@property (nonatomic, strong) UIButton *chineseButton;

@end

@implementation MOOLocalizableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadViews];
}

- (void)reloadViews {
    [self.englishButton removeFromSuperview];
    [self.chineseButton removeFromSuperview];
    self.englishButton = nil;
    self.chineseButton = nil;
    [self.view addSubview:self.englishButton];
    [self.englishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100.0);
        make.left.mas_equalTo(16.0);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(100.0);
    }];
    
    [self.view addSubview:self.chineseButton];
    [self.chineseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100.0);
        make.left.equalTo(self.englishButton.mas_right).offset(4.0);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(100.0);
    }];
}

- (void)changeLanguage:(MOOLocalizableLanguage)language {
    [[MOOLocalizableManager sharedInstance] updateLanguage:language];
    [self reloadViews];
}

- (void)clickEnglish {
    [self changeLanguage:MOOLocalizableLanguageEnglish];
}

- (void)clickChinese {
    [self changeLanguage:MOOLocalizableLanguageChinese];
}

- (UIButton *)englishButton {
    if (!_englishButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:MOOLocalizableString(@"English") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickEnglish) forControlEvents:UIControlEventTouchUpInside];
        _englishButton = button;
    }
    return _englishButton;
}

- (UIButton *)chineseButton {
    if (!_chineseButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:MOOLocalizableString(@"Chinese") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickChinese) forControlEvents:UIControlEventTouchUpInside];
        _chineseButton = button;
    }
    return _chineseButton;
}

@end
