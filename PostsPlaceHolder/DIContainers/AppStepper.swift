//
//  AppStepper.swift
//  PostsPlaceHolder
//
//  Created by Jeans Ruiz on 2/7/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    
    // MARK: - Inyect services here
    
//    private let appServices: AppServices
//    private let disposeBag = DisposeBag()

//    init(withServices services: AppServices) {
//        self.appServices = services
//    }
    
    init() {
    }

    var initialStep: Step {
        return AppStep.postsAreRequired
    }

    /// callback used to emit steps once the FlowCoordinator is ready to listen to them to contribute to the Flow
//    func readyToEmitSteps() {
//        self.appServices
//            .preferencesService.rx
//            .isOnboarded
//            .map { $0 ? DemoStep.onboardingIsComplete : DemoStep.onboardingIsRequired }
//            .bind(to: self.steps)
//            .disposed(by: self.disposeBag)
//    }
}
