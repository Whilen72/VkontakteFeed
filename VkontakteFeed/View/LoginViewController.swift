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
   
    let controllerInditefire = "friendsList"

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
    
    private func goToFriendsList() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: controllerInditefire) as! FriendListController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil) // add navigation controller

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
            let separators = CharacterSet(charactersIn: "&=")
            for element: String in stringArray ?? [] {
                stringArray = element.components(separatedBy: separators)
            }
            let indexesToBeRemoved: Set = [0, 2, 4]
            stringArray = stringArray?
                .enumerated()
                .filter{ !indexesToBeRemoved.contains($0.offset) }
                .map { $0.element }
            let fetchToken =  Token(accessToken: stringArray![0], userId: stringArray![2], expiresIn: stringArray![1])
            NetworkManager.shared.token = fetchToken
            goToFriendsList()
          }
        }
        decisionHandler(.allow)
    }
}
    

