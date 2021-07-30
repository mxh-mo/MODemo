//
//  MODemoOCMockTests.m
//  MODemoOCMockTests
//
//  Created by MikiMo on 2021/4/11.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <objc/runtime.h>
#import <OCHamcrest/OCHamcrest.h>

#import "MOPerson+Tests.h"
#import "MOTitleLineView.h"

@interface MODemoOCMockTests : XCTestCase

@end

@implementation MODemoOCMockTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testMockObjects {
    // 1、创建模拟对象 Creating mock objects
    // 1.1、模拟实例 Class mocks
    // 根据类，模拟其实例
    id mockPerson = OCMClassMock([MOPerson class]);
    
    // 1.2、模拟代理 Protocol mocks
    // 根据协议名，模拟已经实现协议的实例
    id mockProtocol = OCMProtocolMock(@protocol(MOTitleLineViewDelegate));
    
    // 1.3、严格模拟 类和协议 Strict class and protocol mocks
    // 在收到没有预期(expect)的方法时引发异常
    id strictMockClass = OCMStrictClassMock([MOPerson class]);
    id strictMockProtocol = OCMStrictProtocolMock(@protocol(MOTitleLineViewDelegate));
    
    // 1.4、部分模拟 Partial mocks
    // 这里介绍一个定义：`Stub`，存根，就是模拟一个函数。
    MOPerson *aPerson = [[MOPerson alloc] init];
    id partialMockPerson = OCMPartialMock(aPerson);
    // 调用一个函数：已经存根的就触发存根的（`Stub`）；未存根的就触发原有实例的（`aPerson`）。
    
    // 1.5、观察者模拟 Observer mocks
    // 用官方的[`XCTNSNotificationExpectation`](https://developer.apple.com/documentation/xctest/xctnsnotificationexpectation?language=objc)
}

- (void)testStubMethods {
    MOPerson *aPerson = [[MOPerson alloc] init];
    id partialMockPerson = OCMPartialMock(aPerson);
    
    // 2、模拟方法 Stubbing methods
    // 2.1、模拟方法的返回值
    OCMStub([partialMockPerson name]).andReturn(@"moxiaoyan");
    
    // 2.2、委托给另一个方法
    MOPerson *anotherPerson = [[MOPerson alloc] init];
    // 另一个对象的方法，方法签名需要一致
    OCMStub([partialMockPerson name]).andCall(anotherPerson, @selector(name));
    
    // 2.3、委托给一个block
    OCMStub([partialMockPerson name]).andDo(^(NSInvocation *invocation){
        // 调用name方法时，将会调用这个block
        // invocation会携带方法参数
        // invocation可以设置返回值
    });
    // OCMStub([partialMock name]).andDo(nil);
    
    // 2.4、委托给块 Delegating to a block
    // 模拟对象将在调用函数时，调用该Block。该Block可以从调用的对象中读取参数，并可以设置返回值。
    //    OCMStub([mock someMethod]).andDo(^(NSInvocation *invocation) {
    //        /* block that handles the method invocation */
    //    });
    
    // 2.5、模拟 通过参数返回值的方法 的返回值 Returning values in pass-by-reference arguments
    // 2.5.1、对象参数
    // 模拟 应该返回的参数值
    NSError *error = [NSError errorWithDomain:@"获取friends失败(stubbed)" code:001 userInfo:nil];
    OCMStub([partialMockPerson loadFriendsWithError:[OCMArg setTo:error]]);
    // 函数调用，获得模拟的值
    NSError *resultError = nil;
    [partialMockPerson loadFriendsWithError:&resultError];
    NSLog(@"%@", resultError); // 001, 获取friends失败(stubbed)
    
    // 2.5.2、非对象参数
    // OCMStub([mock someMethodWithReferenceArgument:[OCMArg setToValue:OCMOCK_VALUE((int){aValue})]]);
    
    // 2.6、模拟block参数 Invoking block arguments
    // invokeBlock默认模拟，参数都为默认值
    OCMStub([partialMockPerson deviceWithComplete:[OCMArg invokeBlock]]);
    [partialMockPerson deviceWithComplete:^(NSString * _Nonnull value) {
        NSLog(@"%@", value); // nil
    }];
    // invokeBlockWithArgs模拟，可以设置参数值
    OCMStub([partialMockPerson deviceWithComplete:[OCMArg invokeBlockWithArgs:@"iPhone"]]);
    [partialMockPerson deviceWithComplete:^(NSString * _Nonnull value) {
        NSLog(@"%@", value); // iPhone
    }];
    
    // 2.7、抛出异常 Throwing exceptions
    // 设置函数被调用时，抛出异常：
    NSException *exception = [[NSException alloc] initWithName:@"获取name异常" reason:@"name为空" userInfo:nil];
    OCMStub([partialMockPerson name]).andThrow(exception);
    
    // 2.8、发出通知 Posting notifications
    // 设置函数被调用是，发出通知（`notify`）
    NSNotification *notify = [NSNotification notificationWithName:@"通知" object:self userInfo:nil];
    OCMStub([partialMockPerson name]).andPost(notify);
    
    // 2.9、链接模拟方法 Chaining stub actions
    // 诸如andReturn和 之类的所有操作andPost都可以链接
    // 模拟对象将发布通知并返回值:
    // OCMStub([mock someMethod]).andPost(aNotification).andReturn(aValue);
    
    // 2.10、转发给真正的对象/类 Forwarding to the real object / class
    // 当使用部分模拟实例和模拟类方法时，可以将存根方法转发给真实对象或类。
    // 这仅在链接操作或使用期望时有用。
    OCMStub([partialMockPerson name]).andForwardToRealObject();
    
    // 2.11、什么也不做 Doing nothing
    // 可以将nil而不是块传递给andDo。 这仅在部分模拟或模拟类方法时有用。在这些情况下，使用andDo(nil)有效地抑制了现有类中的行为。
    // OCMStub([mock someMethod]).andDo(nil);
    
    // 2.12、满足XCTest的期望（需要OCMock3.8）Fulfilling XCTest expectations
    // 当调用该方法时，XCTest 框架中的期望得到满足:
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"XCTest的期望"];
    OCMStub([partialMockPerson name]).andFulfill(expectation);
    
    // 2.13、记录消息（需要OCMock3.8）Logging messages
    OCMStub([partialMockPerson name]).andLog(@"%@", @"hehe");
    // 调用该方法时，format通过NSLog。很可能您想在一个链中使用它，可能后跟andReturn()或andForwardToRealObject()
    
    // 2.14、打开调试，断点会生效（需要OCMock3.8）Breaking into the debugger
    OCMStub([partialMockPerson name]).andBreak();
    // 当调用该方法时，调试器被打开，就好像一个断点被命中一样。堆栈将在 OCMock 的实现中的某个地方结束，但是如果您进一步查看，越过__forwarding__帧，您应该能够看到您的代码调用该方法的位置。
}

- (void)testVerifyingInteractions {
    MOPerson *aPerson = [[MOPerson alloc] init];
    id partialMockPerson = OCMPartialMock(aPerson);
    
    // 3、验证交互 Verifying interactions
    // 3.1、验证方法已调用 Verify-after-running
    [aPerson name];
    OCMVerify([partialMockPerson name]);
    // 验证`name`已被测试代码调用。如果尚未调用该方法，则会报告错误。
    
    // 3.2、验证Stubbed的方法被调用 Stubs and verification
    OCMStub([partialMockPerson name]).andReturn(@"momo");
    [aPerson name];
    OCMVerify([partialMockPerson name]);
    
    // 3.3、量词要求 Quantifiers requires
    // 验证方法被调用的次数：
    OCMVerify(atLeast(2), [partialMockPerson name]);
    // OCMVerify(never(),    [partialMock doStuff]);
    // OCMVerify(times(0),   [partialMock doStuff]);
    // OCMVerify(times(n),   [partialMock doStuff]);
    // OCMVerify(atLeast(n), [partialMock doStuff]);
    // OCMVerify(atMost(n),  [partialMock doStuff]);
}

- (void)testArgumentConstraints {
    MOPerson *aPerson = [[MOPerson alloc] init];
    id partialMockPerson = OCMPartialMock(aPerson);
    
    // 4、参数约束 Argument constraints
    
    // 4.1、任何约束 The any constraint
    // stub方法，可以响应任何调用
    OCMStub([partialMockPerson addChilden:[OCMArg any]]); // 参数是任何对象
    OCMStub([partialMockPerson takeMoney:[OCMArg anyPointer]]); // 参数是任何指针
    OCMStub([partialMockPerson changeWithSelector:[OCMArg anySelector]]); // 参数是任何选择子
    
    // 4.2、忽视没有对象参数 Ignoring non-object arguments
    // stub方法，可以响应`非对象`参数的调用（可以响应参数没有通过的调用：无论是对象参数or非对象参数）
    OCMStub([partialMockPerson setAge:0]).ignoringNonObjectArgs();
    
    // 4.3、匹配参数 Matching arguments
    // stub方法，仅响应`匹配的参数`的调用
    MOPerson *bPerson = [[MOPerson alloc] init];
    OCMStub([partialMockPerson addChilden:bPerson]);
    OCMStub([partialMockPerson addChilden:[OCMArg isNil]]);
    OCMStub([partialMockPerson addChilden:[OCMArg isNotNil]]);
    OCMStub([partialMockPerson addChilden:[OCMArg isNotEqual:bPerson]]);
    OCMStub([partialMockPerson addChilden:[OCMArg isKindOfClass:[MOPerson class]]]);
    
    // 会触发 anObject 的 aSelector 方法，并将参数传入
    // 在该方法中判断参数是否通过，通过就：返回YES， 否则：返回NO
    id anObject = nil;
    SEL aSelector = @selector(addChilden:);
    OCMStub([partialMockPerson addChilden:[OCMArg checkWithSelector:aSelector onObject:anObject]]);
    
    OCMStub([partialMockPerson addChilden:[OCMArg checkWithBlock:^BOOL(id value) {
        // 判断参数是否通过，通过就：返回YES， 否则：返回NO
        return YES;
    }]]);
    
    // 4.4、使用Hamcrest匹配 (另一个库，之后有空介绍一下)
    OCMStub([partialMockPerson addChilden:startsWith(@"foo")]);
    
}

- (void)testClassMethods {
    // 5、Mocking class methods 模拟类方法
    
    // 5.1、存根类方法 Stubbing class methods
    id mockPerson = OCMClassMock([MOPerson class]);
    OCMStub([mockPerson mo_className]).andReturn(@"XXMOPerson");
    
    // 5.2、消除类和实例方法的歧义 Disambiguating class and instance methods
    // (1)此时如果没有同名的实例方法，mo_className类方法是可以被正确Stub的
    NSString *className1 = [MOPerson mo_className]; // XXMOPerson
    // (2)但是如果实例方法有跟之同名时：
    NSString *instanceName = [mockPerson mo_className]; // XXMOPerson
    NSString *className2 = [MOPerson mo_className]; // class MOPerson
    // 则需要用一下方法进行Stub
    OCMStub(ClassMethod([mockPerson mo_className])).andReturn(@"MOMOPerson");
    NSString *className3 = [MOPerson mo_className]; // XXMOPerson
    
    // 5.3、验证类方法已执行 Verifying invocations of class methods
    [mockPerson mo_className];
    OCMVerify([mockPerson mo_className]);
    
    // 5.4、恢复类 Disambiguating class and instance methods
    [mockPerson stopMocking];
}

- (void)testPartialMocks {
    // 6、部分模拟 Partial mocks
    
    MOPerson *aPerson = [[MOPerson alloc] init];
    // 6.1、存根方法 Stubbing methods
    id partialMockPerson = OCMPartialMock(aPerson);
    OCMStub([partialMockPerson mo_className]).andReturn(@"Partail Class");
    NSString *partialName = [partialMockPerson mo_className]; // Partail Class
    NSString *personName = [aPerson mo_className]; // Partail Class
    NSLog(@"%@ %@", partialName, personName);
    
    // 6.2、验证调用 Verifying invocations
    [partialMockPerson mo_className];
    OCMVerify([partialMockPerson mo_className]);
    
    // 6.3、恢复对象 Restoring the object
    [partialMockPerson stopMocking];
}

- (void)testStrictMocks {
    // 7、严格的模拟和期望 Strict mocks and expectations
    
    // 7.1、设置期望-运行-验证 Expect-run-verify
    id mockPerson = OCMClassMock([MOPerson class]);
    OCMExpect([mockPerson addChilden:[OCMArg isNotNil]]);
    [mockPerson addChilden:[MOPerson new]]; // 只要有一次不为nil，就通过了验证！
    [mockPerson addChilden:nil];
    OCMVerifyAll(mockPerson);
    
    // 7.2、严格的模拟和快速失败 Strict mocks and failing fast
    id strictPerson = OCMStrictClassMock([MOPerson class]);
    // [strictPerson mo_className]; // 没有期望该方法的调用，所以会测试失败
    
    // 7.3、存根和期望 Stub actions and expect
    // 也可以在期望的情况下使用andReturn、andThrow等。这将在调用方法时运行存根操作，并在验证时确保该方法被实际调用
    OCMExpect([strictPerson mo_className]).andReturn(@"instance_MOPerson");
    // OCMExpect([strictPerson mo_className]).andThrow([NSException ...]);
    [strictPerson mo_className];
    OCMVerifyAll(strictPerson);
    
    // 7.4、延迟验证 Verify with delay
    OCMExpect([strictPerson mo_className]);
    [strictPerson mo_className];
    OCMVerifyAllWithDelay(strictPerson, 3.0); // NSTimeInterval, 通常会在满足预期后立即返回
    
    // 7.5、按顺序验证 Verifying in order
    // 一旦调用了不在“预期列表”中的下一个方法，模拟就会快速失败并抛出异常。
    [strictPerson setExpectationOrderMatters:YES];
    OCMExpect([strictPerson mo_className]);
    OCMExpect([strictPerson addChilden:[OCMArg any]]);
    // 调用顺序错了，测试就会失败
    [strictPerson mo_className];
    [strictPerson addChilden:nil];
}

- (void)testObserveMocks {
    //8、观察者模拟 Observer mocks
    //从OCMock 3.8开始不推荐使用观察者模拟。请改用XCTNSNotificationExpectation
}

- (void)testAdvancedTopics {
    // 9、进阶主题 Advanced topics
    // 9.1、快速失败的常规模拟 (需要OCMock3.3) Failing fast for regular (nice) mocks
    // strict模拟：调用未存根的方法会抛出异常
    // 常规模拟：只是返回默认值；可以为函数配置快速失败：
    id mockPerson = OCMClassMock([MOPerson class]);
    OCMReject([mockPerson mo_className]);
    // 在这种情况下，模拟将接受所有方法，除了`mo_className`，如果调用该函数，则将引发异常。
    
    // 9.2、重新验证失败后快速抛出异常 Re-throwing fail fast exceptions in verify all
    // 在快速失败模式下，异常可能不会导致测试失败（如：当方法的调用堆栈未在测试中结束时）
    // OCMerifyAll调用时，快速失败异常将重新引发，可以确保检测到来自通知等不需要的调用
    
    // 9.3、存根创建对象的方法 Stubbing methods that create objects
    MOPerson *myPerson = [[MOPerson alloc] init];
    OCMStub([mockPerson copy]).andReturn(myPerson);
    // 会根据方法名，自动返回对象的：alloc、new、copy、mutableCopy (引用计数)
    
    // 注意：init方法无法Stub，因为该方法是由模拟本身实现的。
    // 当init方法再次被调用时，会直接返回`模拟对象self`
    // 这样就可以有效的对alloc、init进行Stub
    
    // 9.4、基于实现的方法交换 Instance-based method swizzling
    MOPerson *person = [[MOPerson alloc] init];
    id partialMockPerson = OCMPartialMock(person);
    OCMStub([partialMockPerson mo_className]).andCall(myPerson, @selector(name));
    // 方法的名称可以不同，但是签名应该相同
    
    // 9.5、打破保留周期 Breaking retain cycles
    [mockPerson stopMocking];
    [partialMockPerson stopMocking];
    
    // 9.6、禁用短语法 Disabling short syntax
    // 禁用 没有前缀的宏：ClassMethod()、atLeast()、...
    // 用有前缀的宏：OCMClassMethod()、OCMAtLeast()、...
    
    // 9.7、停止为特定类创建模拟 (需要OCMock3.8) Stopping creation of mocks for specific classes
    // 一些框架在运行时动态更改对象的类。OCMock这样做是为了实现部分模拟，并且Foundation框架将更改类作为(KVO)机制的一部分。
    // 如果不仔细协调，可能会导致意外行为或crash。
    // OCMock知道KVO，并小心避免与之发生冲突
    // 对于其它框架，OCMock仅提供了一种选择退出模拟以免发生意外行为的机制
    //
    //    + (BOOL)supportsMocking:(NSString **)reason {
    //        *reason = @"Don't want to be mocked."
    //        return NO;
    //    }
    // 通过实现上面的方法，一个类可以选择不被Mock。
    // 当开发人员尝试为此类创建模拟程序时，将引发异常，解释问题说在
    // 该方法在单独调用中返回不同的值是可以接受的，这使它在运行时对特定条件做出反应
    // 如果该方法为reason赋值，返回值将被忽略
    
    // 对于所有未实现此方法的类，OCMock假定可以接受Mock
    
    // 9.8、检查部分Mock (需要OCMock3.8) Checking for partial mock
    // 判断是否 是部分模拟对象
    // BOOL isPartialMockObj = OCMIsSubclassOfMockClass(objc_getClass(partialMockPerson)); //???报错？
}

- (void)testLimitations {
    // 10、局限性 Limitations
    
    // 10.1、一次只能有一个Mock可以在给定类上存根方法
    // don't do this
    //    id mock1 = OCMClassMock([SomeClass class]);
    //    OCMStub([mock1 aClassMethod]);
    //    id mock2 = OCMClassMock([SomeClass class]);
    //    OCMStub([mock2 anotherClassMethod]);
    // 如果添加了存根类方法的模拟对象未释放，则存根方法将持续存在，即使在测试中也是如此。如果多个模拟对象同时操作同一类，则行为将不可预测。
    
    // 10.2、期望Stub方法无效
    //    id mock = OCMStrictClassMock([SomeClass class]);
    //    OCMStub([mock someMethod]).andReturn(@"a string");
    //    OCMExpect([mock someMethod]);
    // 由于当前实现了模拟对象的方法，Stub会处理所有对它的调用。意味着即使调用了该方法，验证也会失败
    // 避免此问题：
    // 方法1：通过andReturn在Expect语句中添加
    // 方法2：在设置期望之后存根
    
    // 10.3、不能为某些特殊类创建部分模拟
    id partialMockForString = OCMPartialMock(@"Foo"); // 会抛出异常
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    id partialMockForDate = OCMPartialMock(date); // 会对一些架构造成影响吗
    // 无法为 toll-free bridged 类的实例创建局部模拟
    // 无法为 某些实例创建以标记指针表示的对象，如：NSString、在某些体系结构上、NSDate在某些体系结构上
    
    // 10.4、某些方法无法存根或验证
    //    id partialMockForString = OCMPartialMock(anObject);
    //    OCMStub([partialMock class]).andReturn(someOtherClass); // will not work
    // 无法模拟许多核心运行时方法。包括：init、class、methodSignatureForSelector:、forwardInvocation:、respondsToSelector等等
    
    // 10.5、NSString和NSArray上的类方法无法存根或验证
    //id stringMock = OCMClassMock([NSString class]);
    // 无法生效、该方法将不会被存根
    //OCMStub([stringMock stringWithContentsOfFile:[OCMArg any] encoding:NSUTF8StringEncoding error:[OCMArg setTo:nil]]);
    // 无法在NSString和NSArray上存根或验证类方法。尝试这样做没有任何效果。
    
    // 10.6、NSManagedObject的类方法及其子类无法存根或验证
    //id mock = OCMClassMock([MyManagedObject class]);
    // 无法生效、该方法将不会被存根
    //OCMStub([mock someClassMethod]).andReturn(nil);
    // 无法在其NSManagedObject或其子类上存根或验证类方法。尝试这样做没有任何效果。
    
    // 10.7、无法验证 NSObject 上的方法
    id mock = OCMClassMock([NSObject class]);
    /* run code under test, which calls awakeAfterUsingCoder: */
    OCMVerify([mock awakeAfterUsingCoder:[OCMArg any]]); // still fails
    // 不可能使用在 NSObject 中实现的方法或其上的类别进行运行后验证。
    // 在某些情况下，可以对方法进行存根，然后对其进行验证。
    // 当方法在子类中被覆盖时，可以使用运行后验证。
    
    // 10.8、无法验证核心 Apple 类中的私有方法
    // UIWindow *window = /* get window somehow */
    // id mock = OCMPartialMock(window);
    /* run code under test, which causes _sendTouchesForEvent: to be invoked */
    // OCMVerify([mock _sendTouchesForEvent:[OCMArg any]]); // still fails
    // 不可能在核心 Apple 类中使用私有方法运行后验证。
    // 具体来说，在以 NS 或 UI 作为前缀的类中，所有带有下划线前缀和/或后缀的方法。
    // 在某些情况下，可以对方法进行存根，然后对其进行验证。
    
    // 10.9、运行后验证不能使用延迟
    // 目前无法验证具有延迟的方法。这目前只能使用下面在严格模拟和期望中描述的expect-run-verify方法。
    
    
    // 10.10、测试中使用多线程
    // OCMock 不是完全线程安全的。直到 3.2.x 版本 OCMock 根本不知道线程。来自多个线程的模拟对象上的任何操作组合都可能导致问题并使测试失败
    
    // 从 OCMock 3.3 开始，仍然需要从单个线程调用所有设置和验证操作，最好是测试运行程序的主线程。
    // 但是，可以从多个线程使用模拟对象。模拟对象甚至可以在不同的线程中使用，而其设置在主线程中继续进行。
    // 有关详细信息，请参阅#235和#328。
    
}



@end
