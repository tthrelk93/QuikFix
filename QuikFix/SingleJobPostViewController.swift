//
//  SingleJobPostViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/25/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SingleJobPostViewController: UIViewController {
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var posterCity: UILabel!
    @IBOutlet weak var posterName: UILabel!
    
    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "SingleJobToJobPosts", sender: self)
    }
    @IBOutlet weak var applySuccessView: UIView!
   
    @IBAction func applytoJobPressed(_ sender: Any) {
        self.applySuccessView.isHidden = false
        Database.database().reference().child("jobs").child(jobID).observe(.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "responses"{
                        
                }
                
            }
            
        })
        
    
    }
    @IBOutlet weak var detailsTextView: UITextView!
    var jobID = String()
    
    var categoryType = String()
    var posterID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImage.layer.cornerRadius = posterImage.frame.width/2
        posterImage.clipsToBounds = true
        
       posterImage.layer.shadowColor = UIColor.black.cgColor
        posterImage.layer.shadowOpacity = 1
        posterImage.layer.shadowOffset = CGSize.zero
        posterImage.layer.shadowRadius = posterImage.frame.width/2
        posterImage.layer.shadowPath = UIBezierPath(rect: posterImage.bounds).cgPath
        posterImage.layer.shouldRasterize = false
        
        
        
        Database.database().reference().child("jobs").child(jobID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "payment"{
                        self.rateLabel.text = snap.value as! String
                    } else if snap.key == "time"{
                        self.timeLabel.text = (snap.value as! String)
                    }else if snap.key == "additInfo"{
                        self.detailsTextView.text = snap.value as! String
                        
                    } else if snap.key == "posterID"{
                        self.posterID = snap.value as! String
                    } else if snap.key == "date"{
                        self.dateLabel.text = snap.value as! String
                    }
                    
                }
                
            }
            
        })
        Database.database().reference().child("jobPosters").child(self.posterID).observeSingleEvent(of: .value, with : {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "address"{
                        self.addressLabel.text = snap.value as! String
                    } else if snap.key == "pic"{
                        if let messageImageUrl = URL(string: snap.value as! String) {
                            
                            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                                
                                self.posterImage.image = UIImage(data: imageData as Data) }
                        }
                        
                    } else if snap.key == "name"{
                        self.posterName.text = snap.value as! String
                    }
                    
                }
            }
            
        })



        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JobPostViewController{
            vc.categoryType = self.categoryType
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
