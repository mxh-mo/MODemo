//
//  MOUITestsViewController.swift
//  MODemo
//
//  Created by MikiMo on 2021/3/20.
//

import UIKit

let gSubscribeButtonAccessibilityIdentifier = "MOUITestsViewController_subscribeButton"

class MOUITestsViewController: UIViewController {
    
    public var isCanTests: Bool = false
    var subscribeButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .gray
        btn.setTitle("订阅", for: .normal)
        btn.setTitle("已订阅", for: .selected)
        btn.addTarget(self, action: #selector(clickSubscribeButton), for: .touchUpInside)
        btn.accessibilityIdentifier = gSubscribeButtonAccessibilityIdentifier
        return btn
    }()
    let num1: CGFloat = 1.0
    let num2: CGFloat = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(subscribeButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.subscribeButton.frame = CGRect(x: 10.0, y: 100.0, width: 100.0, height: 50.0)
    }
    
    @objc func clickSubscribeButton(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
