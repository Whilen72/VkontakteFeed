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
    
    
    private let controllerInditefire = "HomeViewController"
    private var userData = [UserInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getUserData { [weak self] (result) in
           
            
    }
        func addLabel() {
           
        }
    }
}
//imageURL.image = UIImage(data: myDataVar)


//
