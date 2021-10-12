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
    @IBOutlet weak var friendsViewContainer: UIView!
    @IBOutlet weak var contentView: UIView!
    
    static let controllerInditefire = "HomeViewController"
    var userID: Int = 0
    var userData: UserInfo?
    var photosData = [Album]()
    var urlArray = [String]()
    var imageArray = [UIImage]()
    var avatar = UIImage()
    var imageFriendArray = [UIImage]()
    var friendsData = [FriendModel]()
    private let errors = "error"
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 2)
    private var imagesToFriendList = [UIImage]()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:"HomeCell", bundle: nil), forCellWithReuseIdentifier: HomeCell.reuseId)
        launchScreen()
        tapGesture()
        loadImageFriends()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func getPhotos()  {
        
        NetworkManager.shared.getAlbum { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let photoArray):
                self.photosData = photoArray ?? []
                self.photosData.enumerated().forEach({ index, element in
                    element.sizes.forEach { SizeAndPhotoUrl in
                        if SizeAndPhotoUrl.type == "m" {
                            self.urlArray.append(SizeAndPhotoUrl.url)
                        }
                    }
                })
                
                let photoCount = self.photosData.count
                self.photoLabel.textColor = .fontColor
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
        contentView.backgroundColor = .backgroundColor
        
        if imageArray.count == 0 {
            collectionView.isHidden = true
        }
        
        imageView.image = avatar
        imageView.contentMode = .top
        
        let imageViewArray = [imageViewLower, imageViewMiddle, imageViewUpper]
        let circleViewArray = [circleViewLower, circleViewMiddle, circleViewUpper]
        
        imageViewArray.enumerated().forEach { imageViewIndex, imageView in
            
            if imageFriendArray.isEmpty {
                circleViewArray.forEach { view in
                    view?.isHidden = true
                }
            } else {
                
                if imageFriendArray.count <= imageViewIndex {
                    circleViewArray[imageViewIndex]!.isHidden = true
                } else {
                    imageView!.image = imageFriendArray[imageViewIndex]
                }
            }
        }
        
        guard let userData = userData else { return }
        
        friendsViewContainer.backgroundColor = .backgroundColor
        
        nameLabel.textColor = .fontColor
        nameLabel.text = "\(userData.firstName) " + "\(userData.lastName)"
        
        bDateLabel.textColor = .fontColor
        bDateLabel.text = "B date \(userData.bdate)"
        
        followersCounterLabel.textColor = .fontColor
        followersCounterLabel.text = "Follower: \(userData.followersCount)"
        
        self.cityLabel.textColor = .fontColor
        self.cityLabel.text = "City: \(userData.city!.title)"
        
        self.isOnlineLabel.textColor = .fontColor
        if self.userData?.online != 0 {
            self.isOnlineLabel.text = "Is Online"
        } else {
            self.isOnlineLabel.isHidden = true
        }
        
        self.photoLabel.textColor = .fontColor
        self.photoLabel.text = "Photos \(self.imageArray.count)"
        
        self.friendsCounterLabel.textColor = .fontColor
        self.friendsCounterLabel.text = "Friends: \(self.friendsData.count)"
        
        view.backgroundColor =  UIColor.backgroundColor
        collectionView.backgroundColor = UIColor.backgroundColor
        
        nameLabel.font = nameLabel.font.withSize(20)
        nameLabel.textColor = .white

        isOnlineLabel.font = isOnlineLabel.font.withSize(8)
        isOnlineLabel.textColor = .white
        
        photoLabel.font = cityLabel.font.withSize(14)
        bDateLabel.font = bDateLabel.font.withSize(14)
        cityLabel.font = cityLabel.font.withSize(14)
        followersCounterLabel.font = followersCounterLabel.font.withSize(14)
        friendsCounterLabel.font = followersCounterLabel.font.withSize(14)
        
        imageCity.contentMode = .scaleToFill
        imageCity.image = UIImage(systemName: "house")

        imageFollowers.contentMode = .scaleToFill
        imageFollowers.image = UIImage(systemName: "person.circle")

        imageBdate.contentMode = .scaleToFill
        imageBdate.image = UIImage(systemName: "giftcard")
        
        imageFriends.contentMode = .scaleAspectFit
        imageFriends.image = UIImage(systemName: "person.3")
        
        circleViewLower.layer.cornerRadius = circleViewLower.frame.width/2
        circleViewLower.layer.masksToBounds = true
        imageViewLower.layer.cornerRadius = imageViewLower.frame.width/2
        imageViewLower.layer.masksToBounds = true
        
        circleViewMiddle.layer.cornerRadius = circleViewMiddle.frame.width/2
        circleViewMiddle.layer.masksToBounds = true
        imageViewMiddle.layer.cornerRadius = imageViewMiddle.frame.width/2
        imageViewMiddle.layer.masksToBounds = true
        
        circleViewUpper.layer.cornerRadius = circleViewUpper.frame.width/2
        circleViewUpper.layer.masksToBounds = true
        imageViewUpper.layer.cornerRadius = imageViewUpper.frame.width/2
        imageViewUpper.layer.masksToBounds = true
        
        borderLabelMiddle.backgroundColor = .lightGray
        
        borderUpperLabel.backgroundColor = .lightGray
        borderCenterLabel.backgroundColor = .lightGray
        borderLowerLabel.backgroundColor = .lightGray
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent 
    }

    private func tapGesture() {
        let gestureRecognizerUpper = UITapGestureRecognizer(target: self, action: #selector(goToFriendsList(_:)))
        
        friendsViewContainer.addGestureRecognizer(gestureRecognizerUpper)
        friendsViewContainer.isUserInteractionEnabled = true
    }
    
    private func loadImageFriends() {
        let dispatchGroup = DispatchGroup()
        
        friendsData.forEach {_ in dispatchGroup.enter()}
        
        friendsData.forEach { element in
            guard let url = URL (string: element.photo_200_orig!) else { return }
            
            UIImage.loadImageFromUrl(url: url) { image in
                self.imagesToFriendList.append(image)
                dispatchGroup.leave()
            }
        }
    }
    
    @objc private func goToFriendsList(_ gesture: UITapGestureRecognizer) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: FriendListController.controllerInditefire) as! FriendListController
        vc.friendsImage = imagesToFriendList
        vc.data = friendsData
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CollectionView

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count < 6 ?  self.imageArray.count : 6
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.reuseId, for: indexPath) as! HomeCell
        cell.configure(with: imageArray[indexPath.row])
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = (availableWidth  / itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
      
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
      
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section:Int)->CGFloat {
        
        return sectionInsets.left
    }
}


