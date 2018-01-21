//
//  RateCellCollectionViewCell.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 1/1/18.
//  Copyright © 2018 Thomas Threlkeld. All rights reserved.
//

import UIKit

class RateCellCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    @IBOutlet weak var ratePic: UIImageView!
    
    @IBOutlet weak var rateTextView: UITextView!
    @IBOutlet weak var rateStars: CosmosView!
    @IBOutlet weak var rateName: UILabel!
    var rateDelegate: RateDelegate?
    var jobID = String()
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var submitRateButton: UIButton!
    
    @IBAction func submitRatePressed(_ sender: Any) {
        rateDelegate?.submitPressed(rating: rateStars.rating, feedback: self.rateTextView.text)
        
        
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == "Tap here to tell us any additional information about how this worker did (optional)"{
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView){
        if textView.text == "" || textView.hasText == false{
            textView.text = "Tap here to tell us any additional information about how this worker did (optional)"
            textView.textColor = UIColor.lightGray
        }
        textView.textColor = UIColor.lightGray
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        submitRateButton.layer.cornerRadius = 7
        rateTextView.delegate = self
        rateTextView.layer.borderColor = UIColor.lightGray.cgColor
        rateTextView.layer.borderWidth = 1
        
    }

}
