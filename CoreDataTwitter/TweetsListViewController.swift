//
//  TweetsListViewController.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 05/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//

import UIKit

class TweetsListViewController: UITableViewController {
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
    
    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
        
        
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.tweets?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as? TweetTableViewCell else {
            fatalError("cell cann't instanciated.")
        }
        cell.tweet = user.tweets!.allObjects[indexPath.row] as? Tweet
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let tweet = user.tweets!.allObjects[indexPath.row] as! Tweet
            //AppDelegate.viewContext.delete(tweet)
            user.removeFromTweets(tweet)
            // User's tweet get delete by deletion rule we set in core data editor.
            user.managedObjectContext?.saveToDB()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let tweet = user.tweets!.allObjects[indexPath.row] as! Tweet
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewTweetNavigationVC") as? UINavigationController, let addNewTweetVC =  navigationVC.viewControllers.first as? AddTweetViewController else {
            fatalError()
        }
        
        addNewTweetVC.user = self.user
        addNewTweetVC.tweet = tweet
        self.present(navigationVC, animated: true, completion: nil)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


}
