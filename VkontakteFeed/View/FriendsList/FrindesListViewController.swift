//
//  FrindesListView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 6.08.21.
//

import UIKit

class FriendListController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    static let controllerInditefire = "friendsList"
    var friendsImage = [UIImage]()
    var data = [FriendModel]()
    
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  getFriendsList()
        tableView.register(UINib(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: FriendsTableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .backgroundColor
    }
}

extension FriendListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsTableViewCell

        cell.configure(with: friendsImage[indexPath.row],
                       name: "\(data[indexPath.row].firstName!) \((data[indexPath.row].lastName!))",
                       city: data[indexPath.row].city?.title ?? "Не указан",
                       onlineStatus: data[indexPath.row].online == 1 ? "is online" : "")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Friend ID
        didsele
        NetworkManager.shared.currentID = "\(data[indexPath.row].id)"
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: HomeViewController.controllerInditefire) as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension FriendListController: UITableViewDelegate {
    
}
