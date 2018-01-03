//
//  MenuViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/14/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import GuillotineMenu
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import GooglePlaces
import GoogleMaps
import GooglePlacePicker

class MenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var editView: UIView!
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        editView.isHidden = true
    }
    
    @IBAction func editDefaultAddressPressed(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    @IBOutlet weak var editDefaultAddress: UIButton!
    @IBAction func editNamePressed(_ sender: Any) {
        
        if editPicButton.isHidden == false{
        editPicButton.isHidden = true
            editDefaultAddress.isHidden = true
            editNameTextField.isHidden = false
        editNameButton.setTitle("Save Changes", for: .normal)
        } else {
            editPicButton.isHidden = false
            editDefaultAddress.isHidden = false
            editNameTextField.isHidden = true
            editNameButton.setTitle("Edit Name", for: .normal)
            if editNameTextField.text == ""{
                print("no empty vals")
            }
            else {
                Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(["name": editNameTextField.text!])
            }
        }
    }
    @IBOutlet weak var editNameButton: UIButton!
    @IBOutlet weak var editNameTextField: UITextField!
    
    @IBOutlet weak var editPicButton: UIButton!
    
    @IBAction func editPicPressed(_ sender: Any) {
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    

  
    @IBOutlet weak var menuButtonPressed: UIButton!
    var promo = String()
    @IBAction func logoutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        performSegue(withIdentifier: "LogoutSegue2", sender: self)

    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var menuframe: UIButton!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    var name = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
       editNameTextField.text = name

       /* dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menuRotated"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
            return button
        }()*/
        
       // dismissButton?.frame = menuframe.bounds
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.text = "Profile"
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
        // Do any additional setup after loading the view.
    }
    
    func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }

    @IBAction func jobLogPressed(_ sender: Any) {
        performSegue(withIdentifier: "PosterToJobHistory", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func editProfile(_ sender: Any) {
        editView.isHidden = false
    }
    
    @IBAction func dealsPressed(_ sender: Any) {
    }
    var place: GMSPlace?
    @IBAction func calendarPressed(_ sender: Any) {
        performSegue(withIdentifier: "PosterMenuToCalendar", sender: self)
            }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PosterToJobHistory"{
            if let vc = segue.destination as? JobHistoryViewController{
                vc.senderScreen = "poster"
            }
        }
        if segue.identifier == "PosterMenuToCalendar"{
            print("sup")
            if let vc = segue.destination as? CalendarViewController{
                vc.senderScreen = "poster"
                
            }
        }
    }
    let picker = UIImagePickerController()
    var newImage = UIImage()
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImageFromPicker: UIImage?
        //print("top of image Picker: \(self.accountType)")
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            self.newImage = selectedImage
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child(Auth.auth().currentUser!.uid).child("\(imageName).jpg")
            
            let profileImage = selectedImage
            let uploadData = UIImageJPEGRepresentation(profileImage, 0.1)
            storageRef.putData(uploadData!, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    var values = Dictionary<String, Any>()
                    
                    values["pic"] = profileImageUrl
                    
                    Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(values)
                }
            })
        
            
            
        }
        
        dismiss(animated: true, completion: { (error) in
            
        })
        
    }
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

    

}
extension MenuViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        let newPlace = place.formattedAddress
        Database.database().reference().child("jobPosters").child(Auth.auth().currentUser!.uid).updateChildValues(["address": [newPlace]])
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
