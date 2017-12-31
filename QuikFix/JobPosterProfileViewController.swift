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





class JobPosterProfileViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, PerformSegueInJobPostViewController, MessagingDelegate {
    
   // fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBOutlet weak var promoTextButton: UIButton!
    @IBOutlet weak var myJobsTextButton: UIButton!
    @IBOutlet weak var dealsTextButton: UIButton!
    
    //@IBOutlet weak var postSuccessShadeView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    //@IBOutlet weak var guillotineMenuButton: UIButton!
    @IBAction func currentListingsButtonPressed(_ sender: Any) {
       /* for tempDict in self.currentListingsObj{
            
            let tempJob = JobPost()
            tempJob.additInfo = (tempDict["additInfo"] as! String)
            tempJob.category1 = (tempDict["category1"] as! String)
            //tempJob.category2 = (tempDict["category2"] as! String)
            tempJob.posterName = (tempDict["posterName"] as! String)
            tempJob.date = (tempDict["date"] as! String)
            tempJob.payment = (tempDict["payment"] as! String)
            tempJob.startTime = (tempDict["startTime"] as! String)
            tempJob.jobDuration = tempDict["jobDuration"] as! String
            tempJob.jobID = (tempDict["jobID"] as! String)
            tempJob.posterID = (tempDict["posterID"] as! String)
            tempJob.completed = tempDict["completed"] as! Bool
            
            self.tableViewData.append(tempJob)
            if self.calendarDict[tempJob.date!] != nil {
                var tempJobArray = self.calendarDict[tempJob.date!]! as! [JobPost]
                tempJobArray.append(tempJob)
                self.calendarDict[tempJob.date!] = tempJobArray
            } else {
                self.calendarDict[tempJob.date!] = [tempJob]
            }
            
        }
        for (key, _) in self.calendarDict{
            self.datesArray.append(key)
        }
        //var testArray = ["25 Jun, 2016", "30 Jun, 2016", "28 Jun, 2016", "2 Jul, 2016"]
        var convertedArray: [Date] = []
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        
        for dat in self.datesArray {
            var date = dateFormatter.date(from: dat)
            convertedArray.append(date!)
        }
        
        //Approach : 1
        convertedArray.sort(){$0 < $1}
        self.datesArray.removeAll()
        for dat in convertedArray{
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let myString = formatter.string(from: dat)
            // convert your string to date
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "MMMM-dd-yyyy"
            // again convert your date to string
            let dateString = formatter.string(from: yourDate!)
            self.datesArray.append(dateString)
        }*/
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
            /*DispatchQueue.main.async{
                UIView.animate(withDuration: 0.2, delay: 0.09, usingSpringWithDamping: 0.7, initialSpringVelocity: 2.0, options: self.animationOptions, animations: {
                    self.sharePromo.bounds = self.popoutMenuButton.bounds
                    self.sharePromo.frame.origin = self.popoutMenuButton.frame.origin
                    
                    self.dealsButton.bounds = self.popoutMenuButton.bounds
                    self.dealsButton.frame.origin = self.popoutMenuButton.frame.origin
                    self.myJobs.bounds = self.popoutMenuButton.bounds
                    self.myJobs.frame.origin = self.popoutMenuButton.frame.origin
                    self.hideMenuButton.isHidden = true
                    self.extended = false
                    self.view.bringSubview(toFront: self.popoutMenuButton)
                    
                    //self.sharePromo.isHidden = true
                    //self.myJobs.isHidden = true
                    //self.dealsButton.isHidden = true
                    
                })*/
            //}
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
    
    @IBAction func dealsPressed(_ sender: Any) {
        promoCodeView.isHidden = true
        currentListingsLabel.isHidden = false
        upcomingJobsLabel.isHidden = false
        currentListingsCount.isHidden = false
        jobsCompletedCount.isHidden = false
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
    var currentListingsObj = [[String:Any]]()
    @IBAction func showMenuAction(_ sender: UIButton) {
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
       // presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        //presentationAnimator.supportView = navigationController!.navigationBar
        //presentationAnimator.presentButton = sender
        //present(menuViewController, animated: true, completion: nil)
    }

   // @IBOutlet weak var menuBounds: UIBarButtonItem!
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
       /* calendarDict.removeAll()
        datesArray.removeAll()
        for tempDict in self.upcomingJobsObj{
            let tempJob = JobPost()
            tempJob.additInfo = (tempDict["additInfo"] as! String)
            tempJob.category1 = (tempDict["category1"] as! String)
            //tempJob.category2 = (tempDict["category2"] as! String)
            tempJob.posterName = (tempDict["posterName"] as! String)
            tempJob.date = (tempDict["date"] as! String)
            tempJob.payment = (tempDict["payment"] as! String)
            tempJob.startTime = (tempDict["startTime"] as! String)
            tempJob.jobDuration = tempDict["jobDuration"] as! String
            tempJob.jobID = (tempDict["jobID"] as! String)
            tempJob.posterID = (tempDict["posterID"] as! String)
            tempJob.completed = tempDict["completed"] as! Bool
            
            self.tableViewData.append(tempJob)
            if self.calendarDict[tempJob.date!] != nil {
                var tempJobArray = self.calendarDict[tempJob.date!]! as! [JobPost]
                tempJobArray.append(tempJob)
                self.calendarDict[tempJob.date!] = tempJobArray
            } else {
                self.calendarDict[tempJob.date!] = [tempJob]
            }
            
        }
        for (key, _) in self.calendarDict{
            self.datesArray.append(key)
        }
        //var testArray = ["25 Jun, 2016", "30 Jun, 2016", "28 Jun, 2016", "2 Jul, 2016"]
        var convertedArray: [Date] = []
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM-dd-yyyy"
        
        for dat in self.datesArray {
            var date = dateFormatter.date(from: dat)
            convertedArray.append(date!)
        }
        
        //Approach : 1
        convertedArray.sort(){$0 < $1}
        self.datesArray.removeAll()
        for dat in convertedArray{
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let myString = formatter.string(from: dat)
            // convert your string to date
            let yourDate = formatter.date(from: myString)
            //then again set the date format whhich type of output you need
            formatter.dateFormat = "MMMM-dd-yyyy"
            // again convert your date to string
            let dateString = formatter.string(from: yourDate!)
            self.datesArray.append(dateString)
        }*/
        
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
    var inProgressObj = [[String:Any]]()
    
    var mToken = String()
    var upcomingJobs = [String]()
    var upcomingJobsObj = [[String:Any]]()
    //let qfGreen = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
    var jobsCompleted = [String]()
   // var jobsCompleted
    
    var infoBounds = CGRect()
    var infoOrigin = CGPoint()
    override func viewDidLoad() {
        super.viewDidLoad()
        infoBounds = normalInfoView.bounds
        infoOrigin = normalInfoView.frame.origin
        sepLineVertical.isHidden = true
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
        //sharePromo.layer.cornerRadius = sharePromo.frame.width/2
        //sharePromo.layer.borderColor = qfRed.cgColor
        //sharePromo.layer.borderWidth = 1
        
       // myJobs.layer.cornerRadius = sharePromo.frame.width/2
        //myJobs.layer.borderColor = qfRed.cgColor
        
       // myJobs.layer.borderWidth = 1
        
        //dealsButton.layer.cornerRadius = sharePromo.frame.width/2
        //dealsButton.layer.borderColor = qfRed.cgColor
        //dealsButton.layer.borderWidth = 1
        
        
        
        
       /* if showJobPostedView == true{
            self.postSuccessShadeView.isHidden = false
            jobPostedView.isHidden = false
            postJobsButton.isHidden = true
            
        }*/
        
        //jobPostedView.layer.cornerRadius = 10
        responseBubble.layer.cornerRadius = responseBubble.frame.width/2
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        var responseBool = false
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots{
                    if snap.key == "jobsCompleted"{
                        self.jobsCompleted = snap.value as! [String]
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
                        self.currentListings = snap.value as! [String]
                        self.curListBool = true
                        self.currentListingsCount.text = String(describing: (snap.value as! [String]).count)
                    }
                    else if snap.key == "upcomingJobs"{
                        self.upcomingJobs = snap.value as! [String]
                        
                        self.jobsCompletedCount.text = String(describing: (snap.value as! [String]).count)
                        
                        
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
            
            Database.database().reference().child("jobs").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    
                    for snap in snapshots {
                        
                        if self.currentListings.contains(snap.key){
                            self.currentListingsObj.append(snap.value as! [String:Any])
                        } else if self.upcomingJobs.contains(snap.key){
                            
                            var tempJob = snap.value as! [String:Any]
                            
                            if tempJob["inProgress"] as! Bool == true{
                                self.containsInProgress = true
                                self.inProgressObj.append(tempJob)
                            }
                            self.upcomingJobsObj.append(snap.value as! [String:Any])
                            
                           
                        } else if self.jobsCompleted.contains(snap.key){
                            //self.jobsCompleted
                        }
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
                }
                
                
                
            })

            
            
        })


        // Do any additional setup after loading the view.
    }
    
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
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
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
    

}
/*extension JobPosterProfileViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("pressss")
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("dissss")
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}*/
