//
//  ViewController.swift
//  WKWebView
//
//  Created by 刘高晖 on 16/5/17.
//  Copyright © 2016年 刘高晖. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController {
    var webView:WKWebView!
    var config:WKWebViewConfiguration!
    var progressView:UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        theWebView()
        let myButton = UIButton(frame: CGRectMake(0, 0, 36, 36))
        myButton.setTitle("enenen", forState: .Normal)
//        myButton.setImage(UIImage(named: "grzx"), forState: .Normal)
//        myButton.setImage(UIImage(named: "grzx_pressed"),forState: .Highlighted)
        myButton.addTarget(self, action: #selector(ViewController.person), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myButton)
    
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.progressView = UIProgressView.init(frame: CGRectMake(0, 64, self.view.frame.size.width, 1))
        
        self.progressView.progressViewStyle = .Default
        self.progressView.tintColor = UIColor.redColor()
        self.view.addSubview(self.progressView)
        
        
    }

    
    func person(){
        //直接调用js的方法
        ///不建议使用这个办法  因为会在内部等待webView 的执行结果
        webView.evaluateJavaScript("hi()", completionHandler: nil)
//        print("eeee")
    }
    
    //初始化webVIew
    func theWebView(){
         // 创建一个webiview的配置项
        config = WKWebViewConfiguration()
        // Webview的偏好设置
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 10
        config.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        // 通过js与webview内容交互配置
        config.userContentController = WKUserContentController()
        //注册js方法
        config.userContentController.addScriptMessageHandler(self, name: "WinnerB")
        webView = WKWebView(frame: self.view.frame, configuration: config)
        webView.navigationDelegate = self
        webView.UIDelegate = self
        self.view.addSubview(webView)
//        //加载网页
//                webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://hi18.cn")!))
        //加载本地页面
        webView.loadRequest(NSURLRequest(URL: NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("index", ofType: "html")!)))
                //允许手势，后退前进等操作
                webView.allowsBackForwardNavigationGestures = true
                //监听状态,监听支持KVO的属性
                webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
                webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
           webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
        
        
    }
 
    func helloWorld(param1:String){
        print("helloWorld" + param1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //监控webView变量,// MARK: - KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //是否读取完成
        if (keyPath == "loading") {
//            gobackBtn.enabled = webView.canGoBack
//            forwardBtn.enabled = webView.canGoForward
        }
        //加载进度
        if (keyPath == "estimatedProgress") {
            print(Float(webView.estimatedProgress))
            progressView.hidden = webView.estimatedProgress==1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
        if keyPath == "title" {
            self.title = self.webView.title
        }
    }
    
}

extension ViewController:WKNavigationDelegate{
    
    // 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
    // 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        print(#function)
        decisionHandler(.Allow)
//        let hostname = navigationAction.request.URL?.host?.lowercaseString
//        print(hostname)
//        // 处理跨域问题
//        if navigationAction.navigationType == .LinkActivated && !hostname!.containsString(".baidu.com") {
//            // 手动跳转
//            UIApplication.sharedApplication().openURL(navigationAction.request.URL!)
//            // 不允许导航
//            decisionHandler(.Cancel)
//        } else {
////            self.progressView.alpha = 1.0
//            decisionHandler(.Allow)
//        }
    }
    
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("准备加载页面")
    }
    
    //决定是否允许导航响应，如果不允许就不会跳转到该链接的页面。
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        print(__FUNCTION__)
        decisionHandler(.Allow)
    }
    
    //Invoked when content starts arriving for the main frame.这是API的原注释。也就是在页面内容加载到达mainFrame时会回调此API。如果我们要在mainFrame中注入什么JS，也可以在此处添加。
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print("已开始加载页面，可以在这一步向view中添加一个过渡动画")
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        print("页面已全部加载，可以在这一步把过渡动画去掉")
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("didFailNavigation" + error.localizedDescription)
    }
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("didFailProvisionalNavigation" + error.localizedDescription)
    }
    
    
}

extension ViewController:WKUIDelegate{
    // MARK: - WKUIDelegate
    // 这个方法是在HTML中调用了JS的alert()方法时，就会回调此API。
    // 注意，使用了`WKWebView`后，在JS端调用alert()就不会在HTML
    // 中显示弹出窗口。因此，我们需要在此处手动弹出ios系统的alert。
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
            print("OK")
            // We must call back js
            completionHandler()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (_) -> Void in
            // 点击完成后，可以做相应处理，最后再回调js端
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //TextField弹框类的 prompt
    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.textColor = UIColor.redColor()
        }
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.textColor = UIColor.redColor()
        }
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: { (_) -> Void in
            // 处理好之前，将值传到js端x
            //            completionHandler(alert.textFields)
            if alert.textFields![0].text == ""||alert.textFields![0].text == nil{
                return
            }
            completionHandler(alert.textFields![0].text! + ";" + alert.textFields![1].text!)
        }))
        alert.addAction(UIAlertAction.init(title: "取消", style: .Cancel, handler: { (_) in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler("")
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webViewDidClose(webView: WKWebView) {
        print(__FUNCTION__)
    }
    
}


extension ViewController:WKScriptMessageHandler{
    
       
    
    
    //实现js调用ios的handle委托
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        // 如果在开始时就注入有很多的名称，那么我们就需要区分来处理
        print(message.body)
        //接受传过来的消息从而决定app调用的方法
        let dict = message.body as! Dictionary<String,String>
        let method:String = dict["method"]!
        let param1:String = dict["param1"]!
        if method=="helloWorld"{
            helloWorld(param1)
        }
    }
}

