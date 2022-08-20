//
//  MONestedScrollViewController.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/8/17.
//

import UIKit

class MONestedScrollViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Initail Methods
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.mainScrollView)
        self.mainScrollView.addSubview(self.tabsContainerCtl.view)
        
        self.view.addSubview(self.playerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let viewSize = self.view.bounds.size
        let safeInset = self.view.safeAreaInsets
        let containerWidth = viewSize.width - safeInset.left - safeInset.right
        let containerHeight = viewSize.height - safeInset.top - safeInset.bottom

        let scrollView = self.mainScrollView
        let playerView = self.playerView
        let tabsContainerView = self.tabsContainerCtl.view

        scrollView.frame = CGRect(x: safeInset.left, y: safeInset.top, width: containerWidth, height: containerHeight)
        scrollView.contentInset = UIEdgeInsets(top: scrollInsetTop, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentSize = CGSize(width: containerWidth, height: containerHeight)
        
        print("contentOffset \(scrollView.contentOffset.y)")
        let scrollOffsetY = scrollView.contentOffset.y
        playerView.frame = CGRect(x: safeInset.left,
                                  y: safeInset.top,
                                  width: containerWidth,
                                  height: playerViewMinHeight + abs(scrollOffsetY))
        
        tabsContainerView?.frame = CGRect(x: 0.0,
                                          y: playerViewMinHeight,
                                          width: containerWidth,
                                          height: containerHeight - playerViewMinHeight)

    }
    
    
    // MARK: - Private Methods - 主 ScrollView 的回调事件
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.beforeDraggingOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.canScroll {
            self.view.setNeedsLayout()
            return
        }
        self.updateScrollView(scrollView, self.beforeDraggingOffset)
    }
    
    // MARK: - Private Methods - 内部 ScrollView 的回调事件
    
    func subScrollWillBeginDragging(_ scrollView: UIScrollView) {
        if !scrollView.isEqual(self.subScrollView) {
            return
        }
        print("subScrollWillBeginDragging: \(scrollView.contentOffset.y)")
        self.subScrollViewPreOffset = scrollView.contentOffset
    }
    
    func subScrollDidScroll(_ scrollView: UIScrollView) {
        if !scrollView.isEqual(self.subScrollView) {
            return
        }
        if scrollView.contentOffset.y == self.subScrollViewPreOffset.y {
            return
        }
        let pullDown: Bool = scrollView.contentOffset.y < self.subScrollViewPreOffset.y
        if pullDown {    /// 下拉: 先拉 list
//            print("下拉 subScrollDidScroll: \(scrollView.contentOffset.y)")
            if scrollView.contentOffset.y > 0 { /// 还没拉到顶
                self.canScroll = false
                self.subScrollViewPreOffset = scrollView.contentOffset
                return
            }

            let isMaxState = self.playerView.frame.height == playerViewMaxHeight
            self.canScroll = !isMaxState
            if isMaxState {
                self.subScrollViewPreOffset = scrollView.contentOffset
            } else {
                print("拉到顶部了 & 播放器需要放大")
                /// 放大player时，不需要下拉刷新效果
                self.updateScrollView(scrollView, .zero)
                self.subScrollViewPreOffset = .zero
            }
        } else {    /// pullUp 上拉: 先缩小播放器
            print("上拉 subScrollDidScroll: \(scrollView.contentOffset.y)")
            let isMinState = self.playerView.frame.height == playerViewMinHeight
            self.canScroll = !isMinState
            if isMinState {
                self.subScrollViewPreOffset = scrollView.contentOffset
                return
            }
            if scrollView.contentOffset.y <= 0 { /// 忽略下拉刷新的回弹(否则死循环)
                return
            }
            print("播放器可缩小 重置subScrollView")
            self.updateScrollView(scrollView, self.subScrollViewPreOffset)
        }
    }
    
    // MARK: - Private Methods
    
    /// 切换 subScrollView
    func subScrollDidChange(_ scrollView: UIScrollView) {
        self.canScroll = true
        self.subScrollView = scrollView
        self.subScrollViewPreOffset = scrollView.contentOffset
        print("subScrollDidChange")
    }
    
    /// 更新 scrollView 的 offset, 相同时跳过，防止死循环
    func updateScrollView(_ scrollView: UIScrollView, _ offset: CGPoint) {
        if scrollView.contentOffset.equalTo(offset) {
            return
        }
        scrollView.contentOffset = offset;
    }
    
    // MARK: - Private Properties

    private let scrollInsetTop: CGFloat = 300.0
    private let playerViewMinHeight: CGFloat = 100.0
    private let playerViewMaxHeight: CGFloat = 400.0
    private let scrollViewPullUpManVelocity: CGFloat = -5.0
    private let scrollViewPullDownMinVelocity: CGFloat = 5.0

    private var beforeDraggingOffset: CGPoint = .zero
    private var canScroll: Bool = true {
        didSet {
            print("canScroll: \(canScroll)")
        }
    }
    private var subScrollView: UIScrollView?
    private var subScrollViewPreOffset: CGPoint = .zero {
        didSet {
            print("subScrollViewPreOffset: \(subScrollViewPreOffset)")
        }
    }

    // MARK: - Getter Methods
    
    private lazy var mainScrollView: UIScrollView = {
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
        ctl.subScrollDidChange = { (scrollView: UIScrollView) in
            self.subScrollDidChange(scrollView)
        }
        return ctl
    }()
}
