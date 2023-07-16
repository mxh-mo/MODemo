//
//  MOScreenRotationViewController.m
//  MODemo
//
//  Created by mikimo on 2023/7/16.
//  Copyright © 2023 moxiaoyan. All rights reserved.
//

#import "MOScreenRotationViewController.h"
#import <Masonry/Masonry.h>

@interface MOScreenRotationViewController ()

@end

@implementation MOScreenRotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rotationLandspaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationLandspaceBtn setTitle:@"强制旋转到横屏" forState:UIControlStateNormal];
    [rotationLandspaceBtn addTarget:self action:@selector(clickedRotationLandspace:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotationLandspaceBtn];
    [rotationLandspaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(100));
        make.width.mas_equalTo(@(200));
        make.height.mas_equalTo(@(50));
    }];
    
}

- (void)clickedRotationLandspace:(UIButton *)sender {
    
}

@end
