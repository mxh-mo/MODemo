//
//  MOPerson.m
//  00.OCDemo
//
//  Created by MikiMo on 2020/8/25.
//  Copyright © 2020 moxiaoyan. All rights reserved.
//

#import "MOPerson.h"

@interface MOPerson()

@property (nonatomic, strong) NSArray *names;

@end

@implementation MOPerson {
    //  NSString* _name;
    //  NSString* _isName;
    //  NSString* name;
    //  NSString* isName;
}

+ (void)load {
    NSLog(@"load MOPerson");
}

+ (void)initialize {
    NSLog(@"initialize MOPerson");
}

#pragma mark - Getter
#pragma mark - 1. 简单访问器 (Simple accessor)
// 依次查找: getName、name、isName、_name
//- (NSString *)getName {
//  NSLog(@"%s", __func__);
//  return @"getName";
//}
//- (NSString *)name {
//  NSLog(@"%s", __func__);
//  return @"name";
//}
//- (NSString *)isName {
//  NSLog(@"%s", __func__);
//  return @"isName";
//}
//- (NSString *)_name {
//  NSLog(@"%s", __func__);
//  return @"_name";
//}

#pragma mark - 2. 数组访问器 (Array accessor)
// 创建一个Array，遍历 index: 0->countOfName，调用 objectInNameAtIndex:index, 并把结果存入Array中
- (NSUInteger)countOfName { // 调用两次: why?
    NSLog(@"%s", __func__);
    return self.names.count;
}
//- (id)objectInNameAtIndex:(NSUInteger)index {
//  NSLog(@"%s", __func__);
//  return self.names[index];
//}
//- (NSArray *)nameAtIndexes:(NSIndexSet *)indexes {
//  NSLog(@"%s", __func__);
//  return [self.names objectsAtIndexes:indexes];
//}
//// 可选, 实现了, 可以提高性能
//- (void)getName:(NSString * __unsafe_unretained *)name range:(NSRange)inRange {
//  NSLog(@"%s", __func__);
//  [self.names getObjects:name range:inRange];
//}

#pragma mark - 3. 集合访问器 (Collection accessor)
//- (id)enumeratorOfName { // 返回的是一个 NSEnumerator 类型的对象
//  NSLog(@"%s", __func__);
//  return [self.names reverseObjectEnumerator];
//}
//// set里的member方法是：在set里用 isEqual: 方法查找，euqal的对象返回set里的对象，否则返回nil
//- (id)memberOfName:(id)object {
//  NSLog(@"%s", __func__);
//  NSUInteger index = [self.names indexOfObject:object];
//  return index ? [self.names objectAtIndex:index] : nil;
//  // 因为这个方法的log没有输出，所以我感觉只要有这个方法就行，并不需要实现什么
//  // 所以我试了一下，这里直接 return nil 也可以
//  return nil;
//}

#pragma mark - 4. 直接访问成员变量 (Directly access)
//+ (BOOL)accessInstanceVariablesDirectly {
//  return YES;
//}

#pragma mark - Setter
// 依次查找: setName、_setName、setIsName
//- (void)setName:(NSString *)name {
//  NSLog(@"%s", __func__);
//}
//- (void)_setName:(NSString *)name {
//  NSLog(@"%s", __func__);
//}
//- (void)setIsName:(NSString *)name {
//  NSLog(@"%s", __func__);
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.names = @[@"mo1", @"mo2", @"mo3"];
        self.childens = [NSMutableArray array];
        //    _name = @"_name";
        //    _isName = @"_isName";
        //    name = @"name";
        //    isName = @"isName";
    }
    return self;
}

+ (instancetype)personWithName:(NSString *)name {
    return [[[self class] alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        //    self.name = name;
    }
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"Error: valueForUndefinedKey: %@", key);
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"Error: setValue:%@ forUndefinedKey: %@", value, key);
}

//- (void)setNilValueForKey:(NSString *)key {
//  NSLog(@"%s key: %@", __func__, key);
//  if ([key isEqualToString:@"hidden"]) {
//    [self setValue:@(NO) forKey:@"hidden"];
//  } else {
//    [super setNilValueForKey:key];
//  }
//}

// 如果有实现改方法, 则特定的 validateKey 方法不会触发
//- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing  _Nullable *)outError {
//  NSLog(@"%s", __func__);
//  NSLog(@"validateValue: %@ %@", (NSString *)*ioValue, inKey);
//  return YES;
//}

//- (BOOL)validateName:(id *)ioValue error:(NSError * __autoreleasing *)outError {
//  NSLog(@"%s", __func__);
//  if ((*ioValue == nil) || ([(NSString *)*ioValue length] < 2)) {
//    if (outError != NULL) { // 尝试set error之前，记得判空
//      *outError = [NSError errorWithDomain:[NSString stringWithFormat:@"can't set %@ to name", *ioValue]
//                                      code:1
//                                  userInfo:@{ NSLocalizedDescriptionKey
//                                              : @"Name too short" }];
//    }
//    return NO;
//  }
//  return YES;
//}

//- (BOOL)validateAge:(id *)ioValue error:(NSError * __autoreleasing *)outError {
//  NSLog(@"validateAge: %@", (NSString *)*ioValue);
//  // When the value object isn’t valid, but you know of a valid alternative, create the valid object, assign the value reference to the new object (当value无效, 而你有知道 一个有效的选择时: 创建一个有效对象, 并指定给新对象 ？？)
//  if (*ioValue == nil) {
//    // Value is nil: Might also handle in setNilValueForKey
//    *ioValue = @(0);
//  } else
//    if ([*ioValue floatValue] < 0.0) {
//    if (outError != NULL) {
//      *outError = [NSError errorWithDomain:[NSString stringWithFormat:@"can't set %@ to age", *ioValue]
//                                      code:2
//                                  userInfo:@{ NSLocalizedDescriptionKey
//                                              : @"Age cannot be negative" }];
//    }
//    return NO;
//  }
//  return YES;
//}

@end
