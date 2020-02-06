//
//  MainSceneDIContainer.swift
//  PostsPlaceHolder
//
//  Created by Jeans Ruiz on 2/6/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import UIKit

final class MainSceneDIContainer {
    
    init() {
        // Dependencies Here, Use cases, Persistence, Networking, etc
    }
    
    public func makeMainViewController() -> UIViewController {
        return MainViewController.create( with: makeMainViewModel(),
                                          mainViewControllersFactory: self)
    }
    
    func makePostDetailViewController(identifier: Int) -> UIViewController {
        return DetailPostViewController.create(with: makeDetailViewModel(identifier: identifier))
    }
    
    func makeCreateViewController() -> UIViewController {
        return CreatePostViewController.create(with: makeCreateViewModel())
    }
}

// MARK: - Private

extension MainSceneDIContainer {
    
    // MARK: - View Models
    
    private func makeMainViewModel() -> MainViewModel {
        return MainViewModel()
    }
    
    private func makeDetailViewModel(identifier: Int) -> DetailPostViewModel {
        return DetailPostViewModel(identifier: identifier)
    }
    
    private func makeCreateViewModel() -> CreatePostViewModel {
        return CreatePostViewModel()
    }
}

// MARK: - MainViewControllersFactory

extension MainSceneDIContainer: MainViewControllersFactory {
    
}
