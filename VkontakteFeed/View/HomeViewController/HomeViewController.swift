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
    @IBOutlet weak var borderUpperLabel: UILabel!
    @IBOutlet weak var borderCenterLabel: UILabel!
    @IBOutlet weak var borderLowerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let controllerInditefire = "friendsList"
    private var userData: UserInfo?
    private var friendsData = [Item]()
    private var photosData = [Album]()
    private let errors = "error"
    private let cellIdentifier = "collectionViewCell"
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var urlArray = [String]()
    private var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:"HomeCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        launchScreen()
        getUserData()
        getFriends()
        tapGesture()
        getPhotos()
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
                let name = "\(self.userData!.first_name) " + "\(self.userData!.last_name)"
                self.nameLabel.textColor = self.hexStringToUIColor(hex:"c9c9c9")
                self.nameLabel.text = "\(name)"
                let bDate = self.userData!.bdate
                self.bDateLabel.textColor = self.hexStringToUIColor(hex:"c9c9c9")
                self.bDateLabel.text = "B date \(bDate)"
                let followers = "\(self.userData!.followers_count)"
                self.followersCounterLabel.textColor = self.hexStringToUIColor(hex:"c9c9c9")
                self.followersCounterLabel.text = "Follower: \(followers)"
                let city = self.userData!.city.title
                self.cityLabel.textColor = self.hexStringToUIColor(hex:"c9c9c9")
                self.cityLabel.text = "City: \(city)"
                self.isOnlineLabel.textColor = self.hexStringToUIColor(hex:"c9c9c9")
                if self.userData?.online != 0 {
                    self.isOnlineLabel.text = "Is Online"
                } else {
                    self.isOnlineLabel.isHidden = true
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
                self.friendsCounterLabel.textColor = self.hexStringToUIColor(hex:"c9c9c9")
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
    
    private func getPhotos()  {
        
        NetworkManager.shared.getAlbum { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let photoArray):
                self.photosData = photoArray ?? []
                self.photosData.enumerated().forEach({ index, element in
                    element.sizes.forEach { SizeAndPhotoUrl in
                        if SizeAndPhotoUrl.type == "p" {
                            self.urlArray.append(SizeAndPhotoUrl.url)
                        }
                    }
                })
                let photoCount = self.photosData.count
                self.photoLabel.textColor = self.hexStringToUIColor(hex:"c9c9c9")
                self.photoLabel.text = "Photos \(photoCount)"
                self.urlArray.forEach { url in
                    guard let url = URL(string: url) else { return }
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            self.imageArray.append(image)
                        }
                    }
                }
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
            self.collectionView.reloadData()
        }
    }

    private func launchScreen() {
        
        view.backgroundColor = hexStringToUIColor(hex: "#171414")
        
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
    
    @objc func goToFriendsList(_ gesture: UITapGestureRecognizer) { // Why i cant use private?
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
    
    func hexStringToUIColor (hex:String) -> UIColor {
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

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.imageArray.count < 6 {
            return self.imageArray.count
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeCell
        cell.configure(with: imageArray[indexPath.row])
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {
     
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
      
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
      
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int)->CGFloat {
        
        return sectionInsets.left
    }
}


