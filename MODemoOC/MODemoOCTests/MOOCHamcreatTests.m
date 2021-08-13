//
//  MOOCHamcreatTests.m
//  MODemoOCTests
//
//  Created by MikiMo on 2021/8/12.
//

// https://github.com/hamcrest/OCHamcrest

#import <XCTest/XCTest.h>
#import <OCHamcrest/OCHamcrest.h>

#import "MOStudent.h"

// GitHub: https://github.com/hamcrest/OCHamcrest
// Doucument: http://hamcrest.org/OCHamcrest/index.html

@interface MOOCHamcreatTests : XCTestCase

@end

@implementation MOOCHamcreatTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testObject {
    MOStudent *stu = [[MOStudent alloc] init];
    stu.name = @"momo";
    MOStudent *stu2 = nil;

    assertThat(stu, conformsTo(@protocol(NSCoding)));   // 断言遵循某协议
    assertThat(stu, equalTo(stu));      // 断言相等(由`isEqual`决定)
    assertThat(stu, hasDescription(startsWith(@"<MOStudent:")));      // 断言描述方法的返回值
    assertThat(stu, hasProperty(@"name", @"momo")); // 断言对象属性
    assertThat(stu, instanceOf([NSObject class]));  // 断言对象类型，类似`isKindOf`
    assertThat(stu, isA([MOStudent class]));        // 断言对象的精确类型，类似`isMemberOf`

    assertThat(stu2, nilValue());       // 断言为空
    assertThat(stu, notNilValue());     // 断言不为空

    assertThat(stu, sameInstance(stu)); // 断言相等(由`对象内存地址`决定)
}

- (void)testNumber {
    // BOOL
    BOOL value1 = YES;
    BOOL value2 = NO;
    assertThatBool(value1, isTrue());
    assertThatBool(value2, isFalse());

    // int、float
    int num1 = 5;
    float num2 = 2.5;
    assertThatInt(num1, equalToInt(5));         // 断言`int`相等
    assertThatFloat(num2, equalToFloat(2.5));   // 断言`float`相等

    // NSNumber
    NSNumber *num3 = @(3.14);
    assertThat(num3, closeTo(3.0f, 0.5));       // 断言`NSNumber`接近某个值，波动范围在`0.5`之内
    assertThat(num3, lessThan(@(4)));           // 断言`NSNumber`小于4
    assertThat(num3, lessThanOrEqualTo(@(4)));  // 断言`NSNumber`小于/等于4
    assertThat(num3, greaterThan(@(3)));            // 断言`NSNumber`大于3
    assertThat(num3, greaterThanOrEqualTo(@(3)));   // 断言`NSNumber`大于/等于3
}

- (void)testString {
    
    NSString *str = @"Objective-C";

    assertThat(str, equalTo(@"Objective-C"));   // 断言字符串相等
    assertThat(str, containsSubstring(@"tive"));    // 断言字符串是否包含`tive`
    assertThat(str, startsWith(@"Obj"));            // 断言字符串是否以`Obj`开头
    assertThat(str, endsWith(@"-C"));               // 断言字符串是否以`-C`结尾
    assertThat(str, equalToIgnoringCase(@"objective-c"));  // 断言字符串是否相等，忽略大小写
}

- (void)testLogical {
    NSString *str = @"Objective-C";
    assertThat(str, allOf(startsWith(@"Objective"), endsWith(@"-C"), nil));    // 断言满足所有
    assertThat(str, anyOf(startsWith(@"Objective"), endsWith(@"-S"), nil));    // 断言满足任意一个
    assertThat(str, isNot(@"Swift"));           // 断言不相等
    assertThat(str, isNot(endsWith(@"-S")));    // 断言不以`-S`结尾
}

- (void)testCollection {
    NSArray *arr = [NSArray array];
    assertThat(arr, isEmpty());     // 断言为空

    arr = @[@"a", @"b", @"c"];
    assertThat(arr, contains(@"a", @"b", @"c", nil));   // 断言包含(顺序和数量必须都相同)
    assertThat(arr, containsInAnyOrder(@"b", @"a", @"c", nil));   // 断言乱序包含(数量必须都相同)
    assertThat(arr, everyItem(instanceOf([NSString class])));    // 断言每个item都满足某个条件

    // 断言几个数量满足某个条件
    assertThat(arr, hasCount(greaterThan(@(2))));   // 断言数量大于2
    assertThat(arr, hasCountOf(3));     // 断言数量等于3

    // 断言包含c
    assertThat(arr, hasItem(@"c"));
    assertThat(@"c", isIn(arr));

    // 断言item满足某些条件: (出现的matcher，有一个item满足) (以下两种写法效果一样)
    assertThat(arr, hasItems(is(@"c"), equalToIgnoringCase(@"A"), @"b", nil));
    assertThat(arr, hasItemsIn(@[is(@"c"), equalToIgnoringCase(@"A"), @"b"]));

    // 断言item满足某些条件: (每个item，满足任意一个matcher) (以下两种写法效果一样)
    assertThat(arr, onlyContains(startsWith(@"a"), nil));   // 断言失败，只有a满足了，其他的item都没满足
    assertThat(arr, onlyContains(instanceOf([NSString class]), nil));   // 断言成功，所有item都能满足
    assertThat(arr, onlyContainsIn(@[instanceOf([NSString class])]));

    NSDictionary *dic = @{@"key1": @"value1", @"key2": @"value2"};
    assertThat(dic, isNot(isEmpty()));  // 断言非空
    assertThat(dic, isNot(hasKey(@"key3")));    // 断言包含某个key
    assertThat(dic, hasCountOf(2));     // 断言数量
    assertThat(dic, hasKey(@"key1"));   // 断言包含某个key
    assertThat(dic, hasValue(@"value1"));   // 断言包含某个value

    // 断言键值对
    assertThat(dic, hasEntry(@"key1", @"value1"));  // 断言包含某个键值对
    assertThat(dic, hasEntries(@"key1", @"value1", @"key2", @"value2", nil));    // 断言包含多个键值对
    assertThat(dic, hasEntriesIn(@{@"key1": @"value1", @"key2": @"value2"}));    // 断言包含多个键值对
}

- (void)testIs {
    // is是一个语法糖
    // 用来装饰另一个matcher, 或提供常用的 is(equalTo(x)) 的快捷方式

    // 如果()里是matcher，则跟没写is的效果是一样的
    int num1 = 5;
    assertThatInt(num1, equalToInt(5));
    assertThatInt(num1, is(equalToInt(5)));

    // 如果()里不是matcher，则将其包装在equalTo matcher中(由`isEqual`决定)，下列语法是等效的
    NSString *cheese = @"cheese";
    NSString *smelly = @"cheese";
    assertThat(cheese, equalTo(smelly));
    assertThat(cheese, is(equalTo(smelly)));
    assertThat(cheese, is(smelly));
}

@end
