//
//  ViewController.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 04/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    var user: User?
    let disposebag =  DisposeBag()
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tappedObservable = doneButton.rx.controlEvent(.touchUpInside).asObservable().withLatestFrom(userNameTextField.rx.text.asObservable()) { (_, text)  in
            return text
        }.compactMap{ $0 }
        let input = LoginViewModel.Input(doneTrigger: tappedObservable)
        let output = LoginViewModel().transform(input: input)
        
        output.isLoading.asDriver().drive(onNext: { isLoading in
             UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }).disposed(by: disposebag)
        output.user.drive(onNext: { user in
            //push listVC
                       if let tweetsListVC = self.storyboard?.instantiateViewController(withIdentifier: "TweetsListViewController") as? TweetsListViewController {
                       tweetsListVC.user = user
                       self.navigationController?.pushViewController(tweetsListVC, animated: true)
            }
            }).disposed(by: disposebag)
    }

}

