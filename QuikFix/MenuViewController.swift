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

class MenuViewController: UIViewController, GuillotineMenu {
    
    @IBOutlet weak var editView: UIView!
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        editView.isHidden = true
    }
    
    @IBAction func editDefaultAddressPressed(_ sender: Any) {
    }
    @IBOutlet weak var editDefaultAddress: UIButton!
    @IBAction func editNamePressed(_ sender: Any) {
        
        if editPicButton.isHidden == false{
        editPicButton.isHidden = true
            editDefaultAddress.isHidden = true
            editNameTextField.isHidden = false
        editNameButton.setTitle("Save Changes", for: .normal)
        } else {
            editPicButton.isHidden = true
            editDefaultAddress.isHidden = true
            editNameTextField.isHidden = false
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
    

}
extension MenuViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
    }
}
