//
//  LoginView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 3.08.21.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
        
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var loadingIndicator: UIImageView!
    @IBOutlet weak var loginBanner: UIImageView!
    @IBOutlet weak var loadInfoLabel: UILabel!
    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var midDotLabel: UILabel!
    @IBOutlet weak var leftDotLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var animationView: UIView!
    
    static let controllerInditefire = "LoginViewController"
    static let shared = LoginViewController()
    
        // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchLoginButtonAndLabels()
        tokenValidityCheck()
        view.backgroundColor = .backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        showAuthWebView()
    }
    
    
    private func showAuthWebView() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: WebViewController.controllerInditefire) as! WebViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func reciveDataForHomeVC(){
                
        prepareViewForAnimations()

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
                        self.navigationController?.removeViewController(LoginViewController.self)
                    }

                    picArray.enumerated().forEach({ index, element in
                        element.sizes.forEach { SizeAndPhotoUrl in
                            if SizeAndPhotoUrl.type == "m" {
                                linkArray.append(SizeAndPhotoUrl.url)
                            }
                        }
                    })

                    friend.items?.forEach {_ in group.enter()}
                    linkArray.forEach {_ in group.enter()}
                    group.enter()

                    friend.items?.enumerated().forEach({ index, element in
                        if index < 3 {
                            if let urlString = element.photo_50, let url = URL(string: urlString) {
                                UIImage.loadImageFromUrl(url: url) { image in
                                    photoToVC.append(image)
                                    group.leave()
                                }
                            }
                        }
                    })

                    if let urlString = dataToVC?.photo_max_orig, let url = URL(string: urlString) {
                        UIImage.loadImageFromUrl(url: url, completion: { image in
                            avatarFromNetwork = image
                            group.leave()
                        })
                    }

                    linkArray.forEach { url in
                        if let url = URL(string: url) {
                            UIImage.loadImageFromUrl(url: url) { image in
                                imageToHomeVC.append(image)
                                group.leave()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getUserData(completion: @escaping (UserInfo)->()) {
        
        if NetworkManager.shared.checkAccessToken() == true {
            
            NetworkManager.shared.getUserData { (result) in
                
                switch result {
                case .success(let userInfo):
                    guard let userInfo = userInfo else { return }
                    completion(userInfo)
                case .failure(let error):
                    print("Error processing json data: \(error)")
                }
            }
        } else {
            showAuthWebView()
        }
    }
    
    private func getPhotos(completion: @escaping ([Album])->())  {
        
        if NetworkManager.shared.checkAccessToken() == true {
        
            NetworkManager.shared.getAlbum { (result) in
                
                switch result {
                case .success(let photoArray):
                    completion(photoArray ?? [])
                case .failure(let error):
                    print("Error processing json data: \(error)")
                }
            }
        } else {
            showAuthWebView()
        }
    }
    
    private func getFriends(completion: @escaping (FriendList)->()) {
        
        if NetworkManager.shared.checkAccessToken() == true {
        
            NetworkManager.shared.getList { (result) in
                
                switch result {
                case .success(let friends):
                    completion(friends)
                case .failure(let error):
                    print("Error processing json data: \(error)")
                }
            }
        } else {
            showAuthWebView()
        }
    }
    
    private func tokenValidityCheck() {
        if NetworkManager.shared.checkAccessToken() == true {
            
            loginButtonOutlet.setTitle("Your profile", for: .normal)
            infoLabel.text = "Press the button for enter"
            reciveDataForHomeVC()
        }
    }
    
    // MARK: - UI
    
    private func launchLoginButtonAndLabels() {
        
        loginBanner.image = UIImage(named: "vk-logo")
        
        animationView.isHidden = true
        animationView.backgroundColor = .backgroundColor
        
        loginButtonOutlet.backgroundColor = UIColor(red: 75/255, green: 118/255, blue: 164/255, alpha: 1)
        loginButtonOutlet.layer.cornerRadius = loginButtonOutlet.frame.height/1.9
        loginButtonOutlet.setTitleColor(.white, for: .normal)
        loginButtonOutlet.setTitle("VK sign in", for: .normal)
        
        infoLabel.textColor = .white
        infoLabel.font.withSize(20)
        infoLabel.text = "Just push 'Sign in' button"
        
        dotLabel.isHidden = true
        dotLabel.textColor = .white
        dotLabel.font.withSize(20)
        dotLabel.text = "."
        
        midDotLabel.isHidden = true
        midDotLabel.textColor = .white
        midDotLabel.font.withSize(20)
        midDotLabel.text = "."
        
        leftDotLabel.isHidden = true
        leftDotLabel.textColor = .white
        leftDotLabel.font.withSize(20)
        leftDotLabel.text = "."
        
        loadInfoLabel.isHidden = true
        loadInfoLabel.textColor = .white
        loadInfoLabel.font.withSize(20)
        loadInfoLabel.text = "Loading"
    }
    
    private func animationsForLoading() {
        
        loadInfoLabel.isHidden = false
        self.view.bringSubviewToFront(loadInfoLabel)
        
        dotLabel.isHidden = false
        self.view.bringSubviewToFront(dotLabel)
        
        midDotLabel.isHidden = false
        self.view.bringSubviewToFront(midDotLabel)
        
        leftDotLabel.isHidden = false
        self.view.bringSubviewToFront(leftDotLabel)
        
        UIView.animate(withDuration: 0.8, delay: 0.5, options: .repeat) {
            self.dotLabel.alpha = 0
        }
        UIView.animate(withDuration: 0.8, delay: 0.3, options: .repeat) {
            self.midDotLabel.alpha = 0
        }
        UIView.animate(withDuration: 0.8, delay: 0.1, options: .repeat) {
            self.leftDotLabel.alpha = 0
        }
    }
    
    private func showLoadingAnimation() {
        loadingIndicator.image = UIImage.gif(name: "duckGif")
        self.view.bringSubviewToFront(loadingIndicator)
    }
    
    private func prepareViewForAnimations() {
        animationView.isHidden = false
        self.view.bringSubviewToFront(animationView)
        showLoadingAnimation()
        animationsForLoading()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}



