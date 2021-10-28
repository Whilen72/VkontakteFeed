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
        
        checkValidityToken()
        
        view.backgroundColor = .backgroundColor
        navigationController?.setNavigationBarHidden(true, animated: false)
       
    }
    
    @IBAction func loginAction(_ sender: Any) {
        showAuthWebView()
    }
    
    private func checkValidityToken() {
        if NetworkManager.shared.checkAccessToken() == false {
            launchLoginButtonAndLabels()
        } else {
            showHomeView()
        }
    }
    
    func showAuthWebView() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: WebViewController.controllerInditefire) as! WebViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func showHomeView() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: HomeViewController.controllerInditefire) as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - UI
    
    private func launchLoginButtonAndLabels() {
        
        loginBanner.image = UIImage(named: "vk-logo")
        
        loginButtonOutlet.backgroundColor = UIColor(red: 75/255, green: 118/255, blue: 164/255, alpha: 1)
        loginButtonOutlet.layer.cornerRadius = loginButtonOutlet.frame.height/1.9
        loginButtonOutlet.setTitleColor(.white, for: .normal)
        loginButtonOutlet.setTitle("VK sign in", for: .normal)
        
        infoLabel.textColor = .white
        infoLabel.font.withSize(20)
        infoLabel.text = "Just push 'Sign in' button"
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

