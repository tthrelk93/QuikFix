//
//  JobPostTimeViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/25/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class JobPostTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
        //var endTime = timeFormatter(time: endTimePicker.date)
        jobPost.startTime = "\(startTime)"
        jobPost.jobDuration = durString[durationPicker.selectedRow(inComponent: 0)]
        print(durString[durationPicker.selectedRow(inComponent: 0)])
        
        if jobPost.category1 == "Moving(Home-To-Home)"{
            performSegue(withIdentifier: "SkipLocationSegue", sender: self)
        } else {
            performSegue(withIdentifier: "JPStep4ToStep5", sender: self)
        }
    }
    
    @IBOutlet weak var durationPicker: UIPickerView!
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return durationData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return durationData[row]
        
    }
    var durString = ["1", "2", "3", "4", "5"]
    var durationData = ["1 hour", "2 hours", "3 hours", "4 hours", "5 hours"]

    
    
    //@IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    var jobPost = JobPost()
    override func viewDidLoad() {
        super.viewDidLoad()
        durationPicker.delegate = self
        durationPicker.dataSource = self
        durationPicker.layer.cornerRadius = 7
        startTimePicker.layer.cornerRadius = 7
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JPStep4ToStep5"{
            if let vc = segue.destination as? JobPostLocationPickerViewController{
                vc.jobPost = self.jobPost
            }
            
        } else {
            if let vc = segue.destination as? Finalize{
                vc.jobPost = self.jobPost
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
