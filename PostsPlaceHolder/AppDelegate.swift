//
//  AppDelegate.swift
//  PostsPlaceHolder
//
//  Created by Jeans Carlos Ruiz Calle on 2/4/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let appDIContainer = AppDIContainer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController = appDIContainer.makeMainSceneDIContainer().makeMainViewController()
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)

        window?.makeKeyAndVisible()
        
        return true
    }
}
