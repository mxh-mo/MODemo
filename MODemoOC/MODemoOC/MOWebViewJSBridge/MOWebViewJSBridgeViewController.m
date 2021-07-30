//
//  MOWebViewJSBridgeViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MOWebViewJSBridgeViewController.h"
#import "GCWebviewJSBridge.h"

@interface MOWebViewJSBridgeViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) GCWebviewJSBridge *bridge;
@end

@implementation MOWebViewJSBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.新建WebView
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    // 2.加载网页
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [NSURL fileURLWithPath:indexPath];
    [self.webView loadHTMLString:appHtml baseURL:baseUrl];
    
    // 3.开启日志
    [GCWebviewJSBridge setEnableLogging];
    
    // 4.给webView建立JS和OC的沟通桥梁
    _bridge = [GCWebviewJSBridge bridgeForWebView:self.webView];
    [_bridge setwebViewDelegate:self];
    
    
    /* JS调用OC的API:访问相册 */
    [_bridge registerObjCHandler:@"openCamera" handler:^(id data, GCWVJSBResponseCallback responseCallback) {
        NSLog(@"需要%@图片", data[@"count"]);
        UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
        imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imageVC animated:YES completion:nil];
    }];
    
    /* JS调用OC的API:访问底部弹窗 */
    [_bridge registerObjCHandler:@"showSheet" handler:^(id data, GCWVJSBResponseCallback responseCallback) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"你猜我谈不谈?" message:@"不谈不谈,就不谈!!" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:cancelAction];
        [vc addAction:okAction];
        [self presentViewController:vc animated:YES completion:nil];
    }];
    [self renderButtons:self.webView];
}

- (void)renderButtons:(UIWebView*)webView {
    UIButton *getInfoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getInfoBtn.backgroundColor = [UIColor redColor];
    [getInfoBtn setTitle:@"getUserInfo" forState:UIControlStateNormal];
    [getInfoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getInfoBtn addTarget:self action:@selector(getUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:getInfoBtn aboveSubview:webView];
    getInfoBtn.frame = CGRectMake(10, 400, 100, 35);
    
    UIButton *callAlertBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    callAlertBtn.backgroundColor = [UIColor redColor];
    [callAlertBtn setTitle:@"alertMessage" forState:UIControlStateNormal];
    [callAlertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callAlertBtn addTarget:self action:@selector(alertMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:callAlertBtn aboveSubview:webView];
    callAlertBtn.frame = CGRectMake(150, 400, 100, 35);
}

- (void)getUserInfo {
    // 调用JS中的API
    [self.bridge callHandler:@"getUserInfo" data:@{@"userId":@"DX001"} responseCallback:^(id responseData) {
        NSString *userInfo = [NSString stringWithFormat:@"%@,姓名:%@,年龄:%@", responseData[@"userID"], responseData[@"userName"], responseData[@"age"]];
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"从网页端获取的用户信息" message:userInfo preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:cancelAction];
        [vc addAction:okAction];
        [self presentViewController:vc animated:YES completion:nil];
    }];
}

- (void)alertMessage {
    // 调用JS中的API
    [self.bridge callHandler:@"alertMessage" data:@"调用了js中的Alert弹窗!" responseCallback:^(id responseData) {
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}

@end
