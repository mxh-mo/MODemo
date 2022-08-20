//
//  MOMultiTabContainerViewController.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/8/17.
//

import UIKit

typealias MOSubScrollDidChange = (UIScrollView) -> ()

class MOMultiTabContainerViewController: UIViewController, MOSubScrollViewProtocol {
        
    // MARK: - MOSubScrollViewProtocol
    
    var willBeginDragging: MOSubScrollWillBeginDragging? {
        didSet {
            self.tabViewCtl.willBeginDragging = willBeginDragging
            self.webViewCtl.willBeginDragging = willBeginDragging
        }
    }
    var didScroll: MOSubScrollDidScroll? {
        didSet {
            self.tabViewCtl.didScroll = didScroll
            self.webViewCtl.didScroll = didScroll
        }
    }
    var subScrollDidChange: MOSubScrollDidChange?

    // MARK: - Initail Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.segmentControl)
        self.view.addSubview(self.scrollView)

        self.scrollView.addSubview(self.tabViewCtl.view)
        self.scrollView.addSubview(self.webViewCtl.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewSize = self.view.bounds.size
        let safeInset = self.view.safeAreaInsets
        let containerWidth = viewSize.width - safeInset.left - safeInset.right
        let containerHeight = viewSize.height - safeInset.top - safeInset.bottom
        
        self.segmentControl.frame = CGRect(x: safeInset.left, y: safeInset.top, width: containerWidth, height: 44.0)
        
        let contentHeight = containerHeight  - self.segmentControl.frame.height
        self.scrollView.frame = CGRect(x: safeInset.left,
                                       y: self.segmentControl.frame.maxY,
                                       width: containerWidth,
                                       height: contentHeight)
        self.scrollView.contentSize = CGSize(width: containerWidth * 2.0, height: contentHeight)
        
        self.tabViewCtl.view.frame = CGRect(x: 0.0, y: 0.0, width: containerWidth, height: contentHeight)
        self.webViewCtl.view.frame = CGRect(x: containerWidth, y: 0.0, width: containerWidth, height: contentHeight)
    }
    
    
    // MARK: - Private Methods

    @objc func didSelectedSegement() {
        let index = self.segmentControl.selectedSegmentIndex
        let currentScrollView: UIScrollView
        
        if (index == 0) {
            self.scrollView.contentOffset = CGPoint(x: 0.0, y: self.scrollView.contentOffset.y)
            currentScrollView = self.tabViewCtl.scrollView
        } else {
            self.scrollView.contentOffset = CGPoint(x: self.tabViewCtl.view.frame.width, y: self.scrollView.contentOffset.y)
            currentScrollView = self.webViewCtl.scrollView
        }
        
        guard let subScrollDidChange = subScrollDidChange else {
            return
        }
        subScrollDidChange(currentScrollView)
    }
    
    // MARK: - Getter Methods
    
    private var selectedIndex: UInt = 0
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["tableView", "webView"])
        segment.addTarget(self, action: #selector(didSelectedSegement), for: .valueChanged)
        return segment
    }()
    
    private lazy var tabViewCtl: MOTableViewController = {
        let vc = MOTableViewController(style: .plain)
        return vc
    }()
    
    private lazy var webViewCtl: MOWebViewController = {
        let vc = MOWebViewController(nibName: nil, bundle: nil)
        return vc
    }()
    
}
