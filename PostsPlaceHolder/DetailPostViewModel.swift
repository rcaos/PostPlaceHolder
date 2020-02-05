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
        let request = "https://jsonplaceholder.typicode.com/posts/\(identifier)"
        
        Alamofire.request(request).validate().responseJSON { [weak self] response in
            guard let strongSelf = self else { return }
        
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let resp = try decoder.decode(Post.self, from: data)
                    strongSelf.processPosts(with: resp)
                    strongSelf.viewState = .success
                }
                catch {
                    print("error to Decode: [\(error)]")
                    strongSelf.viewState = .error
                }
                
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

