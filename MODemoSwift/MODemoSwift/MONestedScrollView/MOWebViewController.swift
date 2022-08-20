//
//  MOWebViewController.swift
//  MODemoSwift
//
//  Created by mikimo on 2022/8/17.
//

import UIKit
import WebKit

class MOWebViewController: UIViewController, MOSubScrollViewProtocol {

    // MARK: - MOSubScrollViewProtocol
    var willBeginDragging: MOSubScrollWillBeginDragging?
    var didScroll: MOSubScrollDidScroll?
    var scrollView: UIScrollView {
        get {
            return self.webView.scrollView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.scrollView.bounces = false // 需要兼容
        self.view.addSubview(self.webView)
        
        let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
        self.webView.load(request)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        let viewSize = self.view.bounds.size
        let safeInset = self.view.safeAreaInsets
        let webViewWidth = viewSize.width - safeInset.left - safeInset.right
        let webViewHeight = viewSize.height - safeInset.top - safeInset.bottom

        self.webView.frame = CGRect(x: safeInset.left, y: safeInset.top, width: webViewWidth, height: webViewHeight)
    }
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.scrollView.delegate = self
        return webView
    }()
}

extension MOWebViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let willBeginDragging = self.willBeginDragging else {
            return
        }
        willBeginDragging(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let didScroll = self.didScroll else {
            return
        }
        didScroll(scrollView)
    }
}
