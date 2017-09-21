//
//  DateCollectionViewCell.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/19/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var posterDist: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBAction func selectButtonPressed(_ sender: Any) {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
