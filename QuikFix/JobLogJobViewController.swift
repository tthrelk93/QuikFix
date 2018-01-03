//
//  JobLogJobViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/17/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Stripe
import CoreLocation

class JobLogStudentCell: UICollectionViewCell{
    @IBOutlet weak var studentPic: UIImageView!
    @IBOutlet weak var studentLabel: UILabel!
    
}

class JobLogJobViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, STPAddCardViewControllerDelegate, STPShippingAddressViewControllerDelegate, STPPaymentCardTextFieldDelegate, STPPaymentMethodsViewControllerDelegate, STPPaymentContextDelegate {
    
    
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
        var tempDict = [String:Any]()
        tempDict["stripeToken"] = token.tokenId
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).updateChildValues(tempDict)
        self.poster.email = "tthrelk@gmail.com"
        self.poster.name = "Thomas"
        
       // MyAPIClient.sharedClient.saveCard(token, email: self.poster.email!, name: self.poster.name!)
         dismiss(animated: true)
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
    
    func handleShippingButtonTapped() {
        // Setup shipping address view controller
        /*let shippingAddressViewController = STPShippingAddressViewController()
        shippingAddressViewController.delegate = self
        
        // Present shipping address view controller
        let navigationController = UINavigationController(rootViewController: shippingAddressViewController)
        present(navigationController, animated: true)*/
    }
    
    // MARK: STPShippingAddressViewControllerDelegate
    
    func shippingAddressViewControllerDidCancel(_ addressViewController: STPShippingAddressViewController) {
        // Dismiss shipping address view controller
        dismiss(animated: true)
    }
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didEnter address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let upsGroundShippingMethod = PKShippingMethod()
        upsGroundShippingMethod.amount = 0.00
        upsGroundShippingMethod.label = "UPS Ground"
        upsGroundShippingMethod.detail = "Arrives in 3-5 days"
        upsGroundShippingMethod.identifier = "ups_ground"
        
        let fedExShippingMethod = PKShippingMethod()
        fedExShippingMethod.amount = 5.99
        fedExShippingMethod.label = "FedEx"
        fedExShippingMethod.detail = "Arrives tomorrow"
        fedExShippingMethod.identifier = "fedex"
        
        if address.country == "US" {
            let availableShippingMethods = [upsGroundShippingMethod, fedExShippingMethod]
            let selectedShippingMethod = upsGroundShippingMethod
            
            completion(.valid, nil, availableShippingMethods, selectedShippingMethod)
        }
        else {
            completion(.invalid, nil, nil, nil)
        }
    }
    var selectedAddress = STPAddress()
    var selectedShippingMethod = PKShippingMethod()
    
    func shippingAddressViewController(_ addressViewController: STPShippingAddressViewController, didFinishWith address: STPAddress, shippingMethod method: PKShippingMethod?) {
        // Save selected address and shipping method
        selectedAddress = address
        selectedShippingMethod = method!
        
        // Dismiss shipping address view controller
        dismiss(animated: true)
    }
    
    
    
    

    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "JobLogJobToJobLog", sender: self)
    }
    @IBOutlet weak var jobCompletedButton: UIButton!
    
    @IBOutlet weak var workersCollect: UICollectionView!
    @IBOutlet weak var jobCatLabel: UILabel!
    @IBOutlet weak var studentWorkersCollect: UICollectionView!
    @IBOutlet weak var numberOfStudentsLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func groupChatPressed(_ sender: Any) {
        performSegue(withIdentifier: "JobLogJobToChat", sender: self)
        
        
    }
    var stripeToken = String()
    let settingsVC = SettingsViewController()
    @IBOutlet weak var groupChatButton: UIButton!
    
    func confirmCancel(){
        var sendJob = [String:Any]()
        sendJob["posterID"] = Auth.auth().currentUser!.uid
        sendJob["jobID"] = self.job.jobID!
        
        print("charge the poster for cancel")
        let tempCharge = 25 * 100
        print("charge in cents: \(tempCharge)")
        MyAPIClient.sharedClient.completeCharge(amount: Int(tempCharge), poster: Auth.auth().currentUser!.uid, job: sendJob, senderScreen: "cancelJob")
        DispatchQueue.main.async{
            self.performSegue(withIdentifier: "cancelJobToPosterProfile", sender: self)
        }
    }
    var removeAcceptedCount = Int()
    var workers2 = [String]()
    func confirmCancel2(){
        var sendJob = [String:Any]()
        sendJob["jobID"] = self.job.jobID!
        sendJob["posterID"] = self.job.posterID!
        var now = Date()
        
        let date = self.job.date!
        var timeComp = self.job.startTime!.components(separatedBy: ":")// .componentsSeparatedByString(":")
        let timeHours = timeComp[0]
        print("timeHours: \(timeHours)")
        let timeHoursInt = (timeHours as NSString).integerValue
        let trigger1Time = timeHoursInt + (Int(self.job.jobDuration!)!)
        var triggerTime = Int()
        if trigger1Time > 12{
            triggerTime = trigger1Time % 12
        } else {
            triggerTime = trigger1Time
        }
        print("modTime:\(triggerTime)")
        let triggerTimeString = "\(String(describing: triggerTime)):\(timeComp[1])"
        print("triggerTime: \(triggerTimeString)")
        let dateToFormat = "\(date) \(triggerTimeString)"
        print("dataToFormat: \(dateToFormat)")
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy h:mm a"
        let triggerDate = dateFormatter.date(from: dateToFormat)
        
        var nowString = dateFormatter.string(from: now)
        var nowDate = dateFormatter.date(from: nowString)
        var minutesUntil = nowDate?.minutes(from: triggerDate!)
        print("minutesUntilJob: \(minutesUntil)")
        
        
        
        if minutesUntil! <= 90 {
            print("charge the student for cancel")
            let tempCharge = 5 * 100
            print("charge in cents: \(tempCharge)")
            Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        var snapDict = snap.value as! [String:Any]
                        let studentLat = (snapDict["location"] as! [String:Any])["lat"] as! CLLocationDegrees
                        let studentLong = (snapDict["location"] as! [String:Any])["long"] as! CLLocationDegrees
                        let studentLoc = CLLocation(latitude: studentLat, longitude: studentLong)
                        
                        let exp = snapDict["experience"] as! [String]
                        print("studentEXp: \(exp)")
                        if exp.contains(self.job.category1!){
                            print(snap.key)
                           // print("studLoc: \(studentLoc)")
                            //print("jobLoc: \(self.jobCoord)")
                            var coords = CLLocation(latitude: Double(self.job.jobLat!)!, longitude: Double(self.job.jobLong!)!)
                            if studentLoc.distance(from: coords) <= 90000{
                                print("inRange")
                                if snapDict["nearbyJobs"] == nil {
                                    
                                    print("it was nil")
                                    Database.database().reference().child("students").child(snapDict["studentID"] as! String).updateChildValues(["nearbyJobs": [self.job.jobID]])
                                } else {
                                    var tempArray = snapDict["nearbyJobs"] as! [String]
                                    tempArray.append(self.job.jobID!)
                                    Database.database().reference().child("students").child(snapDict["studentID"] as! String).updateChildValues(["nearbyJobs": tempArray])
                                }
                                
                                
                            }
                        }
                    }
                   
            DispatchQueue.main.async{
                 MyAPIClient.sharedClient.completeCharge(amount: Int(tempCharge), poster: (Auth.auth().currentUser?.uid)!, job: sendJob, senderScreen: "cancelJobStudent")
                self.performSegue(withIdentifier: "cancelJobToStudentProfile", sender: self)
            }
                }
            })
        } else {
            Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        var snapDict = snap.value as! [String:Any]
                        let studentLat = (snapDict["location"] as! [String:Any])["lat"] as! CLLocationDegrees
                        let studentLong = (snapDict["location"] as! [String:Any])["long"] as! CLLocationDegrees
                        let studentLoc = CLLocation(latitude: studentLat, longitude: studentLong)
                        
                        let exp = snapDict["experience"] as! [String]
                        print("studentEXp: \(exp)")
                        if exp.contains(self.job.category1!){
                            print(snap.key)
                            // print("studLoc: \(studentLoc)")
                            //print("jobLoc: \(self.jobCoord)")
                            var coords = CLLocation(latitude: Double(self.job.jobLat!)!, longitude: Double(self.job.jobLong!)!)
                            if studentLoc.distance(from: coords) <= 90000{
                                print("inRange")
                                if snapDict["nearbyJobs"] == nil {
                                    
                                    print("it was nil")
                                    Database.database().reference().child("students").child(snapDict["studentID"] as! String).updateChildValues(["nearbyJobs": [self.job.jobID]])
                                } else {
                                    var tempArray = snapDict["nearbyJobs"] as! [String]
                                    tempArray.append(self.job.jobID!)
                                    Database.database().reference().child("students").child(snapDict["studentID"] as! String).updateChildValues(["nearbyJobs": tempArray])
                                }
                                
                                
                            }
                        }
                    }
                    Database.database().reference().child("jobs").child(self.job.jobID as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapshots {
                                if snap.key == "workers"{
                                    self.workers2 = snap.value as! [String]
                                }
                                if snap.key == "acceptedCount"{
                                    self.removeAcceptedCount = (snap.value as! Int) - 1
                                    
                                }
                            }
                            
                            self.workers.remove(at: self.workers2.index(of: Auth.auth().currentUser!.uid)!)
                            Database.database().reference().child("jobs").child(self.job.jobID!).updateChildValues(["acceptedCount": self.removeAcceptedCount, "workers": self.workers])
                        }
                        Database.database().reference().child("jobPosters").child(self.job.posterID!).updateChildValues(["studentCancelled": true])
                        Database.database().reference().child("students").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            var uploadDataStudent = [String]()
                            
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                
                                for snap in snapshots {
                                    if snap.key == "upcomingJobs"{
                                        
                                        uploadDataStudent = snap.value as! [String]
                                        uploadDataStudent.remove(at: uploadDataStudent.index(of: self.job.jobID!)!)
                                    }
                                }
                                Database.database().reference().child("students").child(Auth.auth().currentUser!.uid).updateChildValues(["upcomingJobs": uploadDataStudent])
                                DispatchQueue.main.async{
                                    self.performSegue(withIdentifier: "cancelJobToStudentProfile", sender: self)
                                }
                            }
                        })
                        
                    })
                    
                }
                
            })
            
        }
    }
    
    //This is now the cancel job button
    @IBAction func jobCompletedPressed(_ sender: Any) {
        if self.senderScreen == "student"{
            print("cancelByStudent")
            let alert = UIAlertController(title: "Confirm Cancel", message: "You will be charged a cancellation fee of $25.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Confirm Cancel", style: UIAlertActionStyle.default, handler: { action in
                self.confirmCancel2()
            }))
            self.present(alert, animated: true, completion: nil)
            //
            
            
        } else {
            //cancel by poster charges poster $25 and credits the student $10
            let alert = UIAlertController(title: "Confirm Cancel", message: "You will be charged a cancellation fee of $25.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Confirm Cancel", style: UIAlertActionStyle.default, handler: { action in
                self.confirmCancel()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    var senderScreen = String()
    var job = JobPost()
    var workers = [[String:Any]]()
    
    // 1) To get started with this demo, first head to https://dashboard.stripe.com/account/apikeys
    // and copy your "Test Publishable Key" (it looks like pk_test_abcdef) into the line below.
    let stripePublishableKey = "pk_live_F3qPhd7gnfCP6HP2gi1LTX41"
    
    // 2) Next, optionally, to have this demo save your user's payment details, head to
    // https://github.com/stripe/example-ios-backend , click "Deploy to Heroku", and follow
    // the instructions (don't worry, it's free). Replace nil on the line below with your
    // Heroku URL (it looks like https://blazing-sunrise-1234.herokuapp.com ).
    let backendBaseURL = "https://quikfix123.herokuapp.com"
    
    
    @IBOutlet weak var posterLabel: UILabel!
    var sender = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.jobType == "jc" || self.jobType == "cl"{
            self.jobCompletedButton.isHidden = true
        }
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        paymentCardTextField.delegate = self
        
        
        groupChatButton.layer.cornerRadius = 10
        posterLabel.text = job.posterName!
        cellSelectedPic.layer.cornerRadius = cellSelectedPic.frame.width/2
        jobCatLabel.text = job.category1!
        dateLabel.text = job.date!
        timeLabel.text = job.startTime!
        durationLabel.text = "\(job.jobDuration!) hour estimated completion time"
        totalCostLabel.text = "\(job.payment!)"
       
        if job.workers != nil {
            if self.sender != "student" {
                if job.workers?.count as! Int > 1{
                    numberOfStudentsLabel.text = "\(job.workers!.count) QuikFix students"
                } else {
                 numberOfStudentsLabel.text = "\(job.workers!.count) QuikFix student"
                }
            }
            else {
                numberOfStudentsLabel.text = "Job Poster"
            }
        }
        
        
        if self.sender == "student"{
            Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots {
                        if self.job.workers != nil && self.job.workers!.contains(snap.key) && Auth.auth().currentUser!.uid != snap.key{
                            var tempDict = [String:Any]()
                            tempDict[snap.key] = ["name": (snap.value as! [String:Any])["name"] as! String, "pic": (snap.value as! [String:Any])["pic"] as! String, "studentID": (snap.value as! [String:Any])["studentID"] as! String]
                            self.workers.append(tempDict)
                        }
                    }
                    
                }
                
                    Database.database().reference().child("jobPosters").child(self.job.posterID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            var tempDict2 = [String:Any]()
                            var tempDict = [String:Any]()
                            
                            for snap in snapshots {
                                if snap.key == "name"{
                                    tempDict["name"] = snap.value as! String
                                    
                                }
                                if snap.key == "pic"{
                                    tempDict["pic"] = snap.value as! String
                                    
                                }
                                if snap.key == "posterID"{
                                    tempDict["posterID"] = snap.value as! String
                                    
                                }
                                
                            }
                            tempDict2[(tempDict["posterID"] as! String)] = tempDict
                            self.workers.append(tempDict2)
                            self.workersCollect.delegate = self
                            self.workersCollect.dataSource = self
                            
                        }
                        
                    })
                    
                
                
                
            })
        } else {
            Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots {
                        if self.job.workers != nil && self.job.workers!.contains(snap.key) && Auth.auth().currentUser!.uid != snap.key{
                            var tempDict = [String:Any]()
                            tempDict[snap.key] = ["name": (snap.value as! [String:Any])["name"] as! String, "pic": (snap.value as! [String:Any])["pic"] as! String, "studentID": (snap.value as! [String:Any])["studentID"] as! String]
                            self.workers.append(tempDict)
                        }
                    }
                    
                }
            if self.job.workers == nil{
                
            } else {
                self.workersCollect.delegate = self
                self.workersCollect.dataSource = self
                }
            
            })
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewProfilePressed(_ sender: Any) {
       // self.studentIDFromResponse =
        performSegue(withIdentifier: "JobLogViewJobToStudentProfile", sender: self)
        
    }
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var totalCostLabel: UILabel!
    
    
    
    @IBAction func closeSelectedViewPressed(_ sender: Any) {
        cellSelectedView.isHidden = true
    }
    @IBOutlet weak var cellSelectedPic: UIImageView!
    @IBAction func sendDMPressed(_ sender: Any) {
        cellSelectedView.isHidden = true
    }
    @IBOutlet weak var cellSelectedView: UIView!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.sender == "poster"{
            return workers.count
        } else {
            return workers.count
        }
    }
    var jobID = String()
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobLogStudentCell", for: indexPath) as! JobLogStudentCell
        
        cell.layer.cornerRadius = cell.frame.width/2
        //print((workers[indexPath.row].values.first as! [String:Any])["name"] as! String)
        
        cell.studentLabel.text = (workers[indexPath.row].values.first as! [String:Any])["name"] as! String
        
        if let messageImageUrl = URL(string: (workers[indexPath.row].values.first as! [String:Any])["pic"] as! String) {
            
            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                cell.studentPic.image = UIImage(data: imageData as Data)
            cellSelectedPic.image = UIImage(data: imageData as Data)
            } }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.sender == "student"{
            cellSelectedView.isHidden = false
            self.studentIDFromResponse = (workers[indexPath.row].values.first as! [String:Any])["studentID"] as! String
        } else {
            
        }
    }

    

    var jobType = String()
    // MARK: - Navigation
    var name = String()
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    var studentIDFromResponse = String()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JobLogJobToChat"{
            if let vc = segue.destination as? ChatContainer{
                self.jobID = self.job.jobID!
                //vc.jobType = self.jobType
                
                if self.sender == "student"{
                    Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            
                            for snap in snapshots {
                                if snap.key == "name"{
                                    self.name = snap.value as! String
                                }
                            }
                        }
                        
                    })
                } else {
                    Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            
                            for snap in snapshots {
                                if snap.key == "name"{
                                    self.name = snap.value as! String
                                }
                            }
                        }
                        
                    })
                    
                }
                vc.name = self.name
                vc.jobID = self.job.jobID!
                vc.userID = (Auth.auth().currentUser?.uid)!
                //vc.bandType = "onb"
                //vc.sender = self.sender
                vc.senderScreen = self.senderScreen
                vc.job = self.job

                
            }
        } else if segue.identifier == "JobLogViewJobToStudentProfile"{
            if let vc = segue.destination as? studentProfile{
                vc.sender = "JobLogSingleJobPoster"
                vc.notUsersProfile = true
                vc.job = self.job
                vc.studentIDFromResponse = self.studentIDFromResponse
            }
            
        } else {
            
        
        if let vc = segue.destination as? JobHistoryViewController{
            vc.senderScreen = self.senderScreen
            vc.jobType = self.jobType
        }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        print("didCreatePaymentResult: \(self.job.posterID)")
        /* MyAPIClient.sharedClient.completeCharge(paymentResult,
         amount: (self.paymentContext?.paymentAmount)!,
         shippingAddress: nil,
         shippingMethod: nil,
         poster: self.posterID,
         completion: completion)*/
    }
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    print("paymentInProgress")
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    // self.buyButton?.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    //self.buyButton?.alpha = 1
                }
            }, completion: nil)
        }
    }
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var numberFormatter: NumberFormatter?
    //let shippingString: String
    var product = ""
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print("finishedWith")
        self.paymentInProgress = false
        let title: String
        let message: String
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
            print("error")
        case .success:
            print("success")
            title = "Success"
            message = ""
        case .userCancellation:
            print("cancelled")
            return
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        //self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        //self.paymentRow.loading = paymentContext.loading
        print("paymentContextDidChange")
        /* if let paymentMethod = paymentContext.selectedPaymentMethod {
         //self.paymentRow.detail = paymentMethod.label
         }
         else {
         //self.paymentRow.detail = "Select Payment"
         }*/
        /*if let shippingMethod = paymentContext.selectedShippingMethod {
         self.shippingRow.detail = shippingMethod.label
         }
         else {
         self.shippingRow.detail = "Enter \(self.shippingString) Info"
         }*/
        //self.totalRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("paymentContextFailedToLoad")
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext?.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var paymentContext: STPPaymentContext?
    
    var theme: STPTheme?
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        let upsWorldwide = PKShippingMethod()
        upsWorldwide.amount = 10.99
        upsWorldwide.label = "UPS Worldwide Express"
        upsWorldwide.detail = "Arrives in 1-3 days"
        upsWorldwide.identifier = "ups_worldwide"
        let fedEx = PKShippingMethod()
        fedEx.amount = 5.99
        fedEx.label = "FedEx"
        fedEx.detail = "Arrives tomorrow"
        fedEx.identifier = "fedex"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if address.country == nil || address.country == "US" {
                completion(.valid, nil, [upsGround, fedEx], fedEx)
            }
            else if address.country == "AQ" {
                let error = NSError(domain: "ShippingError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Invalid Shipping Address",
                                                                                   NSLocalizedFailureReasonErrorKey: "We can't ship to this country."])
                completion(.invalid, error, nil, nil)
            }
            else {
                fedEx.amount = 20.99
                completion(.valid, nil, [upsWorldwide, fedEx], fedEx)
            }
        }
    }

    
    

}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
