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
    @IBOutlet weak var exiteOutlet: UIButton!
    
    static let controllerInditefire = "PhotosCollectionsViewController"
    
    var photo = [Album]()
    
    private let sectionInsets = UIEdgeInsets(top: 10, left: 2, bottom: 10, right: 2)
    private let itemsPerRow: CGFloat = 3
    private var urlArrayTypeM = [String]()
    private var urlArrayTypeY = [String]()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchScreen()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:"PhotosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseId)
    }
    
    @IBAction func exiteEvent(_ sender: Any) {
        print("I pressed")
        
        containerView.isHidden = true
        photoPresentView.isHidden = true
        exiteOutlet.isHidden = true
    }
    
    private func launchScreen() {
        view.backgroundColor = .backgroundColor
        collectionView.backgroundColor = .backgroundColor
        containerView.backgroundColor = .backgroundColor
        containerView.isHidden = true
        photoPresentView.isHidden = true
        exiteOutlet.isHidden = true
        exiteOutlet.setTitle("", for: .normal)
    }
    
    private func showFullScreenPhoto() {
        containerView.isHidden = false
        containerView.alpha = 1
        photoPresentView.isHidden = false
        exiteOutlet.isHidden = false
    }
}

// MARK: - CollectionView

extension PhotosCollectionsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseId, for: indexPath) as! PhotosCollectionViewCell
        
        var urlArrayTypeM = [String]()
        
        
        photo.enumerated().forEach({ index, element in
            element.sizes.forEach { SizeAndPhotoUrl in
                if SizeAndPhotoUrl.type == "m" {
                    urlArrayTypeM.append(SizeAndPhotoUrl.url)
                }
            }
        })
        
        photo.enumerated().forEach({ index, element in
            element.sizes.forEach { SizeAndPhotoUrl in
                if SizeAndPhotoUrl.type == "y" {
                    urlArrayTypeY.append(SizeAndPhotoUrl.url)
                }
            }
        })
        
        let imageURL = URL(string: urlArrayTypeM[indexPath.row])
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
        
        let imageURL = URL(string: urlArrayTypeY[indexPath.row])
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
