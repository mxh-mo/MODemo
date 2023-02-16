//
//  MOBaseViewController.m
//  MODemo
//
//  Created by mikimo on 2023/1/31.
//

#import "MOBaseViewController.h"

@interface MOBaseViewController ()

@end

@implementation MOBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fixBackButton];
}

- (void)fixBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didClickBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)didClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
