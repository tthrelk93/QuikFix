//
//  DateCollectionViewCell.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/22/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

protocol PerformSegueInTableViewCell {
    func performSegueInTableView(category: String, jobID: String, job: JobPost)
    
}


class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterName: UILabel!
   
    @IBOutlet weak var distLabel: UILabel!
   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    var category = String()
    var jobID = String()
    var job = JobPost()
    
    @IBAction func selectCellButtonPressed(_ sender: Any) {
        delegate.performSegueInTableView(category: self.category, jobID: self.jobID, job: self.job)
        
    }
    @IBOutlet weak var selectCellButton: UIButton!
    @IBOutlet weak var additInfoLabel: UILabel!
    
    var delegate: PerformSegueInTableViewCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
   
}
