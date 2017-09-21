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

class JobPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var jobCategoryPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("jobs").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let snapshots = snapshot.children.allObjects as! [DataSnapshot]
            
            for snap in snapshots {
                var tempDict = snap.value as! [String:Any]
                var tempJob = JobPost()
                tempJob.additInfo = tempDict["additInfo"] as! String
                tempJob.category1 = (tempDict["category1"] as! String)
                tempJob.category2 = tempDict["category2"] as! String
                tempJob.posterName = tempDict["posterName"] as! String
                tempJob.date = tempDict["date"] as! String
                tempJob.payment = tempDict["payment"] as! String
                tempJob.paymentType = tempDict["paymentType"] as! Int
                
                //tempJob.setValuesForKeys(tempDict)
                //tempJob.setValues(for: tempDict)
                if self.calendarDict[tempJob.date!] != nil {
                    var tempJobArray = self.calendarDict[tempJob.date!]!
                    tempJobArray.append(tempJob)
                    self.calendarDict[tempJob.date!] = tempJobArray
                } else {
                    self.calendarDict[tempJob.date!] = [tempJob]
                }
                
            }
            for (key, _) in self.calendarDict{
                self.datesArray.append(key)
            }
            //let cellNib = UINib(nibName: "DateTableViewCell", bundle: nil)
            //self.calendarTableView.register(cellNib, forCellReuseIdentifier: "DateTableViewCell")
            self.calendarTableView.delegate = self
            self.calendarTableView.dataSource = self
            
            
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
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return jobsForDate.count
    }
    
    
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath as IndexPath) as! DateCollectionViewCell
        configureCollectCell(cell, collectionView: collectionView, forIndexPath: indexPath as NSIndexPath)
        //cell.indexPath = indexPath
        return cell

    }
    func configureCollectCell(_ cell: DateCollectionViewCell, collectionView: UICollectionView, forIndexPath indexPath: NSIndexPath){
        cell.posterName.text = self.jobsForDate[indexPath.row].posterName
        cell.posterDist.text = ""
        cell.rate.text = self.jobsForDate[indexPath.row].payment
        cell.timeLabel.text = self.jobsForDate[indexPath.row].date
        cell.detailsLabel.text = self.jobsForDate[indexPath.row].additInfo
    }
    
    //***TableView DataSource functions
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return datesArray.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateTableCell",
                                                 for: indexPath)
        configureTableViewCell(tableView: tableView, cell: cell as! DateTableViewCell, indexPath: indexPath)
        
        return cell
    }
    var sizingCell: DateCollectionViewCell?
    func configureTableViewCell(tableView: UITableView, cell: DateTableViewCell, indexPath: IndexPath){
        cell.dateLabel.text = datesArray[indexPath.row]
        
        for (key, val) in calendarDict{
            if key == datesArray[indexPath.row]{
                self.jobsForDate = (val )
                break
            }
        }
        //calendarTableView.contentSize =
        
       // let cellNib = UINib(nibName: "DateCollectionViewCell", bundle: nil)
        //cell.jobsCollect.register(cellNib, forCellWithReuseIdentifier: "DateCollectionViewCell")
        //dself.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! DateCollectionViewCell?
        //self.jobsCollect.backgroundColor = UIColor.clear
        
        var tempCell = DateCollectionViewCell()
        
         //cell.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.width, height: (tempCell.frame.height * CGFloat(jobsForDate.count)))
        
        //cell.jobsCollect.frame = CGRect(x: cell.jobsCollect.frame.origin.x, y: cell.jobsCollect.frame.origin.y, width: cell.jobsCollect.frame.width, height: (tempCell.frame.height * CGFloat(jobsForDate.count)))
        //cell.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.width, height: (tempCell.frame.height * CGFloat(jobsForDate.count)))
        cell.jobsCollect.delegate = self
        cell.jobsCollect.dataSource = self
        
        
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
