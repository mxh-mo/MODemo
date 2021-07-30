//
//  KYButton.swift
//  KYButton
//
//  Created by Lawliet on 2016/10/3.
//  Copyright © 2016年 Lawliet. All rights reserved.
//

import UIKit
@IBDesignable

@objc class KYButton: UIButton {
    enum openButtonType : NSInteger {
        case slideUp
        case slideDown
        case popUp
        case popDown
        case popLeft
        case popRight
    }
    @objc public var kyDelegate:KYButtonDelegate?
    @objc public var fabTitleColor : UIColor!
    var hilighColor : UIColor!
    var orignalColor : UIColor!
    @objc public var overLayView : OverLayView!
    var buttonLayer : ButtonLayer?
    var isHide : Bool = true
    var openType : openButtonType = .popUp
    var buttonCells : KYButtonCells?
    var items : [KYButtonCells] = []
    var plusColor:UIColor = UIColor.black {
        didSet{
            buttonLayer?.plusColor = plusColor
        }
    }
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonLayer = ButtonLayer.init(bg: self.backgroundColor!)
        orignalColor = self.backgroundColor
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.addSublayer(buttonLayer!)
    }
    @objc func touchSelf () {
        if (self.isHide) {
            self.openButton()
        } else {
            self.closeButton()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 60, height: 60)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonLayer?.frame = self.bounds
        self.invalidateIntrinsicContentSize()
        self.addTarget(self, action: #selector(touchSelf), for: .touchUpInside)
    }
    
    fileprivate func openButton() {
        self.isHide = false
        self.overLayView = OverLayView()
        self.superview?.insertSubview(self.overLayView, belowSubview:self)
        overLayView.addTarget(self, action: #selector(KYButton.closeButton), for: .touchUpInside)
        
        for item in items {
            self.overLayView.addSubview(item)
        }
        
        switch openType {
        case .slideUp: slideUpAnimation(isShow: true)
        case .slideDown: slideDownAnimation(isShow: true)
        case .popUp: popAnimation(isShow: true)
        case .popDown: popDownAnimation(isShow: true)
        case .popLeft: popLeftAnimation(isShow: true)
        case .popRight: popRightAnimation(isShow: true)
        }
        self.kyDelegate?.openKYButton?(self)
    }
    
    @objc func closeButton() {
        switch openType {
        case .slideUp: slideUpAnimation(isShow: false)
        case .slideDown: slideDownAnimation(isShow: false)
        case .popUp: popAnimation(isShow: false)
        case .popDown: popDownAnimation(isShow: false)
        case .popLeft: popLeftAnimation(isShow: false)
        case .popRight: popRightAnimation(isShow: false)
        }
        self.kyDelegate?.closeKYButton?(self)
    }
    
    @objc open func add(title:String, titleColor:UIColor, image:UIImage, highlightImage:UIImage, handle:@escaping ((KYButtonCells)->Void)) {
        let item = KYButtonCells()
        item.alpha = 0
        item.actionCloure = handle
        item.actionButton = self
        item.title = title
        item.titleColor = titleColor;
        item.setBackgroundImage(image, for: UIControl.State.normal)
        item.setBackgroundImage(highlightImage, for:UIControl.State.highlighted)
        items.append(item)
    }
    
    //    ----------------------------------------------slideUp---------------------------------------------------
    fileprivate func slideUpAnimation(isShow:Bool) {
        var delay = 0.0
        if isShow {
            for (index,item) in items.enumerated() {
                item.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - self.frame.height * CGFloat(index), width: self.frame.width, height: self.frame.height)
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    let shift = self.frame.height
                    item.transform = CGAffineTransform.init(translationX: 0, y:  -shift)
                    item.alpha = 1
                }, completion: nil)
                delay += 0.15
            }
        } else {
            for (index,item) in items.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    item.transform = CGAffineTransform.identity
                    item.alpha = 0
                }, completion: { (finish) in
                    if index == self.items.count-1 && !isShow{
                        self.isHide = true
                        self.overLayView.removeFromSuperview()
                    }
                })
                delay += 0.15
            }
        }
    }
    
    //    ----------------------------------------------slideDown---------------------------------------------------
    fileprivate func slideDownAnimation(isShow:Bool) {
        var delay = 0.0
        if isShow {
            for (index,item) in items.enumerated() {
                item.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height * CGFloat(index) + 25, width: self.frame.width, height: self.frame.height)
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    let shift = self.frame.height
                    item.transform = CGAffineTransform.init(translationX: 0, y:  shift)
                    item.alpha = 1
                }, completion: nil)
                delay += 0.15
            }
        } else {
            for (index,item) in items.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    item.transform = CGAffineTransform.identity
                    item.alpha = 0
                }, completion: { (finish) in
                    if index == self.items.count-1 && !isShow{
                        self.isHide = true
                        self.overLayView.removeFromSuperview()
                    }
                })
                delay += 0.15
            }
        }
    }
    
    //    ----------------------------------------------pop---------------------------------------------------
    fileprivate func popAnimation(isShow:Bool) {
        var delay = 0.0
        if isShow {
            for (index,item) in items.enumerated() {
                item.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y - (self.frame.height + 20) * CGFloat(index+1) , width: self.frame.width, height: self.frame.height)
                item.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
                UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    item.transform = CGAffineTransform.identity
                    item.alpha = 1
                }, completion: nil)
                delay += 0.15
            }
        } else {
            for (index,item) in items.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                    
                    item.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                    item.alpha = 0
                }, completion: { (finish) in
                    if index == self.items.count-1 && !isShow {
                        self.isHide = true
                        self.overLayView.removeFromSuperview()
                    }
                    item.transform = CGAffineTransform.identity
                })
                delay += 0.15
            }
        }
    }
    
    //    ----------------------------------------------popDown---------------------------------------------------
    fileprivate func popDownAnimation(isShow:Bool) {
        var delay = 0.0
        if isShow {
            for (index,item) in items.enumerated() {
                item.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height * CGFloat(index+1) + 25, width: self.frame.width, height: self.frame.height)
                item.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
                UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    item.transform = CGAffineTransform.identity
                    item.alpha = 1
                }, completion: nil)
                delay += 0.15
            }
        } else {
            for (index,item) in items.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                    item.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                    item.alpha = 0
                }, completion: { (finish) in
                    if index == self.items.count-1 && !isShow {
                        self.isHide = true
                        self.overLayView.removeFromSuperview()
                    }
                    item.transform = CGAffineTransform.identity
                })
                delay += 0.15
            }
        }
    }
    
    //    ----------------------------------------------popLeft---------------------------------------------------
    fileprivate func popLeftAnimation(isShow:Bool) {
        var delay = 0.0
        if isShow {
            for (index,item) in items.enumerated() {
                
                item.frame = CGRect(x: self.frame.origin.x - self.frame.width * CGFloat(index), y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
                
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    let shift = self.frame.height
                    item.transform = CGAffineTransform.init(translationX: -shift, y:  0)
                    item.alpha = 1
                }, completion: nil)
                delay += 0.15
            }
        } else {
            for (index,item) in items.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    item.transform = CGAffineTransform.identity
                    item.alpha = 0
                }, completion: { (finish) in
                    if index == self.items.count-1 && !isShow {
                        self.isHide = true
                        self.overLayView.removeFromSuperview()
                    }
                })
                delay += 0.15
            }
        }
    }
    
    //    ----------------------------------------------popRight---------------------------------------------------
    fileprivate func popRightAnimation(isShow:Bool) {
        var delay = 0.0
        if isShow {
            for (index,item) in items.enumerated() {
                item.frame = CGRect(x: self.frame.origin.x + self.frame.width * CGFloat(index+1), y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
                item.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
                
                UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: {
                    item.transform = CGAffineTransform.identity
                    item.alpha = 1
                }, completion: nil)
                delay += 0.15
            }
        } else {
            for (index,item) in items.reversed().enumerated(){
                UIView.animate(withDuration: 0.2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
                    item.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                    item.alpha = 0
                }, completion: { (finish) in
                    if index == self.items.count-1 && !isShow{
                        self.isHide = true
                        self.overLayView.removeFromSuperview()
                    }
                    item.transform = CGAffineTransform.identity
                })
                delay += 0.15
            }
        }
    }
}
