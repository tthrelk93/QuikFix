//
//  JobPostTimeViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/25/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class JobPostTimeViewController: UIViewController {

    func timeFormatter(time: Date) -> String{
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.dateFormat = "HH:mm a"
        timeFormatter.timeStyle = .short
        
        let timeStamp = timeFormatter.string(from: time)
        return timeStamp
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        var startTime = timeFormatter(time: startTimePicker.date)
        var endTime = timeFormatter(time: endTimePicker.date)
        jobPost.time = "\(startTime) - \(endTime)"
        performSegue(withIdentifier: "JPStepThreeToStepFour", sender: self)
    }
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    var jobPost = JobPost()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JPStepThreeToStepFour"{
            if let vc = segue.destination as? Finalize{
                vc.jobPost = self.jobPost
            }
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
