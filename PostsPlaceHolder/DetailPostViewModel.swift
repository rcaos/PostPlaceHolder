//
//  DetailPostViewModel.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation
import Alamofire

final class DetailPostViewModel {
    
    var posts: [Post]
    
    var viewState: ViewState = .initial {
        didSet {
            updateUI?(viewState)
        }
    }
    
    var updateUI: ((ViewState)-> Void)?
    
    var identifier: Int
    
    var title: String?
    
    var body: String?
    
    // MARK: - Initializers
    
    init(identifier: Int) {
        self.identifier = identifier
        posts = []
    }
    
    func getPostDetail() {
        print("Loading Detail Post...")
        viewState = .loading
        let request = PostProvider.getPostDetail(identifier).urlRequest
        
        AF.request(request).validate().responseDecodable(of: Post.self) { [weak self] response in
            guard let strongSelf = self else { return }
            
            switch response.result {
            case .success(let postResponse):
                strongSelf.processPosts(with: postResponse)
                strongSelf.viewState = .success
            case .failure(let error):
                print(error)
                strongSelf.viewState = .error
            }
        }
    }
    
    func processPosts(with response: Post) {
        print("Detail Ok: \(response)")
        title = response.title
        body = response.body
    }
}

extension DetailPostViewModel {
    
    enum ViewState {
        case initial
        case loading
        case success
        case error
    }
}

