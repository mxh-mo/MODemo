//
//  MOUITestsViewControllerUITests.swift
//  MODemoSwiftUITests
//
//  Created by MikiMo on 2021/3/27.
//

import XCTest
//@testable import MODemoSwift

class MOUITestsViewControllerUITests: XCTestCase {
    
    // 应用程序对象
    let app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        // 在UI测试中，当出现故障时，最好立即停止
        continueAfterFailure = false

        // UI测试必须启动它们测试的应用程序。在设置中这样做将确保每个测试方法都会发生这种情况
        self.app.launch()
    }


    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApplication() {
        // 创建应用程序的代理
        let app = XCUIApplication()
        // 创建指定bundleId的应用程序的代理
        let app2 = XCUIApplication(bundleIdentifier: "xxxx")

        // 同步启动应用程序，如果已有应用程序实例在运行了，则会被终止，以确保启动实例处于干净的状态
        app.launch()
        // 激活应用程序，如果之前没有启动则启动；如果之前启动过，则启动参数和环境变量将再次提供给新的启动
        // (不同于launch，如果已有实例在运行，不会终止现有实例)
        app.activate()
        // 终止正在运行的应用程序实例
        app.terminate()
        
        // properties：
        // 程序的启动参数
        let launchArguments: [String] = app.launchArguments
        // 程序的启动环境
        let launchEnvironment: [String : String] = app.launchEnvironment
        // 程序的状态
        // unknown、notRunning、runningBackgroundSuspended、runningBackground、runningForeground
        let state = app.state
        
        // wait
        // 等待程序变为特定状态，n秒后放弃
        // 这是一个同步方法，有以下3种情况：
        // 1、程序当前处于特定状态：立即返回true
        // 2、超时之前程序转为特定状态：返回true
        // 3、超时后：返回false
        let result = app.wait(for: .runningForeground, timeout: 3)

        // resetAuthorizationStatus
        // 重置受保护资源的授权状态，以便下次访问该资源时系统将显示授权提示。
        // 如果此时app正在运行，重置时app可能会被终止
        // XCUIProtectedResource 枚举：
        // contacts、calendar、reminders、photos、microphone、camera、mediaLibrary、homeKit、bluetooth、keyboardNetwork、location、health
        app.resetAuthorizationStatus(for: .camera)
        
        
        // XCUIElementQuery 一般都是从 XCUIApplication 中取的
        self.app.windows
        self.app.tabs
        self.app.tabBars
        self.app.navigationBars
        self.app.tables
        self.app.cells
        self.app.staticTexts
        self.app.buttons
        self.app.images
        self.app.scrollViews
        self.app.collectionViews
        self.app.webViews
        self.app.sliders
        self.app.textFields
        self.app.textViews
        self.app.switches
        self.app.keyboards
    }
    
    func testDevice() {
        // 可以模拟iOS设备的物理按钮、设备方向和Siri交互的代理
        let device = XCUIDevice.shared
        // UIDeviceOrientation 枚举：
        // unknown: 未知
        // portrait: 设备垂直方向，Home键在下方
        // portraitUpsideDown: 设备垂直方向，Home键在上方
        // landscapeLeft: 设备水平方向，Home键在右侧
        // landscapeRight: 设备水平方向，Home键在左侧
        // faceUp: 面向设备平面，面朝上
        // faceDown: 面向设备平面，面朝下
        let orientation: UIDeviceOrientation = device.orientation

        // XCUISiriService
        let siriService = device.siriService
        // 如果Siri用户界面当前未处于活动状态，则显示该用户界面，并接受一个字符串，然后将其作为语音进行处理。
        siriService.activate(voiceRecognitionText: "xxxx")

        // XCUIDevice.Button
        // 按home键
        device.press(XCUIDevice.Button.home) // 只有一个home键
        
        #if targetEnvironment(simulator)
        #else
        // 音量加/减键 在simulator上不可用
        device.press(XCUIDevice.Button.volumeUp)
        device.press(XCUIDevice.Button.volumeDown)
        #endif
    }
    
    func testElements() {
        let element: XCUIElement = self.app.cells.staticTexts["UnitTests"]
        let cell2: XCUIElement = self.app.cells.staticTexts["TouchID"]
        // 断言该Element存在
        XCTAssert(element.exists)
        // 等待出现，n秒后放弃（同app.wait）
        let result = element.waitForExistence(timeout: 3)
        // 是否可以为元素计算生命点以合成事件?
        element.isHittable
        
        // XCUIElementAttributes：
        element.identifier
        element.frame
        element.value
        element.title
        element.label
        element.elementType // 这个枚举有很多
        element.isEnabled
        element.isSelected
        // SizeClass: unspecified、compact、regular
        element.horizontalSizeClass
        element.verticalSizeClass
        element.placeholderValue
        
        // 手势：
        element.tap() // 点击
        //element.doubleTap() // 双击
        element.press(forDuration: 3) // 长按
        element.press(forDuration: 3, thenDragTo: cell2) // 长按后拖拽
        element.twoFingerTap() // 双指点击
        element.tap(withNumberOfTaps: 3, numberOfTouches: 3) // 3指，3击
        // 滑动手势：
        element.swipeUp()
        element.swipeDown()
        element.swipeLeft()
        element.swipeRight()
        // 用两次触碰发出捏的手势
        // scale：捏手势的比例。使用0到1之间的比例“收缩关闭”或缩小，使用大于1的比例“收缩打开”或放大
        // velocity: 每秒尺度因子中的收缩速度
        element.pinch(withScale: 0.5, velocity: 0.5)

        // 通过两次触摸发送旋转手势
        // rotation: 旋转弧度
        // velocity: 旋转姿态的速度（弧度/秒）
        element.rotate(5, withVelocity: 0.5)

        do {
            let snapshot: XCUIElementSnapshot = try element.snapshot()
            let childerns: [XCUIElementSnapshot] = snapshot.children
            for childern: XCUIElementSnapshot in childerns {
                print("snapshot: \(childern.dictionaryRepresentation)")
            }
            print("snapshot success: \(snapshot)")
        } catch {
            print("snapshot error: \(error)")
        }
        
        // 返回与指定类型匹配的元素的所有子代的查询
        let cellButtons: XCUIElementQuery = element.descendants(matching: .button)
        // 返回与指定类型匹配的元素的直接子元素的查询
        let cellButtons2: XCUIElementQuery = element.children(matching: .button)
        
        // 创建并返回一个新的坐标，该坐标将通过将偏移量乘以元素帧的大小添加到元素帧的原点来计算其屏幕点
        let coordinate: XCUICoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 100, dy: 100))
        // 坐标所基于的元素，可以是直接的，也可以是通过坐标导出的。
        coordinate.referencedElement
        
        // 屏幕上坐标位置的动态计算值
        let point: CGPoint = coordinate.screenPoint
        // 创建一个新坐标，该坐标与原始坐标的绝对偏移以点为单位
        let coordinate2: XCUICoordinate = coordinate.withOffset(CGVector(dx: 50, dy: 50))

        coordinate.tap() // 点击
        coordinate.doubleTap() // 双击
        coordinate.press(forDuration: 3) // 长按
        coordinate.press(forDuration: 3, thenDragTo: coordinate2) // 长按后拖拽
        
    }

    func testSubscribeButtonTapAction() throws {
        // 点击Cell进入 单元测试VC
        let tables: XCUIElementQuery = self.app.tables // tableViews
        let cells: XCUIElementQuery = tables.cells // cells
        let cell: XCUIElement = cells.staticTexts["UnitTests"] // UnitTests cell
        cell.tap() // 点击cell
        
        // 获取订阅按钮（因为这个按钮的title会变，所以用title获取会出错）
        // 因此需要为按钮设置accessibilityIdentifier
        // 然后根据accessibilityIdentifier获取订阅按钮
        let button: XCUIElement = self.app.buttons[gSubscribeButtonAccessibilityIdentifier]
        
        let result = self.app.wait(for: .runningBackground, timeout: 10)

        XCTAssertFalse(button.isSelected) // 断言按钮未选择状态
        button.tap() // 点击按钮
        XCTAssertTrue(button.isSelected) // 断言按钮已选择状态
    }

}
