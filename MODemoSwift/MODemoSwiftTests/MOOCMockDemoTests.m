//
//  MOOCMockDemoTests.m
//  MODemoOCTests
//
//  Created by MikiMo on 2021/6/29.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MOOCMockDemo.h"
#import "MOPerson.h"

@interface MOOCMockDemoTests : XCTestCase

@end

@implementation MOOCMockDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testHandleLoadFinished {
    // 1、准备数据
    NSDictionary *info = @{@"name": @"momo"};
    id mock = OCMClassMock([MOOCMockDemo class]);
    // 2、添加预期
    // 预期顺序执行
    [mock setExpectationOrderMatters:YES];
    // 预期执行
    OCMExpect([mock handleLoadSuccessWithPerson:[OCMArg any]]);
    OCMExpect([mock showError:NO]);
    OCMExpect([mock showError:YES]).ignoringNonObjectArgs; // 忽视参数
    // 预期 + 参数验证
    OCMExpect([mock handleLoadSuccessWithPerson:[OCMArg checkWithBlock:^BOOL(id obj) {
        MOPerson *person = (MOPerson *)obj;
        return [person.name isEqualToString:@"momo"];
    }]]);
    // 预期不执行
    OCMReject([mock handleLoadFailWithPerson:[OCMArg any]]);
    
    // 3、执行
    [MOOCMockDemo handleLoadFinished:info];
    
    // 4、断言
    OCMVerifyAll(mock);
    OCMVerifyAllWithDelay(mock, 1); // 支持延迟验证
    [mock stopMocking];
}


@end
