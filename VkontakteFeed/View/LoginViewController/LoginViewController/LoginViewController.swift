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
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var loadIndicator: UIImageView!
    
        // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButtonOutlet.setTitle("VK sign in", for: .normal)
        view.backgroundColor = .backgroundColor
        waitingView.backgroundColor = .backgroundColor
        waitingView.isHidden = true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        showAuthWebView()
    }
         
    private func showAuthWebView() {
        
        let webView = WKWebView(frame: view.frame)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        let url = URL(string: "https://oauth.vk.com/authorize?client_id=7918001&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.131")
        let request = URLRequest(url: url!)
        webView.load(request)
        }
    
    func reciveDataForHomeVC(){
        
        var avatarFromNetwork = UIImage()
        var linkArray = [String]()
        var imageToHomeVC = [UIImage]()
        var dataToVC: UserInfo?
        var picArray = [Album]()
        
        getUserData { [weak self] userInfo in
            let group = DispatchGroup()
            guard let self = self else { return }
            
            dataToVC = userInfo

            self.getPhotos { [weak self] album in
                picArray = album
                guard let self = self else { return }
                
                self.getFriends { [weak self] friend in
                    guard let self = self else { return }
                    var photoToVC = [UIImage]()
                    let friendToVC = friend

                    group.notify(queue: .main) {
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: HomeViewController.controllerInditefire) as! HomeViewController
                        vc.avatar = avatarFromNetwork
                        vc.imageArray = imageToHomeVC
                        vc.userData = dataToVC
                        vc.imageFriendArray = photoToVC
                        if let friendToVC = friendToVC.items {
                            vc.friendsData = friendToVC
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    friend.items?.forEach {_ in group.enter()}
                    
                    friend.items?.enumerated().forEach({ index, element in
                        if index < 3 {
                            let url = URL(string: element.photo_50!)
                            UIImage.loadImageFromUrl(url: url!) { image in
                            photoToVC.append(image)
                                group.leave()
                            }
                        }
                    })
                    
                    group.enter()
                    guard let url = URL(string: dataToVC!.photo_max_orig) else { return }
                    UIImage.loadImageFromUrl(url: url, completion: { image in
                        avatarFromNetwork = image
                        group.leave()
                    })
                    
                    picArray.enumerated().forEach({ index, element in
                        element.sizes.forEach { SizeAndPhotoUrl in
                            if SizeAndPhotoUrl.type == "m" {
                                linkArray.append(SizeAndPhotoUrl.url)
                            }
                        }
                    })

                    linkArray.forEach {_ in group.enter()}

                    linkArray.forEach { url in
                        guard let url = URL(string: url) else { return }
                        UIImage.loadImageFromUrl(url: url) { image in
                            imageToHomeVC.append(image)
                            group.leave()
                        }
                    }
                }
            }
        }
    }
    
    private func getUserData(completion: @escaping (UserInfo)->()) {
        NetworkManager.shared.getUserData { (result) in
            switch result {
            case .success(let userInfo):
                guard let userInfo = userInfo else { return }
                completion(userInfo)
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    private func getPhotos(completion: @escaping ([Album])->())  {
        NetworkManager.shared.getAlbum { (result) in
            switch result {
            case .success(let photoArray):
                    completion(photoArray ?? [])
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    private func getFriends(completion: @escaping (FriendsList)->()) {
        NetworkManager.shared.getList { (result) in
                switch result {
                case .success(let friends):
                    completion(friends)
                case .failure(let error):
                    print("Error processing json data: \(error)")
                }
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {   // why black?
        return .lightContent
    }
}



extension LoginViewController: WKNavigationDelegate {
        
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        if let urlComponents = URLComponents(url: navigationResponse.response.url!, resolvingAgainstBaseURL: true), let queryItems = urlComponents.queryItems {
            webView.addSubview(waitingView)
            loadIndicator.loadGif(name: "duckGif")
            let value = queryItems[1].value
            
            if value?.contains("access_token") ?? false {
               
                waitingView.isHidden = false
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
                    NetworkManager.shared.token = fetchToken
                    reciveDataForHomeVC()
                }
            }
        }
        decisionHandler(.allow)
    }
}

