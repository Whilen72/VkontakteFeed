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
    
    @IBAction func loginAction(_ sender: Any) {
     showAuthWebView()
    }
    
    var key = "com.example.www.token"
    let header = "access_token"
    let webView = WKWebView(frame: .zero)
    var valueArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButtonOutlet.setTitle("VK sign in", for: .normal)
       
        
    }
    
//    func showAuthWebView(){
//        let vc = AuthWebViewController()
//        let navVC = UINavigationController(rootViewController: vc)
//        present(navVC, animated: true)
//    }
  
    
    func showAuthWebView() {
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
    func goToFriendsList() {
        let vc = FriendListController()
        present(vc, animated: true, completion: nil)
        
    }

}
// authorize_url https%3A%2F%2Foauth.vk.com%2Fblank.html%23access_token%3D29a510bd74dfe5340e737a772db5879d11c03a367203cb0a7ce63d362f850f0dbae1de0a64961d8c28e34%26expires_in%3D86400%26user_id%3D189129628“
extension LoginView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let token = (navigationResponse.response as! HTTPURLResponse).allHeaderFields[header] as? String
        if let urlComponents = URLComponents(url: navigationResponse.response.url!, resolvingAgainstBaseURL: true),let queryItems = urlComponents.queryItems {
          
          let value = queryItems[1].value
          let stringResult = value!.contains(header)
          
          if stringResult == true {
             let encodedString =  value?.removingPercentEncoding
            let separators = CharacterSet(charactersIn: "&=")
             let stringArray = encodedString?.components(separatedBy: separators)
                                               
            Network.accessToken = (stringArray![1])
            Network.expireTime = (stringArray![3])
            Network.userId = (stringArray![5])
            goToFriendsList()
            }
                  //  response -> URL -> String take token and expirasion
           
           
        
       if (token != nil) {
            if (UserDefaults.standard.string(forKey: key) != nil) {
                    UserDefaults.standard.removeObject(forKey: key)
                }
           print("key for user defaults \(key)")
           UserDefaults.standard.set(token, forKey: key)
            }

      decisionHandler(.allow)
        }

    }

}
    
