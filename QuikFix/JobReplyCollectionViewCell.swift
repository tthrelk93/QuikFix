//
//  JobReplyCollectionViewCell.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/4/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


protocol AcceptDeclineDelegate2 {
   
    func viewProf2(studentID: String)
    func acceptDelegateFunc(job: JobPost, studentID: String)
    func hideBack()
    
}


class JobReplyCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, AcceptDeclineDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var acceptedWorkerLabel: UILabel!
    @IBOutlet weak var jobCatLabel: UILabel!
    @IBOutlet weak var responseCollect: UICollectionView!
    var delegate: AcceptDeclineDelegate2?
    var job = JobPost()
    var jobArray = [String]()
    var studentArray = [Student]()
    func dataInit(){
        jobCatLabel.text = self.job.category1
        Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshots {
                    if self.jobArray.contains(snap.key){
                        var tempDict = snap.value as! [String:Any]
                        let tempStudent = Student()
                        tempStudent.pic = tempDict["pic"] as? String
                        tempStudent.name = tempDict["name"] as? String
                        if tempDict["jobsCompleted"] != nil{
                            tempStudent.jobsCompleted = tempDict["jobsCompleted"] as? [String]
                        }
                        tempStudent.studentID = tempDict["studentID"] as? String
                        
                        self.studentArray.append(tempStudent)
                    }
                    
                }
                
                self.responseCollect.delegate = self
                self.responseCollect.dataSource = self
                //let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               // self.responseCollect.collectionViewLayout = layout
            }
        })
        

    }
    
    
    
    
   
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        print("heythere")
        
        let totalCellWidth =  self.frame.width * CGFloat(studentArray.count)//CellWidth * CellCount
        let totalSpacingWidth = 10 * (studentArray.count - 1)
        
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return studentArray.count
    }
    var jobID = String()
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpecificResponseCollectionViewCell", for: indexPath) as! SpecificResponseCollectionViewCell
        cell.layer.cornerRadius = 12
        //cell.layer.cornerRadius = cell.frame.width/2
        cell.delegate = self
        cell.studentID = studentArray[indexPath.row].studentID!
        cell.profileButton.layer.cornerRadius = 12
        cell.profileButton.clipsToBounds = true
        cell.nameLabel.text = studentArray[indexPath.row].name
        
        if studentArray[indexPath.row].jobsCompleted != nil{
            cell.jobCountLabel.text = String(describing: studentArray[indexPath.row].jobsCompleted?.count)
        } else {
            cell.jobCountLabel.text = "0"
        }
        if let messageImageUrl = URL(string: studentArray[indexPath.row].pic!) {
            
            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                cell.profileButton.setBackgroundImage(UIImage(data: imageData as Data), for: .normal)
            }
        }
        
        
        /* for job in jobArray{
         if job.jobID == jobIDArray[indexPath.row]{
         cell.jobCatLabel.text = job.category2
         
         }
         
         }*/
        
        
        
        return cell
    }
    var upcomingJobs = [String]()
    @IBOutlet weak var noNewResponses: UILabel!
    //cellDelegateMethods
    var delegateStudentID = String()
    func accept(studentID: String){
        
       // delegate?.hideBack()
        
        
        self.delegateStudentID = studentID
        for student in 0...studentArray.count{
            if studentID == studentArray[student].studentID{
                studentArray.remove(at: student)
                responseCollect.performBatchUpdates({
                    self.responseCollect.deleteItems(at:[IndexPath(row: student, section: 0)])}
                    , completion: nil)
                break
            }
        }
        
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshots {
                    if snap.key == "upcomingJobs"{
                        self.upcomingJobs = snap.value as! [String]
                    }
                    if snap.key == "responses"{
                        var tempDict = snap.value as! [String:Any]
                        for (key,val) in tempDict{
                            if key == self.job.jobID{
                                var tempArray = val as! [String]
                                //var uploadDict = [String:Any]()
                                
                                let removeIndex = tempArray.index(of: studentID)
                                tempArray.remove(at: removeIndex!)
                                tempDict[key] = tempArray
                                
                            }
                        }
                        var posterUploadDict = [String:Any]()
                        posterUploadDict["responses"] = tempDict
                        
                        self.upcomingJobs.append(self.job.jobID!)
                        posterUploadDict["upcomingJobs"] = self.upcomingJobs
                        
                        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).updateChildValues(posterUploadDict)
                        Database.database().reference().child("students").child(studentID).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                                var containsJobs = false
                                var upcomingArray = [String]()
                                for snap in snapshots {
                                    if snap.key == "upcomingJobs"{
                                        upcomingArray = snap.value as! [String]
                                        upcomingArray.append(self.job.jobID!)
                                        containsJobs = true
                                    }
                                    var uploadDict2 = [String:Any]()
                                    if containsJobs == false{
                                        
                                        uploadDict2["upcomingJobs"] = [self.job.jobID]
                                    }else {
                                        uploadDict2["upcomingJobs"] = upcomingArray
                                    }
                                    Database.database().reference().child("students").child(studentID).updateChildValues(uploadDict2)
                                    
                                    var uploadDict3 = [String:Any]()
                                    
                                    if (String(describing:self.job.acceptedCount! as! Int + 1)) == (String(describing:self.job.workerCount! as! Int)) {
                                        
                                        self.acceptedWorkerLabel.text = "\(String(describing:(self.job.acceptedCount! as! Int) + 1) )/\(String(describing:self.job.workerCount! as! Int) ) accepted student workers"
                                        
                                        uploadDict3["acceptedCount"] = (self.job.acceptedCount as! Int) + 1
                                        Database.database().reference().child("jobs").child(self.job.jobID!).updateChildValues(uploadDict3)
                                        self.delegate?.acceptDelegateFunc(job: self.job, studentID: studentID)
                                        //self.collectionView.isHidden = true
                                        
                                        
                                    } else {
                                        self.acceptedWorkerLabel.text = "\(String(describing:(self.job.acceptedCount as! Int) + 1))/\(String(describing:self.job.workerCount as! Int)) student workers"
                                        uploadDict3["acceptedCount"] = (self.job.acceptedCount as! Int) + 1
                                        Database.database().reference().child("jobs").child(self.job.jobID!).updateChildValues(uploadDict3)
                                //        self.collectionView.isHidden = true
                                    }
                                    
                                    /*uploadDict["acceptedCount"] = (self.job.acceptedCount as! Int) + 1
                                    Database.database().reference().child("jobs").child(self.job.jobID).updateChildValues()*/
                                }
                            }
                        })
                        
                        
                    }
                }
            }
        })
        
        //sendPushNotification
        
        
        
        print("accept")
        
        
    }
    func decline(studentID: String){
        self.delegateStudentID = studentID
        for student in 0...studentArray.count{
            if studentID == studentArray[student].studentID{
                studentArray.remove(at: student)
                responseCollect.performBatchUpdates({
                    self.responseCollect.deleteItems(at:[IndexPath(row: student, section: 0)])}
                    , completion: nil)
                break
            }
        }
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshots {
                    if snap.key == "responses"{
                        var tempDict = snap.value as! [String:Any]
                        for (key,val) in tempDict{
                            if key == self.job.jobID{
                                var tempArray = val as! [String]
                                //var uploadDict = [String:Any]()
                                
                                let removeIndex = tempArray.index(of: studentID)
                                tempArray.remove(at: removeIndex!)
                                tempDict[key] = tempArray
                                
                            }
                        }
                        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).updateChildValues(["responses":tempDict])
                        
                    }
                }
            }
        })
        print("decline")
        
        
    }
    func viewProf(studentID: String){
        delegate?.viewProf2(studentID: studentID)
        //self.delegateStudentID = studentID
       // performSegue(withIdentifier: "ResponseToStudentProfile", sender: self)
    }

    
    
}
