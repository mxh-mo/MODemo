//
//  MONativeNetworkViewController.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import "MONativeNetworkViewController.h"
#import "MMNetworkManager.h"

@interface MONativeNetworkViewController ()

@end

@implementation MONativeNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MMNetworkModel *model = [[MMNetworkModel alloc] init];
    model.url = @"https://www.baidu.com";
    model.type = MMNetworkGet;
    model.params = @{};
    
    [MMNetworkManager netWorkWith:model success:^(NSDictionary *data) {
        NSLog(@"success %@", data);
    } failure:^(NSError *error) {
        NSLog(@"error %@", error);
    }];
}


@end
