//
//  CircleLoadingView.swift
//  06_CircleLoading
//
//  Created by moxiaoyan on 2019/6/26.
//  Copyright © 2019 moxiaoyan. All rights reserved.
//

import UIKit

class CircleLoadingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 形状
        let lineWidth: CGFloat = 4
        let color = UIColor.init(red: 15.0/255.0, green: 197.0/255.0, blue: 177.0/255.0, alpha: 1)
        let middleColor = UIColor.init(red: 15.0/255.0, green: 197.0/255.0, blue: 177.0/255.0, alpha: 0.5)
        let circleLayer = CAShapeLayer.init()
        circleLayer.lineWidth = lineWidth;
        //        circleLayer.frame = self.translateTypeView.bounds
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        
        // 曲线
        //        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: self.translateTypeView.width / 2, y: self.translateTypeView.height / 2), radius: self.translateTypeView.height / 2, startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(Double.pi * 2), clockwise: true) // 有毛边
        let circlePath = UIBezierPath.init(ovalIn: self.bounds)
        circleLayer.path = circlePath.cgPath
        
        // 渐变
        let gradientLayer = CALayer.init()
        // 渐变1
        let gradient = CAGradientLayer.init()
        gradient.frame = CGRect(x: -lineWidth * 2, y: -lineWidth * 2, width: self.bounds.size.width / 2 + lineWidth * 2, height: self.bounds.size.height + lineWidth*3)
        gradient.colors = [color.cgColor, middleColor.cgColor]
        //        gradient.locations = [NSNumber(value: 0.1), NSNumber(value:1.0)] // 设置比例
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.shadowPath = circlePath.cgPath
        
        // 渐变1
        let gradient2 = CAGradientLayer.init()
        gradient2.frame = CGRect(x: self.bounds.size.width / 2, y: -lineWidth * 2, width: self.bounds.size.width / 2 + lineWidth * 2, height: self.bounds.size.height + lineWidth*3)
        gradient2.colors = [UIColor.white.cgColor, middleColor.cgColor]
        //        gradient2.locations = [NSNumber(value: 0.1), NSNumber(value:1.0)]
        gradient2.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient2.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient2.shadowPath = circlePath.cgPath
        
        gradientLayer.addSublayer(gradient)
        gradientLayer.addSublayer(gradient2)
        gradientLayer.mask = circleLayer
        
        // CABasicAnimation strokeEnd动画
        let pathAnimation = CABasicAnimation()
        pathAnimation.keyPath = "strokeEnd"
        pathAnimation.duration = 1.0
        //    pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        //    pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.repeatCount = 1
        circleLayer.add(pathAnimation, forKey: "strokeEndAnimationcircle")
        
        // 旋转z
        let rotateAnima = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotateAnima.duration = 1.0
        rotateAnima.repeatCount = HUGE
        rotateAnima.fromValue = NSNumber(value: 0.0)
        rotateAnima.toValue = NSNumber(value: Double.pi * 2)
        rotateAnima.beginTime = CACurrentMediaTime() + 3.0 / 4.0
        
        gradientLayer.add(rotateAnima, forKey: "rotateAnimationcircle")
        gradientLayer.frame = self.bounds  // 一定要设置frame，不然anchorPoint(锚点--旋转中心点始终是（0,0）)
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
