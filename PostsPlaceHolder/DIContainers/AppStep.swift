//
//  AppStep.swift
//  PostsPlaceHolder
//
//  Created by Jeans Ruiz on 2/6/20.
//  Copyright © 2020 Jeans Carlos Ruiz Calle. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    
    case postsAreRequired
    case postIsPicked(withId: Int)
    
    case createPostAreRequired
}
