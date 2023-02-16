//
//  MMNetworkManager.h
//  09_原生network
//
//  Created by MikiMo on 2018/4/11.
//  Copyright © 2018年 莫小言. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMNetworkModel.h"

typedef void(^MMSuccessBlock)(NSDictionary *data);
typedef void(^MMFailureBlock)(NSError *error);

@interface MMNetworkManager : NSObject

+ (void)netWorkWith:(MMNetworkModel *)model success:(MMSuccessBlock)successBlock failure:(MMFailureBlock)failureBlock;

// 图片下载
+ (void)downloadImageWithUrl:(NSString *)urlStr;

@end
