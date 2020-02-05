//
//  MainViewModel.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation
import Alamofire

final class MainViewModel {
    
    var allPosts: [Post]
    var posts: [Post]
    
    var viewState: ViewState = .initial {
        didSet {
            updateUI?(viewState)
        }
    }
    
    var updateUI: ((ViewState)-> Void)?
    
    // MARK: - Initializers
    
    init( ) {
        posts = []
        allPosts = []
    }
    
    func getPosts() {
        viewState = .loading
        
        let request = PostProvider.getAllPost.urlRequest
        
        AF.request(request).responseDecodable(of: [Post].self) { [weak self] response in
            guard let strongSelf = self else { return }
        
            switch response.result {
            case .success(let posts):
                strongSelf.processPosts(with: posts)
                strongSelf.viewState = .success
                
            case .failure(let error):
                print(error)
                strongSelf.viewState = .error
            }
        }
    }
    
    func processPosts(with response: [Post]) {
        print("fetched: \(response.count) posts. ")
        allPosts = response
        posts = response
    }
    
    func didSearch(with text: String) {
        if text.isEmpty {
            posts = allPosts
        } else {
            posts = allPosts.filter({
                $0.body.contains(text.lowercased())
            })
        }
        viewState = .success
    }
    
    func buildDetailModel(for index: Int) -> DetailPostViewModel {
        return DetailPostViewModel(identifier: posts[index].id)
    }
}

extension MainViewModel {
    
    enum ViewState {
        case initial
        case loading
        case success
        case error
    }
}
