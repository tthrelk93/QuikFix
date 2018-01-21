//
//  JobPosterProfileViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/12/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseMessaging
import FirebaseDatabase
import SwiftOverlays
import MessageUI
import FacebookCore
//import FacebookShare
import FBSDKCoreKit
import FBSDKShareKit
import Contacts
import ContactsUI
import Social
import CoreLocation
//import GoogleAPIClientForREST
//import GoogleSignIn



protocol RateDelegate {
    func submitPressed(rating: Double, feedback: String)
    
}





class JobPosterProfileViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, PerformSegueInJobPostViewController, MessagingDelegate, RateDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, CNContactPickerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var submitRatingButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var statementLabel: UILabel!
    
    
    @IBAction func shareOnFacebookPressed(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        //vc.add(imageView.image!)
        //vc.add(URL(string: "http://www.example.com/"))
        vc?.setInitialText("Download QuikFix!")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBOutlet weak var completeButton: UIButton!
    /*private let scopes = [kGTLRAuthScopeGmailReadonly]
    
    private let service = GTLRGmailService()
    let signInButton = GIDSignInButton()
    let output = UITextView()*/
    @IBAction func shareGmailPressed(_ sender: Any) {
        /*var gtlMessage = GTLGmailMessage()
        gtlMessage.raw = self.generateRawString()
        
        let appd = UIApplication.shared().delegate as! AppDelegate
        let query = GTLQueryGmail.queryForUsersMessagesSendWithUploadParameters(nil)
        query.message = gtlMessage
        
        appd.service.executeQuery(query, completionHandler: { (ticket, response, error) -> Void in
            println("ticket \(ticket)")
            println("response \(response)")
            println("error \(error)")
        })*/
    }
    /*func generateRawString() -> String {
        
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"; //RFC2822-Format
        var todayString:String = dateFormatter.stringFromDate(NSDate())
        
        var rawMessage = "" +
            "Date: \(todayString)\r\n" +
            "From: <mail>\r\n" +
            "To: username <mail>\r\n" +
            "Subject: Test send email\r\n\r\n" +
        "Test body"
        
        println("message \(rawMessage)")
        
        return GTLEncodeWebSafeBase64(rawMessage.dataUsingEncoding(NSUTF8StringEncoding))
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.output.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchLabels()
        }
    }
    
    // Construct a query and get a list of upcoming labels from the gmail API
    func fetchLabels() {
        output.text = "Getting labels..."
        
        let query = GTLRGmailQuery_UsersLabelsList.query(withUserId: "me")
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    // Display the labels in the UITextView
    func displayResultWithTicket(ticket : GTLRServiceTicket,
                                 finishedWithObject labelsResponse : GTLRGmail_ListLabelsResponse,
                                 error : NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        var labelString = ""
        if let labels = labelsResponse.labels, labels.count > 0 {
            labelString += "Labels:\n"
            for label in labels {
                labelString += "\(label.name!)\n"
            }
        } else {
            labelString = "No labels found."
        }
        output.text = labelString
    }
    
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }*/
    @IBAction func actionButtonPressed(_ sender: Any) {
        completeAccountView.isHidden = false
        actionButton.isHidden = false
        
    }
    
     var verificationTimer : Timer = Timer()
    func checkIfTheEmailIsVerified(){
        
        Auth.auth().currentUser?.reload(completion: { (err) in
            if err == nil{
                
                if Auth.auth().currentUser!.isEmailVerified{
                    
                    
                    self.verificationTimer.invalidate()     //Kill the timer
                    Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(self.uploadDict)
                    self.completeAccountView.isHidden = true
                    self.actionButton.isHidden = true
                    self.loadData()
                    return
                } else {
                    
                    print("It aint verified yet")
                    
                }
            } else {
                
                print(err?.localizedDescription)
                
            }
        })
        
    }
    @IBOutlet weak var actionButton: UIButton!
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        completeAccountView.isHidden = true
    }
    var emailVerificationSent = false
    var uploadDict = [String:Any]()
    @IBAction func completeAccountFromAnonPressed(_ sender: Any) {
       var existingCreditAmount = Int()
        Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots{
                    if snap.key == "availableCredits"{
                        existingCreditAmount = snap.value as! Int
                    }
                }
            }
            
        })
        
        if (nameTF.text != "First Name" && nameTF.hasText == true) &&  (emailTF.text != "Email" && emailTF.hasText == true) && (passwordTF.text != "Password" && passwordTF.hasText == true) && (confirmPasswordTF.text != "Confirm Password" && confirmPasswordTF.hasText == true) && cellPhoneTF.hasText == true {
            if confirmPasswordTF.text != passwordTF.text{
                //present error passwords don't match
                let alert = UIAlertController(title: "Password Error", message: "Passwords do not match.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                //student.bio = ""
                self.uploadDict["name"] = nameTF.text!
                self.uploadDict["email"] = emailTF.text!
                // poster.password = passwordTextField.text
                //student.school = ""
                //student.major = ""
                //uploadDict["jobsCompleted"] = [String: [String:Any]]()
                //uploadDict["currentListings"] = [String: [String:Any]]()
                //uploadDict["upcomingJobs"] = [String: [String:Any]]()
                // student.rating = Int()
                self.uploadDict["responses"] = [String:Any]()
                self.uploadDict["phone"] = cellPhoneTF.text!
                
                self.uploadDict["availableCredits"] = existingCreditAmount + 5
                let credential = EmailAuthProvider.credential(withEmail: emailTF.text!, password: passwordTF.text!)
                
                Auth.auth().currentUser!.link(with: credential) { (user, error) in
                    if !self.emailVerificationSent {
                        
                        if error != nil {
                            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        if !(user!.isEmailVerified) {
                            print("emailVer == false")
                            let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.emailTF.text)). Your account will be created  and ready for use upon return to the app.", preferredStyle: .alert)
                            let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
                                (_) in
                                user?.sendEmailVerification(completion: nil)
                                self.completeButton.setTitle("Re-send Verificaion Email", for: .normal)
                                
                                
                                self.verificationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkIfTheEmailIsVerified) , userInfo: nil, repeats: true)
                                
                            }
                            let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                            
                            alertVC.addAction(alertActionCancel)
                            
                            alertVC.addAction(alertActionOkay)
                            self.present(alertVC, animated: true, completion: nil)
                            self.emailVerificationSent = true
                        } else {
                            print("emailVer == true")
                            //self.performSegue(withIdentifier: "CreatePosterStep1ToStep2", sender: self)
                        }
                    }  else {
                    let alertVC = UIAlertController(title: "Verify Email Address", message: "Select Send to get a verification email sent to \(String(describing: self.emailTF.text)). Your account will be created  and ready for use upon return to the app.", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
                        (_) in
                        user?.sendEmailVerification(completion: nil)
                        self.completeButton.setTitle("Resend Email Verification", for: .normal)
                        
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionCancel)
                    
                    alertVC.addAction(alertActionOkay)
                    self.present(alertVC, animated: true, completion: nil)
                    self.emailVerificationSent = true
                    
                }
                }
                
            }
        } else {
            
            let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
                
    }
        
    
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var cellPhoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    @IBOutlet weak var completeAccountView: UIView!
    
    
    
    
    
    
    
    @IBAction func shareTwitterPressed(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
        //vc.add(imageView.image!)
        //vc.add(URL(string: "http://www.example.com/"))
        vc?.setInitialText("Download QuikFix!")
        self.present(vc!, animated: true, completion: nil)
    }
    @IBAction func shareSMSPressed(_ sender: Any) {
        print("supdewd")
        self.contactType = "phone"
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
        
        
        
    }
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        print("sup")
        self.dismiss(animated: true, completion: nil)
    }
    var contactType = String()
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact){
        print("in contact delegate")
        print("contactType: \(self.contactType)")
        if contactType == "phone"{
        if contact.phoneNumbers.count > 0 {
            print("can send text")
            var contactText = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                // add in app store link when ready
                controller.body = "Download QuikFix using the promo code \(self.promoCode.text!) and receive $5 off your first job!"
                controller.recipients = [contactText!]
                controller.messageComposeDelegate = self
                DispatchQueue.main.async{
                    self.present(controller, animated: true, completion: nil)
                }
            }
        } else {
            print("can't send text")
            //self.txtP1.text = ""
        }
        } else {
            print("in email")
                if contact.emailAddresses.count > 0 {
                    let email = "\(contact.emailAddresses[0].value)"
                    
                    print("no mail error")
                    if MFMailComposeViewController.canSendMail() {
                        print("really no mail error")
                        
                        
                        DispatchQueue.main.async{
                            let controller = MFMailComposeViewController()
                            controller.setMessageBody("Need help moving, doing yard work, assembling furniture, installing electronics? Download Quikfix on the iOS App Store and instantly find local hardworking students who are eager and qualified to get jobs like these done and off your to-do list. Download QuikFix using the promo code \(self.promoCode.text!) and receive $5 off your first job!", isHTML: false)
                            controller.setToRecipients([email])
                            controller.setSubject("Download QuikFix today and get $5 off your first job!")
                            controller.mailComposeDelegate = self
                            self.present(controller, animated: true, completion: nil)
                        }
                        
                    } else {
                        print("mail error")
                        showMailError()
                    }
                    //self.lblE1.text = eLabel3[0] //Work
                } else {
                    print("no email address bitchhhh")
                   // self.txtE1.text = ""
                   // self.lblE1.text = "Email 1"
                }
            }
        
        
    }
    
    public func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty){
        
    }
    
    
    
    
    
    
    @IBAction func shareEmailPressed(_ sender: Any) {
        print("shareEmail")
        self.contactType = "email"
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["andrew@seemuapps.com"])
        mailComposerVC.setSubject("Hello")
        mailComposerVC.setMessageBody("How are you doing?", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("done")
        DispatchQueue.main.async {
            controller.dismiss(animated: true, completion: nil)
        }
        
    }

    
    
    
    
    @IBAction func rateExpPressed(_ sender: Any) {
        rateExp.isHidden = true
        statementLabel.isHidden = true
        rateCollect.isHidden = false
    }
    
    @IBOutlet weak var rateExp: UIButton!
    //var newRating = Int()
    func submitPressed(rating: Double, feedback: String){
        var intRating = rating
        var keys1 = [String]()
        for (key, val) in self.completedWaitingObjects{
            keys1.append(key)
        }
        if (collectIndex + 1) == currentCollectData.count{
            currentCollectData.removeAll()
            Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
            var containsJC = false
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots{
                    
                    if ((self.completedWaitingObjects[keys1[self.collectIndex]]!)["workers"] as! [String]).contains(snap.key){
                        let stud = snap.value as! [String:Any]
                        self.currentCollectData.append(stud)
                        
                        let numCompleted = (stud["completedCount"] as! Int) + 1
                        let curRating = ((stud["rating"] as! Double) + rating) / Double(numCompleted)
                        print("updatedRating: \(curRating)")
                        if feedback == "Tap here to tell us any additional information about how this worker did (optional)" {
                            Database.database().reference().child("students").child(stud["studentID"] as! String).updateChildValues(["rating":curRating, "completedCount": numCompleted])
                        } else {
                            
                            var feedbackDict = [String:Any]()
                                var tempDict = [String:Any]()
                                tempDict[((self.completedWaitingObjects[keys1[self.collectIndex]]!)["jobID"] as! String)] = ["posterID":((self.completedWaitingObjects[keys1[self.collectIndex]]!)["posterID"] as! String), "optionalFeedback": feedback]
                            //feedbackDict["feedback": tempDict]
                                Database.database().reference().child("students").child(stud["studentID"] as! String).updateChildValues(["rating":curRating, "completedCount": numCompleted, "feedback": tempDict])
                            
                        }
                        
                        Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            var tempDict = [String: [String:Any]]()
                            var tempJC = [String: [String:Any]]()
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                
                                for snap in snapshots{
                                    if snap.key == "completedWaitingReview"{
                                        var tempDict2 = snap.value as! [String: [String:Any]]
                                        var keys = [String]()
                                        for (key, _) in tempDict2{
                                            keys.append(key)
                                        }
                                        
                                        for job in keys {
                                            if job == ((self.completedWaitingObjects[keys[self.collectIndex]]!)["jobID"] as! String){
                                                
                                            } else {
                                                tempDict[job] = tempDict2[job] as! [String:Any]
                                            }
                                        }
                                        print("tempDictJWR: \(tempDict)")
                                       // tempArray.remove(at: tempArray.index(of: self.completedWaitingObjects[self.collectIndex]["jobID"] as! String)!)
                                       // print("tempArray: \(tempArray)")
                                        //add it to jobsCompleted
                                        
                                        
                                    }
                                    
                                    if snap.key == "jobsCompleted"{
                                        containsJC = true
                                        tempJC = snap.value as! [String: [String:Any]]
                                        tempJC[(self.completedWaitingObjects[keys1[self.collectIndex]]!)["jobID"] as! String] = (self.completedWaitingObjects[keys1[self.collectIndex]]!)
                                    }
                                }
                                if containsJC == false{
                                    tempJC[self.completedWaitingObjects[keys1[self.collectIndex]]!["jobID"] as! String] = (self.completedWaitingObjects[keys1[self.collectIndex]]!)
                            }
                                Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(["completedWaitingReview": tempDict, "jobsCompleted": tempJC])
                            }
                        })
                    }
                }
                self.collectIndex = 0
                self.rateCollect.delegate = self
                self.rateCollect.dataSource = self
                DispatchQueue.main.async{
                    self.rateCollect.reloadData()
                }
            }
        })
        } else {
            //uploadRating and move on to next student
            Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots{
                        if ((self.completedWaitingObjects[keys1[self.collectIndex]]!)["workers"] as! [String]).contains(snap.key){
                            let stud = snap.value as! [String:Any]
                            let numCompleted = (stud["completedCount"] as! Int) + 1
                            let curRating = ((stud["rating"] as! Double) + intRating) / Double(numCompleted)
                            print("updatedRating: \(curRating)")
                            
                            if feedback == "Tap here to tell us any additional information about how this worker did (optional)" {
                                Database.database().reference().child("students").child(stud["studentID"] as! String).updateChildValues(["rating":curRating, "completedCount": numCompleted])
                            } else {
                                
                                var feedbackDict = [String:Any]()
                                var tempDict = [String:Any]()
                                tempDict[((self.completedWaitingObjects[keys1[self.collectIndex]]!)["jobID"] as! String)] = ["posterID":((self.completedWaitingObjects[keys1[self.collectIndex]]!)["posterID"] as! String), "optionalFeedback": feedback]
                                //feedbackDict["feedback": tempDict]
                                Database.database().reference().child("students").child(stud["studentID"] as! String).updateChildValues(["rating":curRating, "completedCount": numCompleted, "feedback": tempDict])
                                
                            }
                            
                            
                        }
                    }
            
        
            let collectionBounds = self.rateCollect.bounds
            let contentOffset = CGFloat(floor(self.rateCollect.contentOffset.x + collectionBounds.size.width))
            self.moveToFrame(contentOffset: contentOffset)
            self.collectIndex = self.collectIndex + 1
                }
            })
        
        }
        if self.completedWaitingObjects.count - 1 == 0{
            jobRateView.isHidden = true
            self.postJobsButton.isHidden = false
            self.menuButton.isHidden = false
        }
        
        
    
    }
    @IBOutlet weak var jobRateTopLabel: UILabel!
    @IBOutlet weak var rateViewStars: CosmosView!
    @IBOutlet weak var jobRateHowDidLabel: UILabel!
    @IBOutlet weak var jobRateCategory: UILabel!
    // fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBOutlet weak var jobRateWorkerName: UILabel!
    
    @IBOutlet weak var jobRateView: UIView!
    
    @IBOutlet weak var jobRateImageView: UIImageView!
    
    @IBOutlet weak var promoTextButton: UIButton!
    @IBOutlet weak var myJobsTextButton: UIButton!
    @IBOutlet weak var dealsTextButton: UIButton!
    
    //@IBOutlet weak var postSuccessShadeView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    //@IBOutlet weak var guillotineMenuButton: UIButton!
    @IBAction func currentListingsButtonPressed(_ sender: Any) {
      
        self.jobType = "cl"
        performSegue(withIdentifier: "MyJobsToJobLog", sender: self)
        
        
        
        //self.jobHistoryTableView.delegate = self
        //self.jobHistoryTableView.dataSource = self
        /*DispatchQueue.main.async{
            self.jobHistoryTableView.reloadData()
            self.currentListingsView.isHidden = false
        }*/
        
        
        
        
        
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        currentListingsView.isHidden = true
    }
    var jobType = String()
    @IBOutlet weak var currentListingsButton: UIButton!
    var promo = String()
    @IBAction func okayPressed(_ sender: Any) {
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    
                    if snap.key == "currentListings"{
                        self.currentListingsCount.text = String(describing: (snap.value as! [String]).count)
                        //self.postSuccessShadeView.isHidden = true
                        //self.jobPostedView.isHidden = true
                        self.postJobsButton.isHidden = false
                        break
                    }
                }
            }
        })

        

    }
    
    
    @IBOutlet weak var infoViewPos2: UIView!
    
    
    @IBOutlet weak var sharePromo: UIButton!
    var extended = false
    fileprivate var animationOptions: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
    @IBAction func popoutMenuPressed(_ sender: Any) {
        
        if extended == true{
            UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.sharePromo.isHidden = false
                self.myJobs.isHidden = false
                self.dealsButton.isHidden = false
                self.sharePromo.bounds = self.menuButton2ExtendedFrame
                self.sharePromo.frame.origin = self.menuButton2ExtendedOrigin
                
                self.dealsButton.bounds = self.menuButton2ExtendedFrame
                self.dealsButton.frame.origin = self.menuButton2ExtendedOrigin
                
                self.myJobs.bounds = self.menuButton2ExtendedFrame
                self.myJobs.frame.origin = self.menuButton2ExtendedOrigin
                
                
                
                
                
                
                
                
                
            })
            DispatchQueue.main.async{
            UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: self.animationOptions, animations: {
                self.sharePromo.bounds = self.menuButton1ExtendedFrame
                self.sharePromo.frame.origin = self.menuButton1ExtendedOrigin
                
                self.dealsButton.bounds = self.menuButton3ExtendedFrame
                self.dealsButton.frame.origin = self.menuButton3ExtendedOrigin
                
                self.extended = true
                
                
            })
        }
    } else {
            
           print("extendedFalse")
            UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
                self.sharePromo.isHidden = false
                self.myJobs.isHidden = false
                self.dealsButton.isHidden = false
                self.sharePromo.bounds = self.menuButton1ExtendedFrame
                self.sharePromo.frame.origin = self.menuButton1ExtendedOrigin
                
                self.dealsButton.bounds = self.menuButton3ExtendedFrame
                self.dealsButton.frame.origin = self.menuButton3ExtendedOrigin
                
                self.myJobs.bounds = self.menuButton2ExtendedFrame
                self.myJobs.frame.origin = self.menuButton2ExtendedOrigin
                
                
            })
           
            
            self.hideMenuButton.isHidden = true
            self.extended = false
            
            
    
    }
}
    
    @IBOutlet weak var currentListingsLabel: UILabel!
    
    @IBOutlet weak var upcomingJobsLabel: UILabel!
    
    @IBOutlet weak var popoutMenuButton: UIButton!
    @IBAction func sharePromoPressed(_ sender: Any) {
        if promoCodeView.isHidden == true{
            promoCodeView.isHidden = false
            currentListingsLabel.isHidden = true
            upcomingJobsLabel.isHidden = true
            currentListingsCount.isHidden = true
            jobsCompletedCount.isHidden = true
            sepLineVertical.isHidden = true
            self.askForContactAccess()
        } else {
            promoCodeView.isHidden = true
            currentListingsLabel.isHidden = false
            upcomingJobsLabel.isHidden = false
            currentListingsCount.isHidden = false
            jobsCompletedCount.isHidden = false
           // sepLineVertical.isHidden = false
        }
        
    }
    @IBOutlet weak var myJobs: UIButton!
    
    @IBAction func myJobsPressed(_ sender: Any) {
        promoCodeView.isHidden = true
        currentListingsLabel.isHidden = false
        upcomingJobsLabel.isHidden = false
        currentListingsCount.isHidden = false
        jobsCompletedCount.isHidden = false
        //sepLineVertical.isHidden = false
        self.jobType = "jc"
        performSegue(withIdentifier: "MyJobsToJobLog", sender: self)
        
    }
    @IBOutlet weak var currentListingsView: UIView!
   // @IBOutlet weak var jobPostedView: UIView!
    @IBAction func responseBubblePressed(_ sender: Any) {
        
        
    }
    
    @IBOutlet weak var availableHoursLabel: UILabel!
    @IBAction func dealsPressed(_ sender: Any) {
        promoCodeView.isHidden = true
        currentListingsLabel.isHidden = false
        upcomingJobsLabel.isHidden = false
        currentListingsCount.isHidden = false
        jobsCompletedCount.isHidden = false
        performSegue(withIdentifier: "ProfToDeals", sender: self)
       // sepLineVertical.isHidden = false
    }
    @IBOutlet weak var dealsButton: UIButton!
    
    
    
    
    @IBOutlet weak var responseBubble: UIButton!
    @IBOutlet weak var postJobsButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func postJobPressed(_ sender: Any) {
    }
    @IBOutlet weak var jobsCompletedCount: UILabel!
    @IBOutlet weak var currentListingsCount: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    //var showJobPostedView: Bool?
    func menuSelected(_ sender: Any){
        
        
        
    }
    
    var currentListings = [String]()
    var currentListingsObj = [String:[String:Any]]()
    
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBAction func showMenuAction(_ sender: UIButton) {
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
       
    }

   
    //var actualMenuBounds
    var curListBool = false
    let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    let qfRed = UIColor(colorLiteralRed: 160/255, green: 25/255, blue: 9/255, alpha: 1.0)
    var menuButton1ExtendedFrame = CGRect()
    var menuButton1ExtendedOrigin = CGPoint()
    var menuButton2ExtendedFrame = CGRect()
    var menuButton2ExtendedOrigin = CGPoint()
    var menuButton3ExtendedFrame = CGRect()
    var menuButton3ExtendedOrigin = CGPoint()
    
    @IBAction func hideMenuPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: animationOptions, animations: {
            self.sharePromo.bounds = self.myJobs.bounds
            self.sharePromo.frame.origin = self.myJobs.frame.origin
            
            self.dealsButton.bounds = self.myJobs.bounds
            self.dealsButton.frame.origin = self.myJobs.frame.origin
            
        })
        DispatchQueue.main.async{
            UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: self.animationOptions, animations: {
                self.sharePromo.bounds = self.popoutMenuButton.bounds
                self.sharePromo.frame.origin = self.popoutMenuButton.frame.origin
                
                self.dealsButton.bounds = self.popoutMenuButton.bounds
                self.dealsButton.frame.origin = self.popoutMenuButton.frame.origin
                self.myJobs.bounds = self.popoutMenuButton.bounds
                self.myJobs.frame.origin = self.popoutMenuButton.frame.origin
                self.hideMenuButton.isHidden = true
                
                //self.sharePromo.isHidden = true
                //self.myJobs.isHidden = true
                //self.dealsButton.isHidden = true
                
            })
        }
        
        
    }
    
    @IBAction func upcomingJobsPressed(_ sender: Any) {
       
        
        self.jobType = "uj"
        performSegue(withIdentifier: "MyJobsToJobLog", sender: self)
        //self.jobHistoryTableView.delegate = self
        //self.jobHistoryTableView.dataSource = self
        /*DispatchQueue.main.async{
            self.jobHistoryTableView.reloadData()
            self.currentListingsView.isHidden = false
        }*/
        
    }
    
    //fileprivate var animationOptions: UIViewAnimationOptions = [.curveEaseInOut, .beginFromCurrentState]
    
    
    @IBOutlet weak var upcomingJobsButton: UIButton!
    @IBOutlet weak var promoCodeView: UIView!
    
    @IBOutlet weak var jobInProgressInfoView: UIView!
    @IBOutlet weak var normalInfoView: UIView!
    @IBOutlet weak var sepLineVertical: UIView!
    @IBOutlet weak var promoCode: UILabel!
    
    @IBOutlet weak var metalBar: UIImageView!
    @IBOutlet weak var hideMenuButton: UIButton!
    var inProgressObj = [String: [String:Any]]()
    var location = CLLocation()
    var mToken = String()
    var upcomingJobs = [String]()
    var upcomingJobsObj = [String: [String:Any]]()
    //let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    var jobsCompleted = [String: [String: Any]]()
    var completedWaiting = [String]()
    var completedWaitingBool = false
   // var jobsCompleted
    
    @IBOutlet weak var facebookShareButtonBounds: UIButton!
    var infoBounds = CGRect()
    var infoOrigin = CGPoint()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
       


        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        nameTF.delegate = self
        cellPhoneTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmPasswordTF.delegate = self
        actionButton.layer.cornerRadius = actionButton.frame.width/2
        
        if Auth.auth().currentUser?.isAnonymous == true{
            actionButton.isHidden = false
        }
        
        
        self.statementLabel.layer.cornerRadius = 7
        self.rateCollect.register(UINib(nibName: "RateCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RateCell")
        statementLabel.layer.cornerRadius = 7
        rateExp.layer.cornerRadius = 7
        infoBounds = normalInfoView.bounds
        infoOrigin = normalInfoView.frame.origin
        sepLineVertical.isHidden = true
        
        //let content1 = FacebookShareLinkContent()
        var content = FBSDKShareLinkContent()
        
        content.contentURL = NSURL(string: "www.google.com")! as URL
        
        content.contentTitle = "Download QuikFix!"
        content.contentDescription = "Use promo code \(self.promoCode.text) during sign up and get $5 off you're first QuikFix job!"
        // content.imageURL = NSURL(string: "<INSERT STRING HERE>") as! URL
        
        let button = FBSDKShareButton()
        button.shareContent = content
        button.isHidden = true
        
        button.frame = facebookShareButtonBounds.frame
        button.bounds = facebookShareButtonBounds.bounds
        
        self.promoCodeView.addSubview(button)
        self.promoCodeView.bringSubview(toFront: button)
        self.promoTextButton.setTitleColor(qfGreen, for: .normal)
        self.myJobsTextButton.setTitleColor(qfGreen, for: .normal)
        self.dealsTextButton.setTitleColor(qfGreen, for: .normal)
        //metalBar.layer.cornerRadius = 8
        // metalBar.layer.borderWidth = 1
        // metalBar.layer.borderColor = qfRed.cgColor
        responseBubble.isHidden = true
        Messaging.messaging().delegate = self
        self.mToken = Messaging.messaging().fcmToken!
        print("token: \(mToken)")
        //appDelegate.deviceToken
        var tokenDict = [String: Any]()
        
        tokenDict["deviceToken"] = [mToken: true] as [String:Any]?
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).updateChildValues(tokenDict)
        //appDelegate.deviceToken
        
        
        menuButton1ExtendedFrame = sharePromo.bounds
        menuButton1ExtendedOrigin = sharePromo.frame.origin
        menuButton2ExtendedFrame = myJobs.bounds
        menuButton2ExtendedOrigin = myJobs.frame.origin
        
        menuButton3ExtendedFrame = dealsButton.bounds
        menuButton3ExtendedOrigin = dealsButton.frame.origin
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowRadius = profileImageView.frame.width + 20
        
        responseBubble.layer.cornerRadius = responseBubble.frame.width/2
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        var responseBool = false
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots{
                    if snap.key == "completedWaitingReview"{
                        self.completedWaitingBool = true
                        self.completedWaitingObjects = snap.value as! [String: [String:Any]]
                    }
                    if snap.key == "jobsCompleted"{
                        self.jobsCompleted = snap.value as! [String: [String:Any]]
                    }
                    if snap.key == "creditHours"{
                        print("creditHours")
                        self.availableHoursLabel.text = "\(Int((snap.value as? Double)!)) prepaid hours"
                    }
                    if snap.key == "name"{
                        //(self.navigationBar as UINavigationBar). //
                        self.nameLabel.text = snap.value as! String
                        
                    }
                    else if snap.key == "promoCode"{
                        let tempDict = snap.value as! [String:Any]
                        self.promoCode.text = tempDict.keys.first
                    }
                        
                    else if snap.key == "pic"{
                        if let messageImageUrl = URL(string: snap.value as! String) {
                            
                            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                                self.profileImageView.image = UIImage(data: imageData as Data) } }
                        //  loadImageUsingCacheWithUrlString(snap.value as! String)
                    }
                    else if snap.key == "currentListings"{
                        self.currentListingsObj = snap.value as! [String: [String:Any]]
                        self.curListBool = true
                        self.currentListingsCount.text = String(describing: self.currentListingsObj.count)
                    }
                    else if snap.key == "upcomingJobs"{
                        self.upcomingJobsObj = snap.value as! [String: [String:Any]]
                        
                        self.jobsCompletedCount.text = String(describing: self.upcomingJobsObj.count)
                    } else if snap.key == "location"{
                        var tempDict = snap.value as! [String: Any]
                        self.location = CLLocation(latitude: tempDict["lat"] as! CLLocationDegrees, longitude: tempDict["long"] as! CLLocationDegrees)
                        
                        let geoCoder = CLGeocoder()
                        
                        geoCoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) -> Void in
                            
                            // Place details
                            var placeMark: CLPlacemark!
                            placeMark = placemarks?[0]
                            
                            // Address dictionary
                            print(placeMark.addressDictionary as Any)
                            
                            // City
                            if let city = placeMark.addressDictionary!["City"] as? NSString {
                                print(city)
                                self.cityLabel.text = city as String
                            }
                        })
                    }
                }
                /*if responseBool == false{
                 self.responseBubble.isHidden = true
                 } else {
                 self.responseBubble.isHidden = false
                 }*/
                if self.curListBool == false{
                    self.currentListingsCount.text = "0"
                }
                
            }
            SwiftOverlays.removeAllBlockingOverlays()
            
            
            
            for (key, val) in self.upcomingJobsObj {
                var tempJob = val as! [String:Any]
                
                if tempJob["inProgress"] as! Bool == true{
                    self.containsInProgress = true
                    self.inProgressObj[key] = tempJob
                }
                
            }
            
            
            if self.completedWaitingBool == true{
                //show rating and review page
                self.postJobsButton.isHidden = true
                self.menuButton.isHidden = true
                
                self.jobRateView.isHidden = false
                if self.completedWaitingObjects.count == 1{
                    self.jobRateTopLabel.text = "You have \(self.completedWaitingObjects.count) job to rate"
                } else {
                    
                    self.jobRateTopLabel.text = "You have \(self.completedWaitingObjects.count) jobs to rate"
                }
                Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        
                        for snap in snapshots{
                            if (self.completedWaitingObjects.first?.value["workers"] as! [String]).contains(snap.key){
                                let stud = snap.value as! [String:Any]
                                self.currentCollectData.append(stud)
                            }
                        }
                        self.rateCollect.delegate = self
                        self.rateCollect.dataSource = self
                    }
                })
            } else {
                self.jobRateView.isHidden = true
            }
            if self.containsInProgress == true{
                UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: self.animationOptions, animations: {
                    self.normalInfoView.bounds = self.infoViewPos2.bounds
                    self.normalInfoView.frame.origin = self.infoViewPos2.frame.origin
                    //  self.normalInfoView.bounds = CGRect(origin: CGPoint(x: self.normalInfoView.frame.origin.x, y: (self.normalInfoView.frame.origin.y - 60.0)), size: self.normalInfoView.bounds.size)
                    self.jobInProgressInfoView.isHidden = false
                    self.inProgressCount.text = String(describing: self.inProgressObj.count)
                    
                })
            }
            
        })
    }
    
    var collectIndex = 0
    var currentCollectData = [[String:Any]]()
    var completedWaitingObjects = [String: [String:Any]]()
    @IBAction func inProgressPressed(_ sender: Any) {
    }
    
    
    var containsInProgress = false
    var jobsForDate = [JobPost]()
    var tableViewData = [JobPost]()
    var calendarDict = [String:Any]()
    var datesArray = [String]()
    
    @IBOutlet weak var inProgressCount: UILabel!
    
    @IBOutlet weak var jobHistoryTableView: UITableView!
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return calendarDict.count
    }
    
    @IBOutlet weak var rateCollect: UICollectionView!
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateTableCell",
                                                 for: indexPath) as! DateTableViewCell
        
        configureTableViewCell(tableView: tableView, cell: cell, indexPath: indexPath)
        // (cell as! DateTableViewCell).cal.delegate = self
        //(cell as! DateTableViewCell).jobsCollect.dataSource = self
        
        return cell
    }
    var sizingCell: DateCollectionViewCell?
    func configureTableViewCell(tableView: UITableView, cell: DateTableViewCell, indexPath: IndexPath){
        cell.dateLabel?.text = datesArray[indexPath.row]
        cell.layer.borderColor = UIColor.clear.cgColor
        for (key, val) in calendarDict{
            if key == datesArray[indexPath.row]{
                print()
                self.jobsForDate = (val as! [JobPost])
                cell.jobsForDate = val as! [JobPost]
                
                cell.calCollect.dataSource = cell
                cell.calCollect.delegate = cell
                cell.calCollect.heightAnchor.constraint(equalToConstant: (147.0 * CGFloat(jobsForDate.count)) + 37).isActive = true
                
                cell.delegate = self
                cell.category = self.categoryType
                break
            }
        }
    }
    var categoryType = String()
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        //let tempCell = DateCollectionViewCell()
        //print("TVCheight: \((tempCell.frame.height * CGFloat(jobsForDate.count)))")
        return ((142.0 * CGFloat(jobsForDate.count)) + 25)
    }
    var selectedJobID = String()
    var selectedJob = JobPost()
    
    func performSegueToSingleJob(category: String, jobID: String, job: JobPost){
        
        self.selectedJobID = jobID
        self.selectedJob = job
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func askForContactAccess() {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if !access {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async{
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts."
                            let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            
                            let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
                            
                                
                                
                                
                            }
                            
                            alertController.addAction(dismissAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            })
            break
        default:
            break
        }
    }
    
    var contactStore = CNContactStore()
    
   /* @available(iOS 2.0, *)
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        print("pressss")
       // presentationAnimator.animationDuration = 0.1
       // presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    
    @available(iOS 2.0, *)
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        print("dissss")
        presentationAnimator.animationDuration = 0.1
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }*/
    
    /*func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if let refreshedToken = InstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
    }*/
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        var tokenDict = [String: Any]()
        
        
        tokenDict["deviceToken"] = [fcmToken: true] as [String: Any]?
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).updateChildValues(tokenDict)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    

    @IBAction func menuPressed(_ sender: Any) {
        performSegue(withIdentifier: "PosterToMenu", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PosterToMenu"{
            if let vc = segue.destination as? MenuViewController{
                vc.promo = self.promo
                vc.name = self.nameLabel.text!
            }
        }
        if segue.identifier == "MyJobsToJobLog"{
                if let vc = segue.destination as? JobHistoryViewController{
                    vc.senderScreen = "poster"
                    vc.jobType = self.jobType
                }
            }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentCollectData.count
    }
    var jobID = String()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RateCell", for: indexPath) as! RateCellCollectionViewCell
        if let messageImageUrl = URL(string: currentCollectData[indexPath.row]["pic"] as! String) {
            
            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                cell.ratePic.image = UIImage(data: imageData as Data)
                
            } }
        var keys1 = [String]()
        for (key, _) in self.completedWaitingObjects{
            keys1.append(key)
        }
        cell.rateName.text = currentCollectData[indexPath.row]["name"] as? String
        cell.categoryLabel.text = completedWaitingObjects[keys1[self.collectIndex]]!["category1"] as? String
        cell.questionLabel.text = "How did \(currentCollectData[indexPath.row]["name"]!) do today?"
        cell.rateDelegate = self
        //cell.layer.cornerRadius = cell.frame.width/2
        
        
        
        
        return cell
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTF {
            textField.text = textField.text?.capitalizingFirstLetter()
        }
        
    }
    func moveToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : self.rateCollect.contentOffset.y ,width : self.rateCollect.frame.width,height : self.rateCollect.frame.height)
        self.rateCollect.scrollRectToVisible(frame, animated: true)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == cellPhoneTF)
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
    

}

// Handle the user's selection.


