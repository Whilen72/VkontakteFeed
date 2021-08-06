//
//  LoginView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 3.08.21.
//

import UIKit
import AuthenticationServices

class LoginView: UIViewController, ASWebAuthenticationPresentationContextProviding {
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    @IBAction func loginAction(_ sender: Any) {
        getAuthTokenWithWebLogin()
    }
    
//    private var logginButton: UIButton = {
//        var button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Loggin in to VK", for: .normal)
//        button.backgroundColor = .black
//        return button
//    }()
    
    
    var webAuthSession: ASWebAuthenticationSession?
    //...
    
    func getAuthTokenWithWebLogin() {

        let authURL = URL(string: "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&response_type=token")
        let callbackUrlScheme = "VkontakteFeed://auth"

        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in

            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }

            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first

            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken ?? "No OAuth Token")
        })
      //  
        // Kick it off
        self.webAuthSession?.presentationContextProvider = self
        self.webAuthSession?.start()
        }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            return self.view.window ?? ASPresentationAnchor()
    }
    
  
    
}
