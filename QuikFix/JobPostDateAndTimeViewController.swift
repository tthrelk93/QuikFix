//
//  JobPostDateAndTimeViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/9/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit



class JobPostDateAndTimeViewController: UIViewController {
    
    var jobPost = JobPost()
    
    @IBAction func continuePressed(_ sender: Any) {
        jobPost.date = String(describing: timeAndDatePicker.date)
        performSegue(withIdentifier: "JPStepTwoToStepThree", sender: self)
    }

    @IBOutlet weak var timeAndDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("jobPost: \(self.jobPost)")
        if segue.identifier == "JPStepTwoToStepThree"{
            if let vc = segue.destination as? JobPost_Payment{
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
