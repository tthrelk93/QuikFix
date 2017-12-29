//
//  JobPostViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/19/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

// TabBarJobPostToJobLog JobVCToCalendar TabBarJobFinderToStudentProfile   

class JobPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PerformSegueInJobPostViewController, UITabBarDelegate{
    
    @IBOutlet weak var noJobsLabel: UILabel!
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        if item == tabBar.items?[0]{
            performSegue(withIdentifier: "TabBarJobPostToJobLog", sender: self)
        } else if item == tabBar.items?[1]{
            
            
        } else if item == tabBar.items?[2]{
            performSegue(withIdentifier: "TabBarJobFinderToStudentProfile", sender: self)
            
        } else {
            performSegue(withIdentifier: "JobVCToCalendar", sender: self)
            
        }
    }

    
    @IBAction func calendarPressed(_ sender: Any) {
        performSegue(withIdentifier: "JobVCToCalendar", sender: self)
        
    }
    @IBOutlet weak var tabBar: UITabBar!
    var currentListings: [String]?
    var expiredJobs: [String]?
    var categoryType = String()
        @IBOutlet weak var calendarTableView: UITableView!
    
    //var dGroup = DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.delegate = self
        
       
            
       
        
        Database.database().reference().child("jobs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM-dd-yyyy h:mm a"
            //let triggerDate = dateFormatter.date(from: dateToFormat)
            //print("tDate: \(triggerDate!)")
            
           
            let today = Date()
           
            
            
            for snap in snapshots {
                
                var tempDict = snap.value as! [String:Any]
                if self.currentListings != nil{
                    self.currentListings!.removeAll()
                }
                Database.database().reference().child("jobPosters").child((tempDict["posterID"] as! String)).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let snapshots1 = snapshot.children.allObjects as! [DataSnapshot]
                    for snap in snapshots1{
                        if snap.key == "currentListings"{
                            self.currentListings = snap.value as? [String]
                        } else if snap.key == "expiredJobs"{
                            self.expiredJobs = snap.value as? [String]
                        }
                    }
                
                let trigger2TimeString = "\(String(describing: tempDict["date"]!)) \(String(describing: tempDict["startTime"]!))"
                
                let trigger2Date = dateFormatter.date(from: trigger2TimeString)
                print("t2Date: \(trigger2Date!)")
                
                if today > trigger2Date! || (tempDict["workerCount"] as! Int) == (tempDict["acceptedCount"] as! Int) {
                    print("dont append job")
                    if self.currentListings == nil {
                        
                    } else {
                    if today > trigger2Date! &&
                        (self.currentListings?.contains(tempDict["jobID"] as! String))! {
                        //send poster push notification asking if they would like to repost the job or scrap it
                        let index = self.currentListings?.index(of: tempDict["jobID"] as! String)
                        
                        print("removeCL: \(String(describing: self.currentListings))")
                        self.currentListings?.remove(at: index!)
                        
                        
                        //var tempArray2 = tempDict["expiredJobs"] as! [String]
                        if self.expiredJobs == nil{
                            self.expiredJobs = [tempDict["jobID"] as! String]
                        } else {
                            self.expiredJobs!.append(tempDict["jobID"] as! String)
                        }
                        
                        Database.database().reference().child("jobPosters").child(tempDict["posterID"] as! String).updateChildValues(["currentListings": self.currentListings!, "expiredJobs": self.expiredJobs!])
                        }
                    }
                }
                else {
                    if tempDict["category1"] as! String == self.categoryType{
                        let tempJob = JobPost()
                        tempJob.additInfo = (tempDict["additInfo"] as! String)
                        tempJob.category1 = (tempDict["category1"] as! String)
                        //tempJob.category2 = (tempDict["category2"] as! String)
                        tempJob.posterName = (tempDict["posterName"] as! String)
                        tempJob.date = (tempDict["date"] as! String)
                        var tempPayString = tempDict["payment"] as! String
                        tempPayString = tempPayString.replacingOccurrences(of: "$", with: "")
                        let tempPayDouble = ((Double(tempPayString)! * 0.6) / (tempDict["workerCount"] as! Double))
                        tempPayString = "$\(tempPayDouble)"
                        tempJob.payment = tempPayString
                        tempJob.startTime = (tempDict["startTime"] as! String)
                        tempJob.jobDuration = tempDict["jobDuration"] as? String
                        tempJob.jobID = (tempDict["jobID"] as! String)
                        tempJob.posterID = (tempDict["posterID"] as! String)
                        //tempJob.paymentType = tempDict["paymentType"] as! Int
                        if self.calendarDict[tempJob.date!] != nil {
                            var tempJobArray = self.calendarDict[tempJob.date!]!
                            tempJobArray.append(tempJob)
                            self.calendarDict[tempJob.date!] = tempJobArray
                        } else {
                            self.calendarDict[tempJob.date!] = [tempJob]
                            }
                    } else if self.categoryType == "All"{
                        let tempJob = JobPost()
                        tempJob.additInfo = (tempDict["additInfo"] as! String)
                        tempJob.category1 = (tempDict["category1"] as! String)
                        //tempJob.category2 = (tempDict["category2"] as! String)
                        tempJob.posterName = (tempDict["posterName"] as! String)
                        tempJob.date = (tempDict["date"] as! String)
                        var tempPayString = tempDict["payment"] as! String
                        tempPayString = tempPayString.replacingOccurrences(of: "$", with: "")
                        let tempPayDouble = ((Double(tempPayString)! * 0.6) / (tempDict["workerCount"] as! Double))
                        tempPayString = "$\(tempPayDouble)"
                        tempJob.payment = tempPayString
                        print("studentPayment: \(tempPayString)")
                        tempJob.startTime = (tempDict["startTime"] as! String)
                        tempJob.jobDuration = tempDict["jobDuration"] as? String
                        tempJob.jobID = (tempDict["jobID"] as! String)
                        tempJob.posterID = (tempDict["posterID"] as! String)
                        //tempJob.paymentType = tempDict["paymentType"] as! Int
                        if self.calendarDict[tempJob.date!] != nil {
                            var tempJobArray = self.calendarDict[tempJob.date!]!
                            tempJobArray.append(tempJob)
                            self.calendarDict[tempJob.date!] = tempJobArray
                        } else {
                            self.calendarDict[tempJob.date!] = [tempJob]
                        }
                    }
                    
                    
                    }
                    if snap == snapshots.last{
                        print("calDict: \(self.calendarDict)")
                        for (key, _) in self.calendarDict{
                            self.datesArray.append(key)
                        }
                        //var testArray = ["25 Jun, 2016", "30 Jun, 2016", "28 Jun, 2016", "2 Jul, 2016"]
                        var convertedArray: [Date] = []
                        
                        let dateFormatter2 = DateFormatter()
                        dateFormatter2.dateFormat = "MMMM-dd-yyyy"
                        
                        for dat in self.datesArray {
                            let date = dateFormatter2.date(from: dat)
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
                        
                        self.calendarTableView.delegate = self
                        self.calendarTableView.dataSource = self
                        DispatchQueue.main.async{
                            
                            self.calendarTableView.reloadData()
                        }
                    }
                })
            }
            
            
            
            
            
            
        })
        

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var calendarDict = [String:[JobPost]]()
    var jobsArray = [JobPost]()
    var jobsForDate = [JobPost]()
    var datesArray = [String]()
    
    @IBAction func calendarButtonPressed(_ sender: Any) {
        if calendarHolderView.isHidden == true{
            calendarHolderView.isHidden = false
        } else {
            calendarHolderView.isHidden = true
        }
    }
    @IBOutlet weak var calendarHolderView: UIView!
    
    //***TableView DataSource functions
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if datesArray.count == 0{
            noJobsLabel.isHidden = false
        } else {
            noJobsLabel.isHidden = true
        }
        return datesArray.count
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
                self.jobsForDate = (val )
                cell.jobsForDate = val
                
                cell.calCollect.dataSource = cell
                cell.calCollect.delegate = cell
                cell.calCollect.heightAnchor.constraint(equalToConstant: (145.0 * CGFloat(jobsForDate.count)) + 37).isActive = true
                
                cell.delegate = self
                cell.category = self.categoryType
                break
            }
        }
        
               

        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        //let tempCell = DateCollectionViewCell()
        //print("TVCheight: \((tempCell.frame.height * CGFloat(jobsForDate.count)))")
        return ((145.0 * CGFloat(jobsForDate.count)) + 37)
    }
    var selectedJobID = String()
    var selectedJob = JobPost()
    var stripeToken = String()
    func performSegueToSingleJob(category: String, jobID: String, job: JobPost){
        self.selectedJobID = jobID
        self.selectedJob = job
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
              //  var paymentVer = false
                
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
                
                //print(tempInt as! Int)
                
                /*let singleJobViewController = SingleJobPostViewController(product: self.stripeToken,
                                                                          price: tempInt,
                                                                          settings: self.settingsVC.settings,
                                                                          jobID: self.selectedJobID,
                                                                          posterID: self.selectedJob.posterID!,
                                                                          categoryType: self.categoryType,
                                                                          job1: self.selectedJob)
                self.navigationController?.pushViewController(singleJobViewController, animated: true)
                let navigationController = UINavigationController(rootViewController: singleJobViewController)
                self.present(navigationController, animated: true)*/
               // self.navigationController?.pushViewController(singleJobViewController, animated: true)
                self.performSegue(withIdentifier: "SingleJobSelected", sender: self)
                //performSeg
            }
        })
        
        
    }
    
    let settingsVC = SettingsViewController()
       
 

 

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SingleJobSelected"{
            if let vc = segue.destination as? SingleJobPostViewController{
                let tempString = self.selectedJob.payment?.substring(from: 1)
                let tempInt = (tempString! as NSString).integerValue
                vc.jobID = self.selectedJobID
                vc.posterID = self.selectedJob.posterID!
                vc.categoryType = self.categoryType
                vc.job1 = self.selectedJob
                vc.price = tempInt
                vc.categoryType = self.categoryType
                vc.product = self.stripeToken
                Database.database().reference().child("jobs").child(self.selectedJobID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        let tempDict = snapshot.value as! [String:Any]
                        
                        for snap in snapshots{
                            if snap.key == "workers"{
                                let tempArray = snap.value as! [String]
                                if tempArray.contains((Auth.auth().currentUser!.uid)){
                                    vc.workerInJobAlready = true
                                }
                            }
                            
                            if snap.key == "payment"{
                                var tempPayString = snap.value as! String
                                vc.chargeAmount = tempPayString.substring(from: 1)
                                tempPayString = tempPayString.replacingOccurrences(of: "$", with: "")
                                let tempPayDouble = ((Double(tempPayString)! * 0.6) / (tempDict["workerCount"] as! Double))
                                tempPayString = "$\(tempPayDouble)"
                                vc.rateLabel.text = tempPayString
                                
                                // self.rateLabel.text = tempPayString
                            } else if snap.key == "startTime"{
                                vc.timeLabel.text = (snap.value as! String)
                            }else if snap.key == "additInfo"{
                                vc.detailsTextView.text = snap.value as! String
                                
                            } else if snap.key == "posterID"{
                                vc.posterID = snap.value as! String
                            } else if snap.key == "date"{
                                vc.dateLabel.text = snap.value as? String
                            } else if snap.key == "jobDuration"{
                                vc.durationLabel.text = "\(snap.value as! String) hours (estimated)"
                            } else if snap.key == "category1"{
                                vc.categoryLabel.text = snap.value as? String
                            }
                            
                        }
                        
                    }
                    
                })
                
            }
            
        }
        if segue.identifier == "JobVCToCalendar"{
            if let vc = segue.destination as? CalendarViewController{
                vc.categoryType = self.categoryType
            }
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}

/*extension ViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        cell = tblViewForHome.dequeueReusableCell(withIdentifier: "FeaturedLocationsCell") as! FeaturedLocationCellClass
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //It should be greater than your collectionViewCell's size
        return 300.0
    }
}*/

//MARK:- UITABLEVIEWCELL CLASS




