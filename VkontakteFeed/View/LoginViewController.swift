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
    
    var key = "com.example.www.token"
    let header = "access_token"
    let webView = WKWebView(frame: .zero)
    var authorizeData: String = ""
    
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

}
// authorize_url https%3A%2F%2Foauth.vk.com%2Fblank.html%23access_token%3D29a510bd74dfe5340e737a772db5879d11c03a367203cb0a7ce63d362f850f0dbae1de0a64961d8c28e34%26expires_in%3D86400%26user_id%3D189129628“
extension LoginView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let token = (navigationResponse.response as! HTTPURLResponse).allHeaderFields[header] as? String
        if let urlComponents = URLComponents(url: navigationResponse.response.url!, resolvingAgainstBaseURL: true),let queryItems = urlComponents.queryItems {

            // for example, we will get the first item name and value:
            let name = queryItems[1].name
            let value = queryItems[1].value
            let hostName = urlComponents.host
            print(name,"\n value is ///////// ", value!)
            print("/////////////////////////////////// \n", hostName!, "\n ///////////////////////////////// \n")
            // response -> URL->String take token and expirasion
            authorizeData = value!
            
        }
//             if let str = queryItems[1].value {
//                let arr = str.components(separatedBy:"&")
//                var data = [String:Any]()
//                for row in arr {
//                    let pairs = row.components(separatedBy:"=")
//                    data[pairs[0]] = pairs[1]
//            }
//                let message = data["access_token"]
//                let sig = data["signature"]
//                print(message!, sig!)
//        }
//        
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

