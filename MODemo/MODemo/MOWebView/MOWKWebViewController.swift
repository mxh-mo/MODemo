//
//  MOWKWebViewController.swift
//  MODemo
//
//  Created by MikiMo on 2020/12/18.
//
// https://www.cnblogs.com/xjf125/p/11040902.html
// https://www.jianshu.com/p/caecde888d9f

import UIKit
import WebKit

class MOWKWebViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let url: URL = Bundle.main.url(forResource: "index", withExtension: "html") ?? URL(string: "https://www.baidu.com")!
        self.url = url
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        navigationItem.leftBarButtonItem = backBtnItem
        view.addSubview(webView)
        // 加载进度条
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .green
        progressView.trackTintColor = .lightGray
        progressView.progress = 0.0
        progressView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1)
        webView.addSubview(progressView)
        loadData()
        setupButtons()
    }
    func setupButtons() {
        let baseHeight = (navigationController?.navigationBar.frame.maxY ?? 0) + 20;
        let getJSBtn = UIButton(type: .custom)
        getJSBtn.setTitle("获取JS信息", for: .normal)
        getJSBtn.setTitleColor(.red, for: .normal)
        getJSBtn.addTarget(self, action: #selector(getJSInformation), for: .touchUpInside)
        getJSBtn.frame = CGRect(x: 30, y: view.frame.size.height/2 + baseHeight, width: 120, height: 40)
        view.addSubview(getJSBtn)
        
        let callJSFuncBtn = UIButton(type: .custom)
        callJSFuncBtn.setTitle("调用JS方法", for: .normal)
        callJSFuncBtn.setTitleColor(.red, for: .normal)
        callJSFuncBtn.addTarget(self, action: #selector(callJSFunc), for: .touchUpInside)
        callJSFuncBtn.frame = CGRect(x: 200, y: view.frame.size.height/2 + baseHeight, width: 120, height: 40)
        view.addSubview(callJSFuncBtn)
    }
    // MARK: - 获取JS title，并打印
    @objc func getJSInformation() {
        let js = "document.getElementsByTagName('h1')[0].innerText";
        webView.evaluateJavaScript(js, completionHandler: { (data, error) in
            print("getJSInformation data:\(String(describing: data)) error: \(String(describing: error))")
        })
    }
    // MARK: - 调用JS的方法，并打印返回数据
    @objc func callJSFunc() {
        webView.evaluateJavaScript("swiftTestObject('xjf', 26)", completionHandler: { (data, error) in
            print("callJSFunc data:\(String(describing: data)) error: \(String(describing: error))")
        })
    }
    func loadData() {
        let request = URLRequest(url: self.url)
        webView.load(request)
        //    webView.loadHTMLString(self.url.absoluteString, baseURL: self.url) 不能用这个方法，否则evaluateJavaScript方法报错
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                progressView.isHidden = true
            }
        }
    }
    @objc func popBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            close()
        }
    }
    @objc func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    @objc func close() {
        if navigationController?.viewControllers.count ?? 0 <= 1 {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    private lazy var webView: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true // default value is NO in iOS and YES in OS X.
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences;
        configuration.userContentController = WKUserContentController()
        // 注册JS发送消息的name (自定义，可以设置多个)
        configuration.userContentController.add(self, name: "moxiaoyan") // 添加 WKScriptMessageHandler 代理
        let webView = WKWebView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.maxY ?? 0) + 1, width: view.frame.size.width, height: view.frame.size.height/2), configuration: configuration)
        webView.navigationDelegate = self // 添加 WKNavigationDelegate 代理
        webView.uiDelegate = self // 添加 WKUIDelegate 代理
        // 观察进度
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    } ()
    private var url: URL
    private var progressView: UIProgressView = UIProgressView()
    private lazy var backBtnItem: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: "mo_green_back"), style: .done, target: self, action: #selector(popBack))
        return btn
    }()
    lazy var forwardBtnItem: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: "mo_green_forward"), style: .done, target: self, action: #selector(goForward))
        btn.imageInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 30)
        return btn
    }()
    private lazy var closeBtnItem: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: "mo_green_close"), style: .done, target: self, action: #selector(close))
        btn.imageInsets = UIEdgeInsets(top: 0, left: -34, bottom: 0, right: 34)
        return btn
    }()
}

extension MOWKWebViewController: WKScriptMessageHandler {
    // MARK: - 接收JS发送过来的消息
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // JS：window.webkit.messageHandlers.moxiaoyan.postMessage
        print("didReceive message: \(message.body)")
        switch message.name {
        case "moxiaoyan":
            print("收到发给我的消息啦： \(message.body)")
        default: break
        }
    }
}

extension MOWKWebViewController: WKNavigationDelegate {
    // MARK: - 判断连接是否允许跳转 navigationAction
    //  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    //    print("判断连接是否允许跳转: decidePolicyFor navigationAction: \(navigationAction)")
    //    decisionHandler(.allow) // .allow or .calcel
    //  }
    // MARK: - 判断连接是否允许跳转 navigationAction preferences:
    //  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
    //    print("判断连接是否允许跳转: decidePolicyFor navigationAction: \(navigationAction) \n preferences: \(preferences)")
    //    decisionHandler(.allow, preferences) // .allow or .calcel
    //  }
    // MARK: - 判断连接是否允许跳转 navigationResponse
    //  func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    //    print("拿到响应后决定是否跳转: decidePolicyFor navigationResponse: \(navigationResponse)")
    //    decisionHandler(.allow) // .allow or .calcel
    //  }
    // MARK: - 服务器重定向
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("服务器重定向: didReceiveServerRedirectForProvisionalNavigation")
    }
    // MARK: - 加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成: didFinish")
        self.title = webView.title
        var btns = [backBtnItem]
        if webView.canGoForward {
            btns.append(forwardBtnItem)
        }
        if webView.canGoBack {
            btns.append(closeBtnItem)
        }
        navigationItem.leftBarButtonItems = btns
        // 调用js方法(把标题h1设置成红色)
        webView.evaluateJavaScript("changeHead()", completionHandler: { (data, error) in
            print("changeHead data:\(String(describing: data)) error: \(String(describing: error))")
        })
        /* 我在这卡了很久，一直报错:
         Error Domain=WKErrorDomain Code=4 "A JavaScript exception occurred" UserInfo={WKJavaScriptExceptionLineNumber=1, WKJavaScriptExceptionMessage=ReferenceError: Can't find variable: changeHead, WKJavaScriptExceptionColumnNumber=11,...
         是因为加载网页的方法用的不对：
         我用了: webView.loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation?
         应该用: webView.load(_ request: URLRequest) -> WKNavigation?
         */
    }
    // MARK: - 加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败: didFail error: \(error)")
    }
    // MARK: - 即将完成
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("即将完成: didCommit")
    }
    // MARK: - 加载错误
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("加载错误: didFailProvisionalNavigation: \(error)")
    }
    // MARK: - 需要响应身份验证时调用(需验证服务器证书)
    //  func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    //    print("需验证服务器证书: didReceive challenge")
    //  }
    
    // MARK: - web内容进程被终止时调用(iOS 9.0之后)
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("进程被终止: webViewWebContentProcessDidTerminate")
    }
}

extension MOWKWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("alert: msg:\(message)")
        let alertVC = UIAlertController(title: "提示", message:message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "确认", style: .default, handler: { (action) in
            completionHandler() // 告知JS结果
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("confirm: msg:\(message)")
        let alertVC = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (alertAction) in
            completionHandler(false) // 告知JS选择结果
        }))
        alertVC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (alertAction) in
            completionHandler(true) // 告知JS选择结果
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("input: prompt:\(prompt) defaultText:\(String(describing: defaultText))")
        let alertVC = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
        alertVC.addTextField { (textField) in
            textField.text = defaultText
        }
        alertVC.addAction(UIAlertAction(title: "完成", style: .default, handler: { (alertAction) in
            completionHandler(alertVC.textFields![0].text) // 告知JS结果
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
}
