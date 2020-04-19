//
//  LoginViewModel.swift
//  CoreDataTwitter
//
//  Created by tokopedia on 16/02/20.
//  Copyright © 2020 SuryaKant Sharma. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct LoginViewModel: ViewModelType {
    struct Input {
        // String contain user string
        let doneTrigger: Observable<String>
    }
    struct Output {
        // Give back user if exists
        let user: Driver<User>
        // Showing activity indicator for user
        let isLoading: BehaviorRelay<Bool>
    }
    
    public func transform(input: Input) -> Output {
        let isLoading = BehaviorRelay<Bool>(value: true)
        let userDriver = input.doneTrigger
            .map { typeName -> User in
                let user =  try! User.findOrCreateUser(typeName)
                isLoading.accept(false)
                return user
        }.asDriver(onErrorJustReturn: User.init())
        
        let output = Output(user: userDriver, isLoading: isLoading)
        return output
    }
}
