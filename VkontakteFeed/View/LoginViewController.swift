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






     let defaults = UserDefaults.standard
     let header = "access_token"
     let controllerInditefire = "frindsList"

        // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationController()
        loginButtonOutlet.setTitle("VK sign in", for: .normal)
        view.addSubview(loginButtonOutlet) //add constraints
        loginButtonOutlet.translatesAutoresizingMaskIntoConstraints = false
        loginButtonOutlet.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButtonOutlet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            }
    

        @IBAction func loginAction(_ sender: Any) {
         showAuthWebView()
        }
        
    private func addNavigationController() {
            let rootVC = LoginViewController()
            let navVC = UINavigationController(rootViewController: rootVC)
            present(navVC, animated: true, completion: nil)
            
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
    
      private func goToFriendsList() {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: controllerInditefire) as! FriendListController 
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil) // add navigation controller

        }
    func lookForAccessToken() {
        let savedToken = defaults.string(forKey: "token")
        if savedToken == NetworkManager.shared.token?.accessToken {
            goToFriendsList()
        }
    }

}

    extension LoginViewController: WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let urlComponents = URLComponents(url: navigationResponse.response.url!, resolvingAgainstBaseURL: true),let queryItems = urlComponents.queryItems {
              //add chek access token
              let savedToken = defaults.string(forKey: "token")
              let value = queryItems[1].value
              let stringResult = value!.contains(header)
              
              if stringResult == true {
                let encodedString = value?.removingPercentEncoding
                let separators = CharacterSet(charactersIn: "&=")
                let stringArray = encodedString?.components(separatedBy: separators)
                let fetchToken =  Token(accessToken: stringArray![1], userId: stringArray![5], expiresIn: stringArray![3])
                NetworkManager.shared.token = fetchToken
                    if savedToken != fetchToken.accessToken  {
                        defaults.set(fetchToken.accessToken, forKey: "token")
                        defaults.set(fetchToken.expiresIn, forKey: "expire")
                }
                
               
                
                
                goToFriendsList()
              }
            }
            decisionHandler(.allow)
        }
    }
    

