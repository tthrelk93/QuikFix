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
    
    @IBOutlet weak var step3Picker: UIPickerView!
    var locationManager = CLLocationManager()
    @IBAction func createAccountPressed(_ sender: Any) {
        if relevantExperienceDropDownTF.hasText == true && tShirtSizeDropDownTF.hasText == true {
            Auth.auth().signIn(withEmail: student.email!, password: self.crypt, completion: { (user: User?, error) in
                if error != nil {
                // SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                print("Successful Login")
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
                                values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                                values["pic"] = profileImageUrl
                                var tempDict = [String: Any]()
                                tempDict[(user?.uid)!] = values
                                Database.database().reference().child("students").updateChildValues(tempDict)
                                self.performSegue(withIdentifier: "CreateStudentToProfile", sender: self)
                                
                            }
                        })
                    
                }
            
        })
    }
    
    
        
        
        
    }
    var shirtData = ["XS", "S", "M", "L", "XL", "XXL"]
    var expData = ["Mow", "Leaf Blowing", "Gardening", "Gutter Cleaning", "Weed-Wacking", "Hedge Clipping", "Installations(Electronics)", "Installations(Decorations)", "Furniture Assembly","Moving(In-Home)", "Moving(Home-To-Home)", "Hauling Away"]
    @IBOutlet weak var tShirtSizeDropDownTF: UITextField!
    @IBOutlet weak var relevantExperienceDropDownTF: UITextField!
    
    @IBOutlet weak var expLabel: UILabel!
    
    // let dropDown = DropDown()
    //let dropDown2 = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // The view to which the drop down will appear on
        
       
        addButton.layer.cornerRadius = 7
        tShirtSizeDropDownTF.delegate = self
        relevantExperienceDropDownTF.delegate = self
        step3Picker.delegate = self
        step3Picker.dataSource = self
        
        

        // Do any additional setup after loading the view.
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if curPicker == "shirt"{
            return shirtData.count
            
        } else {
            return expData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if curPicker == "shirt"{
            return shirtData[row]
            
        } else {
            return expData[row]
        }
        
        
    }
    let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    var curIndex = Int()
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        curIndex = row
        if curPicker == "shirt"{
            tShirtSizeDropDownTF.text = shirtData[row]
            
        } else {
            if experience.contains(expData[row]){
                addButton.setTitle("Remove", for: .normal)
                addButton.backgroundColor = UIColor.red
            } else {
                addButton.setTitle("Add", for: .normal)
                addButton.backgroundColor = qfGreen
            }
        }
        //pickerView.isHidden = true
    }
    
    
    
    var curPicker = String()
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) {
        if textField == tShirtSizeDropDownTF{
            curPicker = "shirt"
            addButton.isHidden = true
        } else {
            curPicker = "exp"
            addButton.isHidden = false
            
        }
        step3Picker.reloadAllComponents()
        step3Picker.isHidden = false
        
        
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
