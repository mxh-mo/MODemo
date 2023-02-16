//
//  MMNetworkManager.m
//  09_原生network
//
//  Created by MikiMo on 2018/4/11.
//  Copyright © 2018年 莫小言. All rights reserved.
//

#import "MMNetworkManager.h"
#import "NSObject+Extension.h"

@implementation MMNetworkManager

#pragma mark - 网络请求

+ (void)netWorkWith:(MMNetworkModel *)model success:(MMSuccessBlock)successBlock failure:(MMFailureBlock)failureBlock {
    
    NSURL *nsurl = [NSURL URLWithString:model.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    // 如果想要设置网络超时的时间的话，可以使用下面的方法：
    // NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    // 设置请求类型
    request.HTTPMethod = model.type == MMNetworkGet ? @"Get" : @"POST";
    
    // 将需要的信息放入请求头 随便定义了几个
    [request setValue:@"xxx" forHTTPHeaderField:@"Authorization"];//token
    [request setValue:@"xxx" forHTTPHeaderField:@"Gis-Lng"];//坐标 lng
    [request setValue:@"xxx" forHTTPHeaderField:@"Gis-Lat"];//坐标 lat
    [request setValue:@"xxx" forHTTPHeaderField:@"Version"];//版本
    NSLog(@"POST-Header:%@", request.allHTTPHeaderFields);
    
    // 把参数放到请求体内
    if (model.type == MMNetworkPost) {
        request.HTTPBody = [model.params jsonData];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) { // 请求失败
            failureBlock(error);
        } else {  // 请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            successBlock(dic);
        }
    }];
    [dataTask resume];  // 开始请求
}

#pragma mark -  图片下载

- (void)downloadImageWithUrl:(NSString *)urlStr {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlStr];
    // location:文件下载缓存路径
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
            NSError *error;
            [[NSFileManager defaultManager] moveItemAtURL:url toURL:[NSURL fileURLWithPath:path] error:&error];
            if (error == nil) {
                NSLog(@"file sace success");
            } else {
                NSLog(@"file save error: %@", error);
            }
            
        } else {
            NSLog(@"download error: %@", error);
        }
    }];
    [downloadTask resume];
}



@end
