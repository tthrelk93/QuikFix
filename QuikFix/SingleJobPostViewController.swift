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
   
    @IBOutlet weak var shadowView: UIView!
    @IBAction func applytoJobPressed(_ sender: Any) {
        self.applySuccessView.isHidden = false
        print("posterID: \(self.posterID)")
        Database.database().reference().child("jobPosters").child(self.posterID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                 var containsResponsesBool = false
               
                for snap in snapshots{
                    if snap.key == "responses"{
                        containsResponsesBool = true
                        var tempJobDict = snap.value as! [String:Any]
                        var keyInDictBool = false
                        var tempIDArray = [String]()
                        for (key, val) in
                            tempJobDict{
                            if key == self.jobID{
                                tempIDArray = val as! [String]
                                tempIDArray.append((Auth.auth().currentUser?.uid)!)
                                tempJobDict[key] = tempIDArray
                                keyInDictBool = true
                                break
                                
                                }
                        }
                        if keyInDictBool == false{
                            tempJobDict[self.jobID] = [Auth.auth().currentUser?.uid]
                            var uploadData = [String:Any]()
                            uploadData["responses"] = tempJobDict
                            Database.database().reference().child("jobPosters").child(self.posterID).updateChildValues(uploadData)
                            break
                        } else {
                            var uploadData = [String:Any]()
                            uploadData["responses"] = tempJobDict
                            Database.database().reference().child("jobPosters").child(self.posterID).updateChildValues(uploadData)
                            break
                        }
                    }
                }
                if containsResponsesBool == false{
                    var uploadData = [String:Any]()
                    uploadData[self.jobID] = [Auth.auth().currentUser?.uid]
                    var uploadDict = [String:Any]()
                    uploadDict["responses"] = uploadData
                    Database.database().reference().child("jobPosters").child(self.posterID).updateChildValues(uploadDict)
                    
                }
                DispatchQueue.main.async{
                    sleep(2)
                self.applySuccessView.isHidden = true
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
        shadowView.dropShadow()
        
        
        
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

extension UIView{
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: -2, height: 2)
        self.layer.shadowRadius = 325
        self.layer.cornerRadius = self.frame.width/2
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
}

