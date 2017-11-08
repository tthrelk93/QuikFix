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
    var poster = JobPoster()
    
    @IBOutlet weak var cellPhoneTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    var phoneVerified = false
    var emailVerificationSent = false
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneVerifcationView: UIView!
    var verCode = String()
    var credent = FIRPhoneAuthCredential()
    @IBAction func continueVerificaitonPressed(_ sender: Any) {
        if ver1.hasText == true && ver2.hasText == true && ver3.hasText == true && ver4.hasText == true && ver5.hasText == true && ver6.hasText == true {
            var verString = "\(ver1!)\(ver2)\(ver3)\(ver4)\(ver5)\(ver6)" as! String
            self.credent = PhoneAuthProvider.provider().credential(
                withVerificationID: self.verificationID,
                verificationCode: verString)
            
            if verString == self.verificationID{
                performSegue(withIdentifier: "CreatePosterStep1ToStep2", sender: self)
            } else {
                let alert = UIAlertController(title: "Incorrect Verification Code", message: "It appears you did not enter the correct verification code.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Missing Field.", message: "Please fill in all six verification digits", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var ver1: UITextField!
    @IBOutlet weak var ver2: UITextField!
    @IBOutlet weak var ver3: UITextField!
    @IBOutlet weak var ver4: UITextField!
    @IBOutlet weak var ver5: UITextField!
    @IBOutlet weak var ver6: UITextField!
    
    @IBAction func createAccountPressed(_ sender: Any) {
        if (nameTextField.text != "First Name" && nameTextField.hasText == true) && (lastNameTextField.text != "Last Name" && lastNameTextField.hasText == true) && (emailTextField.text != "Email" && emailTextField.hasText == true) && (passwordTextField.text != "Password" && passwordTextField.hasText == true) && (confirmPasswordTextField.text != "Confirm Password" && confirmPasswordTextField.hasText == true) && cellPhoneTextField.hasText {
            if confirmPasswordTextField.text != passwordTextField.text{
                //present error passwords don't match
                let alert = UIAlertController(title: "Password Error", message: "Passwords do not match.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            else {
                //student.bio = ""
                poster.name = "\(nameTextField!.text!) \(lastNameTextField!.text!)"
                poster.email = emailTextField.text
                poster.password = passwordTextField.text
                //student.school = ""
                //student.major = ""
                poster.jobsCompleted = [String]()
                poster.upcomingJobs = [String]()
                poster.currentListings = [String]()
               // student.rating = Int()
                poster.responses = [String:Any]()
                poster.phone = cellPhoneTextField.text!
                
                
               /* print("phone#: \(cellPhoneTextField.text!)")
                var strippedString = String()
                for ch in (cellPhoneTextField.text!).characters{
                    if ch != "(" && ch != ")" && ch != "-"{
                        strippedString.characters.append(ch)
                    }
                    
                }
                
                var tempString = "+1\(strippedString)" as! String
                print("ts: \(tempString)")
                PhoneAuthProvider.provider().verifyPhoneNumber(tempString, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    
                    print("success!: \(verificationID)")
                    self.verCode = verificationID as! String
                    self.createAccountButton.isHidden = true
                    self.phoneVerifcationView.isHidden = false
                    
                    // Sign in using the verificationID and the code sent to the user
                    // ...
                }*/
                
                
                
                
                    Auth.auth().createUser(withEmail: poster.email!, password: poster.password!, completion: { (user: User?, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        
                        if !Auth.auth().currentUser.emailVerified {
                        
                        
                        print("emailVer == false")
                        let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.poster.email!)). Your account will be created  and ready for use upon return to the app.", preferredStyle: .alert)
                        let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
                            (_) in
                            user?.sendEmailVerification(completion: nil)
                            self.createAccountButton.setTitle("Continue Once Verified", for: .normal)
                            
                        }
                        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        
                        alertVC.addAction(alertActionOkay)
                        alertVC.addAction(alertActionCancel)
                        self.present(alertVC, animated: true, completion: nil)
                        //self.emailVerificationSent = true
                        } else {
                            print("emailVer == true")
                            self.performSegue(withIdentifier: "CreatePosterStep1ToStep2", sender: self)
                        }
                        
                        
                    })
                
                
                    
                
            }
        } else {
            
            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
           // }
       // }
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
   // @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.setTitle("Verify Email", for: .normal)
        passwordTextField.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextField.delegate = self
        cellPhoneTextField.delegate = self
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        //addressTextField.delegate = self
        
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
    
    /*public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cellPhoneTextField{
            
        }
        
    }*/
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == cellPhoneTextField)
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
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField || textField == lastNameTextField{
            textField.text = textField.text?.capitalizingFirstLetter()
        }

    }
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? CreatePosterStep2{
            vc.poster = self.poster
            vc.profPic = self.profPic!
        }
    }
    

}
extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
