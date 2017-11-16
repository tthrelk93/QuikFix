//
//  CreatePosterStep3ViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 11/2/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CoreLocation

class CreatePosterStep3ViewController: UIViewController {
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        //var authData = Auth.auth().currentUser?.providerData["password"]
        Auth.auth().signIn(withEmail: poster.email!, password: crypt, completion: { (user: User?, error) in
            if error != nil {
                // SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                print("Successful Login")
                //self.poster.experience = self.experience
                
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child((user?.uid)!).child("\(imageName).jpg")
                
                let profileImage = self.profPic
                let uploadData = UIImageJPEGRepresentation(profileImage, 0.1)
                storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        var values = Dictionary<String, Any>()
                        
                        //values["posterID"] = Auth.auth().currentUser!.uid
                        //values["bio"] = self.student.bio
                        values["name"] = self.poster.name
                        values["email"] = self.poster.email
                        // values["password"] = self.poster.password
                        //values["school"] = self.poster.school
                        //values["major"] = self.student.major
                        values["jobsCompleted"] = self.poster.jobsCompleted
                        //values["totalEarned"] = 0
                        values["address"] = [self.poster.address]
                        values["phone"] = self.poster.phone
                        var tempPromo = self.randomString(length: 6)
                        
                        while self.existingPromoCodes.contains(tempPromo){
                            tempPromo = self.randomString(length: 6)
                        }
                        values["promoCode"] = ([tempPromo: [""]] as! [String:Any])
                        values["availableCredits"] = 0
                        values["upcomingJobs"] = self.poster.upcomingJobs
                        //values["experience"] = self.student.experience
                        //values["rating"] =  self.student.rating
                        
                        values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                        values["pic"] = profileImageUrl
                        var tempDict = [String: Any]()
                        tempDict[(user?.uid)!] = values
                        Database.database().reference().child("jobPosters").updateChildValues(tempDict)
                        self.performSegue(withIdentifier: "CreatePosterToProfile", sender: self)
                        
                    }
                })
                
            }
            
        })
        

    }
    @IBAction func skipButton(_ sender: Any) {
        
        
    }
    
    var crypt = String()
    var locationManager = CLLocationManager()
    @IBAction func createAccountPressed(_ sender: Any) {
        //var authData = Auth.auth().currentUser?.providerData["password"]
        Auth.auth().signIn(withEmail: poster.email!, password: crypt, completion: { (user: User?, error) in
            if error != nil {
                // SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else{
                print("Successful Login")
                //self.poster.experience = self.experience
                
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child((user?.uid)!).child("\(imageName).jpg")
                
                let profileImage = self.profPic
                let uploadData = UIImageJPEGRepresentation(profileImage, 0.1)
                storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        var values = Dictionary<String, Any>()
                        
                        //values["posterID"] = Auth.auth().currentUser!.uid
                        //values["bio"] = self.student.bio
                        values["name"] = self.poster.name
                        values["email"] = self.poster.email
                       // values["password"] = self.poster.password
                        //values["school"] = self.poster.school
                        //values["major"] = self.student.major
                        values["jobsCompleted"] = self.poster.jobsCompleted
                        //values["totalEarned"] = 0
                        values["address"] = [self.poster.address]
                        values["phone"] = self.poster.phone
                        var tempPromo = self.randomString(length: 6)
                        
                        while self.existingPromoCodes.contains(tempPromo){
                            tempPromo = self.randomString(length: 6)
                        }
                        values["promoCode"] = ([tempPromo: [""]] as! [String:Any])
                        values["availableCredits"] = 0
                        
                        values["upcomingJobs"] = self.poster.upcomingJobs
                        //values["experience"] = self.student.experience
                        //values["rating"] =  self.student.rating
                        
                        values["location"] = ["lat":Double((self.locationManager.location?.coordinate.latitude)!), "long": Double((self.locationManager.location?.coordinate.longitude)!)] as [String:Any]
                        values["pic"] = profileImageUrl
                        var tempDict = [String: Any]()
                        tempDict[(user?.uid)!] = values
                        Database.database().reference().child("jobPosters").updateChildValues(tempDict)
                        self.performSegue(withIdentifier: "CreatePosterToProfile", sender: self)
                        
                    }
                })
                
            }
            
        })

        
        
    }
    var poster = JobPoster()
    var profPic = UIImage()
    var existingPromoCodes = [String]()
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("jobPosters").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if let tempDict = snap.value as? [String:Any]{
                        var promo = (tempDict["promoCode"] as! [String:Any])
                        for (key, val) in promo{
                            self.existingPromoCodes.append(key)
                        }
                    }
                    

        // Do any additional setup after loading the view.
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
