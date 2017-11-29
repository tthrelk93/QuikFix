//
//  ForgotPasswordViewController1.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/18/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController1: UIViewController {

    @IBAction func recoverButtonPressed(_ sender: Any) {
        if emailTextField.text?.contains("@") == false{
            let alert = UIAlertController(title: "Missing Field.", message: "Please fill in the recovery email field.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: {error in
                let alert = UIAlertController(title: "Recovery email sent.", message: "Check your email to reset your password.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                //self.emailTextField.text = ""
                //self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter recovery email")
                //self.emailTextField.placeholderText = "Enter Recovery Email"
                self.emailTextField.isHidden = true
                
                
            })
            performSegue(withIdentifier: "RecoverToEnterDigits", sender: self)
        }

        
    }
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
