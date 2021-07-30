//
//  MOAuthorizationPhoto.swift
//  07_QRScan
//
//  Created by MikiMo on 2019/7/26.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import UIKit
import Photos

struct MOAuthorizationPhoto: MOAuthrizationProtocol {
  func requestAuthorization(completeHandler: @escaping (_ status: MOAuthorizeStatus) -> Void) {
    if self.status() == .authorized { // 已授权
      completeHandler(self.status())
    } else if (self.status() == .notDetermined) { // 未授权
      PHPhotoLibrary.requestAuthorization { (status) in
        completeHandler(self.status())
      }
    } else { // 已拒绝 自定义View？
      let alert = UIAlertController(title: "相册访问受限", message: "跳转“设置”， 允许访问您的相册", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
        completeHandler(self.status())
      }))
      let destructiveAct = UIAlertAction(title: "设置", style: .default) { (_) in
        let url = URL(string: UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!) {
          UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
      }
      alert.addAction(destructiveAct)
      getTopVC()?.present(alert, animated: true, completion: nil)
    }
  }
  func status() -> MOAuthorizeStatus {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .notDetermined: return .notDetermined
    case .restricted: return .restricted
    case .denied: return .denied
    case .authorized: return .authorized
    default: return .denied
    }
  }
  func getTopVC() -> UIViewController? {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      return topController
    }
    return nil
  }
}
