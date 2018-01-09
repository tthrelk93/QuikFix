//
//  CreateStudentAccountFinalViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/31/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

/*
 
 

 
 */

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
//import DropDown
import CoreLocation
import MapKit
import SwiftOverlays




class CreateStudentAccountFinalViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
       
        if experience.contains(expData[curIndex]) == false {
            experience.append(expData[curIndex])
            addButton.setTitle("Remove", for: .normal)
            addButton.backgroundColor = UIColor.red
        } else {
            experience.remove(at: experience.index(of: expData[ curIndex])!)
            addButton.setTitle("Add", for: .normal)
            addButton.backgroundColor = qfGreen
        }
        var tempString = ""
        for str in experience {
            if str == experience.last{
                tempString = tempString + str
                
            } else {
                tempString = tempString + str + ", "
            }
            
        }
        relevantExperienceDropDownTF.text = tempString
        

    }
    
    @IBOutlet weak var addButton: UIButton!
    var profPic = UIImage()
    var student = Student()
    var experience = [String]()
    var crypt = String()
    var promoData = [String:Any]()
    var promoSuccess = Bool()
    var promoSenderID = String()
    var promoType = String()
    
    @IBOutlet weak var step3Picker: UIPickerView!
    var locationManager = CLLocationManager()
    @IBAction func createAccountPressed(_ sender: Any) {
        if relevantExperienceDropDownTF.hasText == true {
            self.student.experience = self.experience
           // self.student.tShirtSize = self.tShirtSizeDropDownTF.text
            self.performSegue(withIdentifier: "CreateStudentStep3ToStep4", sender: self)
        }
            /*else{
                print("Successful Login")
                    SwiftOverlays.showBlockingWaitOverlayWithText("Loading Profile")
                    self.student.experience = self.experience
               
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child((user?.uid)!).child("\(imageName).jpg")
                    
                    let profileImage = self.profPic
                    let uploadData = UIImageJPEGRepresentation(profileImage, 0.1)
                        storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                            
                            if error != nil {
                                print(error as Any)
                                return
                            }
                            
                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                
                                var values = Dictionary<String, Any>()
                                
                                values["studentID"] = Auth.auth().currentUser!.uid
                                values["bio"] = self.student.bio
                                values["name"] = self.student.name
                                values["email"] = self.student.email
                                //values["password"] = self.student.password
                                values["school"] = self.student.school
                                values["major"] = self.student.major
                                values["jobsCompleted"] = self.student.jobsCompleted
                                
                                values["totalEarned"] = 0
                                values["upcomingJobs"] = self.student.upcomingJobs
                                values["experience"] = self.student.experience
                                values["rating"] =  self.student.rating
                                values["tShirtSize"] = self.tShirtSizeDropDownTF.text
                                
                                var tempPromo = self.randomString(length: 6)
                                
                                while self.existingPromoCodes.contains(tempPromo){
                                    tempPromo = self.randomString(length: 6)
                                }
                                values["promoCode"] = ([tempPromo: [""]] as [String:Any])
                                if self.promoSuccess == false {
                                values["availableCredits"] = 0
                                } else {
                                    values["availableCredits"] = 5
                                }
                                
                                values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                                values["pic"] = profileImageUrl
                                var tempDict = [String: Any]()
                                tempDict[(user?.uid)!] = values
                                Database.database().reference().child("students").updateChildValues(tempDict)
                                if self.promoSuccess == true{
                                if self.promoType == "student"{
                                    var promo = self.promoData["promoCode"] as! [String: [String]]
                                    
                                    
                                    var tempArray = promo[(self.promoSender.first?.value)!] as! [String]
                                    
                                    
                                    if tempArray.first as! String == "" {
                                        tempArray.append(Auth.auth().currentUser!.uid)
                                        tempArray.remove(at: 0)
                                        
                                    } else {
                                        tempArray.append(Auth.auth().currentUser!.uid)
                                    }
                                    promo[(self.promoSender.first?.value)!] = tempArray
                                    self.promoData["promoCode"] = promo
                                    
                                    Database.database().reference().child("students").child(self.promoSenderID).updateChildValues(self.promoData)
                                } else {
                                    var promo = self.promoData["promoCode"] as! [String: [String]]
                                    
                                    
                                    var tempArray = promo[(self.promoSender.first?.value)!] as! [String]
                                    
                                    
                                     if tempArray.first as! String == "" {
                                     tempArray.append(Auth.auth().currentUser!.uid)
                                     tempArray.remove(at: 0)
                                     
                                     } else {
                                     tempArray.append(Auth.auth().currentUser!.uid)
                                     }
                                    promo[(self.promoSender.first?.value)!] = tempArray
                                    self.promoData["promoCode"] = promo
                                    Database.database().reference().child("jobPosters").child(self.promoSenderID).updateChildValues(self.promoData)
                                }
                                }
                                self.performSegue(withIdentifier: "CreateStudentToProfile", sender: self)
                                
                            }
                            
                        })
                    
                }
            
        })
    }*/
    
    
        
        
        
    }
    var promoSender = [String: String]()
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    
    //var shirtData = ["XS", "S", "M", "L", "XL", "XXL"]
    var expData = ["Leaf Blowing", "Gardening", "Gutter Cleaning", "Lawn Care", "Installations(Electronics)", "Installations(Decorations)", "Furniture Assembly","Moving(In-Home)", "Moving(Home-To-Home)", "Hauling Away"]
    //@IBOutlet weak var tShirtSizeDropDownTF: UITextField!
    @IBOutlet weak var relevantExperienceDropDownTF: UITextField!
    
    @IBOutlet weak var expLabel: UILabel!
    
    // let dropDown = DropDown()
    //let dropDown2 = DropDown()
    var existingPromoCodes = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // The view to which the drop down will appear on
        
       
        addButton.layer.cornerRadius = 7
        //tShirtSizeDropDownTF.delegate = self
        relevantExperienceDropDownTF.delegate = self
        step3Picker.delegate = self
        step3Picker.dataSource = self
        
        Database.database().reference().child("jobPosters").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if let tempDict = snap.value as? [String:Any]{
                        let promo = (tempDict["promoCode"] as! [String:Any])
                        for (key, _) in promo{
                            self.existingPromoCodes.append(key)
                        }
                    }
                    
                    
                    // Do any additional setup after loading the view.
                }
                Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if let tempDict = snap.value as? [String:Any]{
                                let promo = (tempDict["promoCode"] as! [String:Any])
                                for (key, _) in promo{
                                    self.existingPromoCodes.append(key)
                                }
                            }
                            
                            
                            // Do any additional setup after loading the view.
                        }
                    }
                })
            }
        })
        
        

        // Do any additional setup after loading the view.
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return expData.count
        }
        
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return expData[row]
        
        
        
    }
    let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    var curIndex = Int()
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        curIndex = row
        
            if experience.contains(expData[row]){
                addButton.setTitle("Remove", for: .normal)
                addButton.backgroundColor = UIColor.red
            } else {
                addButton.setTitle("Add", for: .normal)
                addButton.backgroundColor = qfGreen
            }
        
        //pickerView.isHidden = true
    }
    
    
    
    var curPicker = String()
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) {
        addButton.setTitle("Add", for: .normal)
        addButton.backgroundColor = qfGreen
        
            curPicker = "exp"
            addButton.isHidden = false
            
        
        step3Picker.reloadAllComponents()
        step3Picker.isHidden = false
        
        
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
        if let vc = segue.destination as? CreateStudentStep4EnterCardInfoViewController{
            vc.student = self.student
            vc.profPic = self.profPic
            vc.crypt = self.crypt
            /*vc.promoSenderID = self.promoSenderID
            vc.promoType = self.promoType
            vc.promoData = self.promoData
            vc.promoSuccess = self.promoSuccess
            vc.promoSender = self.promoSender*/
        }
        
    }
    //var promoType = String()

}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
