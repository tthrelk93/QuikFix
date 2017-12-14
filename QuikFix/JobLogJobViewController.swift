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

class JobLogStudentCell: UICollectionViewCell{
    @IBOutlet weak var studentPic: UIImageView!
    @IBOutlet weak var studentLabel: UILabel!
    
}

class JobLogJobViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, STPAddCardViewControllerDelegate, STPShippingAddressViewControllerDelegate, STPPaymentCardTextFieldDelegate, STPPaymentMethodsViewControllerDelegate {
    
    
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
    @IBAction func jobCompletedPressed(_ sender: Any) {
       /* let cardParams = STPCardParams()
        cardParams.number = "4242424242424242"
        cardParams.expMonth = 10
        cardParams.expYear = 2018
        cardParams.cvc = "123"
        
        STPAPIClient.shared().createTokenWithCard(cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                return
            }
            
            submitTokenToBackend(token, completion: { (error: Error?) in
                if let error = error {
                    // Present error to user...
                }
                else {
                    // Continue with payment...
                }
            })
        }*/
        /*print("jobcompletedPressed")
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
                self.handleAddPaymentMethodButtonTapped()                //if paymentVer == true{
                   /* let checkoutViewController = CheckoutViewController(product: self.stripeToken,
                                                                        price: 1200,
                                                                        settings: self.settingsVC.settings)
                    //self.navigationController?.pushViewController(checkoutViewController, animated: true)
                    let navigationController = UINavigationController(rootViewController: checkoutViewController)
                    self.present(navigationController, animated: true)*/

               // } //else {
                   // print("else")
                   // self.handleAddPaymentMethodButtonTapped()
                //}
            }
        })
        
               // handleAddPaymentMethodButtonTapped()*/
        
        
    }
    
    var senderScreen = String()
    var job = JobPost()
    var workers = [[String:Any]]()
    
    
    
    
    @IBOutlet weak var posterLabel: UILabel!
    var sender = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        paymentCardTextField.delegate = self
        /*buyButton.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
       buyButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        buyButton.setTitle("Confirm", for: .normal)*/
       
        // Add payment card text field to view
        //view.addSubview(paymentCardTextField)
       // view.addSubview(buyButton)
        
        groupChatButton.layer.cornerRadius = 10
        posterLabel.text = job.posterName!
        cellSelectedPic.layer.cornerRadius = cellSelectedPic.frame.width/2
        jobCatLabel.text = job.category1!
        dateLabel.text = job.date!
        timeLabel.text = job.startTime!
        durationLabel.text = "\(job.jobDuration!) hour estimated completion time"
        totalCostLabel.text = "\(job.payment!)"
        detailsTextView.text = job.additInfo!
       /* posterLabel.textAlignment = .center
        dateLabel.textAlignment = .center
        timeLabel.textAlignment = .center
        durationLabel.textAlignment = .center
        totalCostLabel.textAlignment = .center
        detailsTextView.textAlignment = .center*/
        if job.workers != nil{
            if self.sender != "student"{
                if job.workers?.count as! Int > 1{
                    numberOfStudentsLabel.text = "\(job.workers!.count) QuikFix students"
                } else {
                 numberOfStudentsLabel.text = "\(job.workers!.count) QuikFix student"
                }
            }
        }
        if (job.completed! as! Bool) == true{
            jobCompletedButton.setTitle("Job Completed/Students Paid", for: .normal)
            jobCompletedButton.isEnabled = false
            jobCompletedButton.alpha = 0.6
        } else {
            jobCompletedButton.setTitle("Complete Job/Pay Students", for: .normal)
            jobCompletedButton.isEnabled = true
        }
        
        if self.sender == "student"{
            Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots {
                        if self.job.workers != nil && self.job.workers!.contains(snap.key){
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
        } else {
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
        return workers.count
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

    

    
    // MARK: - Navigation
    var name = String()
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    var studentIDFromResponse = String()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JobLogJobToChat"{
            if let vc = segue.destination as? ChatContainer{
                self.jobID = self.job.jobID!
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
        }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    

}
