//
//  AddTweetViewModel.swift
//  CoreDataTwitter
//
//  Created by tokopedia on 24/02/20.
//  Copyright © 2020 SuryaKant Sharma. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


struct AddTweetViewModel: ViewModelType {
   
    var tweet: Tweet? = nil
    var user: User? = nil
    var isEditable: Bool {
        !(tweet == nil)
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let doneButtonTrigger: Observable<String>
    }
    
    struct Output {
        let title: Driver<String>
        let popScreen: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let title = input.viewDidLoadTrigger
            .map { return self.isEditable ? "Edit Tweet" : "New Tweet"
        }.asDriver(onErrorJustReturn: "")
        
        let popScreen = input
            .doneButtonTrigger
            .observeOn(MainScheduler.instance)
            .flatMap {  newText -> Driver<Void> in
                if self.isEditable {
                    self.editTweet(newText: newText)
                    return Observable.just(Void()).asDriver(onErrorJustReturn: ())
                }
                self.saveNewTweet(text: newText)
                return Observable.just(Void()).asDriver(onErrorJustReturn: ())
        }
        return Output.init(title: title, popScreen: popScreen.asDriver(onErrorJustReturn: ()))
    }
    
    func editTweet(newText: String) {
        tweet!.text = newText
        tweet!.managedObjectContext!.saveToDB()
    }
    
    func saveNewTweet(text: String) {
      let context = appDelegate.viewContext
      let tweet = Tweet(context: context)
      tweet.creationDate = Date() as NSDate
      tweet.text = text
      user!.addToTweets(tweet)
      user!.managedObjectContext!.saveToDB()
    }
}
