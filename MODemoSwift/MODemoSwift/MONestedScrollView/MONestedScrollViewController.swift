//
//  MONestedScrollViewController.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/8/17.
//

import UIKit

class MONestedScrollViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    // MARK: - Private Methods
    
    func subScrollWillBeginDragging(_: UIScrollView) {
        
    }
    
    func subScrollDidScroll(_: UIScrollView) {
        
    }
    
    // MARK: - Getter Methods
    
    private lazy var scrollView: UIScrollView = {
        let scroll = MOMultiResponseScrollView(frame: .zero)
        scroll.delegate = self
        scroll.bounces = false
        return scroll
    }()
    
    private lazy var playerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .cyan
        return view
    }()
    
    private lazy var tabsContainerCtl: MOMultiTabContainerViewController = {
        let ctl = MOMultiTabContainerViewController(nibName: nil, bundle: nil)
        ctl.willBeginDragging = { (scrollView: UIScrollView) in
            self.subScrollWillBeginDragging(scrollView)
        }
        ctl.didScroll = { (scrollView: UIScrollView) in
            self.subScrollDidScroll(scrollView)
        }
        return ctl
    }()

}
