//
//  EndPoint.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation

protocol EndPoint {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
    var method: ServiceMethod { get }
}

extension EndPoint {
    
    var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        guard let params = parameters, method != .get else { return request }
        
        
        if let bodyParams = params["body"] as? [String: Any] {
            request.setValue("application/json; charset=utf-8",
                             forHTTPHeaderField: "Content-Type")
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyParams)
            request.httpBody = jsonData
        }
        
        
        return request
    }
    
    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        
        var queryItems:[URLQueryItem] = []
        
        if let params = parameters, method == .get {
            queryItems.append(contentsOf: params.map({
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }))
        }
        
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}

enum ServiceMethod: String {
    case get = "GET"
    case post = "POST"
}
