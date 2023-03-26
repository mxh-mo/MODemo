//
//  MOUnitTests.swift
//  MODemoTests
//
//  Created by MikiMo on 2021/3/20.
//

import XCTest
@testable import MODemo
// https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/01-introduction.html#//apple_ref/doc/uid/TP40014132-CH1-SW1

// Swift 无法测试私有属性和方法
// Note: @testable provides access only for internal functions; file-private and private declarations are not visible outside of their usual scope when using @testable.
// https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/04-writing_tests.html
// OC 的可以用分类在这里，再次声明一下就可以测试了

class MOUnitTests: XCTestCase {
    
    let subscribeButton = UIButton(type: .custom)
    var subscribeButton2 : UIButton? = nil
    let vc: MOUITestsViewController = {
        let vc = MOUITestsViewController()
        return vc
    }()
    let delegate: UITableViewDataSource? = nil
    
    override class func setUp() {
        moPrint(self, #line, "mo: class setUp")
    }
    
    override class func tearDown() {
        moPrint(self, #line, "mo: class tearDown")
    }
    
    override func setUp() {
        moPrint(self, #line, "mo: setUp")
    }
    
    override func setUpWithError() throws {
        moPrint(self, #line, "mo: setUpWithError")
        self.vc.subscribeButton = self.subscribeButton
        
    }
    
    override func tearDownWithError() throws {
        moPrint(self, #line, "mo: tearDownWithError")
    }
    
    override func tearDown() {
        moPrint(self, #line, "mo: tearDown")
    }
    
    func testBoolAssertions() throws {
        moPrint(self, #line, "mo: testFuncation1")
        // 断言为 false
        XCTAssertFalse(self.vc.subscribeButton.isSelected)
        self.vc.clickSubscribeButton(sender: self.vc.subscribeButton)
        // 断言为 true
        XCTAssert(self.vc.subscribeButton.isSelected)
        // 断言为 true
        XCTAssertTrue(self.vc.subscribeButton.isSelected)
    }
    
    func testNilAssertions() {
        moPrint(self, #line, "mo: testFuncation2")
        XCTAssertNil(self.delegate)
        XCTAssertNotNil(self.subscribeButton)
    }
    
    func testEqualAssertions() {
        // 断言 两个对象 相等
        XCTAssertEqual(self.subscribeButton, self.vc.subscribeButton)
        // 断言 两个对象 不相等
        XCTAssertNotEqual(self.subscribeButton, self.subscribeButton2)
    }
    
    func testComparableValueAssertions() {
        // 断言num2大于num1
        XCTAssertGreaterThan(self.vc.num2, self.vc.num1)
        // 断言num2大于等于num1
        XCTAssertGreaterThanOrEqual(self.vc.num2, self.vc.num1)
        
        // 断言num1小于num2
        XCTAssertLessThan(self.vc.num1, self.vc.num2)
        // 断言num1小于等于num2
        XCTAssertLessThanOrEqual(self.vc.num1, self.vc.num2)
    }
    
    func testThrowsAressertions() {
        XCTAssertNoThrow(self.vc.viewDidLoad())
        //        XCTAssertThrowsError(self.vc.viewDidLoad())
    }
    
    func testSkipping() throws {
        guard self.vc.isCanTests else {
            throw XCTSkip("Can't test vc")
        }
        try XCTSkipIf(!self.vc.isCanTests, "Can't test vc")
        try XCTSkipUnless(self.vc.isCanTests, "Can't test vc")
        XCTAssert(self.vc.isCanTests)
    }
    
    func testAsynchronous() {
        // 为异步下载任务创建一个期望
        let expectation = XCTestExpectation(description: "Download apple.com home page")
        let url = URL(string: "https://apple.com")!
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            // 断言下载数据不为nil
            XCTAssertNotNil(data)
            // 完成预期
            expectation.fulfill()
        }
        dataTask.resume() // 开始下载任务
        // 等待：知道完成预期 or 超时
        wait(for: [expectation], timeout: 10.0)
        // 失败情况1：下载的data为nil
        // 失败情况2：下载任务在10s内未完成
    }
    
    func testKVOExpectation() {
        self.vc.title = "xixi"
        let expectation = XCTKVOExpectation(keyPath: "title", object: self.vc)
        expectation.handler = { (observedObject, change) -> Bool in
            guard let observedObject = observedObject as? MOUITestsViewController else {
                return false
            }
            return observedObject.title == "hehe"
        }
        self.vc.title = "hehe"
        let result = XCTWaiter().wait(for: [expectation], timeout: 1)
        XCTAssertEqual(result, .completed)
    }
    
    func testPerformanceExample() throws {
        measure {
            for _ in 0...1000 {
                MOPerson(name: "momo", age: 18)
            }
        }
    }
    
}
