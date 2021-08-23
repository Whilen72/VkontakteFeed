//
//  FriendsListNetwork.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 7.08.21.
//

import Foundation

//example: https://api.vk.com/method/users.get?user_id=210700286&v=5.52



class NetworkManager {
    
    static let shared = NetworkManager()
    
    
    var token: Token?
    private let baseUrl: String = "https://api.vk.com/method/"

    
    
// func is logged

    enum GetListFields: String, CaseIterable {
        case photo_50
    }
    func getList(offset: Int = 0, count: Int = 20, fields: [GetListFields] = [.photo_50], completion: @escaping (Result<FriendsList, Error>)->(Void)) {
        let params: [String: String] = [
            "fields": fields.map({ $0.rawValue }).joined(separator:","),
            "name_case": "nom",
            "offset": "\(offset)",
            "count": "\(count)",
            "order": "name",
            "user_id": "11799823",
        ]

        let url = buildMethodURL(method: "friends.get", params: params)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let decoder = JSONDecoder()
                do {
                    struct Responce: Decodable {
                        let response: FriendsList
                    }
                    let responceModel = try decoder.decode(Responce.self, from: data!)
                    DispatchQueue.main.async {
                        completion(.success(responceModel.response))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    private func buildMethodURL(method: String, params: [String: String]) -> URL {
        
        var allParams: [String: String] = [
            "v": "5.131"
        ]
        if let accessToken = token?.accessToken {
            allParams["access_token"] = accessToken
        }
        
        params.forEach { allParams[$0] = $1 }
        let paramsStr: String = allParams
            .map { "\($0)=\($1)"}
            .joined(separator: "&")

        let methodStr = baseUrl + method + "?" + paramsStr

        guard let url = URL.init(string: methodStr) else { fatalError() }
        return url
    }
  /*
    func getCurrentUser (completion: @escaping (Result<Response, Error>)->(Void)) {
        let param = ["":""]
        let url = buildMethodURL(method: "account.getProfileInfo", params: param)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let decoder = JSONDecoder()
                do {
                    let responceModel = try decoder.decode(Response.self, from: data!)
                    DispatchQueue.main.async {
                        completion(.success(responceModel))
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
*/
    enum getUserDataFields: String, CaseIterable {
        case photo_400_orig, followers_count, city, online, bdate
    }
    
    func getUserData (fields: [getUserDataFields] = [.photo_400_orig, .followers_count, .city, .online, .bdate], completion: @escaping (Result<UserInfo?, Error>)->(Void)) {
        let params: [String: String] = [
            "fields": fields.map({ $0.rawValue }).joined(separator:",")]
        let url = buildMethodURL(method: "users.get", params: params)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            print(url)
            if let error = error {
                completion(.failure(error))
            } else {
                let decoder = JSONDecoder()
                do {
                    struct Response: Decodable {
                        let response: [UserInfo]?
                    }
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        print(json)
                    }
                    let responseModel = try! decoder.decode(Response.self, from: data!)
                    print(responseModel)
                    DispatchQueue.main.async {
                        completion(.success(responseModel.response?.first))
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}

    







