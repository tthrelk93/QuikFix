//
//  JobTypePickerViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/25/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class JobTypePickerViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    var jobTypes = ["All","Full Lawn Package", "Mow", "Leaf Blowing", "Gardening", "Gutter Cleaning", "Weed-Wacking", "Hedge Clipping", "Installations(Electronics)", "Installations(Decorations)", "Furniture Assembly","Moving(In-Home)", "Moving(Home-To-Home)", "Hauling Away"]

    @IBAction func searchButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "SelectJobTypeToJobFinder", sender: self)
        
       // performSegue(withIdentifier: "SelectJobTypeToJobFinder", sender: self)
    }
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var jobTypePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        jobTypePicker.delegate = self
        jobTypePicker.dataSource = self
        searchButton.setTitle(jobTypes[jobTypePicker.selectedRow(inComponent: 0)], for: .normal)
        
        

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
        return jobTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return jobTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchButton.setTitle("Search \(jobTypes[row])", for: .normal)
        //self.searchButton.setTitle
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SelectJobTypeToJobFinder" {
            if let vc = segue.destination as? JobPostViewController{
                vc.categoryType = self.jobTypes[jobTypePicker.selectedRow(inComponent: 0)]
            }
        }
    }
    

}
