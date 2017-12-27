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
import CoreLocation

class Finalize: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var promoView: UIView!
    var jobPost = JobPost()
    var timeDifference = Int()
    
    @IBOutlet weak var finalizeButton: UIButton!
    
     let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    

    @IBAction func finalizedPressed(_ sender: Any) {
        finalizeButton.isHidden = true
        //***setting the labels if the additional info textview isnt empty or placeholder text
        if enterAdditInfoTextView.text != ""{
            if enterAdditInfoTextView.text == "Tap here to add any additional information about the job. (optional)"{
                jobPost.additInfo = ""
            } else {
            jobPost.additInfo = enterAdditInfoTextView.text
            }
            var calcRate = ((25 * (Int(jobPost.jobDuration!)!)) * (jobPost.workerCount as! Int))
            if jobPost.category1 == "Moving(Home-To-Home)"{
                calcRate = calcRate + 10
                
            }
            if jobPost.tools?.count != 0 && jobPost.tools?.count != nil {
                calcRate = calcRate + 5
                self.toolCount = (jobPost.tools?.count)!
            } else {
                self.toolCount = 0
            }
            self.jobPost.payment = String(describing:calcRate)
            
            
            
            
            performSegue(withIdentifier:"AdditDetailsToFinalize" , sender: self)
            //let timeInterval = someDate.timeIntervalSince1970
           /* var timeString1 = jobPost.time!
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
            if time1Hour == "12"{
                startDate = "12:\(time1Minutes1[0])\(time1Minutes1[1])"
            } else {
    
                startDate = "\(Int(String(time1Hour1[0]))! + 1)\(Int(String(time1Hour1[1]))! + 2):\(time1Minutes1[0])\(time1Minutes1[1])"
            }
            
        } else {
            startDate = "\(time1Hour):\(time1Minutes)"
        }
        
        if time2AMPM == "PM"{
            if time2Hour == "12"{
                startDate = "12:\(time2Minute1[0])\(time2Minute1[1])"
            } else {
                endDate = "\(Int(String(time2Hour1[0]))! + 1)\(Int(String(time2Hour1[1]))! + 2):\(time2Minute1[0])\(time2Minute1[1])"
            }
            
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
            
            print("startHours: \(startHours)")
            print("startMin: \(startMinutes)")
            print("endHours: \(endHours)")
            print("endMin: \(endMinutes)")
        
        self.timeDifference = endMinutes - startMinutes // -1430
        
        let day = 24 * 60 // 1440
        
        if timeDifference < 0 {
            timeDifference += day // 10
        }
            print("td\(timeDifference)")
            if timeDifference < 60{
                timeDifference = 60
            }*/
            /*var durationInt = Int()
            if jobPost.jobDuration?.characters.count == 2{
                durationInt = 5
            } else {
                durationInt = Int(jobPost.jobDuration!)!
            }*/
            //promoView.isHidden = false
 
        
        
            //blockView.isHidden = false
        }
        
    }
    //@IBOutlet weak var promoField: UITextField!
    var toolCount = Int()
    @IBOutlet weak var enterAdditInfoTextView: UITextView!
    var listingsArray = [String]()
    var promoSuccess = Bool()
    var promoSender = String()
    var promoSenderArray = [String]()
    var invalidCodeBool = true
    
    /*@IBAction func applyPromoPressed(_ sender: Any) {
        Database.database().reference().child("jobPosters").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if let tempDict = snap.value as? [String:Any]{
                        var promo = (tempDict["promoCode"] as! [String:Any])
                        for (key, val) in promo{
                            if key as! String == self.promoField.text{
                                self.invalidCodeBool = false
                                if (val as! [String]).contains((Auth.auth().currentUser?.uid)!){
                                    //show error
                                    let alert = UIAlertController(title: "Promo Error", message: "You have already redeemed this promo code.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.promoSuccess = false
                                } else {
                                    var calcRate = (((25 * (Int(self.jobPost.jobDuration!)!)) * (self.jobPost.workerCount as! Int)) - 5)
                                    self.promoSenderArray = val as! [String]
                                    self.promoSuccess = true
                                    self.promoCode = self.promoField.text!
                                    self.promoSender = snap.key as! String
                                    print("ps1: \(self.promoSender)")
                                    self.creditCount = tempDict["availableCredits"] as! Int
                                    if self.jobPost.category1 == "Moving(Home-To-Home)"{
                                        calcRate = calcRate + 10
                                        
                                    }
                                    if self.jobPost.tools?.count != 0 && self.jobPost.tools?.count != nil {
                                        calcRate = calcRate + 5
                                        self.toolCount = (self.jobPost.tools?.count)!
                                    } else {
                                        self.toolCount = 0
                                    }
                                    self.jobPost.payment = String(describing:calcRate)
                                    self.performSegue(withIdentifier:"AdditDetailsToFinalize" , sender: self)
                                    
                                }
                            }
                        }
                        if self.invalidCodeBool == true{
                            let alert = UIAlertController(title: "Promo Error", message: "Invalid Promo Code", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        
        })
    }*/
    var creditCount = Int()
    var promoCode = String()
    @IBAction func skipPressed(_ sender: Any) {
        var calcRate = ((25 * (Int(jobPost.jobDuration!)!)) * (jobPost.workerCount as! Int))
        if jobPost.category1 == "Moving(Home-To-Home)"{
            calcRate = calcRate + 10
            
        }
        if jobPost.tools?.count != 0 && jobPost.tools?.count != nil {
            calcRate = calcRate + 5
            self.toolCount = (jobPost.tools?.count)!
        } else {
            self.toolCount = 0
        }
        self.jobPost.payment = String(describing:calcRate)
        
        
        
        
        performSegue(withIdentifier:"AdditDetailsToFinalize" , sender: self)
        
    }
    
    var segueJobData = [String:Any]()
    var seguePosterData = [String:Any]()
    var jobRef = String()
    var placeCoord = CLLocation()
    
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
        //promoField.delegate = self
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
                if snap.key == "name"{
                    self.posterName = snap.value as! String
                    self.jobPost.posterName = snap.value as? String
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textField.placeholder = "Type Promo Code or Press Skip"
            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = UIColor.black
        if textView.text == "Tap here to add any additional information about the job. (optional)"{
            textView.text = ""
            
            
        }
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.textColor = qfGreen
        if textView.text == "" || textView.text == nil{
            textView.text = "Tap here to add any additional information about the job. (optional)"
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
        if let vc = segue.destination as? ActualFinalizeViewController{
           vc.jobCoord = self.placeCoord
            vc.jobPost = self.jobPost
            vc.timeDifference = Int(jobPost.jobDuration!)!
            vc.toolCount = self.toolCount
            //vc.promoSuccess = self.promoSuccess
            //vc.promoSender = self.promoSender
            //vc.promoSenderArray = self.promoSenderArray
            //vc.promoCode = self.promoCode
            //vc.creditCount = self.creditCount
            
            
            
        }
    }
    
        
        
        /*let destinationNavigationController = segue.destination as! UINavigationController
        let targetController = destinationNavigationController.topViewController as! JobPosterProfileViewController
        
        
        
            //print("heyyyyyy")
            targetController.showJobPostedView = true
 
 
            
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    

}
