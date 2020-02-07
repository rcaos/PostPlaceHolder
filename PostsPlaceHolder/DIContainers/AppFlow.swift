//
//  AppFlow.swift
//  PostsPlaceHolder
//
//  Created by Jeans Ruiz on 2/6/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AppFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    // RxFlow hace que TODOS los UIViewControllers sean presentables
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        //viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()

    // struct de AppDelegate
//    private let services: AppServices
//
//    init(services: AppServices) {
//        self.services = services
//    }
    
    init() {
    }

    deinit {
        print("\(type(of: self)): \(#function)")
    }

    // MARK: - Transforma un tipo Step en Navigation Actions!
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
            
        case .postsAreRequired:
            return navigateToPostListScreen()
            
        case .postIsPicked(let postId):
            return navigateToPostDetailScreen(with: postId)
            
        case .createPostAreRequired:
            return navigateToCreatePostScreen()
            //return self.dismissOnboarding()
          
        // es una Enum global , cuando tengas otras screens, acá descomento esto.
        // default:
        //      return .none
        }
    }

    private func navigateToPostListScreen() -> FlowContributors {

        let mainViewModel = MainViewModel()
        let viewController = MainViewController.create(with: mainViewModel)
        
        viewController.title = "List of Posts"
        self.rootViewController.pushViewController(viewController, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                                 withNextStepper: CompositeStepper(steppers: [viewController.viewModel, viewController]),
                                                 allowStepWhenNotPresented: true))
    }

    private func navigateToPostDetailScreen(with postId: Int) -> FlowContributors {
        let viewModel = DetailPostViewModel(identifier: postId)
        let viewController = DetailPostViewController.create(with: viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        
        // Significa que es un Nodo final, no emite más Steps.
        // El VC or VM Detail NO tiene porque implementar el protocol "Stepper"
        return .none
    }

    private func navigateToCreatePostScreen() -> FlowContributors {
        let viewModel = CreatePostViewModel()
        let viewController = CreatePostViewController.create(with: viewModel)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none    // Nodo final
    }
}
