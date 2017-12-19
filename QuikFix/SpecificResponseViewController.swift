//
//  SpecificResponseViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/4/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class SpecificResponseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, AcceptDeclineDelegate {

    @IBOutlet weak var jobNameLabel: UILabel!
    @IBOutlet weak var jobResponseCollect: UICollectionView!
    var studentArray = [Student]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobNameLabel.text = self.job.category1
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
                self.jobResponseCollect.delegate = self
                self.jobResponseCollect.dataSource = self
            }
        })
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var job = JobPost()
    var jobArray = [String]()
    
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
        cell.profileButton.layer.cornerRadius = cell.profileButton.frame.width/2
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
    
    //cellDelegateMethods
    var delegateStudentID = String()
    func accept(studentID: String){
        print("pecific response")
        self.delegateStudentID = studentID
        for student in 0...studentArray.count{
            if studentID == studentArray[student].studentID{
                studentArray.remove(at: student)
                jobResponseCollect.performBatchUpdates({
                    self.jobResponseCollect.deleteItems(at:[IndexPath(row: student, section: 0)])}
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
                jobResponseCollect.performBatchUpdates({
                    self.jobResponseCollect.deleteItems(at:[IndexPath(row: student, section: 0)])}
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
        self.delegateStudentID = studentID
        performSegue(withIdentifier: "ResponseToStudentProfile", sender: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResponseToStudentProfile"{
            if let vc = segue.destination as? studentProfile{
                vc.notUsersProfile = true
                vc.studentIDFromResponse = self.delegateStudentID
                vc.job = self.job
                vc.jobArray = self.jobArray
            }
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
