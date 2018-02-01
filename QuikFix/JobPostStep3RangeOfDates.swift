//
//  ViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 1/22/18.
//  Copyright © 2018 Thomas Threlkeld. All rights reserved.
//

import UIKit
import CoreLocation

class JobPostStep3RangeOfDates: UIViewController {
    var jobPost = JobPost()
    var edit = Bool()
    var jobPostEdit = JobPost()
    var toolCount = Int()
    var jobCoord = CLLocation()
    
    @IBOutlet weak var numSelectedDatesLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    var datesArray = [String]()
    @IBAction func continuePressed(_ sender: Any) {
        if datesArray.count == 0{
            //alert
        } else {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        var dateStamp = dateFormatter.string(from: datePicker.date)
        
        jobPost.date = datesArray
        jobPostEdit.date? = [dateStamp]
        if edit == true{
            performSegue(withIdentifier: "EditDateToPostJob", sender: self)
        }
        performSegue(withIdentifier: "JPStepThreeDateToStepFour", sender: self)
        }
    }

    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func selectPressed(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var yearString = dateFormatter.string(from: Date())
        
        var tempDateString = "12-31-\(yearString)"
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        if datesArray.contains(dateFormatter.string(from: datePicker.date)){
            datesArray.remove(at: datesArray.index(of: dateFormatter.string(from: datePicker.date))!)
            selectButton.backgroundColor = qfGreen
            selectButton.setTitle("Select", for: .normal)
            if datesArray.count == 1{
                numSelectedDatesLabel.text = "1 Date Selected"
            } else if datesArray.count == 0{
                numSelectedDatesLabel.text = "0 Date Selected"
            } else {
                numSelectedDatesLabel.text = "\(datesArray.count) Dates Selected"
            }
        } else {
            datesArray.append(dateFormatter.string(from: datePicker.date))
            selectButton.backgroundColor = UIColor.red
            selectButton.setTitle("Remove", for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var yearString = dateFormatter.string(from: Date())
        
        var tempDateString = "12-31-\(yearString)"
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        var tempDate = dateFormatter.date(from: tempDateString)
        
        
        //timeAndDatePicker.maximumDate = tempDate
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        //components.year = -18
        //let minDate: NSDate = gregorian.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        //components.year = -0
        // let maxDate: NSDate = gregorian.date(byAdding: components as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate
        
        //self.datePicker.minimumDate = maxDate
        let todaysDate = Date()
        
        datePicker.minimumDate = todaysDate
        //timeAndDatePicker.maximumDate = //Calendar.current.date(byAdding: .year, value: -1, to: Date())
        //self.timeAndDatePicker.maximumDate = tempDate
        
        // Do any additional setup after loading the view.

        // Do any additional setup after loading the view.
        datePicker.addTarget(self, action: "isRolled", for: .valueChanged)
        
       
    }
    let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    func isRolled() {
        print("Date Picker has been rolled: \(datePicker.date)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var yearString = dateFormatter.string(from: Date())
        
        var tempDateString = "12-31-\(yearString)"
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        if datesArray.contains(dateFormatter.string(from: datePicker.date)){
            
            selectButton.backgroundColor = qfGreen
            selectButton.setTitle("Remove", for: .normal)
        } else {
            
            selectButton.backgroundColor = UIColor.red
            selectButton.setTitle("Select", for: .normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? JobPostTimeViewController{
            
            vc.jobPost = self.jobPost
        }
    }
    

}
