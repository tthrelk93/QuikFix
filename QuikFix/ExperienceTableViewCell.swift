//
//  ExperienceTableViewCell.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/29/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

protocol RemoveDelegate {
    func performRemoveCell(cell: ExperienceTableViewCell)
    
}


class ExperienceTableViewCell: UITableViewCell {
    var removeDelegate: RemoveDelegate?

    @IBOutlet weak var expLabel: UILabel!
    
    @IBAction func removeCellButtonPressed(_ sender: Any) {
    }
    @IBOutlet weak var removeCellButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
