//
//  FrindesListView.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 6.08.21.
//

import UIKit

class FriendListController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
   
   private var data = [Item]()
   static let controllerInditefire = "friendsList"
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriendsList()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendsCell.self, forCellReuseIdentifier: "friendsCell")
        addConstraints()
    }

    private func getFriendsList() {
        NetworkManager.shared.getList {[weak self] (result) in
            switch result {
            case .success(let listOf):
                self?.data = listOf.items ?? []
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
            self!.tableView.reloadData()
        }
    }
    
    private func addConstraints(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
        
    

}

extension FriendListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath) as! FriendsCell
        print((data[indexPath.row].firstName)!)
        cell.nameLabelCell?.text = "lol lol lol" //(data[indexPath.row].firstName)
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension FriendListController: UITableViewDelegate {
    
}
