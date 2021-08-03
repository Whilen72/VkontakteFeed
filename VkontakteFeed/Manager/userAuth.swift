//
//  userAuth.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 3.08.21.
//

import Foundation

class Auth {
let urlAuth = "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&redirect_uri=https://vk.com/feed&response_type=token"
func tryAuth() {
    var webAuthSession: ASWebAuthenticationSession?
    //...
    
    func getAuthTokenWithWebLogin() {

        let authURL = URL(string: "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&redirect_uri=https://vk.com/feed&response_type=token")
        let callbackUrlScheme = "octonotes://auth"

        self.webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in

            // handle auth response
            guard error == nil, let successURL = callBack else {
                return
            }

            let oauthToken = NSURLComponents(string: (successURL.absoluteString))?.queryItems?.filter({$0.name == "code"}).first

            // Do what you now that you've got the token, or use the callBack URL
            print(oauthToken ?? "No OAuth Token")
        })

        // Kick it off
        self.webAuthSession?.start()
        }
    }
}
