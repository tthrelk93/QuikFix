//
//  FindAvailableWorkersViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/5/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class FindAvailableWorkersViewController: UIViewController {

    var jobUploadData = [String:Any]()
    var jobRef = String()
    var posterUploadData = [String:Any]()
    @IBAction func firstToAcceptButtonPressed(_ sender: Any) {
        var tempDict = [String:Any]()
        tempDict[jobRef] = jobUploadData
        print("jf \(jobRef)")
        print("posterUploadData \(posterUploadData)")
        Database.database().reference().child("jobs").updateChildValues(tempDict)
        Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(posterUploadData)
        performSegue(withIdentifier:"HireFirstToPosterProfile", sender: self)
        
    }
    @IBAction func handPickButtonPressed(_ sender: Any) {
    }
    @IBOutlet weak var workerNumbLabel: UILabel!
    
    var tempCoordinate: CLLocation?
    var tempLong: CLLocationDegrees?
    var tempLat: CLLocationDegrees?
    var tempCoordinate2: CLLocation?
    var tempLong2: CLLocationDegrees?
    var tempLat2: CLLocationDegrees?
    var tempDistInMeters: Double?

    var availableStudents = [[String:Any]]()
    var studentsAfterDist = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    let snapDict = snap.value as! [String:Any]
                    if snapDict["available"] as! Bool == true{
                        self.availableStudents.append(snapDict)
                    }
                }
                let userID = Auth.auth().currentUser?.uid
                Database.database().reference().child("jobPosters").child(userID!).child("location").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if snap.key == "long"{
                                self.tempLong2 = snap.value as? CLLocationDegrees
                            }else{
                                self.tempLat2 = snap.value as? CLLocationDegrees
                            }
                        }
                    }
                    self.tempCoordinate2 = CLLocation(latitude: self.tempLat2!, longitude: self.tempLong2!)
                    
                    var tempCount = 0
                    //  DispatchQueue.main.async{
                    for student in self.availableStudents{
                        
                        tempCount += 1
                        self.tempLong = (student["location"] as! [String:Any])["long"] as? CLLocationDegrees
                        self.tempLat = (student["location"] as! [String:Any])["lat"] as? CLLocationDegrees
                        self.tempCoordinate = CLLocation(latitude: self.tempLat!, longitude: self.tempLong!)
                        let geoCoder = CLGeocoder()
                        let geoCoder2 = CLGeocoder()
                            if Int((self.tempCoordinate?.distance(from: self.tempCoordinate2!))!) <= 90000 {
                                self.studentsAfterDist.append(student)
                        }
                    }
                    self.workerNumbLabel.text = "We've found \(self.studentsAfterDist.count) available student(s) nearby!"
                })
            }
        })
    }

        // Do any additional setup after loading the view.


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HireFirstToPosterProfile"{
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! JobPosterProfileViewController
            targetController.showJobPostedView = true
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        }
    }
    

}
