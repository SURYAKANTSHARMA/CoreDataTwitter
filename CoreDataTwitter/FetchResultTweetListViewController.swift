//
//  FetchResultTweetListViewController.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 26/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//

import UIKit
import CoreData

class FetchResultTweetListViewController: TweetsListViewController {
  
    let context = appDelegate.viewContext
    lazy var fetchResultController: NSFetchedResultsController<Tweet> = {
        let fetchRequest: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "tweetUser.name == %@", user.name!)
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
         try fetchResultController.performFetch()
        } catch {
           fatalError(error.localizedDescription)
        }
    }
}



extension FetchResultTweetListViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.fetchedObjects?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell", for: indexPath) as? TweetTableViewCell else {
            fatalError("cell cann't instanciated.")
        }
        cell.tweet = fetchResultController.fetchedObjects![indexPath.row]
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
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let tweet = fetchResultController.fetchedObjects![indexPath.row]
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewTweetNavigationVC") as? UINavigationController, let addNewTweetVC =  navigationVC.viewControllers.first as? AddTweetViewController else {
            fatalError()
        }
        addNewTweetVC.user = self.user
        addNewTweetVC.tweet = tweet
        self.present(navigationVC, animated: true, completion: nil)
    }

}

extension FetchResultTweetListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                configureCell(cell, indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    func configureCell(_ cell: UITableViewCell,_ indexPath: IndexPath) {
        guard let cell = cell as? TweetTableViewCell else {
            fatalError("cell is Not TweetTableCell.")
        }
        cell.tweet = fetchResultController.fetchedObjects![indexPath.row]
    }
}
