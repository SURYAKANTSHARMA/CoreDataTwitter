//
//  ViewController.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 04/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let name = userNameTextField.text, !name.isEmpty else {
            return
        }
        User.userExistInDataBase(name) { (user) in
            self.user = user ?? createNewUser()
            //push listVC
            let tweetsListVC = self.storyboard?.instantiateViewController(withIdentifier: "TweetsListViewController") as! TweetsListViewController
            tweetsListVC.user = user
            self.navigationController?.pushViewController(tweetsListVC, animated: true)
            
        }
     }
    
    func createNewUser() -> User {
        let viewContext = AppDelegate.viewContext
        let user = User(context: viewContext)
        user.name = userNameTextField.text
        AppDelegate.saveContext()
        return user
    }
    
    
}

