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
import DropDown
import CoreLocation

class CreateStudentAccountFinalViewController: UIViewController, UITextFieldDelegate {
    
    var profPic = UIImage()
    var student = Student()
    var experience = [String]()
    
    var locationManager = CLLocationManager()
    @IBAction func createAccountPressed(_ sender: Any) {
        if relevantExperienceDropDownTF.hasText == true && tShirtSizeDropDownTF.hasText == true {
            Auth.auth().signIn(withEmail: student.email!, password: student.password!, completion: { (user: User?, error) in
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
                                values["password"] = self.student.password
                                values["school"] = self.student.school
                                values["major"] = self.student.major
                                values["jobsFinished"] = self.student.jobsFinished
                                values["totalEarned"] = 0
                                values["upcomingJobs"] = self.student.upcomingJobs
                                values["experience"] = self.student.experience
                                values["rating"] =  self.student.rating
                                
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
    @IBOutlet weak var tShirtSizeDropDownTF: UITextField!
    @IBOutlet weak var relevantExperienceDropDownTF: UITextField!
     let dropDown = DropDown()
    let dropDown2 = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // The view to which the drop down will appear on
        dropDown.anchorView = view // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Lawncare", "Assembling Furniture", "Moving", "IT", "Electronics"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if self.experience.contains(item){
                self.experience.remove(at: self.experience.index(of: item)!)
            } else {
                self.experience.append(item)
            }
            var tempString = ""
            for str in self.experience{
                if tempString == ""{
                    tempString = str
                } else {
                    tempString = "\(tempString), \(str)"
                }
                
            }
            self.relevantExperienceDropDownTF.text = tempString
            //dropDown.hide()
        }
        
        // Will set a custom width instead of the anchor view width
       //DropDownCellll.width = 200
        
        
        
        // The view to which the drop down will appear on
        dropDown2.anchorView = view // UIView or UIBarButtonItem
        
        
        // The list of items to display. Can be changed dynamically
        dropDown2.dataSource = ["XS", "S", "M", "L", "XL", "XXL"]
        
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            self.student.tShirtSize = item
            self.tShirtSizeDropDownTF.text = item
            self.dropDown2.hide()
        }
        tShirtSizeDropDownTF.delegate = self
        relevantExperienceDropDownTF.delegate = self

        // Do any additional setup after loading the view.
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) {
        if textField == tShirtSizeDropDownTF{
            dropDown2.show()
        } else {
            for item in dropDown.dataSource{
                if experience.contains(item){
                    dropDown.selectRow(at: dropDown.dataSource.index(of: item))
                }
            }
            dropDown.show()
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
