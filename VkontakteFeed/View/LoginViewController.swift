//
//  LoginView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 3.08.21.
//

import UIKit
import WebKit

class LoginView: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBAction func loginAction(_ sender: Any) {
     showAuthWebView()
    }
    
    let key = "com.example.www.token"
    let header = "access_token"
    let webView = WKWebView(frame: .zero)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonOutlet.setTitle("VK sign in", for: .normal)
        webView.navigationDelegate = self
        
    }
    
//    func showAuthWebView(){
//        let vc = AuthWebViewController()
//        let navVC = UINavigationController(rootViewController: vc)
//        present(navVC, animated: true)
//    }
  
    
    func showAuthWebView() {
        let webView = WKWebView(frame: view.frame)
        self.view.addSubview(webView)
        let url = URL(string: "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.131")
        var request = URLRequest(url: url!)
        let token = UserDefaults.standard.string(forKey: key)

            if (token != nil) {
                request.addValue(token!, forHTTPHeaderField: header)
            }

            webView.load(request)
    }

}

extension LoginView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let token = (navigationResponse.response as! HTTPURLResponse).allHeaderFields[header] as? String

            if (token != nil) {
                if (UserDefaults.standard.string(forKey: key) != nil) {
                    UserDefaults.standard.removeObject(forKey: key)
                }
                print(key)
                UserDefaults.standard.set(token, forKey: key)
            }

            decisionHandler(.allow)
    }
}

