//
//  LoginView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 3.08.21.
//

import UIKit
import WebKit
import Foundation

    class LoginView: UIViewController, WKUIDelegate {
        
        @IBOutlet weak var loginButtonOutlet: UIButton!






        var key = "com.example.www.token"
        let header = "access_token"
        let webView = WKWebView(frame: .zero)

        
        override func viewDidLoad() {
            super.viewDidLoad()
            loginButtonOutlet.setTitle("VK sign in", for: .normal)
            view.addSubview(loginButtonOutlet) //add constraints
            loginButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
            loginButtonOutlet.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            loginButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    

        @IBAction func loginAction(_ sender: Any) {
         showAuthWebView()
        }
    
       private func showAuthWebView() {
        //add guard for check token and expire
            let webView = WKWebView(frame: view.frame)
            webView.navigationDelegate = self
            self.view.addSubview(webView)
            let url = URL(string: "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.131")
            var request = URLRequest(url: url!)
            let token = UserDefaults.standard.string(forKey: key)

                if (token != nil) {
                    request.addValue(token!, forHTTPHeaderField: header)
                }

                webView.load(request)
        }
    
      private func goToFriendsList() {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "frindsList") as! FriendListController // add property for indifier
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil) // add navigation controller

        }

}

    extension LoginView: WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let urlComponents = URLComponents(url: navigationResponse.response.url!, resolvingAgainstBaseURL: true),let queryItems = urlComponents.queryItems {
              //add chek access token
              let value = queryItems[1].value
              let stringResult = value!.contains(header)
              
              if stringResult == true {
                print(stringResult)
                let encodedString =  value?.removingPercentEncoding
                let separators = CharacterSet(charactersIn: "&=")
                let stringArray = encodedString?.components(separatedBy: separators)
    
                Network.accessToken = (stringArray![1])
                Network.expireTime = (stringArray![3])
                Network.userId = (stringArray![5])
                goToFriendsList()
                
              }
            }
            decisionHandler(.allow)
        }
    }
    

