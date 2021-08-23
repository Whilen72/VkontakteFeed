//
//  HomeViewController.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 19.08.21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isOnlineLabel: UILabel!
    @IBOutlet weak var followersCounterLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var bDateLabel: UILabel!
    
    @IBOutlet weak var imageFollowers: UIImageView!
    @IBOutlet weak var imageCity: UIImageView!
    @IBOutlet weak var imageBdate: UIImageView!

    private let controllerInditefire = "HomeViewController"
    private var userData: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationViewController()
        launchScreen()
        takeResult()
    }

    private func takeResult() {
        NetworkManager.shared.getUserData { [weak self] (result) in
            switch result {
            case .success(let userInfo):
                self?.userData = userInfo
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
            self?.nameLabel.text = "\(self!.userData!.first_name) \(self!.userData!.last_name)"
            self?.bDateLabel.text = self!.userData?.bdate
            self?.followersCounterLabel.text = "\(String(describing: self!.userData!.followers_count))"
            self?.cityLabel.text = self?.userData!.city.title
            if self?.userData?.online != 0 {
                self?.isOnlineLabel.text = "Is Online"
            } else {
                self?.isOnlineLabel.text = "Offline"
            }
            guard let url = URL(string: (self?.userData!.photo_400_orig)! ) else { return }
            self!.loadImage(url: url)
        }

    }

    private func addNavigationViewController() {
        let naVC = UINavigationController(rootViewController: self)
        naVC.title = "Home page"
    }

   private func launchScreen() {
    imageView.contentMode = .scaleAspectFill

    nameLabel.font = nameLabel.font.withSize(20)
    nameLabel.textColor = .white

    isOnlineLabel.font = isOnlineLabel.font.withSize(8)
    isOnlineLabel.textColor = .white

    bDateLabel.font = bDateLabel.font.withSize(14)
    cityLabel.font = cityLabel.font.withSize(14)
    followersCounterLabel.font =  followersCounterLabel.font.withSize(14)

    imageCity.contentMode = .scaleToFill
    imageCity.image = UIImage(systemName: "house")

    imageFollowers.contentMode = .scaleToFill
    imageFollowers.image = UIImage(systemName: "person.circle")

    imageBdate.contentMode = .scaleToFill
    imageBdate.image = UIImage(systemName: "giftcard")


    }

 private func loadImage(url: URL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageView.image = image
                        }
                    }
                }
            }
        }

}
