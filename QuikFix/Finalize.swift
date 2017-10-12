//
//  Finalize.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/8/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class Finalize: UIViewController, UITextViewDelegate {
    
    @IBAction func locationEditPressed(_ sender: Any) {
    }
    @IBOutlet weak var locationEditButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    var jobPost = JobPost()
    
    @IBAction func editAdditinfoPressed(_ sender: Any) {
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var editAdditInfo: UIButton!
    @IBOutlet weak var editDatePressed: UIButton!
    @IBOutlet weak var editPayment: UIButton!
    
    @IBOutlet weak var editTimeButton: UIButton!
    
    @IBAction func editTimePressed(_ sender: Any) {
    }
    @IBAction func editPaymentPressed(_ sender: Any) {
    }
    @IBOutlet weak var editCat: UIButton!
    @IBAction func editCatPressed(_ sender: Any) {
    }
    @IBOutlet weak var editDate: UIButton!
    
     let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    

    @IBAction func finalizedPressed(_ sender: Any) {
        
        //***setting the labels if the additional info textview isnt empty or placeholder text
        if enterAdditInfoTextView.text != "Tap here to add any additional information about the job." && enterAdditInfoTextView.text != ""{
            jobPost.additInfo = enterAdditInfoTextView.text
            //let timeInterval = someDate.timeIntervalSince1970
            var timeString1 = jobPost.time!
            var timeString = [String]()
            ///var timeString1 = [String]()
            
            //let middle = timeString.index((timeString.startIndex), offsetBy: (timeString.characters.count)! / 2)
            
            var time1Hour = String()
            var time1Minutes = String()
            var time2Hour = String()
            var time2Minute = String()
            
            var time1Hour1 = [String]()
            var time1Minutes1 = [String]()
            var time2Hour1 = [String]()
            var time2Minute1 = [String]()
            
            
            var time1AMPM = String()
            var time2AMPM = String()
            for index in (timeString1.characters.indices){
                timeString.append(String(describing: timeString1[index]))
                
            
            
            }
            
            if timeString[1] == ":"{
                time2AMPM = "\(timeString[15])\(timeString[16])"
                time1AMPM = "\(timeString[5])\(timeString[6])"
                time1Hour = "0\(timeString[0])"
                time1Minutes = "\(timeString[2])\(timeString[3])"
                if timeString[11] == ":"{
                    time2Hour = "0\(timeString[10])"
                    time2Minute = "\(timeString[12])\(timeString[13])"
                } else {
                    time2Hour = "\(timeString[10])\(timeString[11])"
                    time2Minute = "\(timeString[13])\(timeString[14])"
                }
            } else {
                time2AMPM = "\(timeString[16])\(timeString[17])"
                time1AMPM = "\(timeString[6])\(timeString[7])"
                time1Hour = "\(timeString[0])\(timeString[1])"
                time1Minutes = "\(timeString[3])\(timeString[4])"
                if timeString[12] == ":"{
                    time2Hour = "0\(timeString[11])"
                    time2Minute = "\(timeString[3])\(timeString[4])"
                } else {
                    time2Hour = "\(timeString[11])\(timeString[12])"
                    time2Minute = "\(timeString[14])\(timeString[15])"
                }
            }
            for index in (time1Hour.characters.indices){
                time1Hour1.append(String(time1Hour[index]))
            }
            for index in (time2Hour.characters.indices){
                time2Hour1.append(String(time2Hour[index]))
                
                
                
            }
            for index in (time1Minutes.characters.indices){
                time1Minutes1.append(String(time1Minutes[index]))
                
                
                
            }
            for index in (time2Minute.characters.indices){
                time2Minute1.append(String(time2Minute[index]))
                
                
                
            }



        var startDate = String()
        
        var endDate = String()
        if time1AMPM == "PM"{
    
                startDate = "\(Int(String(time1Hour1[0]))! + 1)\(Int(String(time1Hour1[1]))! + 2):\(time1Minutes1[0])\(time1Minutes1[1])"
            
        } else {
            startDate = "\(time1Hour):\(time1Minutes)"
        }
        
        if time2AMPM == "PM"{
            
                endDate = "\(Int(String(time2Hour1[0]))! + 1)\(Int(String(time2Hour1[1]))! + 2):\(time2Minute1[0])\(time2Minute1[1])"
            
        } else {
            endDate = "\(time2Hour):\(time2Minute)"
        }
        
            
        let startArray = startDate.components(separatedBy: ":") // ["23", "51"]
            let endArray = endDate.components(separatedBy: ":") // ["00", "01"]
            print("start: \(startArray)")
            print("end: \(endArray)")
        
        let startHours = Int(startArray[0])! * 60 // 1380
        let startMinutes = Int(startArray[1])! + startHours // 1431
        
        let endHours = Int(endArray[0])! * 60 // 0
        let endMinutes = Int(endArray[1])! + endHours // 1
        
        var timeDifference = endMinutes - startMinutes // -1430
        
        let day = 24 * 60 // 1440
        
        if timeDifference < 0 {
            timeDifference += day // 10
        }
            print("td\(timeDifference)")
        
        var calcRate = ((25 * (timeDifference / 60)) * (jobPost.workerCount as! Int))
        
        

        
        
        
        
            rateLabel.text = "$\(calcRate)($25/hr * \(self.jobPost.workerCount!) worker(s))"
            categoryLabel.text = ("\(jobPost.category1!)/\(jobPost.category2!)")
            //convertTimeFormater(date: jobPost.time!)
            timeLabel.text = jobPost.time
            additInfoTextView.text = enterAdditInfoTextView.text
            locationLabel.text = jobPost.location
            
            
            //***converting date back from string into Date()
           /* let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm:ss +zzzz"
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            let dateObj = dateFormatter.date(from: jobPost.date!)
            dateFormatter.dateFormat = "MM-dd-yyyy"*/
            dateLabel.text = jobPost.date//dateFormatter.string(from: dateObj!)
            
            blockView.isHidden = false
        }
        
    }
    @IBOutlet weak var enterAdditInfoTextView: UITextView!
    @IBAction func editPressed(_ sender: Any) {
        if editCat.isHidden == true{
            editCat.isHidden = false
            editDate.isHidden = false
            editPayment.isHidden = false
            editAdditInfo.isHidden = false
            editTimeButton.isHidden = false
            locationEditButton.isHidden = false
        } else {
            editCat.isHidden = true
            editDate.isHidden = true
            editPayment.isHidden = true
            editAdditInfo.isHidden = true
            editTimeButton.isHidden = true
            locationEditButton.isHidden = true
        }
    }
    var listingsArray = [String]()
    
    
    
    var segueJobData = [String:Any]()
    var seguePosterData = [String:Any]()
    var jobRef = String()
    @IBAction func postPressed(_ sender: Any) {
        var values = [String:Any]()
        var ref = Database.database().reference().child("jobs").childByAutoId()
        values["posterName"] = self.posterName
        values["posterID"] = Auth.auth().currentUser?.uid

        values["category1"] = jobPost.category1
        values["category2"] = jobPost.category2
        //var formattedDate = convertDateFormater(date: jobPost.date!)
        values["location"] = jobPost.location
        values["date"] = jobPost.date
        values["additInfo"] = jobPost.additInfo
        values["payment"] = "$25 / hour"
        values["time"] = jobPost.time
        values["workerCount"] = jobPost.workerCount
        values["acceptedCount"] = 0
        //values["paymentType"] = jobPost.paymentType
        values["jobID"] = ref.key
        
        self.segueJobData = values
        self.jobRef = ref.key
        //ref.updateChildValues(values)
        var values2 = [String: Any]()
        //values2["currentListings"]
        
        Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            var tempBool = false
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "currentListings"{
                        tempBool = true
                        for val in snap.value as! [String]{
                            self.listingsArray.append(val)
                        }
                    }
                }
                if tempBool == false{
                    
                }
                self.listingsArray.append(ref.key)
            
            var tempDict = [String:Any]()
            tempDict["currentListings"] = self.listingsArray
            self.seguePosterData = tempDict
           // Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(tempDict)
                self.performSegue(withIdentifier: "FinalizeToFindWorkers", sender: self)
            }
            
        })

        
        
    }
    @IBOutlet weak var additInfoTextView: UITextView!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var finalizeView: UIView!
    var posterName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        enterAdditInfoTextView.delegate = self
        enterAdditInfoTextView.textColor = qfGreen
        /*if jobPost.paymentType == 1{
            paymentTypeLabel.text = "Rate:"
        } else {
            paymentTypeLabel.text = "Payment:"
        }*/
        Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for snap in snapshots {
                if snap.key as! String == "name"{
                    self.posterName = snap.value as! String
                    break
                }
            }
        })
        //jobPost.category = "Babysitting"
        
        
       // jobPost?.date = "10/02/2017 8:00pm"
        //jobPost.payment = "$10.00/hr"
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        if textView.text == "Tap here to add any additional information about the job."{
            textView.text = ""
            
            
        }
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.textColor = qfGreen
        if textView.text == ""{
            textView.text == "Tap here to add any additional information about the job."
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    
    //func textView
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("jsegPostData: \(self.seguePosterData)")
        let vc = segue.destination as? FindAvailableWorkersViewController
        vc?.jobUploadData = self.segueJobData
        vc?.posterUploadData = self.seguePosterData
        vc?.jobRef = self.jobRef
    }
    
        
        
        /*let destinationNavigationController = segue.destination as! UINavigationController
        let targetController = destinationNavigationController.topViewController as! JobPosterProfileViewController
        
        
        
            //print("heyyyyyy")
            targetController.showJobPostedView = true
 
 
            
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    

}
