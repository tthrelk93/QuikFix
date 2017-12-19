//
//  CreateAccountMainViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/10/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateAccountMainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var accountType = String()

    @IBAction func iAmStudentPressed(_ sender: Any) {
        if userPic.image == nil {
            let alert = UIAlertController(title: "Select profile image", message: "Press the profile icon to select a profile picture.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { action in
                self.handleSelectProfileImageView()
        }))
            self.present(alert, animated: true, completion: nil)
            return

        } else {
            if self.accountType == "student"{
            performSegue(withIdentifier: "CreateStudent", sender: self)
            } else {
                performSegue(withIdentifier: "CreateJobPoster", sender: self)
            }
        }
    }
    @IBOutlet weak var studentPicLabel: UILabel!
    
    @IBOutlet weak var defaultPicImageView: UIImageView!
    @IBOutlet weak var userPic: UIImageView!
    @IBAction func iWantToPostPressed(_ sender: Any) {
         if userPic.image == nil {
            //present alert to pick pic
            let alert = UIAlertController(title: "Select profile image", message: "Press the profile icon to select a profile picture.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { action in
            self.handleSelectProfileImageView()
            }))
            self.present(alert, animated: true, completion: nil)
            return
         } else {
            performSegue(withIdentifier: "CreateJobPoster", sender: self)
        }
    }
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var promoSuccessLabel: UILabel!
    @IBAction func selectProfilePicPressed(_ sender: Any) {
        handleSelectProfileImageView()
        
    }
    @IBOutlet weak var selectProfilePic: UIButton!
    
    @IBOutlet weak var promoView: UIView!
    
    @IBOutlet weak var promoCodeTF: UITextField!
    
    @IBOutlet weak var redeemButton: UIButton!
    var existingPromoCodes = [String]()
    var promoSender = [String: String]()
    var promoSuccess = false
    @IBAction func redeemPressed(_ sender: Any) {
        if promoCodeTF.hasText == false{
            let alert = UIAlertController(title: "Invalid Code Error", message: "It appears that the promo code you are entering does not exist.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            Database.database().reference().child("jobPosters").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                    for snap in snapshots{
                        if let tempDict = snap.value as? [String:Any]{
                            var promo = (tempDict["promoCode"] as! [String:Any])
                            print("promo: \(promo)")
                            for (key, val) in promo{
                                if key == self.promoCodeTF.text{
                                    let tempArray = val as! [String]
                                    if tempArray.contains(Auth.auth().currentUser!.uid){
                                        let alert = UIAlertController(title: "Promo Code Reuse Error", message: "It appears that you have already used this promo code.", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        return
                                        
                                    }
                                    self.promoSender[snap.key] = key
                                    self.promoSuccess = true
                                    //self.promoCredit = tempDict["availableCredits"] as! Int
                                    
                                    self.promoCredit = 10
                                    
                                    break
                                }
                                
                            }
                            var uploadDict = [String:Any]()
                            uploadDict["availableCredits"] =
                                self.promoCredit
                            var tempArray = promo[(self.promoSender.first?.value)!] as! [String]
                            tempArray.append((self.promoSender.first?.key)!)
                            promo[(self.promoSender.first?.value)!] = tempArray
                            uploadDict["promoCode"] = promo
                            Database.database().reference().child("jobPosters").child((self.promoSender.first?.key)!).updateChildValues(uploadDict)
                            //Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(["promoCredit": 5] as [String:Any])
                            self.topLabel.text = "Success!"
                            self.promoSuccessLabel.isHidden = false
                            self.promoCodeTF.isHidden = true
                            self.redeemButton.isHidden = true
                            self.skipButton.isHidden = true
                            sleep(3)
                            self.self.promoView.isHidden = true
                            
                        }
                    }
                }
                    
            })
            
            
        }
        
    }
        
    var promoCredit = Int()
        
    @IBAction func skipPressed(_ sender: Any) {
        if self.sender == "step2"{
            performSegue(withIdentifier: "PromoToStep4", sender: self)
        } else {
        promoView.isHidden = true
        promoCredit = 5
        }
    }
    @IBOutlet weak var skipButton: UIButton!
    
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.sender == "step2"{
            promoView.isHidden = false
        } else {
            promoView.isHidden = true
    
        if accountType == "student"{
            self.studentPicLabel.text = "*Select a professional looking picture. Any inappropriate content will result in a ban."
            self.promoView.isHidden = true
        } else {
            promoCodeTF.delegate = self
            self.promoView.isHidden = true
            self.studentPicLabel.text = "*Tap the circular profile button above to select a profile picture from your photos"
        }
        
        picker.delegate = self
        //picker.delegate = self
        userPic.layer.cornerRadius = userPic.frame.width/2
        defaultPicImageView.layer.cornerRadius = defaultPicImageView.frame.width/2
        selectProfilePic.layer.cornerRadius = selectProfilePic.frame.width/2
       selectProfilePic.clipsToBounds = true
        }
        //userPic.layer.cornerRadius = userPic.frame.width/2

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleSelectProfileImageView() {
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            userPic.image = selectedImage
            userPic.isHidden = true
            selectProfilePic.setBackgroundImage(selectedImage, for: .normal)
            
            //profileImageViewButton.set
            // profileImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: { (error) in
            
            if self.accountType == "student"{
                self.performSegue(withIdentifier: "CreateStudent", sender: self)
            } else {
                self.performSegue(withIdentifier: "CreateJobPoster", sender: self)
            }

            
        })
        
    }
    
    
    
       
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }


    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    var poster = JobPoster()
    var profPic = UIImage()
    var crypt = String()
    var locDict = [String:Any]()
    var sender = String()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PromoToStep4"{
            if let vc = segue.destination as? CreatePosterStep3ViewController{
                vc.poster = self.poster
                vc.profPic = self.profPic
                vc.crypt = self.crypt
                vc.locDict = self.locDict
            }
        }
        if segue.identifier == "CreateStudent"{
            if let vc = segue.destination as? CreateAccountStudentViewController{
                vc.profPic = self.userPic.image!
            }
            
        } else {
            if let vc = segue.destination as? CreateAccountJobPosterViewController{
                vc.profPic = self.userPic.image!
                vc.promoBool = self.promoSuccess
                
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

}
