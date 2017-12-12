//
//  CreatePosterStep3ViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 11/2/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CoreLocation
import SwiftOverlays
import Stripe

class CreatePosterStep3ViewController: UIViewController, UITextFieldDelegate, STPAddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate, STPPaymentMethodsViewControllerDelegate {
    
    
    var stripeToken = String()
    let settingsVC = SettingsViewController()
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var step4Label: UILabel!
    @IBOutlet var topLabel: UILabel!
    var customer = STPCustomer()
    @IBAction func savePressed(_ sender: Any) {
        if creditCardNumberTF.hasText && creditCardNumberTF.text?.count == 19 && expDate.hasText && expDate.text?.count == 5 && cvvTF.hasText && cvvTF.text?.count == 3 {
            var cardParams = STPCardParams()
            cardParams.cvc = cvvTF.text
            
            let expMonth = expDate.text?.substring(to: 2)
            cardParams.expMonth = UInt(expMonth as! String)! //as! UInt
            
            let expYear = expDate.text?.substring(from: 3)
            print("month: \(expMonth) year: \(expYear)")
            cardParams.expYear = UInt(expYear as! String)!
            var cardNumb = creditCardNumberTF.text
            
            cardParams.number = cardNumb
            print("cardNumber: \(cardParams.number)")
            let sourceParams = STPSourceParams.cardParams(withCard: cardParams)
            STPAPIClient.shared().createSource(with: sourceParams, completion: { (source, error) in
                
               /* let customerContext = STPCustomerContext(keyProvider: STPAPIClient.shared)
                //STPCustomerContext(
                //var temp = STPEphemeralKeyProvider()
                //STPAPIClient.shared().
                
                
                
                /*if let token = source as? STPToken, let card = token.card {
                    customer.defaultSource = card
                }*/
                
                
                customerContext.attachSource(toCustomer: source!, completion: { (error) in
                    if error != nil{
                        print("source error: \(String(describing: error?.localizedDescription))")
                    }
                    
                })*/
                
            })
            
            
        }
    }
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var expDate: UITextField!
    @IBOutlet weak var cvvTF: UITextField!
    @IBOutlet weak var creditCardNumberTF: UITextField!
    @IBOutlet weak var sepAndCreditInfoPosition2: UIView!
    @IBOutlet weak var enterInfoView: UIView!
    @IBOutlet weak var enterCreditPosition2: UIView!
    @IBAction func skipButtonPressed(_ sender: Any) {
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
                        
                        //values["posterID"] = Auth.auth().currentUser!.uid
                        //values["bio"] = self.student.bio
                        values["name"] = self.poster.name
                        values["email"] = self.poster.email
                        // values["password"] = self.poster.password
                        //values["school"] = self.poster.school
                        //values["major"] = self.student.major
                        values["jobsCompleted"] = self.poster.jobsCompleted
                        //values["totalEarned"] = 0
                        values["address"] = [self.poster.address]
                        values["phone"] = self.poster.phone
                        var tempPromo = self.randomString(length: 6)
                        
                        while self.existingPromoCodes.contains(tempPromo){
                            tempPromo = self.randomString(length: 6)
                        }
                        values["posterID"] = Auth.auth().currentUser!.uid
                        values["promoCode"] = ([tempPromo: [""]] as! [String:Any])
                        values["availableCredits"] = 0
                        values["upcomingJobs"] = self.poster.upcomingJobs
                        //values["experience"] = self.student.experience
                        //values["rating"] =  self.student.rating
                        print("locDict: \(self.locDict)")
                        values["location"] = self.locDict
                        values["pic"] = profileImageUrl
                        var tempDict = [String: Any]()
                        tempDict[(user?.uid)!] = values
                        Database.database().reference().child("jobPosters").updateChildValues(tempDict)
                        
                        self.performSegue(withIdentifier: "CreatePosterToProfile", sender: self)
                        
                    }
                })
                
            }
            
        })
        

    }
    @IBAction func skipButton(_ sender: Any) {
        
        
    }
    fileprivate var animationOptions: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
    var creditViewFrame = CGRect()
    var creditButtonFrame = CGRect()
    var creditShowing = false
    @IBAction func creditPressed(_ sender: Any) {
        /*if creditShowing == false{
            topLabel.isHidden = false
            sepAndCreditInfoPosition2.isHidden = true
            orLabel.isHidden = true
            skip.isHidden = true
            enterInfoView.isHidden = false
            step4Label.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
            self.creditButton.bounds = self.enterCreditPosition2.bounds
            self.creditButton.frame.origin = self.enterCreditPosition2.frame.origin
            
            self.enterInfoView.bounds = self.creditViewFrame
            self.enterInfoView.frame.origin = self.creditViewOrigin
            self.creditButton.setTitle("Cancel", for: .normal)
            
            
        })
            creditShowing = true
           
        } else {
            topLabel.isHidden = false
            sepAndCreditInfoPosition2.isHidden = false
            orLabel.isHidden = false
            skip.isHidden = false
            step4Label.isHidden = false
            
            UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.creditButton.bounds = self.creditButtonFrame
                self.creditButton.frame.origin = self.creditButtonOrigin
                
                self.enterInfoView.bounds = self.sepAndCreditInfoPosition2.bounds
                self.enterInfoView.frame.origin = self.sepAndCreditInfoPosition2.frame.origin
                
                self.enterInfoView.isHidden = true
                self.creditButton.setTitle("Connect Credit Card to QuikFix", for: .normal)
                
                
            })
            creditShowing = false
        }*/
        
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                var paymentVer = false
                
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
        //var tempDict = [String:Any]()
        //tempDict["stripeToken"] = token.tokenId
        //Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).updateChildValues(tempDict)
        //self.poster.email = "tthrelk@gmail.com"
        //self.poster.name = "Thomas"
        
        MyAPIClient.sharedClient.saveCard(token, email: self.poster.email!, name: self.poster.name!, completion: completion)
        dismiss(animated: true)
        
        
            Auth.auth().signIn(withEmail: self.poster.email!, password: self.crypt, completion: { (user: User?, error) in
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
                            
                            //values["posterID"] = Auth.auth().currentUser!.uid
                            //values["bio"] = self.student.bio
                            values["name"] = self.poster.name
                            values["email"] = self.poster.email
                            // values["password"] = self.poster.password
                            //values["school"] = self.poster.school
                            //values["major"] = self.student.major
                            values["jobsCompleted"] = self.poster.jobsCompleted
                            //values["totalEarned"] = 0
                            values["address"] = [self.poster.address]
                            values["phone"] = self.poster.phone
                            var tempPromo = self.randomString(length: 6)
                            
                            while self.existingPromoCodes.contains(tempPromo){
                                tempPromo = self.randomString(length: 6)
                            }
                            values["stripeToken"] = token.tokenId
                            values["posterID"] = Auth.auth().currentUser!.uid
                            values["promoCode"] = ([tempPromo: [""]] as! [String:Any])
                            values["availableCredits"] = 0
                            values["upcomingJobs"] = self.poster.upcomingJobs
                            //values["experience"] = self.student.experience
                            //values["rating"] =  self.student.rating
                            print("locDict: \(self.locDict)")
                            values["location"] = self.locDict
                            values["pic"] = profileImageUrl
                            var tempDict = [String: Any]()
                            tempDict[(user?.uid)!] = values
                            Database.database().reference().child("jobPosters").updateChildValues(tempDict)
                            
                            self.performSegue(withIdentifier: "CreatePosterToProfile", sender: self)
                            
                        }
                    })
                    
                }
                
            })
            
        
        
        //dismiss(animated: true)
        //return
        //tempDict["paymentAmount"] = job.payment
        //tempDict["description"] = job.description
        
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
    @IBOutlet weak var skip: UIButton!
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
                        
                        //values["posterID"] = Auth.auth().currentUser!.uid
                        //values["bio"] = self.student.bio
                        values["name"] = self.poster.name
                        values["email"] = self.poster.email
                       // values["password"] = self.poster.password
                        //values["school"] = self.poster.school
                        //values["major"] = self.student.major
                        values["jobsCompleted"] = self.poster.jobsCompleted
                        //values["totalEarned"] = 0
                        values["address"] = [self.poster.address]
                        values["phone"] = self.poster.phone
                        var tempPromo = self.randomString(length: 6)
                        
                        while self.existingPromoCodes.contains(tempPromo){
                            tempPromo = self.randomString(length: 6)
                        }
                        values["promoCode"] = ([tempPromo: [""]] as! [String:Any])
                        values["availableCredits"] = 0
                        values["deviceToken"] = ""
                        
                        values["upcomingJobs"] = self.poster.upcomingJobs
                        //values["experience"] = self.student.experience
                        //values["rating"] =  self.student.rating
                        print("locDict: \(self.locDict)")
                        values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                        values["pic"] = profileImageUrl
                        //var tempDict = [String: Any]()
                        //tempDict[(user?.uid)!] = values
                        //var uploadData = [String: Any]()
                       // uploadData["jobPosters"] = tempDict
                        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser!.uid)).updateChildValues(values)
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
        skip.layer.cornerRadius = 7
       creditCardNumberTF.delegate = self
        expDate.delegate = self
        cvvTF.delegate = self
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
                        var promo = (tempDict["promoCode"] as! [String:Any])
                        for (key, val) in promo{
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
    
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
