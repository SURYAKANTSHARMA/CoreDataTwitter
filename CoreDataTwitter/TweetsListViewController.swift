//
//  TweetsListViewController.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 05/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TweetsListViewController: UITableViewController {
    
    var user: User!
    var tweetListVM: TweetsListViewModel!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        tweetListVM = TweetsListViewModel(user: user)
        let input = TweetsListViewModel.Input(viewLoaded: Observable.just(Void()))
        let output = tweetListVM.transform(input: input)
        tableView.dataSource = nil
        
        output.tweets
        .asObservable()
        .bind(to: tableView.rx.items(cellIdentifier: "TweetTableViewCell", cellType: TweetTableViewCell.self)) {
                row, tweet, cell in
                cell.tweet = tweet
        }.disposed(by: bag)
        
        tableView
            .rx
            .itemAccessoryButtonTapped
        .asObservable()
            .subscribe { [weak self] event in
                guard let indexPath = event.element,let self = self else { return }
                let tweet = self.user.tweets!.allObjects[indexPath.row] as! Tweet
                guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewTweetNavigationVC") as? UINavigationController, let addNewTweetVC =  navigationVC.viewControllers.first as? AddTweetViewController else {
                    fatalError()
                }
                addNewTweetVC.user = self.user
                addNewTweetVC.tweet = tweet
                self.present(navigationVC, animated: true, completion: nil)
        }.disposed(by: bag)
        
        
        tableView
            .rx
        .itemDeleted
            .subscribe(onNext: { indexPath in
                // Delete the row from the data source
                let tweet = self.user.tweets!.allObjects[indexPath.row] as! Tweet
                // AppDelegate.viewContext.delete(tweet)
                self.user.removeFromTweets(tweet)
                // User's tweet get delete by deletion rule we set in core data editor.
                self.user.managedObjectContext?.saveToDB()
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }).disposed(by: bag)
    }
    
    @IBAction func addNewTweetPressed(_ sender: UIBarButtonItem) {
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewTweetNavigationVC") as? UINavigationController, let addNewTweetVC =  navigationVC.viewControllers.first as? AddTweetViewController else {
            fatalError()
        }
       
        addNewTweetVC.user = self.user
        self.present(navigationVC, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let cell = sender.superview?.superview as! TweetTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = user.tweets!.allObjects[indexPath!.row] as! Tweet
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewTweetNavigationVC") as? UINavigationController, let addNewTweetVC =  navigationVC.viewControllers.first as? AddTweetViewController else {
            fatalError()
        }
        
        addNewTweetVC.user = self.user
        addNewTweetVC.tweet = tweet
        self.present(navigationVC, animated: true, completion: nil)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
}
