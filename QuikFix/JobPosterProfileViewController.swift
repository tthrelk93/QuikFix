//
//  JobPosterProfileViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/12/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SwiftOverlays





class JobPosterProfileViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, PerformSegueInJobPostViewController {
    
   // fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
   
    //@IBOutlet weak var postSuccessShadeView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    //@IBOutlet weak var guillotineMenuButton: UIButton!
    @IBAction func currentListingsButtonPressed(_ sender: Any) {
        
        currentListingsView.isHidden = false
        
        
        
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        currentListingsView.isHidden = true
    }
    @IBOutlet weak var currentListingsButton: UIButton!
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
    
    @IBOutlet weak var currentListingsView: UIView!
   // @IBOutlet weak var jobPostedView: UIView!
    @IBAction func responseBubblePressed(_ sender: Any) {
        
        
    }
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
    override func viewDidLoad() {
        super.viewDidLoad()
        //jobPostedView.layer.cornerRadius = 12
        //postSuccessShadeView.layer.cornerRadius = 12
        //let navBar = self.navigationController!.navigationBar
       // navBar.barTintColor = UIColor.white
       // navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)]
       // navBar.backgroundColor = UIColor(colorLiteralRed: 49/255, green: 74/255, blue: 82/255, alpha: 1.0)
        
        
        
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowRadius = profileImageView.frame.width + 20
        
        
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
                    if snap.key == "name"{
                        //(self.navigationBar as UINavigationBar). //
                        self.nameLabel.text = snap.value as! String
                        
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
                    else if snap.key == "responses"{
                        responseBool = true
                        if (snap.value as! [String:Any]).count == 0{
                            self.responseBubble.isHidden = true
                        } else {
                    self.responseBubble.isHidden = false
                            self.responseBubble.titleLabel?.text = String(describing:(snap.value as! [String:Any]).count)
                        }
                        
                    }
                }
                if responseBool == false{
                    self.responseBubble.isHidden = true
                } else {
                    self.responseBubble.isHidden = false
                }
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
                        }
                    }
                }
                
                for tempDict in self.currentListingsObj{
                    let tempJob = JobPost()
                    tempJob.additInfo = (tempDict["additInfo"] as! String)
                    tempJob.category1 = (tempDict["category1"] as! String)
                    tempJob.category2 = (tempDict["category2"] as! String)
                    tempJob.posterName = (tempDict["posterName"] as! String)
                    tempJob.date = (tempDict["date"] as! String)
                    tempJob.payment = (tempDict["payment"] as! String)
                    tempJob.time = (tempDict["time"] as! String)
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
                }
                
                
                
                self.jobHistoryTableView.delegate = self
                self.jobHistoryTableView.dataSource = self
                DispatchQueue.main.async{
                    self.jobHistoryTableView.reloadData()
                }
                
            })

            
            
        })


        // Do any additional setup after loading the view.
    }
    var jobsForDate = [JobPost]()
    var tableViewData = [JobPost]()
    var calendarDict = [String:Any]()
    var datesArray = [String]()
    
    
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
                cell.calCollect.heightAnchor.constraint(equalToConstant: (145.0 * CGFloat(jobsForDate.count)) + 37).isActive = true
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
