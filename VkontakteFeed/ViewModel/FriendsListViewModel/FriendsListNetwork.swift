//
//  FriendsListNetwork.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 7.08.21.
//

import Foundation

//fe8f1f63fe8f1f63fe8f1f6345fef7ced2ffe8ffe8f1f639f863d0289d61cce84461837
class Network {
    
    static let shared = Network()
    
    static var accessToken = ""
    static var expireTime = ""
    static var userId = ""
    //
    let urlString = "https://api.vk.com/friends.get?params&user_id="+userId+"&params?order=name&paramscount=1&params?offset=5&params?fields=city&params?name_case=ins&params&access_token="+accessToken+"&v=5.131"
 var people = [Item]()
    
    func getList (complited: @escaping ()->()) {
    let url = URL(string:urlString)
    URLSession.shared.dataTask(with: url!) { (data, response, error) in
        if error == nil {
            do {
                self.people = try JSONDecoder().decode([Item].self, from: data!)
                DispatchQueue.main.async {
                    complited()
                }
            } catch {
                print("JSON error")
                }
            }
        }.resume()
    }
//friends.get?params[user_id]=6492&params[order]=name&params[count]=1&params[offset]=5&params[fields]=city&params[name_case]=ins&params[v]=5.131
//https://api.vk.com/method/users.get?user_ids=210700286&fields=bdate&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3&v=5.131
}
