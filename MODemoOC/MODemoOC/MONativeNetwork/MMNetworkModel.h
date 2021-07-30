//
//  MMNetworkModel.h
//  09_原生network
//
//  Created by MikiMo on 2018/4/11.
//  Copyright © 2018年 莫小言. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  MMNetworkGet,
  MMNetworkPost,
} MMNetworkType;

@interface MMNetworkModel : NSObject

@property (nonatomic, assign) MMNetworkType type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSDictionary *params;

@end
