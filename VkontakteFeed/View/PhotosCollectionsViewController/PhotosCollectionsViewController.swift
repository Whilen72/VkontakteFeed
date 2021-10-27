//
//  PhotosCollectionsViewController.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 16.10.21.
//

import UIKit

class PhotosCollectionsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoPresentView: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    static let controllerInditefire = "PhotosCollectionsViewController"
    
    var photoArray = [Album]()
    
    private let sectionInsets = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 2)
    private let itemsPerRow: CGFloat = 3
    private var urlArrayTypeM = [String]()
    private var urlArrayTypeY = [String]()
    private var photoCounter: Int = 0
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchScreen()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:"PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseId)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector (swipeAction(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector (swipeAction(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeAction(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            if photoCounter > 0 {

                photoCounter -= 1

                let imageURL = URL(string: photoArray[photoCounter].getUrlFullScreen() ?? "nahui")
                DispatchQueue.global(qos: .background).async {

                    guard let imageURL = imageURL else { return }
                    UIImage.loadImageFromUrl(url: imageURL) { image in
                        DispatchQueue.main.async {
                            self.photoPresentView.image = image
                        }
                    }
                }

                countLabel.text = "\(photoArray.count)/\(photoCounter + 1)"
            } else {
                photoCounter = photoArray.count - 1
                let imageURL = URL(string: photoArray[photoCounter].getUrlFullScreen() ?? "nahui")
                DispatchQueue.global(qos: .background).async {

                    guard let imageURL = imageURL else { return }
                    UIImage.loadImageFromUrl(url: imageURL) { image in
                        DispatchQueue.main.async {
                            self.photoPresentView.image = image
                        }
                    }
                }
            }

        } else if gesture.direction == .left {

            if photoArray.count - 1 > photoCounter {

                photoCounter += 1
                let imageURL = URL(string: photoArray[photoCounter].getUrlFullScreen() ?? "nahui")
                DispatchQueue.global(qos: .background).async {

                    guard let imageURL = imageURL else { return }
                    UIImage.loadImageFromUrl(url: imageURL) { image in
                        DispatchQueue.main.async {
                            self.photoPresentView.image = image
                        }
                    }
                }

            } else {
                photoCounter = 0
                let imageURL = URL(string: photoArray[photoCounter].getUrlFullScreen() ?? "nahui")
                DispatchQueue.global(qos: .background).async {

                    guard let imageURL = imageURL else { return }
                    UIImage.loadImageFromUrl(url: imageURL) { image in
                        DispatchQueue.main.async {
                            self.photoPresentView.image = image
                        }
                    }
                }
            }
            countLabel.text = "\(photoArray.count)/\(photoCounter + 1)"

        }
    }
   
    // MARK: - UI launch
    private func launchScreen() {
        view.backgroundColor = .backgroundColor
        collectionView.backgroundColor = .backgroundColor
        containerView.backgroundColor = .backgroundColor
        containerView.isHidden = true
        photoPresentView.isHidden = true
       
        countLabel.isHidden = true
        
    }
    
    private func showFullScreenPhoto() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain , target: self, action: #selector(addTapped))
        // i create new button every time?
        containerView.isHidden = false
        containerView.alpha = 1
        photoPresentView.isHidden = false
        
        countLabel.isHidden = false
    }
    
    @objc func addTapped(){
        self.navigationItem.rightBarButtonItem?.customView?.isHidden = true
        
        
        containerView.isHidden = true
        photoPresentView.isHidden = true
        countLabel.isHidden = true
    }
}

// MARK: - CollectionView

extension PhotosCollectionsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseId, for: indexPath) as! PhotosCollectionViewCell
        
        photoArray.enumerated().forEach({ index, element in
            element.sizes.forEach { SizeAndPhotoUrl in
                if SizeAndPhotoUrl.type == "x" {
                    urlArrayTypeY.append(SizeAndPhotoUrl.url)
                } else {
                    if SizeAndPhotoUrl.type == "y" {
                        urlArrayTypeY.removeLast()
                        urlArrayTypeY.append(SizeAndPhotoUrl.url)
                    }
                }
            }
        })
        
            let imageURL = URL(string: photoArray[indexPath.row].getUrlM() ?? "")
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
        
        showFullScreenPhoto()
        photoPresentView.contentMode = .center
        countLabel.textColor = .white
        photoCounter = indexPath.row
        countLabel.text = "\(photoArray.count)/\(indexPath.row + 1)"
        let imageURL = URL(string: photoArray[indexPath.row].getUrlFullScreen() ?? "")
        DispatchQueue.global(qos: .background).async {

            guard let imageURL = imageURL else { return }
            UIImage.loadImageFromUrl(url: imageURL) { image in
                DispatchQueue.main.async {
                    self.photoPresentView.image = image
                }
            }
        }
    }
}

extension PhotosCollectionsViewController: UICollectionViewDelegate {
    
}

// MARK: - FlowLayout

extension PhotosCollectionsViewController: UICollectionViewDelegateFlowLayout {
    
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
