//
//  FriendsListNetwork.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 7.08.21.
//

import Foundation

//example: https://api.vk.com/method/users.get?user_id=210700286&v=5.52

//https://api.vk.com/method/friends.get?params&user_id="+userId+"&params?order=name&params?count=1&params?offset=5&params?fields=city&params?name_case=ins&params&access_token="+accessToken+"&v=5.131

//friends.get?params?user_id=   &params?order=name&params?count=500&params?offset=5&params?fields=city&params?name_case?=ins&params?v=5.131

class Network {
    
    static let shared = Network()
    
    static var accessToken = ""
    static var expireTime = ""
    static var userId = ""
    
    
    // "https://api.vk.com/method/friends.get?params?access_token="+accessToken+"&params?order=random&params?count=500&params?offset=5&params?fields=city&params?name_case=ins&v=5.131"
    
    
    let urlString = "https://api.vk.com/method/friends.get?access_token="+accessToken+"&count=20&fields=photo_50&name_case=nom&offset=0&order=name&user_id=11799823&v=5.95"
    
    // https://api.vk.com/method/friends.get?access_token="+accessToken+"&count=20&fields=photo_50&name_case=nom&offset=0&order=name&user_id=11799823&v=5.95

    // https://api.vk.com/method/friends.get?access_token=aa6fc259aa6259aa6fc25928aa05d275aaa6faa6fc259f6d7432f20428dbe90f96c51&count=20&fields=photo_50&name_case=nom&offset=0&order=name&user_id=11799823&v=5.95
    
    func getList(completion: @escaping (Result<FriendsList, Error>)->(Void)) {
        
        //let testString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        guard let url = URL.init(string: urlString)  else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let decoder = JSONDecoder()
                do {
                    struct Responce: Decodable {
                        let response: FriendsList
                    }

                    let str = String(decoding: data!, as: UTF8.self)
                    let responceModel = try! decoder.decode(Responce.self, from: data!)
                    print("////////// \n",data!,"\n////////////")
                    DispatchQueue.main.async {
                        completion(.success(responceModel.response))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}



