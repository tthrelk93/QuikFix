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

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBAction func createAccountPressed(_ sender: Any) {
        let last4Bool = emailTextField.text?.hasSuffix(".edu")
        
        
        
        if (nameTextField.text != "Last Name" && nameTextField.hasText == true) && (firstNameTextField.text != "Last Name" && firstNameTextField.hasText == true) && (emailTextField.text != "Email" && emailTextField.hasText == true) && (passwordTextField.text != "Password" && passwordTextField.hasText == true) && (confirmPasswordTextField.text != "Confirm Password" && confirmPasswordTextField.hasText == true){
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
                student.name = "\(firstNameTextField!.text) \(nameTextField!.text)"
                student.email = emailTextField.text
                student.password = passwordTextField.text
                student.school = ""
                student.major = ""
                student.jobsFinished = [String]()
                student.upcomingJobs = [String]()
                student.experience = [String]()
                student.rating = Int()
                if self.emailVerificationSent == false {
                    Auth.auth().createUser(withEmail: student.email!, password: student.password!, completion: { (user: User?, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                        print("emailVer == false")
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
                    
                    
                })

                
                } else {
                    print("emailVer == true")
                    self.performSegue(withIdentifier: "CreateStudentStep1ToStep2", sender: self)
                    }
                                }
        } else {
                
            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

    
   

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateAccountStudent2ViewController{
            vc.student = self.student
            vc.profPic = self.profPic!
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
