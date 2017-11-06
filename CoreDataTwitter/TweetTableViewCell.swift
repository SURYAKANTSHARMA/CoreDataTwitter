//
//  TweetTableViewCell.swift
//  CoreDataTwitter
//
//  Created by SuryaKant Sharma on 05/11/17.
//  Copyright © 2017 SuryaKant Sharma. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    var tweet: Tweet? {
        didSet {
          tweetTextLabel.text = tweet?.text
            timeLabel.text = (tweet?.creationDate as Date?)?.convertToDisplayFormat()
        }
    }
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
}

extension Date {
    func convertToDisplayFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
    
}
