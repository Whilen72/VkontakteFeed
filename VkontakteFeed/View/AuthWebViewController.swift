//
//  AuthWebView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 9.08.21.
//

import UIKit
import WebKit

class AuthWebViewController: UIViewController, WKUIDelegate {
    
    private let webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        return webView
    }()
    

    
    override func viewDidLoad() {
       super.viewDidLoad()
       webView.navigationDelegate = self
       view.addSubview(webView)
       goToAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    func goToAuth() {
        
        self.view.addSubview(webView)
        let url = URL(string: "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.131")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
}

extension AuthWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

    }
}
