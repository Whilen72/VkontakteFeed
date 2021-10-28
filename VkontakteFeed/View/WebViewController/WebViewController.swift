//
//  WebViewController.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 23.09.21.
//

import Foundation
import UIKit
import WebKit

protocol webIsReadyDelegate {
    func netFlowStart()
}

class WebViewController: UIViewController, WKUIDelegate {
    
    var delegate: webIsReadyDelegate?
    
    static let shared = WebViewController()
    static let controllerInditefire = "WebViewController"
    
    var logOutEvent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAuthWebView()
    }
    
    private func showAuthWebView() {
        
        let webView = WKWebView(frame: view.frame)
        
        webView.backgroundColor = .backgroundColor
        webView.scrollView.backgroundColor = .backgroundColor
        webView.isOpaque = false
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        let url = URL(string: clearCacheForRelog(logIutStatus: logOutEvent))
        let request = URLRequest(url: url!)
        
        webView.load(request)
    }
    
    private func clearCacheForRelog (logIutStatus: Bool) -> String {
        let urlString = "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.131"
        if logIutStatus == true {
            let urlStringForRelog = "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.131&revoke=1"
            return urlString
        }
        return urlString
    }
    
}

extension  WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if let urlComponents = URLComponents(url: navigationResponse.response.url!, resolvingAgainstBaseURL: true), let queryItems = urlComponents.queryItems {
            
            let value = queryItems[1].value
            
            if value?.contains("access_token") ?? false {
                
                let encodedString = value?.removingPercentEncoding
                var stringArray = encodedString?.components(separatedBy: "#")
                stringArray?.removeFirst()
                let separators = CharacterSet(charactersIn: "&")
                guard let stringArray = stringArray else { return }
               
                if stringArray.count > 0 {
                    let paramString = stringArray.first
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
                   
                    let fetchToken = Token(accessToken: paramDict["access_token"]!, userId: paramDict["user_id"]!, expiresIn: paramDict["expires_in"]!)
                    
                    UserDefaults.standard.set(fetchToken.accessToken, forKey: "savedAccessToken")
                    let seconds = Double(fetchToken.expiresIn)
                    let currentExpireDate = Date().addingTimeInterval(seconds!)
                    UserDefaults.standard.set(currentExpireDate, forKey: "savedExpireIn")
                  //  NetworkManager.shared.token = fetchToken
                    delegate?.netFlowStart()
                   
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: HomeViewController.controllerInditefire) as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        decisionHandler(.allow)
    }
}
