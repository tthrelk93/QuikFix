//
//  JobPostTimeViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/25/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import CoreLocation

class JobPostTimeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    var edit = Bool()
    var jobPostEdit = JobPost()
    var toolCount = Int()
    var jobCoord = CLLocation()
    
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
       
            hourData = self.hourData
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM-dd-yyyy hh:mm a"
        //formatter.timeStyle = .short
        //formatter.dateStyle = .none
        let tempDate = formatter.string(from: date)
        
        
        print("actualDateTime: \(tempDate)")
        
        let jobTime = "\(hourData[hourPicker.selectedRow(inComponent: 0)]):\(minuteData[minutePicker.selectedRow(inComponent: 0)]) \(amPMData[amPMPicker.selectedRow(inComponent: 0)])"
        var tempString = String()
        if edit == true {
            tempString = "\(self.jobPostEdit.date!) \(hourData[hourPicker.selectedRow(inComponent: 0)]):\(minuteData[minutePicker.selectedRow(inComponent: 0)]) \(amPMData[amPMPicker.selectedRow(inComponent: 0)])"
        } else {
        tempString = "\(self.jobPost.date!) \(hourData[hourPicker.selectedRow(inComponent: 0)]):\(minuteData[minutePicker.selectedRow(inComponent: 0)]) \(amPMData[amPMPicker.selectedRow(inComponent: 0)])"
        }
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMMM-dd-yyyy h:mm a"
        //var startTime = timeFormatter(time: startTimePicker.date)
        //var endTime = timeFormatter(time: endTimePicker.date)
        let dateObj = dateFormatter2.date(from: tempString)
        let dateObj2 = formatter.date(from: tempDate)
        print("jobTime: \(String(describing: dateObj)), realTime: \(String(describing: dateObj2))")
        if (dateObj as! Date) <= (dateObj2 as! Date){
            let alert = UIAlertController(title: "Date has Passed", message: "Job start time must be atleast thirty minutes from right now.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            print("selectedTime: \(tempString)")
            jobPost.startTime = jobTime
            
            jobPostEdit.startTime = jobTime
            jobPostEdit.jobDuration = durString[durationPicker.selectedRow(inComponent: 0)]
            
            jobPost.jobDuration = durString[durationPicker.selectedRow(inComponent: 0)]
            print(durString[durationPicker.selectedRow(inComponent: 0)])
            if edit == true {
                performSegue(withIdentifier: "EditTimeToPostJob", sender: self)
            } else {
            
            if jobPost.category1 == "Moving(Home-To-Home)"{
                performSegue(withIdentifier: "SkipLocationSegue", sender: self)
            } else {
                performSegue(withIdentifier: "JPStep4ToStep5", sender: self)
            }
            }
        }
    }
    
    @IBOutlet weak var durationPicker: UIPickerView!
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == hourPicker {
            if row >= 4 {
                amPMPicker.selectRow(1, inComponent: 0, animated: true)
            amPMPicker.reloadAllComponents()
            } else {
                amPMPicker.selectRow(0, inComponent: 0, animated: true)
                amPMPicker.reloadAllComponents()
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == durationPicker{
            return durationData.count
        } else if pickerView == amPMPicker{
            return amPMData.count
        } else if pickerView == hourPicker{
            return hourData.count
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
            
                return hourData[row]
            
            
        } else {
            return minuteData[row]
        }
        
    }
    var hourData = ["8","9","10","11","12","1","2","3","4","5","6","7","8"]
   // var hourDataAM = ["8","9","10","11"]
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
        amPMPicker.isUserInteractionEnabled = false
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
            
        } else if segue.identifier == "EditTimeToPostJob" {
            if let vc = segue.destination as? ActualFinalizeViewController{
                vc.jobCoord = self.jobCoord
                vc.jobPost = self.jobPostEdit
                vc.timeDifference = Int(jobPostEdit.jobDuration!)!
                vc.toolCount = self.toolCount
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
