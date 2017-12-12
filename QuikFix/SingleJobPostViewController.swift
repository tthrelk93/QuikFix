//
//  SingleJobPostViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/25/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging
import Stripe

class SingleJobPostViewController: UIViewController, MessagingDelegate, STPPaymentContextDelegate {
    
    // 1) To get started with this demo, first head to https://dashboard.stripe.com/account/apikeys
    // and copy your "Test Publishable Key" (it looks like pk_test_abcdef) into the line below.
    let stripePublishableKey = "pk_live_F3qPhd7gnfCP6HP2gi1LTX41"
    
    // 2) Next, optionally, to have this demo save your user's payment details, head to
    // https://github.com/stripe/example-ios-backend , click "Deploy to Heroku", and follow
    // the instructions (don't worry, it's free). Replace nil on the line below with your
    // Heroku URL (it looks like https://blazing-sunrise-1234.herokuapp.com ).
    let backendBaseURL: String? = "https://quikfix123.herokuapp.com"
    
    // 3) Optionally, to enable Apple Pay, follow the instructions at https://stripe.com/docs/mobile/apple-pay
    // to create an Apple Merchant ID. Replace nil on the line below with it (it looks like merchant.com.yourappname).
    let appleMerchantID: String? = nil
    
    // These values will be shown to the user when they purchase with Apple Pay.
    let companyName = "QuikFix"
    let paymentCurrency = "usd"
    
    var paymentContext: STPPaymentContext?
    
    var theme: STPTheme?
    var paymentRow: CheckoutRowView?
    //let shippingRow: CheckoutRowView
    var totalRow: CheckoutRowView?
    var buyButton: BuyButton?
    let rowHeight: CGFloat = 44
    let productImage = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var numberFormatter: NumberFormatter?
    //let shippingString: String
    var product = ""
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var posterCity: UILabel!
    @IBOutlet weak var posterName: UILabel!
    var job1 = JobPost()
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "SingleJobToJobPosts", sender: self)
    }
    @IBOutlet weak var applySuccessView: UIView!
   
    @IBOutlet weak var shadowView: UIView!
    @IBAction func applytoJobPressed(_ sender: Any) {
        
        if workerInJobAlready == true{
            let alert = UIAlertController(title: "Duplicate Application Error", message: "You have already applied to this job. Your application is awaiting review by the job poster.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
        self.applySuccessView.isHidden = false
        print("posterID: \(self.posterID)")
            
        
        Database.database().reference().child("jobPosters").child(self.posterID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                 var containsCurrentListings = false
                var containsUpcomingJobs = false
               
                for snap in snapshots{
                   /* if snap.key == "deviceToken"{
                        var deviceToken = (snap.value as! [String:Any]).keys.first
                        
                    }*/
                    if snap.key == "currentListings"{
                        containsCurrentListings = true
                        var tempJobArray = snap.value as! [String]
                        tempJobArray.remove(at: tempJobArray.index(of: self.job1.jobID!)!)
                        //var keyInDictBool = false
                        //var tempIDArray = [String]()
                        var uploadDict = [String:Any]()
                        uploadDict["currentListings"] = tempJobArray
                        Database.database().reference().child("jobPosters").child(self.posterID).updateChildValues(uploadDict)
                        
                    } else if snap.key == "upcomingJobs"{
                        containsUpcomingJobs = true
                        var tempJobArray = snap.value as! [String]
                        tempJobArray.append(self.jobID)
                        //var keyInDictBool = false
                        //tempJobDict[self.jobID] = self.job
                        //var tempIDArray = [String]()
                        var uploadDict = [String:Any]()
                        uploadDict["upcomingJobs"] = tempJobArray
                    Database.database().reference().child("jobPosters").child(self.posterID).updateChildValues(uploadDict)
                        
                    }
                }
                if containsUpcomingJobs == false{
                    var uploadData = [String]()
                    uploadData.append(self.jobID)
                    var uploadDict = [String:Any]()
                    uploadDict["upcomingJobs"] = uploadData
                    Database.database().reference().child("jobPosters").child(self.posterID).updateChildValues(uploadDict)
                }
                    if containsCurrentListings == false{
                        var uploadData = [String]()
                        uploadData.append(self.jobID)
                        var uploadDict = [String:Any]()
                        uploadDict["currentListings"] = uploadData
                        
                        Database.database().reference().child("jobPosters").child(self.posterID).updateChildValues(uploadDict)
                    }
                
    
       /* } else {
            let alert = UIAlertController(title: "Duplicate Application Error", message: "You have already applied to this job. Your application is awaiting review by the job poster.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }*/
            
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                var containsJobs = false
                var upcomingArray = [String]()
                for snap in snapshots {
                    
                    if snap.key == "upcomingJobs"{
                        upcomingArray = snap.value as! [String]
                        upcomingArray.append(self.jobID)
                        containsJobs = true
                    }
                    var uploadDict2 = [String:Any]()
                    if containsJobs == false{
                        
                        uploadDict2["upcomingJobs"] = [self.jobID]
                    }else {
                        uploadDict2["upcomingJobs"] = upcomingArray
                    }
                    Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).updateChildValues(uploadDict2)
                }
                }
            Database.database().reference().child("jobs").child(self.jobID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    var containsWorkers = false
                    var workersArray = [String]()
                    for snap in snapshots {
                        
                        if snap.key == "workers"{
                            containsWorkers = true
                            workersArray = snap.value as! [String]
                            workersArray.append((Auth.auth().currentUser!.uid))
                            var uploadDict = [String:Any]()
                            uploadDict["workers"] = workersArray
                            Database.database().reference().child("jobs").child(self.jobID).updateChildValues(uploadDict)
                        } else if snap.key == "acceptedCount" {
                            var tempInt = snap.value as! Int
                            tempInt = tempInt + 1
                            var uploadDict = [String:Any]()
                            uploadDict["acceptedCount"] = tempInt
                            Database.database().reference().child("jobs").child(self.jobID).updateChildValues(uploadDict)
                            
                        }
                        }
                    
                    if containsWorkers == false{
                        var uploadDict = [String:Any]()
                        uploadDict["workers"] = ([(Auth.auth().currentUser!.uid)] as! Any)
                        Database.database().reference().child("jobs").child(self.jobID).updateChildValues(uploadDict)
                    }
                }
                 self.applySuccessView.isHidden = true
                var date = self.job1.date!
                var timeComp = self.job1.startTime!.components(separatedBy: ":")// .componentsSeparatedByString(":")
                var timeHours = timeComp[0]
                print("timeHours: \(timeHours)")
                var timeHoursInt = Int(timeHours)
                var triggerTime = (timeHoursInt as! Int) + (Int(self.job1.jobDuration!) as! Int)
                var triggerTimeString = "\(String(describing: triggerTime)):\(timeComp[1])"
                print("triggerTime: \(triggerTimeString)")
                var dateToFormat = "\(date) \(triggerTimeString)"
                
                
                
                var dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM-dd-yyyy hh:mm a"
                let triggerDate = dateFormatter.date(from: dateToFormat)
                
                //MyAPIClient.sharedClient.completeCharge(amount: 10,
                                                       // poster: self.posterID)
                MyAPIClient.sharedClient.completeCharge(amount: 2000, poster: self.posterID)
                //let timer = Timer(fireAt: triggerDate!, interval: 0, target: self, selector: #selector(self.chargePoster), userInfo: nil, repeats: false)
                //RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
            
            })
            
                    
        })
            }
        })
        }
            

        
    
    }
    
    func chargePoster(){
        print("charge the poster")
        self.paymentContext?.requestPayment()
    }
    
    //var product = String()
    var price = Int()
    let settingsVC = SettingsViewController()
    
    
   /* init(product: String, price: Int, settings: Settings, jobID: String, posterID: String, categoryType: String, job1: JobPost) {
        print("init")
        var settings = settingsVC.settings
        self.jobID = jobID
        self.posterID = posterID
        self.categoryType = categoryType
        self.job1 = job1
        let stripePublishableKey = self.stripePublishableKey
        let backendBaseURL = self.backendBaseURL
        
        assert(stripePublishableKey.hasPrefix("pk_"), "You must set your Stripe publishable key at the top of CheckoutViewController.swift to run this app.")
        assert(backendBaseURL != nil, "You must set your backend base url at the top of CheckoutViewController.swift to run this app.")
        
        self.product = product
        self.productImage.text = product
        self.theme = settings.theme
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        config.publishableKey = self.stripePublishableKey
        config.appleMerchantIdentifier = self.appleMerchantID
        config.companyName = self.companyName
        config.requiredBillingAddressFields = settings.requiredBillingAddressFields
        //config.requiredShippingAddressFields = settings.requiredShippingAddressFields
        // config.shippingType = settings.shippingType
        config.additionalPaymentMethods = settings.additionalPaymentMethods
        
        
        
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: config,
                                               theme: settings.theme)
        let userInformation = STPUserInformation()
        
        paymentContext.prefilledInformation = userInformation
        
        paymentContext.paymentAmount = price
        paymentContext.paymentCurrency = self.paymentCurrency
        
        let paymentSelectionFooter = PaymentContextFooterView(text: "You can add custom footer views to the payment selection screen.")
        paymentSelectionFooter.theme = settings.theme
        
        //paymentContext.paymentMethodsViewControllerFooterView
        paymentContext.paymentMethodsViewControllerFooterView = paymentSelectionFooter
        
        let addCardFooter = PaymentContextFooterView(text: "You can add custom footer views to the add card screen.")
        addCardFooter.theme = settings.theme
        paymentContext.addCardViewControllerFooterView = addCardFooter
        
        self.paymentContext = paymentContext
        
        //self.paymentRow = CheckoutRowView(title: "Payment", detail: "Select Payment",
                                          theme: settings.theme)
        //var shippingString = "Contact"
        /*if config.requiredShippingAddressFields.contains(.postalAddress) {
         shippingString = config.shippingType == .shipping ? "Shipping" : "Delivery"
         }
         self.shippingString = shippingString
         self.shippingRow = CheckoutRowView(title: self.shippingString,
         detail: "Enter \(self.shippingString) Info",
         theme: settings.theme)*/
        //self.totalRow = CheckoutRowView(title: "Total", detail: "", tappable: false,
                                        theme: settings.theme)
        self.buyButton = BuyButton(enabled: true, theme: settings.theme)
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        //self.numberFormatter = numberFormatter
        super.init(nibName: nil, bundle: nil)
        self.paymentContext.delegate = self
        paymentContext.hostViewController = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    var job = [String: Any]()
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    var jobID = String()
    var studentsWhoHaveAppliedForJobArray = [String]()
    var studentHasAlreadyApplied = false
    var categoryType = String()
    var posterID = String()
    var workerInJobAlready = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.navigationController?.pushViewController(self, animated: false)
        var settings = settingsVC.settings
        //self.jobID = jobID
        //self.posterID = posterID
        //self.categoryType = categoryType
        //self.job1 = job1
        let stripePublishableKey = self.stripePublishableKey
        let backendBaseURL = self.backendBaseURL
        
        assert(stripePublishableKey.hasPrefix("pk_"), "You must set your Stripe publishable key at the top of CheckoutViewController.swift to run this app.")
        assert(backendBaseURL != nil, "You must set your backend base url at the top of CheckoutViewController.swift to run this app.")
        
        //self.product = product
        self.productImage.text = self.product
        self.theme = settings.theme
        MyAPIClient.sharedClient.baseURLString = self.backendBaseURL
        
        // This code is included here for the sake of readability, but in your application you should set up your configuration and theme earlier, preferably in your App Delegate.
        let config = STPPaymentConfiguration.shared()
        //config.publishableKey = self.stripePublishableKey
        //config.appleMerchantIdentifier = self.appleMerchantID
        //config.companyName = self.companyName
        //config.requiredBillingAddressFields = settings.requiredBillingAddressFields
        //config.requiredShippingAddressFields = settings.requiredShippingAddressFields
        // config.shippingType = settings.shippingType
        //config.additionalPaymentMethods = settings.additionalPaymentMethods
        
        
       // STPCustomerContext(
        
        /*let customerContext = STPCustomerContext(keyProvider: MyAPIClient.sharedClient)
        let paymentContext = STPPaymentContext(customerContext: customerContext,
                                               configuration: config,
                                               theme: settings.theme)
        let userInformation = STPUserInformation()
        
        paymentContext.prefilledInformation = userInformation
        
        paymentContext.paymentAmount = price
        paymentContext.paymentCurrency = self.paymentCurrency
        
        let paymentSelectionFooter = PaymentContextFooterView(text: "You can add custom footer views to the payment selection screen.")
        paymentSelectionFooter.theme = settings.theme
        
        //paymentContext.paymentMethodsViewControllerFooterView
        paymentContext.paymentMethodsViewControllerFooterView = paymentSelectionFooter
        
        let addCardFooter = PaymentContextFooterView(text: "You can add custom footer views to the add card screen.")
        addCardFooter.theme = settings.theme
        paymentContext.addCardViewControllerFooterView = addCardFooter
        
        self.paymentContext = paymentContext
        
        //self.paymentRow = CheckoutRowView(title: "Payment", detail: "Select Payment",
                                          //theme: settings.theme)
        //var shippingString = "Contact"
        /*if config.requiredShippingAddressFields.contains(.postalAddress) {
         shippingString = config.shippingType == .shipping ? "Shipping" : "Delivery"
         }
         self.shippingString = shippingString
         self.shippingRow = CheckoutRowView(title: self.shippingString,
         detail: "Enter \(self.shippingString) Info",
         theme: settings.theme)*/
        //self.totalRow = CheckoutRowView(title: "Total", detail: "", tappable: false,
                                       // theme: settings.theme)
        self.buyButton = BuyButton(enabled: true, theme: settings.theme)
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        //self.numberFormatter = numberFormatter
        //super.init(nibName: nil, bundle: nil)
        self.paymentContext?.delegate = self
        paymentContext.hostViewController = self*/
     
        posterImage.layer.cornerRadius = posterImage.frame.width/2
        posterImage.clipsToBounds = true
        shadowView.dropShadow()
        
        
        
        Database.database().reference().child("jobs").child(jobID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                let tempDict = snapshot.value as! [String:Any]
                
                for snap in snapshots{
                    if snap.key == "workers"{
                        var tempArray = snap.value as! [String]
                        if tempArray.contains((Auth.auth().currentUser!.uid)){
                            self.workerInJobAlready = true
                        }
                    }
                    
                    if snap.key == "payment"{
                        var tempPayString = snap.value as! String
                        tempPayString = tempPayString.replacingOccurrences(of: "$", with: "")
                        let tempPayDouble = ((Double(tempPayString)! * 0.6) / (tempDict["workerCount"] as! Double))
                        tempPayString = "$\(tempPayDouble)"
                        self.rateLabel.text = tempPayString
                        
                       // self.rateLabel.text = tempPayString
                    } else if snap.key == "startTime"{
                        self.timeLabel.text = (snap.value as! String)
                    }else if snap.key == "additInfo"{
                        self.detailsTextView.text = snap.value as! String
                        
                    } else if snap.key == "posterID"{
                        self.posterID = snap.value as! String
                    } else if snap.key == "date"{
                        self.dateLabel.text = snap.value as! String
                    } else if snap.key == "jobDuration"{
                        self.durationLabel.text = "\(snap.value as! String) hours (estimated)"
                    } else if snap.key == "category1"{
                        self.categoryText.text = snap.value as! String
                    }
                    
                }
                
            }
            
        })
        Database.database().reference().child("jobPosters").child(self.posterID).observeSingleEvent(of: .value, with : {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    var tempArray = [String]()
                    if snap.key == "address"{
                        self.addressLabel.text = (snap.value as! [String]).first
                    } else if snap.key == "pic"{
                        if let messageImageUrl = URL(string: snap.value as! String) {
                            
                            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                                
                                self.posterImage.image = UIImage(data: imageData as Data) }
                        }
                        
                    } else if snap.key == "name"{
                        self.posterName.text = snap.value as! String
                    } else if snap.key == "responses"{
                        var tempDict = snap.value as! [String: Any]
                        
                        for (key, val) in tempDict{
                            if key == self.jobID{
                                tempArray = val as! [String]
                            }
                        }
                        
                    }
                    if tempArray.isEmpty{
                        self.studentHasAlreadyApplied = false
                    } else if tempArray.contains((Auth.auth().currentUser?.uid)!) == false{
                        self.studentHasAlreadyApplied = false
                    } else {
                        self.studentHasAlreadyApplied = true
                    }

                }
            }
            
        })



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memoryWarning")
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JobPostViewController{
            vc.categoryType = self.categoryType
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        print("didCreatePaymentResult: \(self.posterID)")
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
                    self.buyButton?.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.buyButton?.alpha = 1
                }
            }, completion: nil)
        }
    }
    
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
            message = "You bought a \(self.product)!"
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
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            //self.paymentRow.detail = paymentMethod.label
        }
        else {
            //self.paymentRow.detail = "Select Payment"
        }
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

extension UIView{
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: -2, height: 2)
        self.layer.shadowRadius = 325
        self.layer.cornerRadius = self.frame.width/2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
}

