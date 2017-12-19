//
//  JobResponseViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/4/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class JobResponseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AcceptDeclineDelegate2 {

    @IBOutlet weak var jobPlacementWorkerCountLabel: UILabel!
    @IBAction func placeJobOrderPressed(_ sender: Any) {
        jobOrderReadyView.isHidden = true
        orderPlacedSuccesView.isHidden = false
        self.backButton.isHidden = false
        //send push notification to student workers
    }
    @IBOutlet weak var jobsCollect: UICollectionView!
    
    @IBOutlet weak var jobOrderReadyView: UIView!
    
    var responseDict = [String:Any]()
    var jobIDArray = [String]()
    var jobArray = [JobPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
            
                for snap in snapshots {
                    if snap.key == "responses"{
                        self.responseDict = snap.value as! [String:Any]
                        
                    }
                
                }
                for (key, _) in self.responseDict{
                    self.jobIDArray.append(key)
                }
                Database.database().reference().child("jobs").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        for snap in snapshots {
                            if self.jobIDArray.contains(snap.key){
                                let tempJob = JobPost()
                                let tempDict = snap.value as! [String:Any]
                                for (key, val) in tempDict{
                                    if key == "workerCount"{
                                        let tempInt = val as! Int
                                       tempJob.setValue(tempInt, forKeyPath: key)
                                    } else {
                                    tempJob.setValue(val, forKeyPath: key)
                                    }
                                
                                }
                                
                                
                                
                                self.jobArray.append(tempJob)
                            }
                        }
                      /*  for job in self.jobArray{
                            for (key, val) in responseDict{
                                if job.jobID == key{
                                    if val.response
                                    
                                }
                            }
                            
                        }*/
                        
                        self.jobsCollect.delegate = self
                        self.jobsCollect.dataSource = self
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobIDArray.count
    }
    var jobID = String()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobReplyCollectionViewCell", for: indexPath) as! JobReplyCollectionViewCell
       //cell.layer.cornerRadius = cell.frame.width/2
        for job in jobArray{
            if job.jobID == jobIDArray[indexPath.row]{
                cell.jobCatLabel.text = job.category1
                cell.acceptedWorkerLabel.text = "\(job.acceptedCount!)/\(job.workerCount!) accepted student workers"
                for (key,val) in responseDict{
                    if key == self.jobIDArray[indexPath.row]{
                        sendData = val as! [String]
                        
                    }
                }
                for job in jobArray{
                    if job.jobID == jobIDArray[indexPath.row]{
                        self.selectedJob = job
                    }
                }
                cell.delegate = self
                cell.job = self.selectedJob
                cell.jobArray = self.sendData
                cell.dataInit()

                
                
            }
            
        }
        
        
        
        return cell
    }
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func thanksButtonPressed(_ sender: Any) {
        orderPlacedSuccesView.isHidden = true
        jobsCollect.isHidden = false
        self.backButton.isHidden = false
        
        
    }
    
    @IBOutlet weak var orderPlacedSuccesView: UIView!
    var studentIDFromDelegate = String()
    var acceptString = String()
    var workerCountString = String()
    func hideBack(){
        //self.backButton.isHidden = true
    }
   var tempListingsArray = [String]()
    func acceptDelegateFunc(job: JobPost, studentID: String){
        
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshots {
                    if snap.key == "currentListings"{
                        self.tempListingsArray = snap.value as! [String]
                        print("cl: \(self.tempListingsArray)")
                        for val in 0...self.tempListingsArray.count - 1{
                            
                            if self.tempListingsArray[val] == job.jobID{
                                print(self.tempListingsArray[val])
                                self.tempListingsArray.remove(at: val)
                                break
                            }
                        }
                        
                    }
                }
                print("cl: \(self.tempListingsArray)")
                 Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).updateChildValues([ "currentListings": self.tempListingsArray])
            }
            Database.database().reference().child("jobs").child(job.jobID!).observeSingleEvent(of: .value, with: { (snapshot) in
                print("in accepttt")
                
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    var workersBool = false
                    var workers = [String]()
                    for snap in snapshots{
                        if snap.key == "workers"{
                            workers = snap.value as! [String]
                            workersBool = true
                        }
                        
                    }
                    
                    if workersBool == false{
                        var tempDict = [String:Any]()
                        tempDict["workers"] = [studentID]
                        Database.database().reference().child("jobs").child(job.jobID!).updateChildValues(tempDict)
                        print("jobID: \(String(describing: job.jobID))")
                    } else {
                        workers.append(studentID)
                        var tempDict = [String:Any]()
                        tempDict["workers"] = workers
                        Database.database().reference().child("jobs").child(job.jobID!).updateChildValues(tempDict)
                        
                    }
                    
                }
            })

        })
        

        acceptString = String(describing:(job.acceptedCount! as! Int) + 1)
        workerCountString = String(describing: job.workerCount! as! Int) as String!
        jobPlacementWorkerCountLabel.text = "\(acceptString)/\(workerCountString) student workers found to complete your job."
        jobOrderReadyView.isHidden = false
        self.jobsCollect.reloadData()
        
    }
    func viewProf2(studentID: String){
        self.studentIDFromDelegate = studentID
        performSegue(withIdentifier: "ResponseToStudentProfile", sender: self)
    }
    var sendData = [String]()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
               performSegue(withIdentifier:"MainResponseToSpecific", sender: self)
    }

    

    var selectedJob = JobPost()
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? studentProfile{
            //vc.job = self.selectedJob
            //vc.jobArray = self.sendData
            vc.notUsersProfile = true
            vc.studentIDFromResponse = self.studentIDFromDelegate
           // vc.job = self.job
            //vc.jobArray = self.jobArray
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
