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
import CoreLocation

class CreateAccountStudentViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    var student = Student()
    var profPic: UIImage?
    var emailVerificationSent = false

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBAction func createAccountPressed(_ sender: Any) {
        let last4Bool = emailTextField.text?.hasSuffix(".edu")
        
        
        
        if (nameTextField.text != "Name" && nameTextField.hasText == true) && (emailTextField.text != "Email" && emailTextField.hasText == true) && (passwordTextField.text != "Password" && passwordTextField.hasText == true) && (confirmPasswordTextField.text != "Confirm Password" && confirmPasswordTextField.hasText == true){
            if confirmPasswordTextField.text != passwordTextField.text{
                //present error passwords don't match
                let alert = UIAlertController(title: "Password Error", message: "Passwords do not match.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if last4Bool == false && emailTextField.text != "tthrelk@gmail.com"{
                //present error that not school email
                let alert = UIAlertController(title: "Email Error", message: "Make sure that you are using your school email that ends in .edu", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
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
                student.experience = [String]()
                student.rating = Int()
                
                if emailVerificationSent == true{
                    print("emailVer == true")
                    Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {
                        (user: User?, error) in
                        
                        if error != nil{
                            // SwiftOverlays.removeAllBlockingOverlays()
                            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        else{
                            print("Successful Login")
                            if (user?.isEmailVerified)!{
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
                                            values["available"] = false
                                            values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                                            //var locDict = [String:Any]()
                                            
                                            values["pic"] = profileImageUrl
                                            
                                            var tempDict = [String: Any]()
                                            tempDict[(user?.uid)!] = values
                                            //firedatase upload
                                            Database.database().reference().child("students").updateChildValues(tempDict)
                                            self.performSegue(withIdentifier: "CreateStudentToProfile", sender: self)
                                            
                                        }
                                    })
                                }
                            } else {
                                let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.student.email!)). Your account will be created  and ready for use upon return to the app.", preferredStyle: .alert)
                                let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
                                    (_) in
                                    user?.sendEmailVerification(completion: nil)
                                }
                                let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                                
                                alertVC.addAction(alertActionOkay)
                                alertVC.addAction(alertActionCancel)
                                self.present(alertVC, animated: true, completion: nil)
                                self.emailVerificationSent = true
                                return
                                
                            }
                        }
                    })
                    
                    
                } else {
                    print("emailVer == false (before createUser)")
                    //createAccountButton.set
                createAccountButton.setTitle("Create Account", for: .normal)
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
                    
                    if let user = Auth.auth().currentUser {
                        if !user.isEmailVerified{
                            let alertVC = UIAlertController(title: "Verify Email", message: "Select Send to get a verification email sent to \(String(describing: self.student.email!)). Return to the app after verifying and select the Create Account button below.", preferredStyle: .alert)
                            let alertActionOkay = UIAlertAction(title: "send", style: .default) {
                                (_) in
                                user.sendEmailVerification(completion: nil)
                            }
                            let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                            
                            alertVC.addAction(alertActionOkay)
                            alertVC.addAction(alertActionCancel)
                            self.present(alertVC, animated: true, completion: nil)
                            self.emailVerificationSent = true
                            return
                        } else {
                            print ("Email verified. Signing in...")
                    
                    
                        }
                    }
                    
                    
                })
                }
            

                
                
            }
        }
        
    }
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       createAccountButton.setTitle("Verify Email", for: .normal)
        passwordTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tempDict = [String: Any]()
    let locationManager = CLLocationManager()
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        var locDict = ["lat" : locValue.latitude, "long": locValue.longitude]
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //var ref = Database.database().reference.child("users").child(Auth.auth().currentUser.uid).child("location")
        //ref.updateChildValues(locDict)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
