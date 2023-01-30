//
//  MOStudent.m
//  MODemoOC
//
//  Created by MikiMo on 2020/12/18.
//

#import <objc/runtime.h>

#import "MOStudent.h"

@implementation MOStudent

@synthesize nickName;

- (instancetype)init {
    self = [super init];
    if (self) {
        // class 获取当前方法的调用者的类
        NSLog(@"%@", NSStringFromClass([self class]));  // objc_msgSend
        // 调用父类方法 还是当前对象调用
        NSLog(@"%@", NSStringFromClass([super class])); // objc_msgSendSuper
        NSLog(@"%@", NSStringFromClass([super superclass]));
    }
    return self;
}

+ (NSDictionary *)arrayContainModelClass {
    return @{@"friends":NSStringFromClass([self class])};
}

#pragma mark - 处理未实现方法

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == NSSelectorFromString(@"run:")) {
        class_addMethod(self, sel, (IMP)aaa, "v@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

/// 任何方法默认都有两个隐式参数：self _cmd(当前方法的编号)
void aaa(id self, SEL _cmd, NSNumber *meter) {
    NSLog(@"跑了%@米", meter);
}

#pragma mark - 归档

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key]; // 归档
    }
    free(ivarList);
}

#pragma mark - 解档

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivarList = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar var = ivarList[i];
            const char *name = ivar_getName(var);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];   // 解档
            [self setValue:value forKey:key];
        }
        free(ivarList);
    }
    return self;
}

- (void)thinking {
    
}

@end
