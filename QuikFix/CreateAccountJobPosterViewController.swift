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

class CreateAccountJobPosterViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    var profPic: UIImage?
    var jobPoster = JobPoster()
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func createAccountPressed(_ sender: Any) {
        if(addressTextField.text != "Address" && addressTextField.hasText == true) &&  (nameTextField.text != "Name" && nameTextField.hasText == true) && (emailTextField.text != "Email" && emailTextField.hasText == true) && (passwordTextField.text != "Password" && passwordTextField.hasText == true) && (confirmPasswordTextField.text != "Confirm Password" && confirmPasswordTextField.hasText == true) {
            if confirmPasswordTextField.text != self.passwordTextField.text{
                //present error passwords don't match
            }
            else {
               
                jobPoster.name = nameTextField.text
                jobPoster.email = emailTextField.text
                jobPoster.password = passwordTextField.text
                jobPoster.address = addressTextField.text
                jobPoster.jobsCompleted = [String]()
                jobPoster.currentListings = [String]()
                //student.experience = [String: Any]()
                //student.rating = Int()
                
                //Firebase create user
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
                    
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child((user?.uid)!).child("\(imageName).jpg")
                    
                    if let profileImage = self.profPic, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                        
                        //storageRef.putData(uploadData)
                        
                        
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            
                            if error != nil {
                                print(error as Any)
                                return
                            }
                            
                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                
                                var values = Dictionary<String, Any>()
                                
                                //values["bio"] = self.student.bio
                                values["name"] = self.jobPoster.name
                                var locDict = [String:Any]()
                                values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                                
                                values["email"] = self.jobPoster.email
                                values["password"] = self.jobPoster.password
                                //values["school"] = self.student.school
                                values["address"] = self.jobPoster.address
                                values["jobsCompleted"] = self.jobPoster.jobsCompleted
                                values["currentListings"] = self.jobPoster.currentListings
                                //values["experience"] = self.student.experience
                                //values["rating"] =  self.student.rating
                                values["pic"] = profileImageUrl
                                
                                var tempDict = [String: Any]()
                                tempDict[(user?.uid)!] = values
                                //firedatase upload
                                Database.database().reference().child("jobPosters").updateChildValues(tempDict)
                                
                                self.performSegue(withIdentifier: "CreateJobPosterToProfile", sender: self)
                                //self.registerUserIntoDatabaseWithUID(uid, values: values as [String : Any])
                                
                                
                            }
                        })
                    }
                    
                    
                })
                
                
                
                
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
