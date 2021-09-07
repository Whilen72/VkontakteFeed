//
//  FriendsListNetwork.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 7.08.21.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    
    var token: Token?
    private let baseUrl: String = "https://api.vk.com/method/"
    
    enum GetListFields: String, CaseIterable {
        case photo_50
    }
    func getList(offset: Int = 0, count: Int = 500, fields: [GetListFields] = [.photo_50], completion: @escaping (Result<FriendsList, Error>)->(Void)) {
        let params: [String: String] = [
            "fields": fields.map({ $0.rawValue }).joined(separator:","),
            "name_case": "nom",
            "offset": "\(offset)",
            "count": "\(count)",
            "order": "name",
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
                    if let data = data {
                        let responceModel = try decoder.decode(Responce.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(responceModel.response))
                        }
                    } else {
                        completion(.failure(error?.localizedDescription as! Error))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    private func buildMethodURL(method: String, params: [String: String]?) -> URL {
        var allParams: [String: String] = [
            "v": "5.131"
        ]
        if let accessToken = token?.accessToken {
            allParams["access_token"] = accessToken
        }
            
        let keysToRemove: [String] = allParams.reduce([], { result, keyValue in
            return keyValue.value.isEmpty ? result + [keyValue.key] : result
        })
        keysToRemove.forEach { allParams.removeValue(forKey: $0) }

        params!.forEach { allParams[$0] = $1 }
        let paramsStr: String = allParams
            .map { "\($0)=\($1)"}
            .joined(separator: "&")

        let methodStr = baseUrl + method + "?" + paramsStr
        guard let url = URL.init(string: methodStr) else { fatalError() }

        return url
    }
  
    func getCurrentUser (completion: @escaping (Result<CurrentUser, Error>)->(Void)) {
        let param = ["":""]
        let url = buildMethodURL(method: "account.getProfileInfo", params: param)
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let decoder = JSONDecoder()
                do {
                    struct Response: Decodable {
                        let response: [CurrentUser]?
                    }
                    if let data = data {
                    let responceModel = try decoder.decode(CurrentUser.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(responceModel))
                        }
                    } else {
                        completion(.failure(error?.localizedDescription as! Error))
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }

    enum getUserDataFields: String, CaseIterable {
        case photo_max_orig, followers_count, city, online, bdate
    }
    
    func getUserData (fields: [getUserDataFields] = [.photo_max_orig, .followers_count, .city, .online, .bdate], completion: @escaping (Result<UserInfo?, Error>)->(Void)) {
        let params: [String: String] = [
            "fields": fields.map({ $0.rawValue }).joined(separator:",")]
        let url = buildMethodURL(method: "users.get", params: params)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let decoder = JSONDecoder()
                do {
                    struct Response: Decodable {
                        let response: [UserInfo]?
                    }
                    if let data = data {
                    let responseModel = try decoder.decode(Response.self, from: data)
                        DispatchQueue.main.async {
                        completion(.success(responseModel.response?.first))
                        }
                    } else {
                        completion(.failure(error?.localizedDescription as! Error))
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    func getAlbum(offset: Int = 0, count: Int = 500, completion: @escaping (Result<[Album]?, Error>)->(Void)) {
        let params: [String: String] = [
            "album_id": "wall",
            "offset": "\(offset)",
            "count": "\(count)",
        ]
        let url = buildMethodURL(method: "photos.get", params: params)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let decoder = JSONDecoder()
                do {
                    struct Response: Decodable {
                        let response: Photos
                    }
                    if let data = data {
                    let responseModel = try decoder.decode(Response.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(responseModel.response.items ?? []))
                    }
                    } else {
                        completion(.failure(error?.localizedDescription as! Error))
                    }
                } catch let error {
                    completion(.failure(error))  
                }
            }
        }.resume()
    }
}
    







