//
//  CreateAccountStudentViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/11/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import CoreLocation

class CreateAccountStudentViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    var student = Student()
    var profPic: UIImage?
    var emailVerificationSent = false
    var crypt = String()
    var verificationTimer : Timer = Timer()
    
    var promoData = [String:Any]()
    var promoSuccess = Bool()
    var promoSenderID = String()

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBAction func createAccountPressed(_ sender: Any) {
        let last4Bool = emailTextField.text?.hasSuffix(".edu")
        
        
        
        if (cellPhoneNumberTF.hasText && nameTextField.text != "Last Name" && nameTextField.hasText == true) && (firstNameTextField.text != "Last Name" && firstNameTextField.hasText == true) && (emailTextField.text != "Email" && emailTextField.hasText == true) && (passwordTextField.text != "Password" && passwordTextField.hasText == true) && (confirmPasswordTextField.text != "Confirm Password" && confirmPasswordTextField.hasText == true){
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
                student.name = "\(firstNameTextField!.text!) \(nameTextField!.text!)"
                student.email = emailTextField.text
                student.phone = cellPhoneNumberTF.text
                //student.password = passwordTextField.text
                student.school = ""
                student.major = ""
                student.jobsCompleted = [String]()
                student.upcomingJobs = [String]()
                student.experience = [String]()
                student.rating = Double()
                if !emailVerificationSent {
                    Auth.auth().createUser(withEmail: student.email!, password: passwordTextField.text!, completion: { (user: User?, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        self.crypt = self.passwordTextField.text!
                        
                        if !(Auth.auth().currentUser?.isEmailVerified)! {
                            
                            
                            print("emailVer == false")
                            let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.student.email!)). Your account will be created  and ready for use upon return to the app.", preferredStyle: .alert)
                            let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
                                (_) in
                                user?.sendEmailVerification(completion: nil)
                                self.createAccountButton.setTitle("Re-send Verification Email", for: .normal)
                                
                                
                                self.verificationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkIfTheEmailIsVerified) , userInfo: nil, repeats: true)
                                
                            }
                            let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                            
                            alertVC.addAction(alertActionCancel)
                            
                            alertVC.addAction(alertActionOkay)
                            
                            self.present(alertVC, animated: true, completion: nil)
                            self.emailVerificationSent = true
                        } else {
                            print("emailVer == true")
                            self.performSegue(withIdentifier: "CreateStudentStep1ToStep2", sender: self)
                        }
                        
                        
                    })
                } else {
                    let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.student.email!)). Your account will be created  and ready for use upon return to the app.", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
                        (_) in
                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                        self.createAccountButton.setTitle("Resend Email Verification", for: .normal)
                        
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionCancel)
                    
                    alertVC.addAction(alertActionOkay)
                    self.present(alertVC, animated: true, completion: nil)
                    self.emailVerificationSent = true
                    
                }
                /* } else {
                 print((Auth.auth().currentUser?.isEmailVerified)!)
                 if !(Auth.auth().currentUser?.isEmailVerified)! {
                 print("emailVer == falsee")
                 let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.poster.email!)). Your account will be created  and ready for use upon return to the app.", preferredStyle: .alert)
                 let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
                 (_) in
                 Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                 self.createAccountButton.setTitle("Continue Once Verified", for: .normal)
                 
                 }
                 let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                 
                 alertVC.addAction(alertActionOkay)
                 alertVC.addAction(alertActionCancel)
                 self.present(alertVC, animated: true, completion: nil)
                 self.emailVerificationSent = true
                 
                 } else {
                 print("emailVer == true")
                 self.performSegue(withIdentifier: "CreatePosterStep1ToStep2", sender: self)
                 }
                 
                 }*/
                
                
                
                
            }
        } else {
            
            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        // }
        // }
    }
    
    func checkIfTheEmailIsVerified(){
        
        Auth.auth().currentUser?.reload(completion: { (err) in
            if err == nil{
                
                if Auth.auth().currentUser!.isEmailVerified{
                    
                    
                    self.verificationTimer.invalidate()     //Kill the timer
                    self.performSegue(withIdentifier: "CreateStudentStep1ToStep2", sender: self)
                } else {
                    
                    print("It aint verified yet")
                    
                }
            } else {
                
                print(err?.localizedDescription)
                
            }
        })
        
    }
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
       createAccountButton.setTitle("Verify Email", for: .normal)
        passwordTextField.delegate = self
        cellPhoneNumberTF.delegate = self
        nameTextField.delegate = self
        firstNameTextField.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextField.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var tempDict = [String: Any]()
    let locationManager = CLLocationManager()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //var locValue:CLLocationCoordinate2D = manager.location!.coordinate
       // var locDict = ["lat" : locValue.latitude, "long": locValue.longitude]
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        //var ref = Database.database().reference.child("users").child(Auth.auth().currentUser.uid).child("location")
        //ref.updateChildValues(locDict)
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField || textField == firstNameTextField{
        textField.text = textField.text?.capitalizingFirstLetter()
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
   

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == cellPhoneNumberTF)
        {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted as CharacterSet)  //componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        }
        else
        {
            return true
        }
    }
    var promoType = String()
    var promoSender = [String: String]()
    

    @IBOutlet weak var cellPhoneNumberTF: UITextField!
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateAccountStudent2ViewController{
            vc.student = self.student
            vc.profPic = self.profPic!
            vc.crypt = self.crypt
            /*vc.promoType = self.promoType
            vc.promoSenderID = self.promoSenderID
            vc.promoSuccess = self.promoSuccess
            vc.promoData = self.promoData
            vc.promoSender = self.promoSender*/
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
