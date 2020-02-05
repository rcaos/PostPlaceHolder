//
//  CreatePostViewModel.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation
import Alamofire

final class CreatePostViewModel {
    
    var viewState: ViewState = .initial {
        didSet {
            updateUI?(viewState)
        }
    }
    
    var updateUI: ((ViewState)-> Void)?
    
    var updateImageUI: ((ViewState)-> Void)?
    
    let randomImageURL = "https://picsum.photos/200"
    
    var dataForImage: Data?
    
    // MARK: - Initializers
    
    init( ) {
    }
    
    func createPost(title: String, body: String) {
        viewState = .loading
        let request = PostProvider.createPost(title, body, 51).urlRequest
        
        AF.request(request).responseJSON { [weak self] response in
            guard let strongSelf = self else { return }
        
            switch response.result {
            case .success:
                guard let _ = response.data else { return }
                strongSelf.viewState = .success
            case .failure:
                strongSelf.viewState = .error
            }
        }
    }
    
    func getRandomImage() {
        updateImageUI?(.loading)
        
        AF.request(randomImageURL).validate().responseData { [weak self] response in
            guard let strongSelf = self else { return }
        
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                strongSelf.dataForImage = data
                strongSelf.updateImageUI?(.success)
            case .failure:
                strongSelf.dataForImage = nil
                strongSelf.updateImageUI?(.error)
            }
        }
    }
}

extension CreatePostViewModel {
    
    enum ViewState {
        case initial
        case loading
        case success
        case error
    }
}
