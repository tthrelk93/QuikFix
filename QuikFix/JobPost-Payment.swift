//
//  JobPost-Payment.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/8/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class JobPost_Payment: UIViewController {

    
    var jobPost = JobPost()
    @IBOutlet weak var perHourLabel: UILabel!
    @IBOutlet weak var textFieldHolder: UIView!
    @IBOutlet weak var hourlyRateTextField: UITextField!
    @IBOutlet weak var flatPriceTextField: UITextField!
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if flatPriceButton.backgroundColor == qfGreen {
            if flatPriceTextField.text == "0.00" || flatPriceTextField.hasText == false {
                //show error that info is missing
            } else {
                //jobPost.paymentType = 0
                jobPost.payment = flatPriceTextField.text
                performSegue(withIdentifier: "JPStepThreeToStepFour", sender: self)
                //perform segue
            }
            
        } else if hourlyRateButton.backgroundColor == qfGreen {
            if hourlyRateTextField.text == "0.00" || hourlyRateTextField.hasText == false {
                //show error that missing info
            } else {
                //jobPost.paymentType = 1
                jobPost.payment = hourlyRateTextField.text
                performSegue(withIdentifier: "JPStepThreeToStepFour", sender: self)
            }
            
        } else {
            //show error that user needs to select payment type
        }
    }
    
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBAction func hourlyRatePressed(_ sender: Any) {
        flatPriceButton.setTitleColor(qfGreen, for: .normal)
        flatPriceButton.backgroundColor = UIColor.white
        hourlyRateButton.setTitleColor(UIColor.white, for: .normal)
        hourlyRateButton.backgroundColor = qfGreen
        
        paymentTypeLabel.text = "Select hourly rate"
        flatPriceTextField.isHidden = true
        hourlyRateTextField.isHidden = false
        perHourLabel.isHidden = false
        textFieldHolder.isHidden = false
        
        
    }
    
    @IBOutlet weak var hourlyRateButton: UIButton!
    @IBAction func flatPricePressed(_ sender: Any) {
        hourlyRateButton.setTitleColor(qfGreen, for: .normal)
        hourlyRateButton.backgroundColor = UIColor.white
        flatPriceButton.setTitleColor(UIColor.white, for: .normal)
        flatPriceButton.backgroundColor = qfGreen
        
        paymentTypeLabel.text = "Select flat price"
        flatPriceTextField.isHidden = false
        hourlyRateTextField.isHidden = true
        perHourLabel.isHidden = true
        textFieldHolder.isHidden = false
    }
    
    //quikfix green color
    let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    
    @IBOutlet weak var flatPriceButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldHolder.layer.cornerRadius = 10
        
        flatPriceButton.layer.cornerRadius = 10
        flatPriceButton.layer.borderWidth = 2
        flatPriceButton.layer.borderColor = qfGreen.cgColor
        
        hourlyRateButton.layer.cornerRadius = 10
        hourlyRateButton.layer.borderWidth = 2
        hourlyRateButton.layer.borderColor = qfGreen.cgColor

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JPStepThreeToStepFour"{
            if let vc = segue.destination as? Finalize{
                vc.jobPost = self.jobPost
            }
            
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
