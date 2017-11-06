//
//  AddTweetViewController.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 05/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//

import UIKit

class AddTweetViewController: UIViewController {
    
    var user: User!
    var isEditable = false
    var tweet: Tweet? {
        didSet {
         isEditable = true
        }
    }
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        if let tweet = tweet {
           textView.text = tweet.text
        }
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        isEditable ? editTweet() : saveNewTweet()
        dismiss(animated: true, completion: nil)
    }
    func editTweet() {
        tweet?.text = textView.text
        tweet?.managedObjectContext?.saveToDB()
    }
    
    func saveNewTweet() {
      let context = AppDelegate.viewContext
      let tweet = Tweet(context: context)
      tweet.creationDate = Date() as NSDate
      tweet.text = textView.text
      //tweet.tweetUser = user
        /*
         can do in either way
         */
      user.addToTweets(tweet)
      user.managedObjectContext?.saveToDB()
        
    }
}
