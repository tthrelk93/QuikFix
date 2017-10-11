//
//  JobHistoryViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/30/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class JobHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var calendarDict = [String:Any]()
    var categoryType = String()
    @IBOutlet weak var jobHistoryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("jobs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for snap in snapshots {
                
                var tempDict = snap.value as! [String:Any]
                if tempDict["category1"] as! String == self.categoryType{
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
                    //tempJob.paymentType = tempDict["paymentType"] as! Int
                    if self.calendarDict[tempJob.date!] != nil {
                        var tempJobArray = self.calendarDict[tempJob.date!]!
                        //tempJobArray.append(tempJob)
                        self.calendarDict[tempJob.date!] = tempJobArray
                    } else {
                        self.calendarDict[tempJob.date!] = [tempJob]
                    }
                } else if self.categoryType == "All"{
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
                    //tempJob.paymentType = tempDict["paymentType"] as! Int
                    if self.calendarDict[tempJob.date!] != nil {
                        var tempJobArray = self.calendarDict[tempJob.date!]!
                        //tempJobArray.append(tempJob)
                        self.calendarDict[tempJob.date!] = tempJobArray
                    } else {
                        self.calendarDict[tempJob.date!] = [tempJob]
                    }
                    
                }
                
            }
            for (key, _) in self.calendarDict{
                //self.datesArray.append(key)
            }
            //var testArray = ["25 Jun, 2016", "30 Jun, 2016", "28 Jun, 2016", "2 Jul, 2016"]
            var convertedArray: [Date] = []
            
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM-dd-yyyy"
            
            /*for dat in self.datesArray {
                var date = dateFormatter.date(from: dat)
                convertedArray.append(date!)
            }*/
            
            //Approach : 1
            convertedArray.sort(){$0 < $1}
            //self.datesArray.removeAll()
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
                //self.datesArray.append(dateString)
            }
            
            //self.calendarTableView.delegate = self
            //self.calendarTableView.dataSource = self
            DispatchQueue.main.async{
                //self.calendarTableView.reloadData()
            }
            
            
            
        })


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //***TableView DataSource functions
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
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
        //cell.dateLabel?.text = datesArray[indexPath.row]
        cell.layer.borderColor = UIColor.clear.cgColor
       /* for (key, val) in calendarDict{
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
            }*/
       // }
        
        
        
        
    }
   /* public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        //let tempCell = DateCollectionViewCell()
        //print("TVCheight: \((tempCell.frame.height * CGFloat(jobsForDate.count)))")
        return ((145.0 * CGFloat(jobsForDate.count)) + 37)
    }*/
    var selectedJobID = String()
    var selectedJob = JobPost()
    
    /*func performSegueToJob(category: String, jobID: String, job: JobPost){
        self.selectedJobID = jobID
        self.selectedJob = job
        performSegue(withIdentifier: "SingleJobSelected", sender: self)
    }
*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
