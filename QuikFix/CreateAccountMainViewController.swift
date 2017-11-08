//
//  CreateAccountMainViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/10/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

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
    @IBAction func selectProfilePicPressed(_ sender: Any) {
        handleSelectProfileImageView()
        
    }
    @IBOutlet weak var selectProfilePic: UIButton!
    
    let picker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        if accountType == "student"{
            self.studentPicLabel.isHidden = false
        } else {
            self.studentPicLabel.isHidden = true
        }
        
        picker.delegate = self
        //picker.delegate = self
        userPic.layer.cornerRadius = userPic.frame.width/2
        defaultPicImageView.layer.cornerRadius = defaultPicImageView.frame.width/2
        selectProfilePic.layer.cornerRadius = selectProfilePic.frame.width/2
       selectProfilePic.clipsToBounds = true
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateStudent"{
            if let vc = segue.destination as? CreateAccountStudentViewController{
                vc.profPic = self.userPic.image!
            }
            
        } else {
            if let vc = segue.destination as? CreateAccountJobPosterViewController{
                vc.profPic = self.userPic.image!
                
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
