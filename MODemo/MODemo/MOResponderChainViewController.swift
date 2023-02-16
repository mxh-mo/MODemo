//
//  MOResponderChainViewController.swift
//  MODemo
//
//  Created by mikimo on 2022/10/15.
//

import UIKit

class MOResponderTestView: UIView {
    
    init(frame: CGRect, title: String, color: UIColor) {
        self.title = title
        super.init(frame: frame)
        
        self.backgroundColor = color
        
        self.addSubview(self.titleLabel)
        self.titleLabel.text = title
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("hitTest: \(self)")
        /// 1. 判断当前view是否可响应
        guard isUserInteractionEnabled else {
            /// 不允许用户交互
            return nil
        }
        guard !isHidden else {
            /// 已隐藏
            return nil
        }
        guard alpha > 0.01 else {
            /// 不透明度小于等于 0.01
            return nil
        }
        
        /// 2. touch的坐标是否在view的frame内
        guard self.point(inside: point, with: event) else {
            return nil
        }

        /// 3. 倒序遍历子视图, 递归调用hitTest
        for subview in subviews.reversed() {
            let subPoint = self.convert(point, to: subview)
            /// 首个非空子视图, 即为 first responder
            if let fitView = subview.hitTest(subPoint, with: event) {
                return fitView
            }
        }
        /// 4. 遍历所有的子视图都没有响应 hit-testing, 则该view为 first responder
        return self
    }
    
    override var description: String {
        return String("\(Unmanaged.passUnretained(self).toOpaque()), title:\(self.title)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let title: String
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 60, height: 30))
        return label
    }()
}

class MOResponderChainViewController: UIViewController {

    override func loadView() {
        super.loadView()
        
        self.view = MOResponderTestView(frame: .zero,
                                        title: "white",
                                        color: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view1 = MOResponderTestView(frame: CGRect(x: 20, y: 100, width: 200, height: 200),
                                        title: "cyan",
                                        color: .cyan)
        view.addSubview(view1)
                
        let view2 = MOResponderTestView(frame: CGRect(x: 50, y: 50, width: 130, height: 130),
                                        title: "red",
                                        color: .red)
        view1.addSubview(view2)
        
        let view3 = MOResponderTestView(frame: CGRect(x: 50, y: 50, width: 130, height: 130),
                                        title: "blue",
                                        color: .blue)
        view2.addSubview(view3)
    }

}
