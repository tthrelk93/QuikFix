//
//  DealsViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 1/9/18.
//  Copyright © 2018 Thomas Threlkeld. All rights reserved.
//

import UIKit
import Stripe
import FirebaseDatabase
import FirebaseAuth
import SwiftOverlays


class DealsViewController: UIViewController, STPAddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate, STPPaymentMethodsViewControllerDelegate {
    
    // 1) To get started with this demo, first head to https://dashboard.stripe.com/account/apikeys
    // and copy your "Test Publishable Key" (it looks like pk_test_abcdef) into the line below.
    let stripePublishableKey = "pk_live_F3qPhd7gnfCP6HP2gi1LTX41"
    
    // 2) Next, optionally, to have this demo save your user's payment details, head to
    // https://github.com/stripe/example-ios-backend , click "Deploy to Heroku", and follow
    // the instructions (don't worry, it's free). Replace nil on the line below with your
    // Heroku URL (it looks like https://blazing-sunrise-1234.herokuapp.com ).
    let backendBaseURL = "https://quikfix123.herokuapp.com"
    
    // 3) Optionally, to enable Apple Pay, follow the instructions at https://stripe.com/docs/mobile/apple-pay
    // to create an Apple Merchant ID. Replace nil on the line below with it (it looks like merchant.com.yourappname).
    // let appleMerchantID: String? = nil
    
    // These values will be shown to the user when they purchase with Apple Pay.
    let companyName = "QuikFix"
    let paymentCurrency = "usd"
    
    var paymentContext: STPPaymentContext?
    
    var theme: STPTheme?
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var numberFormatter: NumberFormatter?
    
    var product = ""
    
    
    var cardConnected = Bool()

    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "DealsToProf", sender: self)
    }
    var buttonPressed = String()
    func confirmPayment(type: String){
        if type == "grad"{
            if self.cardConnected == true {
                SwiftOverlays.showBlockingTextOverlay("Verifying Purchase...")
                var sendJob = [String:Any]()
                sendJob["posterID"] = Auth.auth().currentUser!.uid
                sendJob["jobID"] = ""
                
                print("charge the poster for cancel")
                let tempCharge = 200 * 100
                print("charge in cents: \(tempCharge)")
                MyAPIClient.sharedClient.completeCharge(amount: Int(tempCharge), poster: Auth.auth().currentUser!.uid, job: sendJob, senderScreen: "dealsGrad",jobDict: ["":""])
                DispatchQueue.main.async{
                    sleep(2)
                    SwiftOverlays.removeAllBlockingOverlays()
                }
                
            } else {
                
                let alert = UIAlertController(title: "No Credit Card Connected", message: "You must connect an active credit card to QuikFix in order to post jobs.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { action in
                    self.showAddCard()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            if self.cardConnected == true {
                SwiftOverlays.showBlockingTextOverlay("Verifying Purchase...")
                var sendJob = [String:Any]()
                sendJob["posterID"] = Auth.auth().currentUser!.uid
                sendJob["jobID"] = ""
                
                print("charge the poster for underGrad")
                let tempCharge = 100 * 100
                print("charge in cents: \(tempCharge)")
                MyAPIClient.sharedClient.completeCharge(amount: Int(tempCharge), poster: Auth.auth().currentUser!.uid, job: sendJob, senderScreen: "dealsUnderGrad",jobDict: ["":""])
                DispatchQueue.main.async{
                    sleep(2)
                    SwiftOverlays.removeAllBlockingOverlays()
                }
                
            } else {
                let alert = UIAlertController(title: "No Credit Card Connected", message: "You must connect an active credit card to QuikFix in order to post jobs.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { action in
                    self.showAddCard()
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func gradPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Purchase", message: "Press okay to confirm purchase of 10 prepaid QuikFix hours for $200 to be applied to jobs at your choosing.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { action in
            self.confirmPayment(type: "grad")
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        self.buttonPressed = "grad"
        
    }
    
    @IBAction func undergradPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Confirm Purchase", message: "Press okay to confirm purchase of 5 prepaid QuikFix hours for $100 to be applied to jobs at your choosing.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { action in
            self.confirmPayment(type: "underGrad")
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel, handler: nil) )
        self.present(alert, animated: true, completion: nil)
        
        self.buttonPressed = "underGrad"
        
    }
    
    
    func showAddCard(){
        self.handleAddPaymentMethodButtonTapped()
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
    var selectorJobID = String()
    
    
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
        //MyAPIClient.sharedClient.delegate = self
        MyAPIClient.sharedClient.callSaveCard(stripeToken: token, email: self.email, name: self.name){ responseObject, error in
            // use responseObject and error here
            //self.dataID = responseObject as! String
            print("jobCoord")
            print("responseObject = \(responseObject!); error = \(error)")
            self.dismiss(animated: true)
            var tempDict = [String:Any]()
            tempDict["stripeToken"] = responseObject!
            Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(tempDict)
            self.cardConnected = true
            DispatchQueue.main.async{
                if self.buttonPressed == "grad"{
                sleep(1)
                var sendJob = [String:Any]()
                sendJob["posterID"] = Auth.auth().currentUser!.uid
                sendJob["jobID"] = ""
                
                print("charge the poster for grad")
                let tempCharge = 200 * 100
                print("charge in cents: \(tempCharge)")
                MyAPIClient.sharedClient.completeCharge(amount: Int(tempCharge), poster: Auth.auth().currentUser!.uid, job: sendJob, senderScreen: "dealsGrad",jobDict: ["":""])
                } else {
                    sleep(1)
                    var sendJob = [String:Any]()
                    sendJob["posterID"] = Auth.auth().currentUser!.uid
                    sendJob["jobID"] = ""
                    
                    print("charge the poster for underGrad")
                    let tempCharge = 100 * 100
                    print("charge in cents: \(tempCharge)")
                    MyAPIClient.sharedClient.completeCharge(amount: Int(tempCharge), poster: Auth.auth().currentUser!.uid, job: sendJob, senderScreen: "dealsUnderGrad",jobDict: ["":""])
                    /*DispatchQueue.main.async{
                        sleep(2)
                        self.performSegue(withIdentifier: "DealsToProf", sender: self)
                    }*/
                }
            }
        }
    }
    
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
        print("cancel")
        dismiss(animated: true)
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        print("inDismiss")
        dismiss(animated: true)
        /* let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "posterProfile") as! JobPosterProfileViewController
         let nav = UINavigationController(rootViewController: secondViewController)
         self.present(nav, animated:true, completion:nil)*/
        /*DispatchQueue.main.async {
            self.perfSeg()
        }*/
    }
    
    var selectedPaymentMethod: STPPaymentMethod?
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
        // Save selected payment method
        selectedPaymentMethod = paymentMethod
    }
    
    
    
    var creditCount = Int()
    
    var email = String()
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "name"{
                        self.name = snap.value as! String
                    }
                    if snap.key == "stripeToken" {
                        if (snap.value as! String) != "" {
                            self.cardConnected = true
                        } else {
                            self.cardConnected = false
                        }
                    }
                    if snap.key == "email"{
                        self.email = snap.value as! String
                    }
                }
            }
        })

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
