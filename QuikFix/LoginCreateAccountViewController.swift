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
import SwiftOverlays
import UserNotifications
import FirebaseMessaging

class LoginCreateAccountViewController: UIViewController, UITextFieldDelegate, MessagingDelegate {
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
                                studentBool = true
                                self.performSegue(withIdentifier: "LoginSegue", sender: self)
                                //SwiftOverlays.showBlockingWaitOverlayWithText("Loading Profile")
                                
                            }
                        }
                        if studentBool == false{
                            //SwiftOverlays.showBlockingWaitOverlayWithText("Loading Profile")
                            self.performSegue(withIdentifier: "LoginSeguePoster", sender: self)
                        }
                    }
                })

                
                
            }
            
        })
        
    

    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
    }

    @IBOutlet weak var keepMeLoggedIn: UISwitch!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var notSignedUpLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        
    }
    var handle: AuthStateDidChangeListenerHandle?
    
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
     var isListening = false
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        var studentBool = false
        var posterBool = false
        
        
        
        var isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
        if(isRegisteredForRemoteNotifications == false){
            print("registeredForRemote = false")
            if #available(iOS 10, *) {
                UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
                UIApplication.shared.registerForRemoteNotifications()
            }
                // iOS 9 support
            else if #available(iOS 9, *) {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
                // iOS 8 support
            else if #available(iOS 8, *) {
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
                // iOS 7 support
            else {
               print("registeringForRemote")
                UIApplication.shared.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
            }
            
           
        
        } else {
            isListening = true
            print("in some else")
            handle = Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    self.authUser = user.uid
                    Messaging.messaging().delegate = self
                    Database.database().reference().child("students").observeSingleEvent(of: .value, with: { (snapshot) in
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                            for snap in snapshots{
                                if snap.key == Auth.auth().currentUser?.uid{
                                    studentBool = true
                                    posterBool = false
                                }
                            }
                        }
                        Database.database().reference().child("jobPosters").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                                for snap in snapshots{
                                    if snap.key == Auth.auth().currentUser?.uid{
                                        studentBool = false
                                        posterBool = true
                                      
                                    }
                                }
                                if posterBool == false && studentBool == false{
                                    Auth.auth().currentUser?.delete(completion: { (error) in
                                        if error != nil {
                                            print("Error unable to delete user")
                                            
                                        }
                                    })
                                    
                                } else if posterBool == false {
                                    self.performSegue(withIdentifier: "LoginSegue", sender: self)
                                } else if studentBool == false{
                                    SwiftOverlays.showBlockingWaitOverlayWithText("Loading Profile")
                                    self.performSegue(withIdentifier: "LoginSeguePoster", sender: self)
                                }
                            }
                        })
                    })
                    
                } else {
                    // No user is signed in.
                    //Auth.auth().removeStateDidChangeListener(<#T##listenerHandle: AuthStateDidChangeListenerHandle##AuthStateDidChangeListenerHandle#>)
                }
            }
        }
        
        
        //userNameTextField.color

        // Do any additional setup after loading the view.
    }
    var authUser = String()
    override func viewWillDisappear(_ animated: Bool) {
        if isListening == true{
        Auth.auth().removeStateDidChangeListener(handle!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        var tokenDict = [String: Any]()
        
        
        tokenDict["deviceToken"] = [fcmToken: true] as [String: Any]?
        Database.database().reference().child("students").child(self.authUser).updateChildValues(tokenDict)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginSegue"{
            if let vc = segue.destination as? studentProfile{
                vc.sender = "student"
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
            }
    

}
