//
//  KYButtonCells.swift
//  KYButton
//
//  Created by cuber7788 on 2016/10/7.
//  Copyright © 2016年 Lawliet. All rights reserved.
//

import UIKit

class KYButtonCells: UIButton {
    weak var actionButton:KYButton?
    fileprivate let circleLayer = CAShapeLayer()
    fileprivate let tintLayer = CAShapeLayer()
    let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 58, height: 58), cornerRadius: 58 / 2)
    var actionCloure : ((KYButtonCells) -> Void)?
    var originColor : UIColor?
    var label:UILabel? = nil
    
    open var buttonItemColor : UIColor = UIColor.clear {
        didSet {
            circleLayer.fillColor = buttonItemColor.cgColor
            originColor? = buttonItemColor
        }
    }
    public init() {
        super.init(frame:CGRect.zero)
        self.creatCircle()
        self.createShadow()
        label = UILabel()
        label?.textColor = titleColor
        addSubview(label!)
        self.addTarget(self, action: #selector(touch), for: UIControl.Event.touchUpInside)
    }
    
    open var titleColor : UIColor = UIColor.white{
        didSet{
            label?.textColor = titleColor
        }
    }
    
    open var title: String? = nil {
        didSet {
            label?.text = title
            label?.sizeToFit()
            label?.frame.origin.x = -((label?.frame.size.width)!)
            label?.frame.origin.y = 58/2 - (label?.frame.size.height)!/2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func creatCircle() {
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = buttonItemColor.cgColor
        originColor = buttonItemColor
        layer.addSublayer(circleLayer)
    }
    
    fileprivate func creatLayer(){
        tintLayer.path = circlePath.cgPath
        tintLayer.fillColor = UIColor.white.withAlphaComponent(0.5).cgColor
        layer.addSublayer(tintLayer)
    }
    
    fileprivate func createShadow(){
        circleLayer.shadowOffset = CGSize(width: 0, height: 0)
        circleLayer.shadowOpacity = 1
    }
    @objc func touch () {
        actionCloure?(self)
        actionButton!.closeButton()
    }
}
