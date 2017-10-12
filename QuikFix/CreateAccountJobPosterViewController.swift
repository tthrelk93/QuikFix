//
//  CreateAccountJobPosterViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/12/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import CoreLocation

import SwiftOverlays

class CreateAccountJobPosterViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    var profPic: UIImage?
    var jobPoster = JobPoster()
    var emailVerificationSent = false
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func createAccountPressed(_ sender: Any) {
        if(addressTextField.text != "Address" && addressTextField.hasText == true) &&  (nameTextField.text != "Name" && nameTextField.hasText == true) && (emailTextField.text != "Email" && emailTextField.hasText == true) && (passwordTextField.text != "Password" && passwordTextField.hasText == true) && (confirmPasswordTextField.text != "Confirm Password" && confirmPasswordTextField.hasText == true) {
            if confirmPasswordTextField.text != self.passwordTextField.text{
                let alert = UIAlertController(title: "Passwords do not match", message: "Check that you entered the same password into both the password and confirm password fields.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return

            }
            else {
               print("passed first errors")
                jobPoster.name = nameTextField.text
                jobPoster.email = emailTextField.text
                jobPoster.password = passwordTextField.text
                jobPoster.address = addressTextField.text
                jobPoster.jobsCompleted = [String]()
                jobPoster.currentListings = [String]()
                //student.experience = [String: Any]()
                //student.rating = Int()
                
                //Firebase create user
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
                            SwiftOverlays.showBlockingWaitOverlayWithText("This is blocking overlay!")
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
                                        values["name"] = self.jobPoster.name
                                        var locDict = [String:Any]()
                                        values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                                        values["email"] = self.jobPoster.email
                                        values["password"] = self.jobPoster.password
                                        values["address"] = self.jobPoster.address
                                        values["jobsCompleted"] = self.jobPoster.jobsCompleted
                                        values["currentListings"] = self.jobPoster.currentListings
                                        values["pic"] = profileImageUrl
                                        var tempDict = [String: Any]()
                                        tempDict[(user?.uid)!] = values
                                        //firedatase upload
                                        Database.database().reference().child("jobPosters").updateChildValues(tempDict)
                                        self.performSegue(withIdentifier: "CreateJobPosterToProfile", sender: self)
                                    }
                                })
                            }
                        } else {
                            let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.jobPoster.email!)). Your account will be created  and ready for use upon return to the app.", preferredStyle: .alert)
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
                    createAccountButton.setTitle("Create Account", for: .normal)
                Auth.auth().createUser(withEmail: jobPoster.email!, password: jobPoster.password!, completion: { (user: User?, error) in
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
                        print("emailVer == false (after 2nd error test and after if let user =)")
                        if !user.isEmailVerified{
                            print("emailNotVerified")
                            let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.jobPoster.email!)). After verifying just return to the app and select the Create Account button below.", preferredStyle: .alert)
                            let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
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
    
    let locationManager = CLLocationManager()
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        var locDict = ["lat" : locValue.latitude, "long": locValue.longitude]
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //var ref = Database.database().reference.child("users").child(Auth.auth().currentUser.uid).child("location")
        //ref.updateChildValues(locDict)
    }


    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.setTitle("Verify Email", for: .normal)
        passwordTextField.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextField.delegate = self
        addressTextField.delegate = self
        
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
