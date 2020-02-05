//
//  PostProvider.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation

enum PostProvider {
    case getAllPost
    case getPostDetail(Int)
    case createPost(String, String, Int)
}

extension PostProvider: EndPoint {
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        switch self {
        case .getAllPost:
            return "/posts"
        case .getPostDetail(let identifier):
            return "/posts/\(identifier)"
        case .createPost:
            return "/post"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getAllPost, .getPostDetail:
            return nil
        case .createPost(let title, let body, let id):
            let params: [String: Any] = [
                "title": title,
                "body": body,
                "userid": id]
            return ["body": params]
        }
    }
    
    var method: ServiceMethod {
        switch self {
        case .getAllPost, .getPostDetail:
            return .get
        case .createPost:
            return .post
        }
    }
}
