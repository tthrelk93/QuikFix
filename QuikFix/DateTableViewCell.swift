//
//  DateTableViewCell.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/19/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var jobsCollect: UICollectionView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
