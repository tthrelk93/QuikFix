//
//  CreateAccountStudent2ViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/31/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseDatabase
import DropDown


class CreateAccountStudent2ViewController: UIViewController, UITextFieldDelegate {

    
    var profPic = UIImage()
    @IBAction func continuePressed(_ sender: Any) {
        if schoolDropDownTF.hasText && majorDropDownTF.hasText && cellPhoneNumberTF.hasText{
            if cellPhoneNumberTF.text?.characters.count != 10{
                let alert = UIAlertController(title: "Phone Number Error", message: "Please enter your valid 10 digit phone number.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler:nil))
                self.present(alert, animated: true, completion: nil)
                return

                
            } else {
            student.phone = cellPhoneNumberTF.text
                student.major = majorDropDownTF.text
                student.school = schoolDropDownTF.text
                performSegue(withIdentifier: "CreateStudentStep2ToStep3", sender: self)
            }
        }
        
    }
    
    @IBOutlet weak var cellPhoneNumberTF: UITextField!
    @IBOutlet weak var majorDropDownTF: UITextField!
    @IBOutlet weak var schoolDropDownTF: UITextField!
    var student = Student()
    let dropDown = DropDown()
    let dropDown2 = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // The view to which the drop down will appear on
        dropDown.anchorView = view // UIView or UIBarButtonItem
        
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Computer Science", "Communications", "Government/Political Science", "Business", "Economics", "English", "Psychology", "Nursing","Chemistry","Biology","Physics","Art","Engineering"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.student.major = item
            self.majorDropDownTF.text = item
            self.dropDown.hide()
        }
        
        // Will set a custom width instead of the anchor view width
        //DropDownCell.width = 200
        
       
        
        // The view to which the drop down will appear on
        dropDown2.anchorView = view // UIView or UIBarButtonItem
        dropDown2.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        // The list of items to display. Can be changed dynamically
        dropDown2.dataSource = ["Rhodes College", "Hendrix", "Sewanee", "CBU", "University of Memphis", "Southwest Community College"]
        
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
            self.student.school = item
            self.schoolDropDownTF.text = item
            self.dropDown2.hide()
        }
        schoolDropDownTF.delegate = self
        majorDropDownTF.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
   
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) {
        if textField == schoolDropDownTF{
            dropDown2.show()
        } else {
            dropDown.show()
        }
        //return false
        
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
        if let vc = segue.destination as? CreateStudentAccountFinalViewController{
            vc.student = self.student
            vc.profPic = self.profPic
        }
    }
    

}
