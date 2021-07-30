//
//  MOWaterRippleViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOWaterRippleViewController.h"
#import "MOWaterRipperView.h"

@interface MOWaterRippleViewController ()

@property (nonatomic, strong) MOWaterRipperView *progressView;

@end

@implementation MOWaterRippleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 水波进度
    self.progressView = [[MOWaterRipperView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.progressView.center = self.view.center;
    self.progressView.progress = 0.0;
    [self.view addSubview:self.progressView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(90, CGRectGetMaxY(self.progressView.frame)+20, 200, 20)];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)changeValue:(UISlider *)slider {
    self.progressView.progress = slider.value;
}

@end
