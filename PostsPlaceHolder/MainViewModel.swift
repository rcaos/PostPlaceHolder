//
//  MainViewModel.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation
import Alamofire

import RxSwift
import RxCocoa

final class MainViewModel {
    
    var viewState: ViewState = .initial {
        didSet {
            updateUI?(viewState)
        }
    }
    
    var updateUI: ((ViewState)-> Void)?
    
    let rxAllPosts: BehaviorRelay<[Post]> = BehaviorRelay(value: [])    //RxCocoa Type
    
    var rxPosts: BehaviorRelay<[Post]> = BehaviorRelay(value: [])
    var rxPostsObservable: Observable<[Post]> {
        return rxPosts.asObservable()
    }
    
    var route: ((MainViewModelRoute)-> Void)?
    
    // MARK: - Initializers
    
    init( ) {
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
        
        //Acepta evento y Emite a sus Subscriptores!
        rxAllPosts.accept(response)
        rxPosts.accept(response)
    }
    
    func didSearch(with text: String) {
        guard viewState == .success else { return }
        
        if text.isEmpty {
            rxPosts.accept( rxAllPosts.value )
        } else {
            let filterPosts = rxAllPosts.value.filter({
                $0.body.contains(text.lowercased())
            })
            rxPosts.accept(filterPosts)
        }
        viewState = .success
    }
    
    func didSelectPost(with index: Int) {
        let identifier = rxPosts.value[index].id
        route?( .showMovieDetail(identifier: identifier) )
    }
    
    func didCreatePost() {
        route?(  .showCreatePost )
    }
}

// MARK: - Navigation

enum MainViewModelRoute {
    case initial
    case showMovieDetail(identifier: Int)
    case showCreatePost
}

// MARK: - State

extension MainViewModel {
    
    enum ViewState {
        case initial
        case loading
        case success
        case error
    }
}
