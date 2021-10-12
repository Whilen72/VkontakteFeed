//
//  FriendsListNetwork.swift
//  VkontakteFeed
//
//  Created by Alexey Kniazev on 7.08.21.
//

import Foundation
import UIKit

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
    
    func getList(offset: Int = 0, count: Int = 100, fields: [GetListFields] = [.photo_200_orig, .photo_50, .online, .city], completion: @escaping (Result<FriendList, Error>)->(Void)) {
        
        let params: [String: String] = [
            "fields": fields.map({ $0.rawValue }).joined(separator:","),
            "name_case": "nom",
            "offset": "\(offset)",
            "count": "\(count)",
            "order": "name",
        ]

        let url = buildMethodURL(method: "friends.get", params: params)
        
        performeRequest(url: url) { data, error in
            
            let decoder = JSONDecoder()
            do {
                struct Responce: Decodable {
                    let response: FriendList
                }
                if let data = data {
                    
                    let responceModel = try decoder.decode(Responce.self, from: data)
                    print(responceModel)
                    DispatchQueue.main.async {
                        completion(.success(responceModel.response))
                    }
                } else {
                    completion(.failure(error?.localizedDescription as! Error))
                }
            } catch let error {
                print("error")
                completion(.failure(error))
            }
        }
    }

    private func buildMethodURL(method: String, params: [String: String]?) -> URL {
   
        var allParams: [String: String] = [
            "v": "5.131"
        ]
        
        if let accessToken = UserDefaults.standard.object(forKey: "savedAccessToken") as? String {
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
    
    enum ErrorCodes: Int {
        case authError = 5
    }
    
    enum ServerError: Error {
        case tokenError
        case unknownError
    }
    
    private func performeRequest(url: URL, completion: @escaping (Data?, Error?)->(Void)) {
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                do {

                    if let data = data {

                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print(json)
                            if let serverError = json["error"] as? [String : Any], let errorCode = serverError["error_code"] as? Int {
                            
                                if errorCode == ErrorCodes.authError.rawValue {
                                    completion(nil, ServerError.tokenError)
                                    DispatchQueue.main.async {
                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                        if let topController = appDelegate.getTopMostVC() {
                                            let vc = topController.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                                            vc.navigationController?.pushViewController(vc, animated: false)
                                        }
                                    }
                                } else {
                                    completion(nil, ServerError.unknownError)
                                }
                            } else {
                                completion(data, nil)
                            }
                        }
                    }
                } catch {
                    completion(nil, error)
                }
            }
        }.resume()
    }
  
    func getCurrentUser (completion: @escaping (Result<CurrentUser, Error>)->(Void)) {
        
        let url = buildMethodURL(method: "account.getProfileInfo", params: nil)
        performeRequest(url: url) { data, error in
            
            let decoder = JSONDecoder()
            do {
                struct Response: Decodable {
                    let response: [CurrentUser]?
                }
                
                if let data = data {
                    
                let responceModel = try decoder.decode(CurrentUser.self, from: data)
                    print(responceModel)
                DispatchQueue.main.async {
                    completion(.success(responceModel))
                    }
                } else {
                    if let error = error {
                        completion(.failure(error))
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }

    enum getUserDataFields: String, CaseIterable {
        case photo_max_orig, followers_count, city, online, bdate
    }
    
    func getUserData (fields: [getUserDataFields] = [.photo_max_orig, .followers_count, .city, .online, .bdate], completion: @escaping (Result<UserInfo?, Error>)->(Void)) {
        
        let params: [String: String] = [
            "fields": fields.map({ $0.rawValue }).joined(separator:",")]
        
        let url = buildMethodURL(method: "users.get", params: params)
        
        performeRequest(url: url) { data, error in
            
            let decoder = JSONDecoder()
            do {
                struct Response: Decodable {
                    let response: [UserInfo]?
                }
               
                if let data = data {
                let responseModel = try decoder.decode(Response.self, from: data)
                    print(responseModel)
                    DispatchQueue.main.async {
                    completion(.success(responseModel.response?.first))
                    }
                } else {
                    completion(.failure(error!))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func getAlbum(offset: Int = 0, count: Int = 500, completion: @escaping (Result<[Album]?, Error>)->(Void)) {
        
        let params: [String: String] = [
            "album_id": "wall",
            "offset": "\(offset)",
            "count": "\(count)",
        ]
        
        let url = buildMethodURL(method: "photos.get", params: params)
        
        performeRequest(url: url) { data, error in
            
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
                    if let error = error {
                    completion(.failure(error))
                    }
                }
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func checkAccessToken() -> Bool {
        
        let expireDate = UserDefaults.standard.object(forKey: "savedExpireIn") as? Date

        if let expireDate = expireDate {

            if expireDate > Date() {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}







