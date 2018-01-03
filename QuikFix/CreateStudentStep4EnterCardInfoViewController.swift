//
//  CreateStudentStep4EnterCardInfoViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 12/30/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CoreLocation
import SwiftOverlays
import Stripe

class CreateStudentStep4EnterCardInfoViewController: UIViewController, STPAddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate, STPPaymentMethodsViewControllerDelegate, DataDelegate {
    var dataID = String()
    func getID(id: String) {
        self.dataID = id
    }
    var stripeToken = String()
    let settingsVC = SettingsViewController()
    
    var student = Student()
    var promoSender = [String: String]()
    
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var step4Label: UILabel!
    @IBOutlet var topLabel: UILabel!
    var customer = STPCustomer()
    var skip = false
    var promoData = [String:Any]()
    var promoSuccess = Bool()
    @IBAction func savePressed(_ sender: Any) {
        
            Auth.auth().signIn(withEmail: student.email!, password: crypt, completion: { (user: User?, error) in
                if error != nil {
                    
                    let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else{
                    print("Successful Login")
                    SwiftOverlays.showBlockingWaitOverlayWithText("Loading Profile")
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
                            values["stripeToken"] = self.dataID
                            values["totalEarned"] = 0
                            values["upcomingJobs"] = self.student.upcomingJobs
                            values["experience"] = self.student.experience
                            values["rating"] =  self.student.rating
                            values["tShirtSize"] = self.student.tShirtSize
                            
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
    }
    
    
    
    fileprivate var animationOptions: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
    var creditViewFrame = CGRect()
    var creditButtonFrame = CGRect()
    var creditShowing = false
    var promoType = String()
    var promoSenderID = String()
    
    @IBAction func creditPressed(_ sender: Any) {
        
        
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //var paymentVer = false
                
                for snap in snapshots {
                    /*if snap.key == "paymentVerified"{
                     if snap.value as! Bool == true{
                     paymentVer = true
                     }
                     }*/
                    if snap.key == "stripeToken"{
                        self.stripeToken = snap.value as! String
                    }
                    
                }
                self.handleAddPaymentMethodButtonTapped()
            }
        })
    }
    
    
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var sepAndCreditInfoPosition2: UIView!
    @IBOutlet weak var enterInfoView: UIView!
    @IBOutlet weak var enterCreditPosition2: UIView!
    
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.enterInfoView.isHidden = false
        self.creditButton.isHidden = true
        self.orLabel.isHidden = true
        self.skipButton.isHidden = true
        
        
    }
    var custID = String()
    func handleAddPaymentMethodButtonTapped() {
        // Setup add card view controller
        print("handleAddPayment")
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func submitTokenToBackend(token: STPToken, completion: @escaping STPErrorBlock, completionHandler: (Error) -> ()){
        print("submitTokenToBackEnd")
        
        MyAPIClient.sharedClient.callSaveCard(stripeToken: token, email: self.student.email!, name: self.student.name!){ responseObject, error in
            // use responseObject and error here
            self.dataID = responseObject!
            print("responseObject = \(responseObject!); error = \(String(describing: error))")
            self.dismiss(animated: true)
            self.enterInfoView.isHidden = false
            self.creditButton.isHidden = true
            self.orLabel.isHidden = true
            self.skipButton.isHidden = true
            
            
            
            return
        }
    }
    
    
    
    var poster = JobPoster()
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print("begin save card")
        submitTokenToBackend(token: token, completion: completion, completionHandler: { (error: Error?) in
            if let error = error {
                // Show error in add card view controller
                print("error: \(error.localizedDescription)")
                completion(error)
            }
            else {
                print("Sup")
                completion(nil)
                
                
                // Dismiss add card view controller
                dismiss(animated: true)
            }
        })
    }
    var buyButton = UIButton()
    let paymentCardTextField = STPPaymentCardTextField()
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        // Toggle buy button state
        buyButton.isEnabled = textField.isValid
        buyButton.isHidden = false
    }
    
    @IBAction func termsOfServicePressed(_ sender: Any) {
    }
    func handlePaymentMethodsButtonTapped() {
        // Setup customer context
        print("handlemethodstouched")
        let customerContext = STPCustomerContext(keyProvider: STPAPIClient.shared as! STPEphemeralKeyProvider)
        
        
        
        
        // Setup payment methods view controller
        let paymentMethodsViewController = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: customerContext, delegate: self)
        
        // Present payment methods view controller
        let navigationController = UINavigationController(rootViewController: paymentMethodsViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: STPPaymentMethodsViewControllerDelegate
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        // Dismiss payment methods view controller
        dismiss(animated: true)
        
        // Present error to user...
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        dismiss(animated: true)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        dismiss(animated: true)
    }
    
    var selectedPaymentMethod: STPPaymentMethod?
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
        // Save selected payment method
        selectedPaymentMethod = paymentMethod
    }
    
    
    
    
    
    
    
    @IBOutlet weak var creditButton: UIButton!
    //@IBOutlet weak var skip: UIButton!
    var crypt = String()
    var locationManager = CLLocationManager()
    
    @IBAction func createAccountPressed(_ sender: Any) {
        //var authData = Auth.auth().currentUser?.providerData["password"]
        Auth.auth().signIn(withEmail: poster.email!, password: crypt, completion: { (user: User?, error) in
            if error != nil {
                // SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                print("Successful Login")
                //self.poster.experience = self.experience
                
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
                        
                        
                        values["name"] = self.student.name
                        values["email"] = self.poster.email
                        
                        values["jobsCompleted"] = self.poster.jobsCompleted
                        values["completedCount"] = 0
                        values["address"] = [self.poster.address]
                        values["phone"] = self.poster.phone
                        var tempPromo = self.randomString(length: 6)
                        
                        while self.existingPromoCodes.contains(tempPromo){
                            tempPromo = self.randomString(length: 6)
                        }
                        values["promoCode"] = ([tempPromo: [""]] as [String:Any])
                        values["availableCredits"] = 0
                        values["deviceToken"] = ""
                        
                        values["upcomingJobs"] = self.poster.upcomingJobs
                        
                        print("locDict: \(self.locDict)")
                        values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                        values["pic"] = profileImageUrl
                        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser!.uid)).updateChildValues(values)
                        if self.promoSuccess == true {
                            if self.promoType == "student"{
                                Database.database().reference().child("students").child(self.promoSenderID).updateChildValues(self.promoData)
                            } else {
                                Database.database().reference().child("posters").child(self.promoSenderID).updateChildValues(self.promoData)
                            }
                        }
                        self.performSegue(withIdentifier: "CreatePosterToProfile", sender: self)
                        
                    }
                })
                
            }
            
        })
        
    }
    //var poster = JobPoster()
    var profPic = UIImage()
    var existingPromoCodes = [String]()
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
    
    var locDict = [String:Any]()
    var creditButtonOrigin = CGPoint()
    var creditViewOrigin = CGPoint()
    override func viewDidLoad() {
        super.viewDidLoad()
        enterInfoView.layer.cornerRadius = 7
        saveButton.layer.cornerRadius = 7
        skipButton.layer.cornerRadius = 7
        //creditCardNumberTF.delegate = self
        //expDate.delegate = self
        // cvvTF.delegate = self
        creditButton.layer.cornerRadius = 7
        creditButtonFrame = creditButton.bounds
        creditButtonOrigin = creditButton.frame.origin
        creditViewFrame = enterInfoView.bounds
        creditViewOrigin = enterInfoView.frame.origin
        
        paymentCardTextField.delegate = self
        /*buyButton.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
         buyButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
         buyButton.setTitle("Confirm", for: .normal)*/
        
        // Add payment card text field to view
        view.addSubview(paymentCardTextField)
        
        
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
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? studentProfile {
            vc.sender = "student"
        }
     }
    
    


}
