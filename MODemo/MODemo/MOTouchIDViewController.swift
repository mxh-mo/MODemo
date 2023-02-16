//
//  MOTouchIDViewController.swift
//  MODemo
//
//  Created by MikiMo on 2020/12/18.
//

import UIKit
// 1. 导入: LocalAuthentication
import LocalAuthentication

class MOTouchIDViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        touchID();
    }
    
    func touchID () {
        // 2. 获得一个上下文对象，来管理操作指纹解锁的过程
        let context = LAContext()
        var error: NSError?
        
        // 3. 判断设备是都支持指纹识别
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            // 4. 开始进入识别状态
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "请用指纹解锁") { (success, error) in
                if success {
                    print("识别成功");
                } else {
                    print("识别失败");
                    if let error = error as NSError? {
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        print(message);
                    }
                }
            }
        }
    }
    
    // 错误类型
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
        case LAError.systemCancel.rawValue: message = "身份验证被系统取消"
        case LAError.appCancel.rawValue: message = "身份验证被应用程序取消"
        case LAError.authenticationFailed.rawValue: message = "用户未能提供有效凭证"
        case LAError.invalidContext.rawValue: message = "上下文无效"
        case LAError.passcodeNotSet.rawValue: message = "设备上没有设置密码"
        case LAError.biometryNotAvailable.rawValue: message = "TouchID在设备上是不可用的"
        case LAError.biometryNotEnrolled.rawValue: message = "身份验证无法启动，因为生物识别没有登记身份"
        case LAError.biometryLockout.rawValue: message = "身份验证尝试太多, 已被锁定"
        case LAError.userCancel.rawValue: message = "用户取消了"
        case LAError.userFallback.rawValue: message = "用户选择使用回退"
        case LAError.notInteractive.rawValue: message = "身份验证失败，因为使用interactionNotAllowed属性禁止的UI的显示"
        default: message = "Did not find error code on LAError object"
        }
        return message
    }
}

