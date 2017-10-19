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

class JobLogStudentCell: UICollectionViewCell{
    @IBOutlet weak var studentPic: UIImageView!
    @IBOutlet weak var studentLabel: UILabel!
    
}

class JobLogJobViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

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
        print("groupChat")
        
    }
    @IBOutlet weak var groupChatButton: UIButton!
    @IBAction func jobCompletedPressed(_ sender: Any) {
        
        
    }
    
    var senderScreen = String()
    var job = JobPost()
    var workers = [[String:Any]]()
    
    @IBOutlet weak var posterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterLabel.text = "Poster: \(job.posterName!)"
        cellSelectedPic.layer.cornerRadius = cellSelectedPic.frame.width/2
        jobCatLabel.text = job.category2!
        dateLabel.text = "Date: \(job.date!)"
        timeLabel.text = "Time: \(job.time!)"
        detailsTextView.text = "Details: \(job.additInfo!)"
        if job.workers != nil{
        numberOfStudentsLabel.text = "\(job.workers!.count) QuikFix students"
        }
        if (job.completed! as! Bool) == true{
            jobCompletedButton.setTitle("Job Completed/Students Paid", for: .normal)
            jobCompletedButton.isEnabled = false
            jobCompletedButton.alpha = 0.6
        } else {
            jobCompletedButton.setTitle("Complete Job/Pay Students", for: .normal)
            jobCompletedButton.isEnabled = true
        }
        
        Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshots {
                    if self.job.workers != nil && self.job.workers!.contains(snap.key){
                        var tempDict = [String:Any]()
                        tempDict[snap.key] = ["name": (snap.value as! [String:Any])["name"] as! String, "pic": (snap.value as! [String:Any])["pic"] as! String]
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
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewProfilePressed(_ sender: Any) {
    }
    
    @IBAction func closeSelectedViewPressed(_ sender: Any) {
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
        cellSelectedView.isHidden = false
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JobHistoryViewController{
            vc.senderScreen = self.senderScreen
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
