//
//  MOPerson+Tests.m
//  MODemoOC
//
//  Created by MikiMo on 2021/6/29.
//

#import "MOPerson+Tests.h"

@implementation MOPerson (Tests)

#pragma mark - 以下，OCMock Tests 使用

- (void)loadFriendsWithError:(NSError **)error {
    *error = [NSError errorWithDomain:@"获取friends失败" code:001 userInfo:nil];
}

- (void)deviceWithComplete:(void(^)(NSString *value))complete {
    complete(@"iwatch");
}

- (void)addChilden:(MOPerson * _Nullable)person {
    //    [self.childens addObject:person];
}
- (BOOL)takeMoney:(NSUInteger *)money {
    *money = 100; // 解引用后进行赋值
    return YES;
}

- (void)changeWithSelector:(SEL)selector {
    
}

- (NSString *)mo_className {
    return [NSString stringWithFormat:@"instance %@", NSStringFromClass(self.class)];
}

+ (NSString *)mo_className {
    return [NSString stringWithFormat:@"class %@", NSStringFromClass(self)];
}

#pragma mark - 以下，OCMock Demo 使用

+ (MOPerson * _Nullable)personWithInfo:(NSDictionary * _Nullable)info {
    if (!info || info.allKeys.count == 0) {
        return nil;
    }
    MOPerson *person = [[MOPerson alloc] init];
    person.name = [info objectForKey:@"name"];
    return person;
}

- (BOOL)isValid {
    if (self.name) {
        return YES;
    }
    return NO;
}

@end
