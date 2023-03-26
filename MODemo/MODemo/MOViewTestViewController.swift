//
//  MOViewTestViewController.swift
//  MODemo
//
//  Created by MikiMo on 2020/12/18.
//

import UIKit
import SnapKit

typealias MOSwipeUpCallback = () -> ()

struct MOAssociatedKeys {
    static var touchPointKey: String = "touchPoint"
    static var swipeUpCallbackKey: String = "swipeUpCallback"
}

/* 会全局修改view的手势，先注释避免影响
extension UIView {
    // 上一次触摸点
    public var touchPoint: CGPoint? {
        get {
            return objc_getAssociatedObject(self, &MOAssociatedKeys.touchPointKey) as? CGPoint
        }
        set {
            objc_setAssociatedObject(self, &MOAssociatedKeys.touchPointKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // 上滑回调
    var didReceiveSwipeUp: MOSwipeUpCallback? {
        get {
            return objc_getAssociatedObject(self, &MOAssociatedKeys.swipeUpCallbackKey) as? MOSwipeUpCallback
        }
        set {
            objc_setAssociatedObject(self, &MOAssociatedKeys.swipeUpCallbackKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        if let touchPoint = self.touchPoint { // 不是第一次
            if (touchPoint.y > point.y) { // 当前点在上一个点的上方
                moPrint(self, #line, "swipe up")
                guard let callback = self.didReceiveSwipeUp else { return }
                callback();
                self.touchPoint = point
            }
        } else { // 是第一次
            self.touchPoint = point
        }
    }
}
 */

class MOViewTestViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        moPrint(self, #line, "init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        moPrint(self, #line, "loadView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moPrint(self, #line, "viewDidLoad")

//        swipeGestureTest(); // 解决：上滑手势 跟 按钮 cancel 手势 冲突
//        imageViewTransform() // UIImageView 翻转
//        stackView() // UIStackView
//        gradientLayer() // UIView 颜色渐变
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moPrint(self, #line, "viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moPrint(self, #line, "viewDidAppear")
    }
    
    // MARK: - 解决：上滑手势 跟 按钮 cancel 手势 冲突
    func swipeGestureTest() {

        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.isUserInteractionEnabled = true
//        view.didReceiveSwipeUp = {
//            moPrint(self, #line, "did reveive swipe up")
//        }
        self.view.addSubview(view)
        
        let btn = UIView(frame: .zero)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didClickBtn))
        btn.addGestureRecognizer(tap)
        btn.backgroundColor = .red
//        btn.didReceiveSwipeUp = {
//            moPrint(self, #line, "did reveive swipe up btn")
//        }
        self.view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.top.left.equalTo(self.view).offset(200)
            make.height.width.equalTo(44.0)
        }
    }

    @objc func didClickBtn() {
        moPrint(self, #line, "did clic button")
    }
    
    // MARK: - UIView 颜色渐变
    func gradientLayer() {
        let rect = CGRect(x: 30, y: 320, width: 100, height: 100)
        let gradientView = UIView(frame: rect)
        
        let gradientLayer = CAGradientLayer()  //新建一个渐变层
        gradientLayer.frame = gradientView.frame
        
        let fromColor = UIColor.yellow.cgColor
        let midColor = UIColor.red.cgColor
        let toColor = UIColor.purple.cgColor
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        //[fromColor,midColor,toColor]//将渐变层的颜色属性设置为由三个颜色所构建的数组
        
        view.layer.addSublayer(gradientLayer) //将设置好的渐变层添加到视图对象的层中
        self.view.addSubview(gradientView)
    }
    
    // MARK: - UIStackView
    func stackView() {
        let img1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        img1.backgroundColor = .red
        
        let img2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        img2.backgroundColor = .green
        
        let img3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        img3.backgroundColor = .blue
        
        let stackView = UIStackView(arrangedSubviews: [img1, img2])
        stackView.frame = CGRect(x: 20, y: 150, width: 100, height: 100);
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.backgroundColor = .cyan
        //    self.view.addSubview(stackView)
        
        let stackView2 = UIStackView(arrangedSubviews: [stackView, img3])
        stackView2.frame = CGRect(x: 0, y: 250, width:200, height: 50);
        stackView2.axis = .horizontal
        stackView2.alignment = .fill
        stackView2.distribution = .fillEqually
        stackView2.spacing = 4
        stackView2.backgroundColor = .cyan
        self.view.addSubview(stackView2)
    }
    
    // MARK: - UIImageView 翻转
    func imageViewTransform() {
        // 测试 设置图片后翻转 和 翻转后设置图片
        let imgV1 = UIImageView(frame: CGRect(x: 50, y: 100, width: 50, height: 50))
        imgV1.image = UIImage(named: "mo_mic")
        self.view.addSubview(imgV1)
        imgV1.transform = CGAffineTransform(rotationAngle: .pi)
        //    // CGAffineTransform 是按照原始角度旋转的, 所以写两次是不会旋转回去的
        //    imgV1.transform = CGAffineTransform(rotationAngle: .pi)
        //
        //    // OC的`CGAffineTransformRotate`方法 用 transform.rotated(by: Float) 代替
        //    // 在 imgV1.transform 的 基础上旋转角度
        //    imgV1.transform = imgV1.transform.rotated(by: .pi)
        
        
        let imgV2 = UIImageView(frame: CGRect(x: 200, y: 100, width: 50, height: 50))
        self.view.addSubview(imgV2)
        imgV2.transform = CGAffineTransform(rotationAngle: .pi)
        imgV2.image = UIImage(named: "mo_mic")
        // 结论: 不管是旋转前设置image 还是 旋转后设置image  都是一样的
        // (图片是按照当前`View的正方向`为`正方向`的)
    }
}
