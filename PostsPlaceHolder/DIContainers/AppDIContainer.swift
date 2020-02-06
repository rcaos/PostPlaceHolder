//
//  AppDIContainer.swift
//  PostsPlaceHolder
//
//  Created by Jeans Ruiz on 2/6/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import Foundation

final class AppDIContainer {
    
}

extension AppDIContainer {
    
    // MARK : - DIContainer Main Scene
    
    func makeMainSceneDIContainer() -> MainSceneDIContainer {
        return MainSceneDIContainer()
    }
}
