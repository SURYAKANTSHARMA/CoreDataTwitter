//
//  TweetsListViewModel.swift
//  CoreDataTwitter
//
//  Created by tokopedia on 24/02/20.
//  Copyright © 2020 SuryaKant Sharma. All rights reserved.
//

import RxSwift
import RxCocoa

struct TweetsListViewModel: ViewModelType {
    let loginUser: User
    
    init(user: User) {
       loginUser = user
    }
    
    struct Input {
        let viewLoaded: Observable<Void>
    }
    
    struct Output {
        let tweets: Driver<[Tweet]>
    }
    
    func transform(input: TweetsListViewModel.Input) -> TweetsListViewModel.Output {
        let output = input
            .viewLoaded
            .map { _ -> [Tweet] in
                let tweetSet = self.loginUser.tweets
                let _array: [Tweet] = tweetSet?.allObjects.compactMap{ $0 as? Tweet } ?? []
                return _array
        }.asDriver(onErrorJustReturn: [])
        
        return Output(tweets: output)
    }
}
