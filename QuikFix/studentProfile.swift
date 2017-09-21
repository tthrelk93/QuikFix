//
//  studentProfile.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/5/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class studentProfile: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var earnedAmount: UILabel!
    @IBOutlet weak var jobsFinished: UILabel!
    @IBOutlet weak var expTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var starView: CosmosView!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var gradYearLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var studentBioLabel: UILabel!
    @IBOutlet weak var jobCountLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
    @IBOutlet weak var studentBio: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var jobsFinishedArray = [String]()
    var upcomingJobsArray = [String]()
    var experienceDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "name"{
                        self.nameLabel.text = snap.value as! String
                        
                    }
                    else if snap.key == "school"{
                        self.schoolLabel.text = snap.value as? String
                        }
                    else if snap.key == "major"{
                        self.majorLabel.text = snap.value as? String
                    }
                        else if snap.key == "jobsFinished"{
                        for job in snap.value as! [String]{
                            self.jobsFinishedArray.append(job)
                        }
                        self.jobsFinished.text = String(describing:self.jobsFinishedArray.count)
                        
                    }
                    else if snap.key == "rating"{
                        self.starView.rating = Double(snap.value as! Int)
                    }
                    else if snap.key == "totalEarned"{
                        self.earnedAmount.text = ("$\(String(describing:snap.value as! Int))")
                    }
                        
                
                
                    else if snap.key == "pic"{
                        if let messageImageUrl = URL(string: snap.value as! String) {
                            
                            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                                self.profileImageView.image = UIImage(data: imageData as Data) } }
                        //  loadImageUsingCacheWithUrlString(snap.value as! String)
                    }
                    else if snap.key == "bio"{
                        self.studentBio.text = snap.value as! String
                    }
                }
            }
        })
        
        
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
