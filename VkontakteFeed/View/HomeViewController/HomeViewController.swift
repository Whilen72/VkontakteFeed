//
//  HomeViewController.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 19.08.21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var leftDotLabel: UILabel!
    @IBOutlet weak var midDotLabel: UILabel!
    @IBOutlet weak var loadingInfoLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIImageView!
    @IBOutlet weak var animationView: UIView!
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
    
    var userID: String?
    var userData: UserInfo?
    var photosData = [Album]()
    var urlArray = [String]()
    var imageArray = [PhotoModel]()
    var avatar = UIImage()
    var imageFriendArray = [UIImage]()
    var friendsData = [FriendModel]()
    var linkArray = [String]()
    var currentUser: CurrentUser?
    
    private let errors = "error"
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 2)
   
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundColor
        animationView.backgroundColor = .backgroundColor
        navigationController?.navigationBar.barTintColor = .backgroundColor
        
        reciveDataForHomeVC()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:"HomeCell", bundle: nil), forCellWithReuseIdentifier: HomeCell.reuseId)
        tapGesture()
        navBarItems()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       

    }
    
    @objc func addTapped() {
        UserDefaults.standard.removeObject(forKey: "savedAccessToken")
        UserDefaults.standard.removeObject(forKey: "savedExpireIn")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: LoginViewController.controllerInditefire) as! LoginViewController
        navigationController?.viewControllers.removeAll()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToHome(){
        userID = currentUser?.id
        reciveDataForHomeVC()
    }
    
    private func getPhotos()  {
        
        NetworkManager.shared.getAlbum(id: userID) { [weak self] (result) in
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
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
            self.collectionView.reloadData()
        }
    }

    // MARK: - UI
    
    private func navBarItems() {
        
        let homeImage = UIImage(systemName: "house")
        let logOutButton = UIBarButtonItem(title: "Log out", style: .plain , target: self, action: #selector(addTapped))
        let homeButton = UIBarButtonItem(image: homeImage, style: .plain, target: self, action: #selector(goToHome))
        self.navigationController?.navigationBar.topItem?.setRightBarButtonItems([logOutButton, homeButton], animated: true)
    }
    
    private func launchScreen() {
        contentView.backgroundColor = .backgroundColor
        
        imageView.contentMode = .top
        imageView.image = avatar
        
        
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
        if let name = userData.firstName, let lastName = userData.lastName {
            
            nameLabel.text = "\(name) " + "\(lastName)"
        }
        bDateLabel.textColor = .fontColor
        bDateLabel.text = "B date \(userData.bdate ?? "hidden")"
        
        followersCounterLabel.textColor = .fontColor
        followersCounterLabel.text = "Follower: \(userData.followersCount ?? 0)"
        
        self.cityLabel.textColor = .fontColor
        
        self.cityLabel.text = "City: \(userData.city?.title ?? "hidden")"
        
        self.isOnlineLabel.textColor = .fontColor
        if self.userData?.online != 0 {
            self.isOnlineLabel.text = "Is Online"
        } else {
            self.isOnlineLabel.isHidden = true
        }
        
        self.photoLabel.textColor = .fontColor
        self.photoLabel.text = "Photos \(self.photosData.count)"
        
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
    
   
    
    @objc private func goToFriendsList(_ gesture: UITapGestureRecognizer) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: FriendListController.controllerInditefire) as! FriendListController

        vc.data = friendsData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - animations
    
    private func animationsForLoading() {
        
        loadingInfoLabel.isHidden = false
        self.view.bringSubviewToFront(loadingInfoLabel)
        
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
        
        loadingInfoLabel.isHidden = true
        loadingInfoLabel.textColor = .white
        loadingInfoLabel.font.withSize(20)
        loadingInfoLabel.text = "Loading"
    }
    
    private func prepareViewForAnimations() {
        animationView.isHidden = false
        self.view.bringSubviewToFront(animationView)
        showLoadingAnimation()
        animationsForLoading()
    }

    // MARK: - NetFlow
    
    func reciveDataForHomeVC(){  //rename func
                
        prepareViewForAnimations()

        var avatarFromNetwork = UIImage()

        var dataToVC: UserInfo?

        getUserData { [weak self] userInfo in

            let group = DispatchGroup()
            guard let self = self else { return }

            dataToVC = userInfo

            self.getPhotos { [weak self] album in

                guard let self = self else { return }

                self.getFriends { [weak self] friend in

                    guard let self = self else { return }
                    var photoToVC = [UIImage]()
                    let friendToVC = friend

                    group.notify(queue: .main) {
        
                        self.avatar = avatarFromNetwork
                        self.userData = dataToVC
                        self.imageFriendArray = photoToVC
                        if let friendToVC = friendToVC.items {
                           self.friendsData = friendToVC
                        }
                        
                        self.launchScreen()
                        self.animationView.isHidden = true
                        self.collectionView.reloadData()
                    }
                    
                    friend.items?.forEach {_ in group.enter()}
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
                }
            }
        }
    }
    
    private func getUserData(completion: @escaping (UserInfo)->()) {
        
        if NetworkManager.shared.checkAccessToken() == true {
            
            NetworkManager.shared.getUserData(id: userID) { (result) in
                
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
        
            NetworkManager.shared.getAlbum(id: userID) { (result) in
                
                switch result {
                case .success(let photoArray):
                    completion(photoArray ?? [])
                    if let photoForVC = photoArray {
                        self.photosData = photoForVC
                    }
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
        
            NetworkManager.shared.getList(id: userID) { (result) in
                
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
    
    func showAuthWebView() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: WebViewController.controllerInditefire) as! WebViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: - CollectionView

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosData.count < 6 ?  self.photosData.count : 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.reuseId, for: indexPath) as! HomeCell

        let imageURL = URL(string: photosData[indexPath.row].getUrlM()!) // UNWARP
       
        DispatchQueue.global(qos: .background).async {
           
            guard let imageURL = imageURL else { return }
            UIImage.loadImageFromUrl(url: imageURL) { image in
                
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        }
        
        cell.imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: PhotosCollectionsViewController.controllerInditefire) as! PhotosCollectionsViewController
        vc.photoArray = photosData
        self.navigationController?.pushViewController(vc, animated: false)
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

extension HomeViewController: webIsReadyDelegate {
    func netFlowStart() {
        reciveDataForHomeVC()
    }
}

