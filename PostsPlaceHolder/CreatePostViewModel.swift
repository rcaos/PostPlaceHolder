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
    
    let randomImagesURL = ["https://i.picsum.photos/id/449/500/500.jpg",
                           "https://i.picsum.photos/id/541/500/500.jpg",
                           "https://i.picsum.photos/id/623/500/500.jpg",
                           "https://i.picsum.photos/id/825/500/500.jpg",
                           "https://i.picsum.photos/id/424/500/500.jpg",
                           "https://i.picsum.photos/id/547/500/500.jpg"]
    
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

    func getRandomImageURL() -> URL? {
        let index = Int.random(in: 0...(randomImagesURL.count-1))
        return URL(string: randomImagesURL[index])
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
