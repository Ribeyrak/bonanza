//
//  InterfaceRequest.swift
//  bonanza
//
//  Created by Evhen Lukhtan on 23.05.2023.
//

import Foundation

class InterfaceRequest {
    
    static let privacyPolicyURL = "https://bonanzabillion.fun/"
    
    lazy var requestClient: Request = {
        let baseUrl = URL(string: InterfaceRequest.privacyPolicyURL)!
        let session = URLSession.shared
        let requestClient = Request(baseUrl: baseUrl, session: session)
        return requestClient
    }()
    
    struct Request {
        let baseUrl: URL
        let session: URLSession
        
        func requestData(color: String = "NiUS37WTD",
                         cmp: String,
                         medsor: String,
                         packname: String,
                         cmpid: String,
                         advid: String,
                         appfid: String,
                         uuid: String,
                         completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
            
            var components = URLComponents(url: baseUrl.appendingPathComponent(color), resolvingAgainstBaseURL: true)!
            
            var queryItems = [URLQueryItem]()
            queryItems.append(URLQueryItem(name: "7HR8C", value: medsor))
            queryItems.append(URLQueryItem(name: "Syc4zs4", value: packname))
            queryItems.append(URLQueryItem(name: "pynkqd", value: cmpid))
            queryItems.append(URLQueryItem(name: "er8jf86", value: advid))
            queryItems.append(URLQueryItem(name: "ZPObxN90g", value: appfid))
            queryItems.append(URLQueryItem(name: "17pfiycy", value: uuid))
            components.queryItems = queryItems
            
            let url = components.url!
            let task = session.dataTask(with: url, completionHandler: completion)
            task.resume()
        }
    }
}


