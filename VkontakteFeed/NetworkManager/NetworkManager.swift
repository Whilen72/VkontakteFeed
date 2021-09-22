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
        case photo_200_orig
        case online
        case city
    }
    func getList(offset: Int = 0, count: Int = 100, fields: [GetListFields] = [.photo_200_orig, .photo_50, .online], completion: @escaping (Result<FriendList, Error>)->(Void)) {
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
                        let response: FriendList
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
        
        if params != nil {
            params?.forEach { allParams[$0] = $1 }
        }
        let paramsStr: String = allParams
            .map { "\($0)=\($1)"}
            .joined(separator: "&")

        let methodStr = baseUrl + method + "?" + paramsStr
        guard let url = URL.init(string: methodStr) else { fatalError() }
    
        return url
    }
  
    func getCurrentUser (completion: @escaping (Result<CurrentUser, Error>)->(Void)) {
        
        let url = buildMethodURL(method: "account.getProfileInfo", params: nil)
        
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
                        let response: PhotosResponse
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
    
    func checkAccessToken() -> Bool {
        
        guard let tokenExpire = token?.expiresIn else { return false }
        guard let seconds = Double(tokenExpire) else { return false }
        let expireDate = Date().addingTimeInterval(seconds)
        
        if expireDate > Date() {
            
            return true
        } else {
        
            return false
        }
    }
}
    







