//
//  NSObject+arrayContain.m
//  04_runtime使用
//
//  Created by MikiMo on 2018/3/29.
//  Copyright © 2018年 莫小言. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+arrayContain.h"

@implementation NSObject (arrayContain)

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    id objc = [[self alloc] init];
    // 成员变量个数
    unsigned int count = 0;
    // 获取类中的所有成员变量
    Ivar *ivarList = class_copyIvarList(self, &count);
    // 遍历所有成员变量
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        // 类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // @"User" -> User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        // 名字 ivar_getName
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 去掉name前面的"_"
        NSString *key = [ivarName substringFromIndex:1];
        
        // 根据名字取字典里找对应的value
        id value = dict[key];
        
        // --------   字典里还有字典   --------
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            // 根据类型名 生成类对象
            Class modelClass = NSClassFromString(ivarType);
            if (modelClass) {   // 有对应的类型才转
                value = [modelClass modelWithDict:value];
            }
        }
        // --------   字典里有数组   --------
        if ([value isKindOfClass:[NSArray class]]) {
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                // 转换成id类型，就能调用任何对象的方法
                id idSelf = self;
                // 获取数组中字典对应的模型
                NSString *type =  [idSelf arrayContainModelClass][key];
                // 生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *arrM = [NSMutableArray array];
                for (NSDictionary *dic in value) {
                    id model = [classModel modelWithDict:dic];
                    [arrM addObject:model];
                }
                value = arrM;
            }
        }
        if (value) {    // 给属性赋值
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}

@end
