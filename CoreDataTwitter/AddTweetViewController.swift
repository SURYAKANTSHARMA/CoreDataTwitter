//
//  AddTweetViewController.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 05/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddTweetViewController: UIViewController {
    
    var user: User!
    @IBOutlet weak var textView: UITextView!
    var viewModel: AddTweetViewModel!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var isEditable = false
    var tweet: Tweet?
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddTweetViewModel(tweet: tweet, user: user)
        
        textView.becomeFirstResponder()
        if let tweet = tweet {
           textView.text = tweet.text
        }
        
        bindViewModel()
    }
    
    func bindViewModel() {
        let doneButtonObservable = doneButton.rx.tap.withLatestFrom(textView.rx.text).map { $0 ?? "" }
        let input = AddTweetViewModel.Input(viewDidLoadTrigger: Observable.just(Void()), doneButtonTrigger: doneButtonObservable)
        let output = viewModel.transform(input: input)
        output.popScreen.drive(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: bag)
        
        output.title.drive(onNext: { self.title = $0 }).disposed(by: bag)
    }
    
    
}
