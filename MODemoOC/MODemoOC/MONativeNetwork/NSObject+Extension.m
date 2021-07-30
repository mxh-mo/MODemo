//
//  NSObject+Extension.m
//  09_原生network
//
//  Created by MikiMo on 2018/4/11.
//  Copyright © 2018年 莫小言. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (NSString *)jsonString {
    if (self == nil) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData.length > 0 && error == nil) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

- (NSData *)jsonData {
    if (self == nil) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData.length > 0 && error == nil) {
        return jsonData;
    } else {
        return nil;
    }
}

@end
