//
//  LoginCreateAccountViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/10/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginCreateAccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var createAccountView: UIView!
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        guard let email = userNameTextField.text, let password = passwordTextField.text
            else{
               // SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        
        
        Auth.auth().signIn(withEmail: email, password: password, completion: {
            (user: User?, error) in
            
            if error != nil{
               // SwiftOverlays.removeAllBlockingOverlays()
                let alert = UIAlertController(title: "Login/Register Failed", message: "Check that you entered the correct information.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            else{
               // self.user = (user?.uid)!
                print("Successful Login")
                var studentBool = false
                Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                        for snap in snapshots{
                            if snap.key == Auth.auth().currentUser?.uid{
                                self.performSegue(withIdentifier: "LoginSegue", sender: self)
                                studentBool = true
                            }
                        }
                        if studentBool == false{
                            self.performSegue(withIdentifier: "LoginSeguePoster", sender: self)
                        }
                    }
                })

                
                
            }
            
        })
        
    

    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
    }

    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var notSignedUpLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
    }
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        //userNameTextField.color

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            }
    

}
