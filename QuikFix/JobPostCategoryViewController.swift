//
//  JobPostCategoryViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/9/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit

class JobPostCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var jobPost = JobPost()

    @IBAction func continuePressed(_ sender: Any) {
        if categoryList1[categoryPicker.selectedRow(inComponent: 0)] != "Select a Category" && categoryLists[categoryPicker.selectedRow(inComponent: 0)][category2Picker.selectedRow(inComponent: 0)] != ""{
            
            jobPost.category1 = categoryList1[categoryPicker.selectedRow(inComponent: 0)]
                
                
            jobPost.category2 = categoryLists[categoryPicker.selectedRow(inComponent: 0)][category2Picker.selectedRow(inComponent: 0)]
                
            performSegue(withIdentifier: "JPStepOneToStepTwo", sender: self)
            
        } else {
            //present alert
        }
    }
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var category2Picker: UIPickerView!
    var categoryList1 = ["Select a Category","Lawn Care", "Installations", "Assembly","Moving", "Other"]
    var LawnCareCategoryList = ["Mow", "Gardening", "Outdoor Maintenance(gutters)"]
    var installationsCategoryList = ["Electronics", "Decorations"]
    var assemblyCategoryList = ["Furniture"]
    var movingCategoryList = ["In-Home","Hauling Away"]
    
    var categoryLists = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        category2Picker.delegate = self
        categoryPicker.dataSource = self
        category2Picker.dataSource = self
        categoryLists = [[""], LawnCareCategoryList, installationsCategoryList, assemblyCategoryList, movingCategoryList, [""]]

        // Do any additional setup after loading the view.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoryPicker{
        return categoryList1.count
        } else {
            return categoryLists[categoryPicker.selectedRow(inComponent: 0)].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPicker{
            return categoryList1[row]
        } else {
            return categoryLists[categoryPicker.selectedRow(inComponent: 0)][row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPicker{
            category2Picker.reloadAllComponents()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JPStepOneToStepTwo"{
            if let vc = segue.destination as? SelectWorkerNumberViewController{
                vc.jobPost = self.jobPost
            }
            
        }
        
    }
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
