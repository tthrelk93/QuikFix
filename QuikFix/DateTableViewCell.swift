//
//  DateTableViewCell.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/24/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol PerformSegueInJobPostViewController {
    func performSegueToSingleJob(category: String, jobID: String, job: JobPost)
    
}


class DateTableViewCell: UITableViewCell, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, PerformSegueInTableViewCell {
   var date = String()
    var sender = String()
    var delegate: PerformSegueInJobPostViewController?
    //var tempCollect = UICollectionView()
    @IBOutlet weak var calCollect: UICollectionView!
    
    @IBOutlet weak var dateLabel: UILabel!
    var category = String()
    var jobsForDate = [JobPost]()
    var calendarDict = [String:Any]()
    
    
    
    
    func performSegueInTableView(category: String, jobID: String, job: JobPost){
        delegate?.performSegueToSingleJob(category: category, jobID: jobID, job: job)
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
       // var tempJobArray = [JobPost]()
        self.contentView.isMultipleTouchEnabled = true
        self.contentView.gestureRecognizers?.first?.cancelsTouchesInView = false
       // self.contentView.gestureRecognizers.first?.
        print("tableCellLoadNib")
        print("jobsForDate: \(self.jobsForDate)")
        

        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobsForDate.count
    }
    var jobID = String()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        //cell.gestureRecognizers?.first?.cancelsTouchesInView = false
        // cell.gestureRecognizers?.first?.delaysTouchesBegan = false
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.posterName.text = self.jobsForDate[indexPath.row].category1
        cell.distLabel.text = ""
        cell.rateLabel.text = self.jobsForDate[indexPath.row].payment
        cell.timeLabel.text = self.jobsForDate[indexPath.row].date
        cell.additInfoLabel.text = self.jobsForDate[indexPath.row].additInfo
        cell.category = self.category
        cell.jobID = self.jobsForDate[indexPath.row].jobID!
        cell.job = self.jobsForDate[indexPath.row]
        cell.widthAnchor.constraint(equalToConstant: self.dateLabel.frame.width)
        
        cell.delegate = self
        
    
        return cell
    }
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        //let screenSize = UIScreen.main.bounds
        //let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        return CGSize(width: self.frame.width, height: 375.0)
    }*/
    
    

}
