//
//  ViewController.swift
//  reader-mode-demo
//
//  Created by Tomoya Hirano on 2015/11/20.
//  Copyright © 2015年 Tomoya Hirano. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate,WKUIDelegate{
    var webView:WKWebView!//UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = NSBundle.mainBundle().pathForResource("safari-reader", ofType: "js")
        let script = try! String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
        let userScript = WKUserScript(source: script, injectionTime: .AtDocumentEnd, forMainFrameOnly: false)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.UIDelegate = self
        view.addSubview(webView)
        let request = NSURLRequest(URL: NSURL(string: "http://arufa.hatenablog.jp/entries/2015/11/05")!)
        webView.loadRequest(request)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        webView.evaluateJavaScript("var ReaderArticleFinderJS = new ReaderArticleFinder(document);") { (obj, error) -> Void in
        }
        webView.evaluateJavaScript("var article = ReaderArticleFinderJS.findArticle();") { (html, error) -> Void in
        }
        webView.evaluateJavaScript("article.element.innerText") { (res, error) -> Void in
            if let html = res as? String {
//                webView.loadHTMLString(html, baseURL: nil)
            }
        }
        webView.evaluateJavaScript("article.element.outerHTML") { (res, error) -> Void in
            if let html = res as? String {
                webView.loadHTMLString(html, baseURL: nil)
            }
        }
        webView.evaluateJavaScript("ReaderArticleFinderJS.isReaderModeAvailable();") { (html, error) -> Void in
        }
        webView.evaluateJavaScript("ReaderArticleFinderJS.prepareToTransitionToReader();") { (html, error) -> Void in
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

