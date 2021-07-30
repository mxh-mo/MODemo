//
//  NSObject+arrayContain.h
//  04_runtime使用
//
//  Created by MikiMo on 2018/3/29.
//  Copyright © 2018年 莫小言. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSObjectDelegate <NSObject>

@property (nonatomic, copy) NSString *nickName;

+ (NSDictionary *)arrayContainModelClass;

@end

@interface NSObject (arrayContain)

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
