//
//  MOExtensions.swift
//  MODemo
//
//  Created by MikiMo on 2021/8/6.
//

import Foundation
import UIKit
import CoreGraphics

func moPrint(_ target: NSObject, _ line: Int, _ params: Any) {
    print("\(Date()): <\(type(of: target)), \(String(format: "%p", target))> \(line): \(params)")
}

extension String {
    // 参考： https://juejin.cn/post/6856418701584007176
    subscript(_ indexs: ClosedRange<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex...endIndex])
    }
    
    subscript(_ indexs: Range<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeThrough<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex...endIndex])
    }
    
    subscript(_ indexs: PartialRangeFrom<Int>) -> String {
        let beginIndex = index(startIndex, offsetBy: indexs.lowerBound)
        return String(self[beginIndex..<endIndex])
    }
    
    subscript(_ indexs: PartialRangeUpTo<Int>) -> String {
        let endIndex = index(startIndex, offsetBy: indexs.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    // Demo
    func testString() {
        let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        print(alphabet[alphabet.index(alphabet.startIndex, offsetBy: 3)])
        print(alphabet[..<4])  // ABCD
        print(alphabet[...4])  // ABCDE
        print(alphabet[5..<10]) // FGHIJ
        print(alphabet[5...10]) // FGHIJK
        print(alphabet[11...])  // LMNOPQRSTUVWXYZ
    }
}

func getTopVC() -> UIViewController? {
    guard let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first else {
        return nil
    }
    if var topController = keyWindow.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    return nil
}

extension UIView {
    /// 截图整个view
    /// - Returns: image
    func mooSnapshot() -> UIImage? {
        if self.window == nil {
            return nil
        }
        let scale = UIScreen.main.scale
        var image: UIImage? = nil
        // 1. 创建绘图渲染格式
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.scale = scale
            format.opaque = self.isOpaque
            // 2. 创建绘图渲染器
            let renderer = UIGraphicsImageRenderer(size: self.bounds.size,
                                                   format: format)
            // 3. 绘制图
            image = renderer.image { context in
                let success = self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
                print("draw success: \(success)")
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, scale);
            let success = self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            print("draw success: \(success)")
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        return image
    }
    
    /// 截取view的部分区域
    /// - Parameter frame: 需要截取的区域
    /// - Returns: image
    func mooSnapshotForFrame(_ frame: CGRect) -> UIImage? {
        guard let image = self.mooSnapshot() else { return nil }
        guard let cgImage = image.cgImage else { return nil }
        let scale = UIScreen.main.scale
        // 根据屏幕倍率将 frame 进行缩放
        let scaledRect = CGRectApplyAffineTransform(frame, CGAffineTransformMakeScale(scale, scale))
        // 根据 缩放frame 进行裁剪
        guard let scaledCGImage = cgImage.cropping(to: scaledRect) else { return nil }
        let returnImage = UIImage(cgImage: scaledCGImage)
        return returnImage
    }
}
