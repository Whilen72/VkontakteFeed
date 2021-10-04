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
                       city: ";'k",
                       onlineStatus: data[indexPath.row].online == 1 ? "is online" : "offline")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension FriendListController: UITableViewDelegate {
    
}
