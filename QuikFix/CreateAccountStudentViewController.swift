//
//  CreateAccountStudentViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/11/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CreateAccountStudentViewController: UIViewController {
    var student = Student()
    var profPic: UIImage?

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBAction func createAccountPressed(_ sender: Any) {
        let last4Bool = emailTextField.text?.hasSuffix(".edu")
        if (nameTextField.text != "Name" && nameTextField.hasText == true) && (emailTextField.text != "Email" && emailTextField.hasText == true) && (passwordTextField.text != "Password" && passwordTextField.hasText == true) && (confirmPasswordTextField.text != "Confirm Password" && confirmPasswordTextField.hasText == true){
            if confirmPasswordTextField.text != passwordTextField.text{
                //present error passwords don't match
            }
            else if last4Bool == false{
                //present error that not school email
            }
            else {
                student.bio = ""
                student.name = nameTextField.text
                student.email = emailTextField.text
                student.password = passwordTextField.text
                student.school = ""
                student.major = ""
                student.jobsFinished = [String]()
                student.upcomingJobs = [String]()
                student.experience = [String: Any]()
                student.rating = Int()
                
                //Firebase create user
                Auth.auth().createUser(withEmail: student.email!, password: student.password!, completion: { (user: User?, error) in
                    if error != nil {
                       // SwiftOverlays.removeAllBlockingOverlays()
                        print("error: \(error as! Any)")
                        if error?.localizedDescription == "The email address is already in use by another account."{
                            let alert = UIAlertController(title: "Email In Use.", message: "An account already exists under this email.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        return
                    }
                    //self.user = (user?.uid)!
                    guard let uid = user?.uid else{
                        
                        return
                    }
                    
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child((user?.uid)!).child("\(imageName).jpg")
                    
                    if let profileImage = self.profPic, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            
                            if error != nil {
                                print(error as Any)
                                return
                            }
                            
                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                
                                var values = Dictionary<String, Any>()
                                                               
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
                                values["pic"] = profileImageUrl
                                
                                var tempDict = [String: Any]()
                                tempDict[(user?.uid)!] = values
                                //firedatase upload
                                Database.database().reference().child("students").updateChildValues(tempDict)
                                self.performSegue(withIdentifier: "CreateStudentToProfile", sender: self)
                                
                            }
                        })
                    }
                    
                    
                })
            

                
                
            }
        }
        
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
