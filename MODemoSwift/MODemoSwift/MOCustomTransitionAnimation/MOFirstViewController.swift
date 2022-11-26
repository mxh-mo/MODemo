//
//  MOFirstViewController.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/11/6.
//

import UIKit

class MOFirstViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(self.pushButton)
        view.addSubview(self.presentButton)
        moPrint(self, #line, "firstView: \(view)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent { /// 回外部，移除代理
            self.navigationController?.delegate = nil
            self.navigationController?.transitioningDelegate = nil
        }
    }
    
    // MARK: - Private Methods

    @objc func didClickPushButton() {
        let toVC = UIViewController()
        toVC.view.backgroundColor = .purple
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(toVC, animated: true)
    }
    
    @objc func didClickPresentButton() {
        let toVC = MOSecondViewController()
        toVC.modalPresentationStyle = .custom
        toVC.transitioningDelegate = self
        present(toVC, animated: true)
    }
    
    // MARK: - Getter Methods
    
    private lazy var pushButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 120, width: 44, height: 44))
        button.setTitle("push", for: .normal)
        button.addTarget(self, action: #selector(didClickPushButton), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    private lazy var presentButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 200, width: 66, height: 44))
        button.setTitle("present", for: .normal)
        button.addTarget(self, action: #selector(didClickPresentButton), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
}

// push 动效代理 (naviagtionController.delegate)
extension MOFirstViewController {
    
    // MARK: - UINavigationControllerDelegate
    
    /// 返回自定义转场动画
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        moPrint(self, #line, "return animator")
        if operation == .push {
            return MOPushOrPresentAnimator()

        } else {
            return MOPopOrDismissAnimator()

        }
    }
}

// present 动效代理 (toVC.transitioningDelegate)
extension MOFirstViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        moPrint(self, #line, "return present animator")
        return MOPushOrPresentAnimator()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        moPrint(self, #line, "return dismissed animator")
        return MOPopOrDismissAnimator()
    }

    // 也可以用一个vc来实现动效
//    func presentationController(forPresented presented: UIViewController,
//                                presenting: UIViewController?,
//                                source: UIViewController) -> UIPresentationController? {
//        moPrint(self, #line, "return presentationController")
//        return MOPresentationController(presentedViewController: presented, presenting: presenting)
//    }

}
