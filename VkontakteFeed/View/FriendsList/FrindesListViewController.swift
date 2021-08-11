//
//  FrindesListView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 6.08.21.
//

import UIKit

class FriendListController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
   
    var data = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Network.shared.getList {
            self.tableView.reloadData()
        }
        tableView.dataSource = self
        tableView.delegate = self
        
        
    }
    
}

extension FriendListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsCell
        cell.nameLabel.text = data[indexPath.row].firstName
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension FriendListController: UITableViewDelegate {
    
}
