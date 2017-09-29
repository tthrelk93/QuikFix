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

class MenuViewController: UIViewController, GuillotineMenu {

    
    @IBAction func logoutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        performSegue(withIdentifier: "LogoutSegue2", sender: self)

    }
    
    
    @IBOutlet weak var menuframe: UIButton!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menuRotated"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var calendarView: UIView!
    @IBAction func calendarPressed(_ sender: Any) {
        if calendarView.isHidden == true{
            calendarView.isHidden = false
        } else {
            calendarView.isHidden = true
        }
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
