//
//  MOOLocalizableViewController.m
//  MODemo
//
//  Created by mikimo on 2025/3/8.
//  Copyright © 2025 Mobi Technology. All rights reserved.
//

#import "MOOLocalizableViewController.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import "UILabel+MOOLocalizable.h"
#import "UIButton+MOOLocalizable.h"
#import "UITextView+MOOLocalizable.h"
#import "MOOLocalizableManager.h"

@interface MOOLocalizableViewController ()

@property (nonatomic, strong) UIButton *englishButton;

@property (nonatomic, strong) UIButton *chineseButton;

@end

@implementation MOOLocalizableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MOOLocalizableManager sharedInstance]; // 初始化
    
    [self.view addSubview:self.englishButton];
    [self.englishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100.0);
        make.left.mas_equalTo(16.0);
        make.height.mas_equalTo(40.0);
    }];
    
    [self.view addSubview:self.chineseButton];
    [self.chineseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100.0);
        make.left.equalTo(self.englishButton.mas_right).offset(10.0);
        make.height.mas_equalTo(40.0);
    }];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.backgroundColor = [UIColor systemPinkColor];
    textLabel.textLocalizableKey = @"UseLocation";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickUseLocation)];
    [textLabel addGestureRecognizer:tap];
    textLabel.userInteractionEnabled = YES;
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.englishButton.mas_bottom).offset(10.0);
        make.left.mas_equalTo(16.0);
        make.height.mas_equalTo(40.0);
    }];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.backgroundColor = [UIColor systemGreenColor];
    textView.textLocalizableKey = @"textViewText";
    textView.textColor = [UIColor grayColor];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textLabel.mas_bottom).offset(10.0);
        make.left.mas_equalTo(16.0);
        make.height.mas_equalTo(40.0);
        make.width.mas_equalTo(200.0);
    }];
}

- (void)changeLanguage:(MOOLanguage)language {
    [[MOOLocalizableManager sharedInstance] updateLanguage:language];
}

- (void)clickEnglish {
    [self changeLanguage:MOOLanguageEnglish];
}

- (void)clickChinese {
    [self changeLanguage:MOOLanguageChinese];
}

- (void)didClickUseLocation {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"相机权限已授权");
        } else {
            NSLog(@"相机权限被拒绝");
        }
    }];
}

#pragma mark - CLLocationManagerDelegate

- (UIButton *)englishButton {
    if (!_englishButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor cyanColor];
        [button setTitleLocalizableKey:@"English" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickEnglish) forControlEvents:UIControlEventTouchUpInside];
        _englishButton = button;
    }
    return _englishButton;
}

- (UIButton *)chineseButton {
    if (!_chineseButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor systemGreenColor];
        [button setTitleLocalizableKey:@"Chinese" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickChinese) forControlEvents:UIControlEventTouchUpInside];
        _chineseButton = button;
    }
    return _chineseButton;
}



@end
