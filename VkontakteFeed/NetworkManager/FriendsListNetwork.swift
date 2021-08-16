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
    // add token model
    static var accessToken = ""
    static var expireTime = ""
    static var userId = ""


    private let base: String = "https://api.vk.com"

    func launchUrl() {

    }
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

        let url = buldMethodURL(method: "friends.get", params: params)
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

    private func buldMethodURL(method: String, params: [String: String]) -> URL {
        var allParams: [String: String] = [
            "access_token": Network.accessToken,
            "v": "5.131"
        ]
        params.forEach { allParams[$0] = $1 }
        let paramsStr: String = allParams
            .map { "\($0)=\($1)"}
            .joined(separator: "&")

        let methodStr = base + "/method/" + method + "?" + paramsStr

        guard let url = URL.init(string: methodStr) else { fatalError() }
        return url
    }
}



