//
//  MOPopViewController.swift
//  MODemo
//
//  Created by MikiMo on 2020/12/18.
//

import UIKit

class MOPopViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let btn = UIButton(frame: CGRect(x: 50, y: 100, width: 50, height: 50))
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(clickBtn(sender:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
    }
    @objc func clickBtn(sender: UIButton) {
        let vc = UITableViewController(style: .plain)
        vc.tableView.isScrollEnabled = false
        // 设置内容控制器大小
        vc.preferredContentSize = CGSize(width: 300, height: 300)
        // 模态显示类型
        vc.modalPresentationStyle = .popover
        
        // 参照物
        vc.popoverPresentationController?.sourceView = sender
        vc.popoverPresentationController?.sourceRect = sender.bounds
        // 设置popView显示时, 还可与用户交互的views
        //    vc.popoverPresentationController?.passthroughViews =
        // 设置箭头方向
        vc.popoverPresentationController?.permittedArrowDirections = .up
        vc.popoverPresentationController?.delegate = self
        self.navigationController?.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)
    }
    // MARK: - UIAdaptivePresentationControllerDelegate
    // 在ipad下不会调用，在iphone下会调用
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // iPhone下默认是.overFullScreen(全屏显示)，需要返回.none，否则，没有弹窗效果。iPad不需要 !!!!
        return .none
    }
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let nav = UINavigationController(rootViewController: controller.presentedViewController)
        let item = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(complete))
        nav.topViewController?.navigationItem.rightBarButtonItem = item
        return nav
    }
    @objc func complete() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UIPopoverPresentationControllerDelegate
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        print("prepare pop")
    }
    // 点击蒙板消失, 默认: true
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("pop dismissed")
    }
    // 弹出窗将要复位到指定视图区域时触发的方法
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
    }
    
}

