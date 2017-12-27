//
//  StudentOrPosterViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 11/7/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class StudentOrPosterViewController: UIViewController {

    var accountType = String()
    @IBAction func iAmStudentPressed(_ sender: Any) {
        self.accountType = "homeOwner"
        performSegue(withIdentifier: "StudentOrPosterToImageSelect", sender: self)
    }
    
    @IBOutlet weak var labelView: UIView!
    @IBAction func
        iAmHomeOwnerPressed(_ sender: Any) {
        self.accountType = "student"
         performSegue(withIdentifier: "StudentOrPosterToImageSelect", sender: self)
    }
    
    @IBOutlet weak var orLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //orLabel.baselineAdjustment = .alignCenters//kCAAlignmentCenter
        labelView.layer.cornerRadius = 7//orLabel.frame.width/2
        self.view.bringSubview(toFront: labelView)
        self.view.bringSubview(toFront: orLabel)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateAccountMainViewController{
            print(self.accountType)
        vc.accountType = self.accountType
            vc.sender = "step2"
            
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
