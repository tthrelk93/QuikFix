//
//  StudentOrPosterViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 11/7/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import CoreLocation
import SwiftOverlays

class StudentOrPosterViewController: UIViewController, CLLocationManagerDelegate {

    var accountType = String()
    @IBAction func iAmStudentPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            //self.orLabel.isHidden = true
            //self.orLabelView.isHidden = true
            self.iAmHomeowner.setTitle("", for: .normal)
            self.iAmStudent.setTitle("", for: .normal)
            self.nowOrLaterView.isHidden = false
            self.nowOrLaterView.frame = self.mainView.frame
            
            
            //self.iAmStudent.isHidden = true
        }, completion: nil)
        
    }
    @IBOutlet weak var orLabel: UIView!
    
    @IBOutlet weak var iAmStudent: UIButton!
    @IBOutlet weak var iAmHomeowner: UIButton!
    @IBOutlet weak var labelView: UIView!
    @IBAction func
        iAmHomeOwnerPressed(_ sender: Any) {
        self.accountType = "student"
        performSegue(withIdentifier: "StudentOrPosterToImageSelect", sender: self)
    }
    
    @IBOutlet weak var orLabelView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //orLabel.baselineAdjustment = .alignCenters//kCAAlignmentCenter
        labelView.layer.cornerRadius = 7//orLabel.frame.width/2
        self.view.bringSubview(toFront: labelView)
        self.view.bringSubview(toFront: orLabel)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var nowOrLaterView: UIView!
    
    @IBAction func nowButtonPressed(_ sender: Any) {
        self.accountType = "homeOwner"
        performSegue(withIdentifier: "StudentOrPosterToImageSelect", sender: self)
        
    }
    
    @IBAction func laterPressed(_ sender: Any) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        Auth.auth().signInAnonymously() { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
            print("Successful Anon Login")
            //self.poster.experience = self.experience
            SwiftOverlays.showBlockingWaitOverlayWithText("Loading Profile")
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child((user?.uid)!).child("\(imageName).jpg")
            
            let profileImage = UIImage(named: "profilePicButton")
            let uploadData = UIImageJPEGRepresentation(profileImage!, 0.1)
            storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    var values = Dictionary<String, Any>()
                    
                    //values["posterID"] = Auth.auth().currentUser!.uid
                    //values["bio"] = self.student.bio
                    values["name"] = "n/a"
                    values["email"] = "n/a"
                    values["address"] = ["n/a"]
                    values["phone"] = "n/a"
                    var tempPromo = self.randomString(length: 6)
                    
                    while self.existingPromoCodes.contains(tempPromo){
                        tempPromo = self.randomString(length: 6)
                    }
                    values["stripeToken"] = ""
                    values["posterID"] = Auth.auth().currentUser!.uid
                    values["promoCode"] = ([tempPromo: [""]] as [String:Any])
                    
                    values["creditHours"] = 0.0
                    values["availableCredits"] = 0
                    //values["upcomingJobs"] = self.poster.upcomingJobs
                    //values["experience"] = self.student.experience
                    //values["rating"] =  self.student.rating
                    print("locDict: \(self.locDict)")
                    values["location"] = self.locDict
                    values["pic"] = profileImageUrl
                    var tempDict = [String: Any]()
                    tempDict[(user?.uid)!] = values
                    Database.database().reference().child("jobPosters").updateChildValues(tempDict)
            self.performSegue(withIdentifier: "CreateAccountLater", sender: self)
        }
            })
            }
            }
        
    }
    @IBOutlet var mainView: UIView!
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateAccountMainViewController{
            print(self.accountType)
        vc.accountType = self.accountType
            vc.sender = "step2"
            
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
            var locDict = [String:Any]()
            let locationManager = CLLocationManager()
            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                var locValue:CLLocationCoordinate2D = manager.location!.coordinate
                self.locDict = ["lat" : locValue.latitude, "long": locValue.longitude]
                //print("locations = \(locValue.latitude) \(locValue.longitude)")
                //var ref = Database.database().reference.child("users").child(Auth.auth().currentUser.uid).child("location")
                //ref.updateChildValues(locDict)
            }

    

}
