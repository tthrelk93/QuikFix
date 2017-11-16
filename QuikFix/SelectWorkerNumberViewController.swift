//
//  SelectWorkerNumberViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/4/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class SelectWorkerNumberViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var numbers = ["1","2","3","4","5","6","7","8","9", "10","11","12","13","14","15"]
    
    

    @IBOutlet weak var numberPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if jobPost.category1 == "Moving(Home-To-Home)"{
            self.numbers = ["2","3","4","5","6","7","8","9", "10","11","12","13","14","15"]
        }
        numberPicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return numbers.count
    }
    var jobPost = JobPost()
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numbers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*if pickerView == categoryPicker{
            category2Picker.reloadAllComponents()
        }*/
    }

    @IBAction func continuePressed(_ sender: Any) {
        self.jobPost.workerCount = Int(numbers[numberPicker.selectedRow(inComponent: 0)])
         performSegue(withIdentifier: "SelectWorkerCountToDate", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "SelectWorkerCountToDate"{
        if let vc = segue.destination as? JobPostDateAndTimeViewController{
            vc.jobPost = self.jobPost
            
        }
 
    }
 
 }

}
