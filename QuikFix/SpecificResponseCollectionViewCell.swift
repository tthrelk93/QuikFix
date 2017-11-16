//
//  SpecificResponseCollectionViewCell.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/4/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit


protocol AcceptDeclineDelegate {
    func accept(studentID: String)
    func decline(studentID: String)
    func viewProf(studentID: String)
    
}


class SpecificResponseCollectionViewCell: UICollectionViewCell {
    
    var delegate: AcceptDeclineDelegate?
    var studentID = String()
    @IBAction func profileButtonSelected(_ sender: Any) {
        //perform segue using delegate
       delegate?.viewProf(studentID: self.studentID)
        
    }
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var jobCountLabel: UILabel!
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
         delegate?.accept(studentID: self.studentID)
        
    }
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    @IBAction func declineButtonPressed(_ sender: Any) {
        delegate?.decline(studentID: self.studentID)
        
    }
    
}
