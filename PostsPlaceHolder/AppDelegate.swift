//
//  AppDelegate.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import UIKit
import RxSwift
import RxFlow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let disposeBag = DisposeBag()
    var coordinator = FlowCoordinator()     //RxFlow object
    
    lazy var appServices = {
        // MARK: - Inyect services here
        return AppServices()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Not necessary
        // Only for debug, statistics, A/B Testing,
        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
        
        let appFlow = AppFlow()
        
        Flows.whenReady(flow1: appFlow) { [weak self] root in
            self?.window?.rootViewController = root
            self?.window?.makeKeyAndVisible()
        }
        
        self.coordinator.coordinate(flow: appFlow, with: AppStepper())

        return true
    }
}

struct AppServices {
    // MARK: - Inyect services here
    
    //    let moviesService: MoviesService
    //    let preferencesService: PreferencesService
}
