//
//  JobPostTimeViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/25/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class JobPostTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var amPMPicker: UIPickerView!
    @IBOutlet weak var minutePicker: UIPickerView!
    @IBOutlet weak var hourPicker: UIPickerView!
    func timeFormatter(time: Date) -> String{
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.dateFormat = "HH:mm a"
        timeFormatter.timeStyle = .short
        
        let timeStamp = timeFormatter.string(from: time)
        return timeStamp
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        var hourData = [String]()
        if amPMPicker.selectedRow(inComponent: 0) == 0{
            hourData = hourDataAM
        } else {
            hourData = hourDataPM
        }
        var tempString = "\(hourData[hourPicker.selectedRow(inComponent: 0)]): \(minuteData[minutePicker.selectedRow(inComponent: 0)]) \(amPMData[amPMPicker.selectedRow(inComponent: 0)])"
        //var startTime = timeFormatter(time: startTimePicker.date)
        //var endTime = timeFormatter(time: endTimePicker.date)
        print("tmepString: \(tempString)")
        jobPost.startTime = tempString
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == amPMPicker{
            hourPicker.reloadAllComponents()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == durationPicker{
            return durationData.count
        } else if pickerView == amPMPicker{
            return amPMData.count
        } else if pickerView == hourPicker{
            if amPMPicker.selectedRow(inComponent: 0) == 0 {
                    return hourDataAM.count
            } else {
                return hourDataPM.count
            }
        } else {
            return minuteData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == durationPicker{
            return durationData[row]
        } else if pickerView == amPMPicker{
            return amPMData[row]
        } else if pickerView == hourPicker{
            if amPMPicker.selectedRow(inComponent: 0) == 0 {
                return hourDataAM[row]
            } else {
                return hourDataPM[row]
            }
        } else {
            return minuteData[row]
        }
        
    }
    var hourDataPM = ["12","1","2","3","4","5", "6"]
    var hourDataAM = ["8","9","10","11"]
    var minuteData = ["00","15","30","45"]
    var amPMData = ["AM", "PM"]
    
    var durString = ["1", "2", "3", "4", "5"]
    var durationData = ["1 hour", "2 hours", "3 hours", "4 hours", "5 hours"]

    
    
    //@IBOutlet weak var endTimePicker: UIDatePicker!
   // @IBOutlet weak var startTimePicker: UIDatePicker!
    var jobPost = JobPost()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amPMPicker.delegate = self
        amPMPicker.dataSource = self
        hourPicker.delegate = self
        hourPicker.dataSource = self
        minutePicker.delegate = self
        minutePicker.dataSource = self
        
        durationPicker.delegate = self
        durationPicker.dataSource = self
        durationPicker.layer.cornerRadius = 7
        //startTimePicker.layer.cornerRadius = 7
        

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
