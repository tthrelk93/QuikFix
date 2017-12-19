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
import FirebaseMessaging
import FirebaseAuth
import FirebaseStorage
import SwiftOverlays
import CoreLocation





class studentProfile: UIViewController, UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RemoveDelegate, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, MessagingDelegate {
    
    
    

    
    
    
    //@IBOutlet weak var availableForWorkLabel: UILabel!
    //@IBAction func availableSwitchActivated(_ sender: Any) {
        //var tempDict = [String:Any]()
        /*if availableSwitch.isOn{
            tempDict["available"] = true
            availableForWorkLabel.text = "Available for work"
        } else {
            tempDict["available"] = false
            availableForWorkLabel.text = "Not available for work"
        }
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).updateChildValues(tempDict)
        
        
    }*/
    //@IBOutlet weak var availableSwitch: UISwitch!
    var notUsersProfile = false
    var studentIDFromResponse = String()
    var job = JobPost()
    var jobArray = [String]()
    
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
   // @IBOutlet weak var studentBioLabel: UILabel!
    @IBOutlet weak var jobCountLabel: UILabel!
    @IBOutlet weak var earnedLabel: UILabel!
  //  @IBOutlet weak var studentBio: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var jobsFinishedArray = [String]()
    var upcomingJobsArray = [String]()
    var experienceDict = [String:Any]()
    var location = CLLocation()
    //edit profile view
    var selectedImage = UIImage()
   // @IBOutlet weak var editProfView: UIView!
   /* @IBAction func saveChangesPressed(_ sender: Any) {
        var values = [String: Any]()
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child((Auth.auth().currentUser?.uid)!).child("\(imageName).jpg")
        
        if let profileImage = self.editProfPicImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            //storageRef.putData(uploadData)
            
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    if self.editCityTextField.text != "" {
                        values["city"] = self.editCityTextField.text
                    } else {
                         values["city"] = self.editCityTextField.placeholder
                    }
                    if self.editSchoolTextField.text != ""{
                        values["school"] = self.editSchoolTextField.text
                    } else {
                         values["school"] = self.editSchoolTextField.placeholder
                    }
                    if self.editMajorTextField.text != ""{
                        values["major"] = self.editMajorTextField.text
                    } else {
                        values["major"] = self.editMajorTextField.placeholder
                    }
                    if self.editGradYearTextField.text != ""{
                        values["gradYear"] = self.editGradYearTextField.text
                    } else {
                        values["gradYear"] = self.editGradYearTextField.placeholder
                    }
                    //if self.editBioTextView.text != "Edit Bio"
                    values["bio"] = self.editBioTextView.text
                    if self.editNameTextField.text != ""{
                        
                        values["name"] = self.editNameTextField.text
                    } else {
                        values["name"] = self.editNameTextField.placeholder
                    }
                    
                    values["pic"] = profileImageUrl
                    
        
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).updateChildValues(values)
                    self.editProfView.isHidden = true
                    self.loadPageData()
                }
            })
        }
    
    
        
    }*/
    
    @IBOutlet weak var menuButton: UIButton!
    var sender = String()
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButtonForPoster: UIButton!
    func loadPageData(){
        SwiftOverlays.removeAllOverlaysFromView(self.view)
        SwiftOverlays.removeAllBlockingOverlays()
        tabBar.delegate = self
        if self.notUsersProfile == false{
            //availableForWorkLabel.isHidden = false
            //availableSwitch.isHidden = false
            menuButton.isHidden = false
            backButtonForPoster.isHidden = true
            editButton.isHidden = false
        //self.editProfPicImageView.layer.cornerRadius = 10
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        picker.delegate = self
        profileImageView.clipsToBounds = false
        profileImageView.layer.masksToBounds = true
            profileImageView.centerXAnchor.constraint(equalTo: self.cityLabel.centerXAnchor).isActive = true
        /*editGradYearTextField.delegate = self
        editMajorTextField.delegate = self
        editNameTextField.delegate = self
        editBioTextView.delegate = self
        editSchoolTextField.delegate = self*/
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "name"{
                        self.nameLabel.text = snap.value as? String
                        //self.editNameTextField.placeholder = snap.value as! String
                        
                    }
                        /*else if snap.key == "available"{
                        if snap.value as! Bool == true{
                            self.availableSwitch.isOn = true
                        } else {
                            self.availableSwitch.isOn = false
                        }*/
                        
                        
                    //}
                    else if snap.key == "school"{
                        self.schoolLabel.text = snap.value as? String
                        //self.editSchoolTextField.placeholder = snap.value as! String
                    }
                    else if snap.key == "major"{
                        self.majorLabel.text = snap.value as? String
                        //self.editMajorTextField.placeholder = snap.value as! String
                    }
                    else if snap.key == "jobsCompleted"{
                        for job in snap.value as! [String]{
                            self.jobsFinishedArray.append(job)
                        }
                        self.jobsFinished.text = String(describing:self.jobsFinishedArray.count)
                        
                        
                    }
                        else if snap.key == "location"{
                        var tempDict = snap.value as! [String: Any]
                        self.location = CLLocation(latitude: tempDict["lat"] as! CLLocationDegrees, longitude: tempDict["long"] as! CLLocationDegrees)
                        
                        let geoCoder = CLGeocoder()
                        
                        geoCoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) -> Void in
                            
                            // Place details
                            var placeMark: CLPlacemark!
                            placeMark = placemarks?[0]
                            
                            // Address dictionary
                            print(placeMark.addressDictionary as Any)
                            
                                                        // City
                            if let city = placeMark.addressDictionary!["City"] as? NSString {
                                print(city)
                            
                        
                        
                        
                                self.cityLabel.text = city as String
                            }
                        })
                        
                    
                    
                        //self.editCityTextField.placeholder = snap.value as! String
                        
                        
                    }
                    else if snap.key == "rating"{
                        self.starView.rating = Double(snap.value as! Int)
                    }
                    else if snap.key == "totalEarned"{
                        self.earnedAmount.text = ("$\(String(describing:snap.value as! Int))")
                    }
                        
                    else if snap.key == "gradYear"{
                        self.gradYearLabel.text = snap.value as? String
                       // self.editGradYearTextField.placeholder = snap.value as! String
                    }
                        
                    else if snap.key == "experience"{
                        self.expTableData = snap.value as! [String]
                        
                    }
                        
                        
                        
                    else if snap.key == "pic"{
                        if let messageImageUrl = URL(string: snap.value as! String) {
                            
                            if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                                self.profileImageView.image = UIImage(data: imageData as Data)
                                //self.editProfPicImageView.image = UIImage(data: imageData as Data)
                            } }
                        //  loadImageUsingCacheWithUrlString(snap.value as! String)
                    }
                   /* else if snap.key == "bio"{
                        //self.studentBio.text = snap.value as! String
                        //self.editBioTextView.text = snap.value as! String
                    }*/
                }
            }
            self.expTableView.delegate = self
            self.expTableView.dataSource = self
            DispatchQueue.main.async{
                self.expTableView.reloadData()
            }
        })
        } else {
           // availableForWorkLabel.isHidden = true
            //availableSwitch.isHidden = true
            menuButton.isHidden = true
            backButtonForPoster.isHidden = false
            editButton.isHidden = true
            tabBar.isHidden = true
            //self.editProfPicImageView.layer.cornerRadius = 10
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            picker.delegate = self
            profileImageView.clipsToBounds = true
            //editGradYearTextField.delegate = self
            //editMajorTextField.delegate = self
            //editNameTextField.delegate = self
            //editBioTextView.delegate = self
            //editSchoolTextField.delegate = self
            Database.database().reference().child("students").child(self.studentIDFromResponse).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if snap.key == "name"{
                            self.nameLabel.text = snap.value as? String
                            //self.editNameTextField.placeholder = snap.value as! String
                            
                        }
                        else if snap.key == "school"{
                            self.schoolLabel.text = snap.value as? String
                            //self.editSchoolTextField.placeholder = snap.value as! String
                        }
                        else if snap.key == "major"{
                            self.majorLabel.text = snap.value as? String
                            //self.editMajorTextField.placeholder = snap.value as! String
                        }
                        else if snap.key == "jobsCompleted"{
                            for job in snap.value as! [String]{
                                self.jobsFinishedArray.append(job)
                            }
                            self.jobsFinished.text = String(describing:self.jobsFinishedArray.count)
                            
                            
                        }
                        else if snap.key == "location"{
                            var tempDict = snap.value as! [String: Any]
                            self.location = CLLocation(latitude: tempDict["lat"] as! CLLocationDegrees, longitude: tempDict["long"] as! CLLocationDegrees)
                            
                            let geoCoder = CLGeocoder()
                            
                            geoCoder.reverseGeocodeLocation(self.location, completionHandler: { (placemarks, error) -> Void in
                                
                                // Place details
                                var placeMark: CLPlacemark!
                                placeMark = placemarks?[0]
                                
                                // Address dictionary
                                print(placeMark.addressDictionary as Any)
                                
                                // City
                                if let city = placeMark.addressDictionary!["City"] as? NSString {
                                    print(city)
                                
                                
                                
                                
                                self.cityLabel.text = city as String
                                }
                            })
                            //self.editCityTextField.placeholder = snap.value as! String
                            
                            
                        }
                        else if snap.key == "rating"{
                            self.starView.rating = Double(snap.value as! Int)
                        }
                        else if snap.key == "totalEarned"{
                            self.earnedAmount.text = ("$\(String(describing:snap.value as! Int))")
                        }
                            
                        else if snap.key == "gradYear"{
                            self.gradYearLabel.text = snap.value as? String
                           // self.editGradYearTextField.placeholder = snap.value as! String
                        }
                            
                        else if snap.key == "experience"{
                            print("yooo")
                            self.expTableData = snap.value as! [String]
                                                    }
                            
                            
                            
                        else if snap.key == "pic"{
                            if let messageImageUrl = URL(string: snap.value as! String) {
                                
                                if let imageData: NSData = NSData(contentsOf: messageImageUrl) {
                                    self.profileImageView.image = UIImage(data: imageData as Data)
                                    //self.//editProfPicImageView.image = UIImage(data: imageData as Data)
                                } }
                            //  loadImageUsingCacheWithUrlString(snap.value as! String)
                        }
                        /*else if snap.key == "bio"{
                            self.studentBio.text = snap.value as! String
                            //self.editBioTextView.text = snap.value as! String
                        }*/
                    }
                }
                self.expTableView.delegate = self
                self.expTableView.dataSource = self
                DispatchQueue.main.async{
                    self.expTableView.reloadData()
                }
                
            })
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        scrollView.delegate = self

    }
    
   // @IBOutlet weak var editProfPicButton: UIButton!
    
   // @IBOutlet weak var editProfPicImageView: UIImageView!
   /* @IBAction func editProfPicPressed(_ sender: Any) {
        handleSelectProfileImageView()
        
        
    }*/
   // @IBOutlet weak var editNameTextField: UITextField!
   // @IBOutlet weak var editCityTextField: UITextField!
    
   // @IBOutlet weak var editSchoolTextField: UITextField!
   // @IBOutlet weak var editMajorTextField: UITextField!
    
    //@IBOutlet weak var editBioTextView: UITextView!
   // @IBOutlet weak var editExpTableView: UITableView!
    let picker = UIImagePickerController()
    
    //@IBOutlet weak var editGradYearTextField: UITextField!
    @IBAction func editProfilePressed(_ sender: Any) {
       /* if self.editProfView.isHidden == true{
            if self.editCityTextField.placeholder == ""{
                self.editCityTextField.placeholder = "City"
            }
            if self.editSchoolTextField.placeholder == ""{
                self.editSchoolTextField.placeholder = "School"
            }
            if editMajorTextField.placeholder == ""{
                editMajorTextField.placeholder = "Major"
            }
            if editGradYearTextField.placeholder == ""{
                editGradYearTextField.text = "Grad Year"
            }
            if editBioTextView.text == ""{
                editBioTextView.text = "Edit Bio"
            }
            self.editProfView.isHidden = false
        } else {
            editProfView.isHidden = true
        }*/
        
    }
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(expTableData)
        print("expCount: \(expTableData.count)")
        return self.expTableData.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpTableViewCell",
                                                 for: indexPath) as! ExpTableViewCell
        
        cell.expLabel.text = expTableData[indexPath.row]
        print(expTableData)
        //configureTableViewCell(tableView: tableView, cell: cell, indexPath: indexPath)
        // (cell as! DateTableViewCell).cal.delegate = self
        //(cell as! DateTableViewCell).jobsCollect.dataSource = self
        
        return cell
    }
    var sizingCell: ExpTableViewCell?
    func configureTableViewCell(tableView: UITableView, cell: ExpTableViewCell, indexPath: IndexPath){
        cell.expLabel.text = expTableData[indexPath.row]
        
            }

    
   // var job = JobPost()
    @IBAction func backButtonPressed(_ sender: Any) {
        if self.sender == "JobLogSingleJobPoster"{
            performSegue(withIdentifier: "StudentProfileBackToJobLogJob", sender: self)
            
        } else {
            performSegue(withIdentifier: "StudentProfileBackToResponse", sender: self)
            
        }
    }
    
    @IBAction func addExpPressed(_ sender: Any) {
        
        
    }
    
    //removeDelegateFunc
    func performRemoveCell(cell: ExperienceTableViewCell) {
        print("remove: \(cell)")
    }
    
    
    var mToken = String()
    var expTableData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPageData()
        scrollView.bounces = false
        SwiftOverlays.removeAllBlockingOverlays()
        if sender == "student"{
        Messaging.messaging().delegate = self
        self.mToken = Messaging.messaging().fcmToken!
        //appDelegate.deviceToken
        var tokenDict = [String: Any]()
        tokenDict["deviceToken"] = [mToken: true] as [String:Any]?
        Database.database().reference().child("students").child((Auth.auth().currentUser?.uid)!).updateChildValues(tokenDict)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //if textView == editBioTextView{
            
        //}
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       // if textView == editBioTextView{
            
        //}
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func handleSelectProfileImageView() {
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.selectedImage = selectedImageFromPicker!
            //userPic.image = selectedImage
            //userPic.isHidden = true
            //selectProfilePic.setBackgroundImage(selectedImage, for: .normal)
            //self.editProfPicButton.setBackgroundImage(selectedImage, for: .normal)
            print("selectedImage: \(selectedImage)")
            //self.editProfPicImageView.image = selectedImage
            
            //profileImageViewButton.set
            // profileImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)    }
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    @IBOutlet weak var tabBar: UITabBar!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StudentBackToResponse"{
            if let vc = segue.destination as? SpecificResponseViewController{
                vc.job = self.job
                vc.jobArray = self.jobArray
            }
        
        } else if segue.identifier == "StudentProfileBackToJobLogJob"{
            if let vc = segue.destination as? JobLogJobViewController{
                vc.job = self.job
                vc.senderScreen = "student"
            }
            
        } else if segue.identifier == "StudentProfileTabBarToJobHistory"{
            if let vc = segue.destination as? JobHistoryViewController{
                vc.senderScreen = "student"
                print("profile: senderScreen = student")
            }
        }
    }
    public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem){
        if item == tabBar.items?[0]{
            performSegue(withIdentifier: "StudentProfileTabBarToJobHistory", sender: self)
        } else if item == tabBar.items?[1]{
            performSegue(withIdentifier: "StudentProfileTabBarToJobFinder", sender: self)
            
        } else if item == tabBar.items?[2]{
            
            
        } else {
            performSegue(withIdentifier: "StudentProfileTabBarToCalendar", sender: self)
            
        }
    }
    

    


    
    
}
