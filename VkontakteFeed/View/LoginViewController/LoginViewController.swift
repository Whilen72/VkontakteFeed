//
//  LoginView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 3.08.21.
//

import UIKit
import WebKit
import Foundation

class LoginViewController: UIViewController, WKUIDelegate {
        
    @IBOutlet weak var loginButtonOutlet: UIButton!
   
    let controllerInditefire = "HomeViewController"

        // MARK: - viewDidLoad
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
            let request = URLRequest(url: url!)
            webView.load(request)
        }
    
    private func goToHomeViewController() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: controllerInditefire) as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: WKNavigationDelegate {
        
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    if let urlComponents = URLComponents(url: navigationResponse.response.url!, resolvingAgainstBaseURL: true),let queryItems = urlComponents.queryItems {
          //add chek access token
          let value = queryItems[1].value
          let isTokenString = value!.contains("access_token")
          if isTokenString {
            let encodedString = value?.removingPercentEncoding
            var stringArray = encodedString?.components(separatedBy: "#")
            stringArray?.removeFirst()
            let separators = CharacterSet(charactersIn: "&")
            if stringArray!.count > 0 {
               let paramString = stringArray!.first
               let paramArray = paramString!.components(separatedBy: separators)
               var paramDict = [String: String]()
               for element in paramArray {
                   if element.contains("access_token") {
                        let accessToken = element.components(separatedBy: "=")
                        paramDict[accessToken[0]] = accessToken[1]
                   }
                   if element.contains("expires_in") {
                        let expires_in = element.components(separatedBy: "=")
                        paramDict[expires_in[0]] = expires_in[1]
                   }
                   if element.contains("user_id") {
                        let user_id = element.components(separatedBy: "=")
                        paramDict[user_id[0]] = user_id[1]
                   }
               }
                       
                let fetchToken =  Token(accessToken: paramDict["access_token"]!, userId: paramDict["user_id"]!, expiresIn: paramDict["expires_in"]!)
                NetworkManager.shared.token = fetchToken
                goToHomeViewController()
            }
          }
        }
        decisionHandler(.allow)
    }
}

