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
    let defaults = UserDefaults.standard

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
    
    func getCurrentUser (completion: @escaping (Result<Response, Error>)->(Void)){
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

    func checkExpireTime() {
        
        let expireTime = token?.expiresIn
        let expireTimeDouble = (expireTime! as NSString).doubleValue
        let date = Date()
        let expireDate = date.addingTimeInterval(expireTimeDouble)
        let savedExpireDate = defaults.object(forKey: "expire") as? Date
        if savedExpireDate != expireDate {
            defaults.set(token?.expiresIn, forKey: "expire") // And? for what im done that?
            
        }
        
        
    }
//    func checkExpireTime() {
//
//        let expireTime = token?.accessToken
//        let expireTimeDouble = (expireTime! as NSString).doubleValue
//        let date = Date()
//        let expireDate = date.addingTimeInterval(TimeInterval(expireTimeDouble/60))
//
//
//        //let date = startDate.addingTimeInterval(TimeInterval(5.0 * 60.0))
//    }


}

    


//https://api.vk.com/method/users.get?access_token=fee561901a977452bdab205dbedc0d6910cf1489803617c27fefc9b1c174f18b733e97213e75a06a57679&v=5.131

//let expireTime = token.expireIn
//let expireTimeDouble = (expireTime as NSString).doubleValue




