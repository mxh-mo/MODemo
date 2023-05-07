//
//  MOAuthorizeManager.swift
//  07_QRScan
//
//  Created by MikiMo on 2019/7/23.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import UIKit

enum MOAuthorizeType {
    case camera // 相机
    case photo  // 相册
}

enum MOAuthorizeStatus {
    case notDetermined  // 未授权
    case authorized     // 已授权
    case restricted     // 受限
    case denied         // 拒绝
}

protocol MOAuthrizationProtocol {
    // 授权状态
    func status() -> MOAuthorizeStatus
    // 查询授权
    func requestAuthorization(completeHandler: @escaping (_ status: MOAuthorizeStatus) -> Void);
}

struct MOAuthorizationManager {
    // MARK: - 检测授权：未授权的request，拒绝的alert； 回调授权结果
    func requestAuthoriza(type: MOAuthorizeType, completionHandler: @escaping (_ status: MOAuthorizeStatus) -> Void) {
        authorizeFactory(type: type).requestAuthorization(completeHandler: completionHandler)
    }
    // MARK: - 工厂方法 (获取不同权限model，model实现协议方法)
    func authorizeFactory(type: MOAuthorizeType) -> MOAuthrizationProtocol {
        switch type {
        case .camera: return MOAuthorizationCamera()
        case .photo: return MOAuthorizationPhoto()
        }
    }
}
