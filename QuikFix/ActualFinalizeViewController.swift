//
//  ActualFinalizeViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 11/8/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Stripe
import CoreLocation
import SwiftOverlays


class ActualFinalizeViewController: UIViewController, UITextFieldDelegate, STPAddCardViewControllerDelegate, STPPaymentCardTextFieldDelegate, STPPaymentMethodsViewControllerDelegate {
    
    @IBAction func editDetailsPressed(_ sender: Any) {
        performSegue(withIdentifier: "PostJobToEditDetails", sender: self)
    }
    @IBAction func editLocationPressed(_ sender: Any) {
        performSegue(withIdentifier: "PostJobToEditLoc", sender: self)
        
    }
    @IBAction func editPickupPressed(_ sender: Any) {
    }
    @IBOutlet weak var editPickup: UIButton!
    @IBAction func editDropoffPressed(_ sender: Any) {
    }
    @IBOutlet weak var editDropoff: UIButton!
    var promoSuccess = Bool()
    @IBOutlet weak var mainEditButton: UIButton!
    @IBAction func mainEditPressed(_ sender: Any) {
        if editCat.isHidden == true{
            mainEditButton.setTitle("Done", for: .normal)
            mainEditButton.setTitleColor(qfGreen, for: .normal)
            editCat.isHidden = false
            editDate.isHidden = false
            //editPayment.isHidden = false
            editAdditInfo.isHidden = false
            editTimeButton.isHidden = false
            locationEditButton.isHidden = false
            editDropoff.isHidden = false
            editPickup.isHidden = false
        } else {
            mainEditButton.setTitleColor(UIColor.red, for: .normal)
            mainEditButton.setTitle("Edit", for: .normal)
            editCat.isHidden = true
            editDate.isHidden = true
            //editPayment.isHidden = true
            editAdditInfo.isHidden = true
            editTimeButton.isHidden = true
            locationEditButton.isHidden = true
            editDropoff.isHidden = true
            editPickup.isHidden = true
        }

        
    }
    
    @IBOutlet weak var locationEditButton: UIButton!
    @IBOutlet weak var editAdditInfo: UIButton!
    
   // @IBOutlet weak var editPayment: UIButton!
    
    @IBOutlet weak var editTimeButton: UIButton!
    
    
    @IBOutlet weak var paymentTitle: UILabel!
    
    @IBOutlet weak var sepLine: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var promoView: UIView!
    @IBAction func usePromoPressed(_ sender: Any) {
        if totalPromoDisc.text == "- $0 Promo Discount"{
            promoView.isHidden = false
            categoryLabel.isHidden = true
            categoryTitle.isHidden = true
            locationTitle.isHidden = true
            homeToHomeView.isHidden = true
            locationLabel.isHidden = true
            dateTitle.isHidden = true
            dateLabel.isHidden = true
            timeTitle.isHidden = true
            self.timeLabel.isHidden = true
            totalBaselineCost.isHidden = true
            paymentTitle.isHidden = true
            totalHoursWorked.isHidden = true
            totalToolFee.isHidden = true
            totalHaulingFee.isHidden = true
            totalWorkerCount.isHidden = true
            totalPromoDisc.isHidden = true
            totalFinalCost.isHidden = true
            usePromo.isHidden = true
            detailTitle.isHidden = true
            detailsTextView.isHidden = true
            sepLine.isHidden = true
            
        } else {
            let alert = UIAlertController(title: "Multiple Promo Codes", message: "You have already applied a promo code to this job.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var applyPromoButton: UIButton!
    
    @IBOutlet weak var enterPromoTF: UITextField!
    @IBOutlet weak var cancelPromoButton: UIButton!
    
    @IBAction func cancelPromoPressed(_ sender: Any) {
        promoView.isHidden = true
        categoryLabel.isHidden = false
        categoryTitle.isHidden = false
        homeToHomeView.isHidden = false
        
        if self.categoryLabel.text == "Moving(Home-to-Home)"{
            homeToHomeView.isHidden = false
        } else {
            homeToHomeView.isHidden = true
            locationTitle.isHidden = false
            locationLabel.isHidden = false
        }
        
        dateTitle.isHidden = false
        dateLabel.isHidden = false
        timeTitle.isHidden = false
        self.timeLabel.isHidden = false
        totalBaselineCost.isHidden = false
        paymentTitle.isHidden = false
        totalHoursWorked.isHidden = false
        totalToolFee.isHidden = false
        totalHaulingFee.isHidden = false
        totalWorkerCount.isHidden = false
        totalPromoDisc.isHidden = false
        totalFinalCost.isHidden = false
        usePromo.isHidden = false
        detailTitle.isHidden = false
        detailsTextView.isHidden = false
        sepLine.isHidden = false
        
    }
    
    @IBOutlet weak var detailTitle: UILabel!
    var invalidCodeBool = Bool()
    @IBAction func applyPromoPressed(_ sender: Any) {
        Database.database().reference().child("jobPosters").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if let tempDict = snap.value as? [String:Any]{
                        var promo = (tempDict["promoCode"] as! [String:Any])
                        for (key, val) in promo{
                            if key as! String == self.enterPromoTF.text{
                                self.invalidCodeBool = false
                                if (val as! [String]).contains((Auth.auth().currentUser?.uid)!){
                                    //show error
                                    let alert = UIAlertController(title: "Promo Error", message: "You have already redeemed this promo code.", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.promoSuccess = false
                                } else {
                                    //var calcRate = (((25 * (Int(self.jobPost.jobDuration!)!)) * (self.jobPost.workerCount as! Int)) - 5)
                                    self.promoSenderArray = val as! [String]
                                    self.promoSuccess = true
                                    self.promoCode = self.enterPromoTF.text!
                                    self.promoSender = snap.key as! String
                                    print("ps1: \(self.promoSender)")
                                    //self.creditCount = tempDict["availableCredits"] as! Int
                                   /* if self.jobPost.category1 == "Moving(Home-To-Home)"{
                                        calcRate = calcRate + 10
                                        
                                    }
                                    if self.jobPost.tools?.count != 0 && self.jobPost.tools?.count != nil {
                                        calcRate = calcRate + 5
                                        self.toolCount = (self.jobPost.tools?.count)!
                                    } else {
                                        self.toolCount = 0
                                    }
                                    self.jobPost.payment = String(describing:calcRate)*///
                                    //self.performSegue(withIdentifier:"AdditDetailsToFinalize" , sender: self)
                                    
                                    self.promoView.isHidden = true
                                    self.categoryLabel.isHidden = false
                                    self.categoryTitle.isHidden = false
                                    self.locationTitle.isHidden = false
                                    self.homeToHomeView.isHidden = false
                                    self.locationLabel.isHidden = false
                                    self.dateTitle.isHidden = false
                                    self.dateLabel.isHidden = false
                                    self.timeTitle.isHidden = false
                                    self.timeLabel.isHidden = false
                                    self.totalBaselineCost.isHidden = false
                                    self.paymentTitle.isHidden = false
                                    self.totalHoursWorked.isHidden = false
                                    self.totalToolFee.isHidden = false
                                    self.totalHaulingFee.isHidden = false
                                    self.totalWorkerCount.isHidden = false
                                    self.totalPromoDisc.isHidden = false
                                    self.totalFinalCost.isHidden = false
                                    self.usePromo.isHidden = false
                                    self.detailTitle.isHidden = false
                                    self.detailsTextView.isHidden = false
                                    self.sepLine.isHidden = false
                                    
                                    self.totalPromoDisc.text = "- $5 Promo Discount"
                                    print("tfc: \(self.totalFinalCost.text)")
                                    var removeSign = (self.totalFinalCost.text)?.substring(from: 1)
                                     print("removeSignTFC: \(removeSign)")
                                    var test = Int(removeSign!)
                                    print("backToInt: \(test)")
                                    var tempInt = (test! - 5)
                                    self.totalFinalCost.text = "$\(String(describing: tempInt))"
                                    
                                    
                                }
                            }
                        }
                        if self.invalidCodeBool == true{
                            let alert = UIAlertController(title: "Promo Error", message: "Invalid Promo Code", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
        })
        
        
    }
    
    @IBOutlet weak var usePromo: UIButton!
    @IBAction func editTimePressed(_ sender: Any) {
        performSegue(withIdentifier: "PostJobToEditTime", sender: self)
    }
   // @IBAction func editPaymentPressed(_ sender: Any) {
    //}
    @IBOutlet weak var editCat: UIButton!
    @IBAction func editCatPressed(_ sender: Any) {
        performSegue(withIdentifier: "PostJobToEditCat", sender: self)
    }
    @IBOutlet weak var editDate: UIButton!
    
    @IBAction func editDateTouched(_ sender: Any) {
        performSegue(withIdentifier: "PostJobToEditDate", sender: self)
        
        
    }
    let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    var posterName = String()
    
    @IBAction func postJobPressed(_ sender: Any) {
        print("in post job Pressed")
        if self.cardConnected == true {
            SwiftOverlays.showBlockingTextOverlay("Posting Job...")
            print("cardTrue")
            var values = [String:Any]()
            var ref = Database.database().reference().child("jobs").childByAutoId()
            values["posterName"] = self.tempPosterName
            values["posterID"] = Auth.auth().currentUser?.uid
            values["inProgress"] = false
            values["category1"] = jobPost.category1
        
            values["location"] = jobPost.location
            values["date"] = jobPost.date
            
            values["additInfo"] = jobPost.additInfo
            values["jobLat"] = String(describing: self.jobCoord.coordinate.latitude)
            values["jobLong"] = String(describing: self.jobCoord.coordinate.longitude)
            
            values["payment"] = totalFinalCost.text
            
            values["startTime"] = jobPost.startTime
            
        values["jobDuration"] = jobPost.jobDuration
        values["studentsInRange"] = self.studentsInRange
            values["workerCount"] = jobPost.workerCount
            values["acceptedCount"] = 0
            if jobPost.category1 == "Moving(Home-To-Home)"{
                values["pickupLocation"] = jobPost.pickupLocation
                values["dropOffLocation"] = jobPost.dropOffLocation
            }
            
            if jobPost.tools != nil{
                values["tools"] = jobPost.tools!
            }
            
            values["jobID"] = ref.key
            values["completed"] = false
            self.selectorJobID = ref.key
            //self.segueJobData = values
            self.jobRef = ref.key
            ref.updateChildValues(values)
            
            
            
            //var values2 = [String: Any]()
            //values2["currentListings"]
            
            Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                var tempBool = false
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if snap.key == "currentListings"{
                            tempBool = true
                            for (key, val) in snap.value as! [String: [String:Any]]{
                                self.listingsArray[key] = val
                            }
                        }
                    }
                    if tempBool == false{
                        
                    }
                    self.listingsArray[ref.key] = values
                    
                    var tempDict = [String:Any]()
                    tempDict["currentListings"] = self.listingsArray
                    //self.seguePosterData = tempDict
                    Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(tempDict)
                    
                    Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapshots{
                                var snapDict = snap.value as! [String:Any]
                                let studentLat = (snapDict["location"] as! [String:Any])["lat"] as! CLLocationDegrees
                                let studentLong = (snapDict["location"] as! [String:Any])["long"] as! CLLocationDegrees
                                let studentLoc = CLLocation(latitude: studentLat, longitude: studentLong)
                                
                                let exp = snapDict["experience"] as! [String]
                                print("studentEXp: \(exp)")
                                if exp.contains(self.jobPost.category1!){
                                    print(snap.key)
                                    print("studLoc: \(studentLoc)")
                                    print("jobLoc: \(self.jobCoord)")
                                    if studentLoc.distance(from: self.jobCoord) <= 90000{
                                        print("inRange")
                                        if snapDict["nearbyJobs"] == nil {
                                            
                                            print("it was nil")
                                            Database.database().reference().child("students").child(snapDict["studentID"] as! String).updateChildValues(["nearbyJobs": [ref.key]])
                                        } else {
                                            var tempArray = snapDict["nearbyJobs"] as! [String]
                                            tempArray.append(ref.key)
                                            Database.database().reference().child("students").child(snapDict["studentID"] as! String).updateChildValues(["nearbyJobs": tempArray])
                                        }
                                        
                                        
                                    }
                                }
                            }
                            print("need to segue")
                            DispatchQueue.main.async{
                                self.performSegue(withIdentifier: "CreateJobToProfile", sender: self)
                            }
                        }
                    })
                }
                
            })
        if promoSuccess == true{
            print("ps: \(self.promoSender)")
            self.creditCount = self.creditCount + 1
            self.promoSenderArray.append((Auth.auth().currentUser?.uid)!)
        
            Database.database().reference().child("jobPosters").child(self.promoSender).child("promoCode").updateChildValues([self.promoCode: self.promoSenderArray])
            Database.database().reference().child("jobPosters").child(self.promoSender).updateChildValues(["availableCredits":self.creditCount])
        }
        } else {
            let alert = UIAlertController(title: "No Credit Card Connected", message: "You must connect an active credit card to QuikFix in order to post jobs.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { action in
                self.showAddCard()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
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
        MyAPIClient.sharedClient.callSaveCard(stripeToken: token, email: self.email, name: self.tempPosterName){ responseObject, error in
            // use responseObject and error here
            //self.dataID = responseObject as! String
            print("jobCoord")
            print("responseObject = \(responseObject!); error = \(error)")
            self.dismiss(animated: true)
            var tempDict = [String:Any]()
            tempDict["stripeToken"] = responseObject!
            Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(tempDict)
            self.cardConnected = true
            var values = [String:Any]()
            var ref = Database.database().reference().child("jobs").childByAutoId()
            values["posterName"] = self.tempPosterName
            values["posterID"] = Auth.auth().currentUser?.uid
            values["inProgress"] = false
            values["category1"] = self.jobPost.category1
            
            values["location"] = self.jobPost.location
            values["jobLat"] = String(describing: self.jobCoord.coordinate.latitude)
            values["jobLong"] = String(describing: self.jobCoord.coordinate.longitude)
            
            values["date"] = self.jobPost.date
            values["additInfo"] = self.jobPost.additInfo
            values["payment"] = self.totalFinalCost.text
            values["startTime"] = self.jobPost.startTime
            values["jobDuration"] = self.jobPost.jobDuration
            
            values["workerCount"] = self.self.jobPost.workerCount
            values["acceptedCount"] = 0
            values["studentsInRange"] = self.studentsInRange
            if self.jobPost.category1 == "Moving(Home-To-Home)"{
                values["pickupLocation"] = self.jobPost.pickupLocation
                values["dropOffLocation"] = self.jobPost.dropOffLocation
            }
            
            if self.jobPost.tools != nil{
                values["tools"] = self.self.jobPost.tools!
            }
            
            values["jobID"] = ref.key
            values["completed"] = false
            
            //self.segueJobData = values
            self.jobRef = ref.key
            ref.updateChildValues(values)
            //var values2 = [String: Any]()
            //values2["currentListings"]
            
            Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                var tempBool = false
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if snap.key == "currentListings"{
                            tempBool = true
                            for (key, val) in snap.value as! [String: [String:Any]]{
                                self.listingsArray[key] = val
                            }
                        }
                    }
                    if tempBool == false{
                        
                    }
                    self.listingsArray[ref.key] = values
                    
                    var tempDict = [String:Any]()
                    tempDict["currentListings"] = self.listingsArray
                    //self.seguePosterData = tempDict
                    Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(tempDict)
                    
                   print("im here")
                    Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapshots{
                                var snapDict = snap.value as! [String:Any]
                                let studentLat = (snapDict["location"] as! [String:Any])["lat"] as! CLLocationDegrees
                                let studentLong = (snapDict["location"] as! [String:Any])["long"] as! CLLocationDegrees
                                
                                
                                
                                
                                let studentLoc = CLLocation(latitude: studentLat, longitude: studentLong)
                                
                                let exp = snapDict["experience"] as! [String]
                                if exp.contains(self.jobPost.category1!){
                                    print(snap.key)
                                    if studentLoc.distance(from: self.jobCoord) <= 90000{
                                       print("inRange")
                                        if snapDict["nearbyJobs"] == nil {
                                            
                                           print("it was nil")
                                            Database.database().reference().child("students").child(snapDict["studentID"] as! String).updateChildValues(["nearbyJobs": [ref.key]])
                                        } else {
                                       var tempArray = snapDict["nearbyJobs"] as! [String]
                                            tempArray.append(ref.key)
                                            Database.database().reference().child("students").child(snapDict["studentID"] as! String).updateChildValues(["nearbyJobs": tempArray])
                                        }
                                        
                                        
                                        
                                    }
                                }
                            }
                        }
                    })
                }
            })
            if self.promoSuccess == true{
                print("ps: \(self.promoSender)")
                self.creditCount = self.creditCount + 1
                self.promoSenderArray.append((Auth.auth().currentUser?.uid)!)
                
                Database.database().reference().child("jobPosters").child(self.promoSender).child("promoCode").updateChildValues([self.promoCode: self.promoSenderArray])
                Database.database().reference().child("jobPosters").child(self.promoSender).updateChildValues(["availableCredits":self.creditCount])
            }
            DispatchQueue.main.async {
                print("need to segue")
                self.perfSeg()
            }
            //self.postJobPressed(Any)
            //self.perfSeg()
        }
    }
    func perfSeg(){
        print("perf")
        //performSegue(withIdentifier: "CreateJobToProfile", sender: self)
        let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "posterProfile") as! JobPosterProfileViewController
        let nav = UINavigationController(rootViewController: secondViewController)
        self.present(nav, animated:true, completion:nil)
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
        DispatchQueue.main.async {
            self.perfSeg()
        }
    }
    
    var selectedPaymentMethod: STPPaymentMethod?
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
        // Save selected payment method
        selectedPaymentMethod = paymentMethod
    }

    
    
    var creditCount = Int()
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var totalFinalCost: UILabel!
    @IBOutlet weak var totalHaulingFee: UILabel!
    @IBOutlet weak var totalToolFee: UILabel!
    @IBOutlet weak var totalWorkerCount: UILabel!
    @IBOutlet weak var totalHoursWorked: UILabel!
    @IBOutlet weak var totalBaselineCost: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    var jobPost = JobPost()
    
    var listingsArray = [String: [String:Any]]()
    
    
    
    //var segueJobData = [String:Any]()
    //var seguePosterData = [String:Any]()
    var jobRef = String()
    var timeDifference = Int()
    var toolCount = Int()
    var tempPosterName = String()
    var promoSenderArray = [String]()
    var promoSender = String()
    var promoCode = String()
    
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var pickupLabel: UILabel!
    @IBOutlet weak var homeToHomeView: UIView!

    @IBOutlet weak var totalPromoDisc: UILabel!
    @IBOutlet weak var dropoffLabel: UILabel!
    var cardConnected = false
    var email = String()
    var jobCoord = CLLocation()
    var studentsInRange = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterPromoTF.delegate = self
        usePromo.layer.cornerRadius = 6
        cancelPromoButton.layer.cornerRadius = 6
        applyPromoButton.layer.cornerRadius = 6
        mainEditButton.setTitle("Edit", for: .normal)
        mainEditButton.setTitle("Done", for: .selected)
        mainEditButton.setTitleColor(qfGreen, for: .selected)
        mainEditButton.setTitleColor(UIColor.red, for: .normal)
        
        var exp = [String]()
        
        
        
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "name"{
                        self.tempPosterName = snap.value as! String
                    }
                    if snap.key == "stripeToken" && snap.value as! String != ""{
                        self.cardConnected = true
                    }
                    if snap.key == "email"{
                        self.email = snap.value as! String
                    }
                }
            }
        })
        
        self.categoryLabel.text = self.jobPost.category1
        if promoSuccess == true {
            self.totalPromoDisc.text = "- $5 Promo Discount"
        } else {
            self.totalPromoDisc.text = "- $0 Promo Discount"
        }
        if jobPost.category1 == "Moving(Home-To-Home)"{
            self.homeToHomeView.isHidden = false
            self.pickupLabel.text = jobPost.pickupLocation
            self.dropoffLabel.text = jobPost.dropOffLocation
            self.totalHaulingFee.text = "+ $10 Hauling Fee"
            
        } else {
            self.homeToHomeView.isHidden = true
            self.locationLabel.text = jobPost.location
            self.totalHaulingFee.text = "+ $0 Hauling Fee"
        }
        self.dateLabel.text = jobPost.date
        self.timeLabel.text = jobPost.startTime
        self.totalBaselineCost.text = "$25 Baseline Cost"
        self.totalHoursWorked.text = "x \(jobPost.jobDuration!) hours"
        if self.toolCount == 0{
            self.totalToolFee.text = "+ $0 Tool Fee"
            
            
        } else {
            self.totalToolFee.text = "+ $5 Tool Fee"
        }
        self.totalWorkerCount.text = "x \(jobPost.workerCount!) Workers"
        
        
        var calcRate = ((25 * (Int(jobPost.jobDuration!)!)) * (jobPost.workerCount as! Int))
        if jobPost.category1 == "Moving(Home-To-Home)"{
            calcRate = calcRate + 10
            
        }
        if jobPost.tools?.count != 0 && jobPost.tools?.count != nil {
            calcRate = calcRate + 5
            self.toolCount = (jobPost.tools?.count)!
        } else {
            self.toolCount = 0
        }
        self.jobPost.payment = String(describing:calcRate)
        
        self.totalFinalCost.text = "$\(jobPost.payment!)"
        
        self.detailsTextView.text = jobPost.additInfo
        print("toolCount: \(self.jobPost.tools?.count)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == ""{
            textField.placeholder = "Enter Promo Code"
            
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PostJobToEditDetails"{
            if let vc = segue.destination as? Finalize{
                vc.edit = true
                vc.jobPostEdit = self.jobPost
                vc.toolCount = self.toolCount
                vc.jobCoord = self.jobCoord
            }
        }
        if segue.identifier == "PostJobToEditTime"{
            if let vc = segue.destination as? JobPostTimeViewController{
                vc.edit = true
                vc.jobPostEdit = self.jobPost
                vc.toolCount = self.toolCount
                vc.jobCoord = self.jobCoord
            }
        }
        if segue.identifier == "PostJobToEditDate"{
            if let vc = segue.destination as? JobPostDateAndTimeViewController{
                vc.edit = true
                vc.jobPostEdit = self.jobPost
                vc.toolCount = self.toolCount
                vc.jobCoord = self.jobCoord
            }
        }
        if segue.identifier == "PostJobToEditLoc"{
            if let vc = segue.destination as? JobPostLocationPickerViewController{
                vc.edit = true
                vc.jobPostEdit = self.jobPost
                vc.toolCount = self.toolCount
            }
        }
        if segue.identifier == "PostJobToEditCat"{
            if let vc = segue.destination as? JobPostCategoryViewController{
                vc.edit = true
                vc.jobPostEdit = self.jobPost
            }
        }
        
    }
    

}
