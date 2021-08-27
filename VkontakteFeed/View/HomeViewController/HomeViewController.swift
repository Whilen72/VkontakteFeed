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
    @IBOutlet weak var circleViewLower: UIView!
    @IBOutlet weak var imageViewLower: UIImageView!
    @IBOutlet weak var circleViewMiddle: UIView!
    @IBOutlet weak var imageViewMiddle: UIImageView!
    @IBOutlet weak var circleViewUpper: UIView!
    @IBOutlet weak var imageViewUpper: UIImageView!
    @IBOutlet weak var friendsCounterLabel: UILabel!
    @IBOutlet weak var imageFriends: UIImageView!
    @IBOutlet weak var borderLabelMiddle: UILabel!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var photoImageLeft: UIImageView!
    @IBOutlet weak var photoImageMiddle: UIImageView!
    @IBOutlet weak var photoImageRight: UIImageView!
    @IBOutlet weak var borderUpperLabel: UILabel!
    @IBOutlet weak var borderCenterLabel: UILabel!
    @IBOutlet weak var borderLowerLabel: UILabel!
    
    
    private let controllerInditefire = "friendsList"
    private var userData: UserInfo?
    private var friendsData = [Item]()
    private var photosData = [Album]()
    private let errors = "error"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchScreen()
        getUserData()
        getFriends()
        getPhotos() 
        tapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func getUserData() {
        NetworkManager.shared.getUserData { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let userInfo):
                self.userData = userInfo
                let name = "\(self.userData!.first_name)" + "\(self.userData!.last_name)"
                self.nameLabel.text = "\(name)"
                let bDate = self.userData!.bdate
                self.bDateLabel.text = "B date \(bDate)"
                let followers = "\(self.userData!.followers_count)"
                self.followersCounterLabel.text = "Follower: \(followers)"
                let city = self.userData!.city.title
                self.cityLabel.text = "City: \(city)"
                if self.userData?.online != 0 {
                    self.isOnlineLabel.text = "Is Online"
                } else {
                    self.isOnlineLabel.text = "Offline"
                }
                
                guard let url = URL(string: (self.userData!.photo_max)) else { return }
                self.loadImageFriends(url: url, downloadImageView: self.imageView)
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    private func getFriends() {
        NetworkManager.shared.getList { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let friends):
                self.friendsData = friends.items ?? []
                self.friendsCounterLabel.text = "Friends: \(self.friendsData.count)"
                guard let urlFirst = URL(string: (self.friendsData.first?.photo_50)!) else { return }
                self.loadImageFriends(url: urlFirst, downloadImageView: self.imageViewLower)
                guard let urlSecond = URL(string: (self.friendsData[2].photo_50)!) else { return }
                self.loadImageFriends(url: urlSecond, downloadImageView: self.imageViewMiddle)
                guard let urlThird = URL(string: (self.friendsData[3].photo_50)!) else { return }
                self.loadImageFriends(url: urlThird, downloadImageView: self.imageViewUpper)
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    private func getPhotos() {
        NetworkManager.shared.getAlbum { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let photoArray):
                self.photosData = photoArray ?? []
                var urlArray = [String]()
                self.photosData.enumerated().forEach({ index, element in
                    element.sizes.forEach { SizeAndPhotoUrl in
                        if SizeAndPhotoUrl.type == "p" {
                            urlArray.append(SizeAndPhotoUrl.url)
                        }
                    }
                })
                for url in urlArray {
                    if urlArray.count < 3 {
                        self.photoImageMiddle.isHidden = true
                        self.photoImageRight.isHidden = true
                        guard let url = URL(string: url) else { return }
                        self.loadImageFriends(url: url, downloadImageView: self.photoImageLeft)
                    } else {
                        guard let url = URL(string: urlArray[1]) else { return }
                        self.loadImageFriends(url: url, downloadImageView: self.photoImageLeft)
                        guard let url = URL(string: urlArray[2])  else { return }
                        self.loadImageFriends(url: url, downloadImageView: self.photoImageMiddle)
                        guard let url = URL(string: urlArray[3]) else { return }
                        self.loadImageFriends(url: url, downloadImageView: self.photoImageRight)
                    }
                }
                let photoCount = self.photosData.count
                self.photoLabel.text = "Photos \(photoCount)"
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }

    private func launchScreen() {
                       
        view.addSubview(imageView)
        imageView.contentMode = .scaleToFill
        view.addSubview(nameLabel)
        nameLabel.font = nameLabel.font.withSize(20)
        nameLabel.textColor = .white

        view.addSubview(isOnlineLabel)
        isOnlineLabel.font = isOnlineLabel.font.withSize(8)
        isOnlineLabel.textColor = .white
        
        view.addSubview(photoLabel)
        view.addSubview(bDateLabel)
        view.addSubview(cityLabel)
        view.addSubview(followersCounterLabel)
        view.addSubview(friendsCounterLabel)
        photoLabel.font = cityLabel.font.withSize(14)
        bDateLabel.font = bDateLabel.font.withSize(14)
        cityLabel.font = cityLabel.font.withSize(14)
        followersCounterLabel.font = followersCounterLabel.font.withSize(14)
        friendsCounterLabel.font = followersCounterLabel.font.withSize(14)
        
        view.addSubview(imageCity)
        imageCity.contentMode = .scaleToFill
        imageCity.image = UIImage(systemName: "house")

        view.addSubview(imageFollowers)
        imageFollowers.contentMode = .scaleToFill
        imageFollowers.image = UIImage(systemName: "person.circle")

        view.addSubview(imageBdate)
        imageBdate.contentMode = .scaleToFill
        imageBdate.image = UIImage(systemName: "giftcard")
        
        view.addSubview(imageFriends)
        imageFriends.contentMode = .scaleAspectFit
        imageFriends.image = UIImage(systemName: "person.3")
        
        view.addSubview(circleViewLower)
        circleViewLower.addSubview(imageViewLower)
        circleViewLower.layer.cornerRadius = circleViewLower.frame.width/2
        circleViewLower.layer.masksToBounds = true
        imageViewLower.layer.cornerRadius = imageViewLower.frame.width/2
        imageViewLower.layer.masksToBounds = true
        
        view.addSubview(circleViewMiddle)
        circleViewMiddle.addSubview(imageViewMiddle)
        circleViewMiddle.layer.cornerRadius = circleViewMiddle.frame.width/2
        circleViewMiddle.layer.masksToBounds = true
        imageViewMiddle.layer.cornerRadius = imageViewMiddle.frame.width/2
        imageViewMiddle.layer.masksToBounds = true
        
        view.addSubview(circleViewUpper)
        circleViewUpper.addSubview(imageViewUpper)
        circleViewUpper.layer.cornerRadius = circleViewUpper.frame.width/2
        circleViewUpper.layer.masksToBounds = true
        imageViewUpper.layer.cornerRadius = imageViewUpper.frame.width/2
        imageViewUpper.layer.masksToBounds = true
        
        view.addSubview(photoImageLeft)
        view.addSubview(photoImageMiddle)
        view.addSubview(photoImageRight)
        
        photoImageLeft.contentMode = .scaleAspectFill
        photoImageMiddle.contentMode = .scaleAspectFill
        photoImageRight.contentMode = .scaleAspectFill
        
        view.addSubview(borderLabelMiddle)
        borderLabelMiddle.backgroundColor = .lightGray
        
        
        view.addSubview(borderUpperLabel)
        view.addSubview(borderCenterLabel)
        view.addSubview(borderLowerLabel)
        borderUpperLabel.backgroundColor = .lightGray
        borderCenterLabel.backgroundColor = .lightGray
        borderLowerLabel.backgroundColor = .lightGray
        
        
        
    }

    private func tapGesture() {
        let gestureRecognizerUpper = UITapGestureRecognizer(target: self, action: #selector(goToFriendsList(_:)))
        gestureRecognizerUpper.numberOfTapsRequired = 1
        gestureRecognizerUpper.numberOfTouchesRequired = 1
        imageViewUpper.addGestureRecognizer(gestureRecognizerUpper)
        imageViewUpper.isUserInteractionEnabled = true
        
        let gestureRecognizerMiddle = UITapGestureRecognizer(target: self, action: #selector(goToFriendsList(_:)))
        gestureRecognizerMiddle.numberOfTapsRequired = 1
        gestureRecognizerMiddle.numberOfTouchesRequired = 1
        imageViewMiddle.addGestureRecognizer(gestureRecognizerMiddle)
        imageViewMiddle.isUserInteractionEnabled = true
        
        let gestureRecognizerLower = UITapGestureRecognizer(target: self, action: #selector(goToFriendsList(_:)))
        gestureRecognizerLower.numberOfTapsRequired = 1
        gestureRecognizerLower.numberOfTouchesRequired = 1
        imageViewLower.addGestureRecognizer(gestureRecognizerLower)
        imageViewLower.isUserInteractionEnabled = true    
    }
    
    @objc func goToFriendsList(_ gesture: UITapGestureRecognizer) {
        goToFriendsListController()
    }
    
    private func loadImageFriends(url: URL, downloadImageView: UIImageView?) {
        guard  let neededImageView = downloadImageView  else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        neededImageView.image = image
                    }
                }
            }
        }
    }
    
    private func goToFriendsListController() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: controllerInditefire) as! FriendListController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor( red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                        alpha: CGFloat(1.0))
    }
}
