//
//  JobPostCategoryViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 9/9/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class JobPostCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var jobPost = JobPost()
    var toolsArray = [String]()
    
    @IBOutlet weak var hedgeClippers: UIButton!
    @IBOutlet weak var leafBlower: UIButton!
    @IBOutlet weak var weedWacker: UIButton!
    
    @IBAction func wackerPressed(_ sender: Any) {
        var button = (sender as! UIButton)
        
        
        
        if button.isSelected == true{
            button.isSelected = false
            toolsArray.remove(at: toolsArray.index(of: (button.titleLabel?.text)!)!)
        } else {
            button.isSelected = true
            toolsArray.append((button.titleLabel?.text)!)
        }

    }
    
    @IBAction func leafBlowerPressed(_ sender: Any) {
        var button = (sender as! UIButton)
        
        
        
        if button.isSelected == true{
            button.isSelected = false
            toolsArray.remove(at: toolsArray.index(of: (button.titleLabel?.text)!)!)
        } else {
            button.isSelected = true
            toolsArray.append((button.titleLabel?.text)!)
        }

    }
    
    @IBAction func hedgeClippersPressed(_ sender: Any) {
        var button = (sender as! UIButton)
        
        
        
        if button.isSelected == true{
            button.isSelected = false
            toolsArray.remove(at: toolsArray.index(of: (button.titleLabel?.text)!)!)
        } else {
            button.isSelected = true
            toolsArray.append((button.titleLabel?.text)!)
        }

    }
    
    @IBAction func toolPressed(_ sender: Any) {
        var button = (sender as! UIButton)
        
        
        
        if button.isSelected == true{
            button.isSelected = false
            toolsArray.remove(at: toolsArray.index(of: (button.titleLabel?.text)!)!)
        } else {
            button.isSelected = true
            toolsArray.append((button.titleLabel?.text)!)
        }
    }
    

    @IBAction func continuePressed(_ sender: Any) {
        
        if categoryList1[categoryPicker.selectedRow(inComponent: 0)] != "Select a Category" {
            
            if categoryList1[categoryPicker.selectedRow(inComponent: 0)] == "Moving(Home-To-Home)"{
                if !pickupLocationTF.hasText || !dropoffLocationTF.hasText{
                    let alert = UIAlertController(title: "Missing Field", message: "You must designate pickup and dropoff locations when creating a moving(Home-ToHome) job.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    jobPost.pickupLocation = self.pickupLocationTF.text
                    jobPost.dropOffLocation = self.dropoffLocationTF.text
                }
                
                
                
            } else if categoryList1[categoryPicker.selectedRow(inComponent: 0)] == "Full Lawn Package"{
                weedWacker.isHidden = false
                leafBlower.isHidden = false
                hedgeClippers.isHidden = false
                
                if toolSelectView.isHidden == true{
                    toolSelectView.isHidden = false
                    return
                } else {
                    jobPost.tools = self.toolsArray
                }

            
            }
            else if categoryList1[categoryPicker.selectedRow(inComponent: 0)] == "Mow" {
                weedWacker.isHidden = true
                leafBlower.isHidden = true
                hedgeClippers.isHidden = true
                
                
                
                
                if toolSelectView.isHidden == true{
                    toolSelectView.isHidden = false
                    return
                } else {
                    jobPost.tools = self.toolsArray
                }

            
            }
            else if categoryList1[categoryPicker.selectedRow(inComponent: 0)] == "Weed-Wacking" {
                weedWacker.isHidden = true
                leafBlower.isHidden = true
                hedgeClippers.isHidden = true
                toolButton.setTitle("Weed Wacker", for: .normal)
                toolButton.setTitle("Weed Wacker", for: .selected)
                if toolSelectView.isHidden == true{
                    toolSelectView.isHidden = false
                    return
                } else {
                    jobPost.tools = self.toolsArray
                }

            
            }
            else if categoryList1[categoryPicker.selectedRow(inComponent: 0)] == "Leaf Blowing" {
                toolButton.setTitle("Leaf Blower", for: .normal)
                toolButton.setTitle("Leaf Blower", for: .selected)
                weedWacker.isHidden = true
                leafBlower.isHidden = true
                hedgeClippers.isHidden = true
                if toolSelectView.isHidden == true{
                    toolSelectView.isHidden = false
                    return
                } else {
                    jobPost.tools = self.toolsArray
                }

            
            }
            else if categoryList1[categoryPicker.selectedRow(inComponent: 0)] == "Hedge Clipping"{
                toolButton.setTitle("Hedge Clippers", for: .normal)
                toolButton.setTitle("Hedge Clippers", for: .selected)
                weedWacker.isHidden = true
                leafBlower.isHidden = true
                hedgeClippers.isHidden = true
                
                if toolSelectView.isHidden == true{
                    toolSelectView.isHidden = false
                    return
                } else {
                    jobPost.tools = self.toolsArray
                }

                
            } else {
                weedWacker.isHidden = true
                leafBlower.isHidden = true
                hedgeClippers.isHidden = true
                toolButton.titleLabel?.text = "Drill"
                toolButton.setTitle("Drill", for: .normal)
                toolButton.setTitle("Drill", for: .selected)
                if toolSelectView.isHidden == true{
                    toolSelectView.isHidden = false
                    return
                } else {
                    jobPost.tools = self.toolsArray
                }
                
            }
            
            

            
            
            
            jobPost.category1 = categoryList1[categoryPicker.selectedRow(inComponent: 0)]
                
                
            //jobPost.category2 = categoryLists[categoryPicker.selectedRow(inComponent: 0)][category2Picker.selectedRow(inComponent: 0)]
                
            performSegue(withIdentifier: "JPStepOneToStepTwo", sender: self)
            
        } else {
            //present alert
            let alert = UIAlertController(title: "Missing Field", message: "You must select a category from the picker to continue.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var toolSelectView: UIView!
    @IBOutlet weak var category2Picker: UIPickerView!
    var categoryList1 = ["Select a Category", "Full Lawn Package", "Mow", "Leaf Blowing", "Gardening", "Gutter Cleaning", "Weed-Wacking", "Hedge Clipping", "Installations(Electronics)", "Installations(Decorations)", "Furniture Assembly","Moving(In-Home)", "Moving(Home-To-Home)", "Hauling Away"]
   
    
    
    var categoryLists = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
       // category2Picker.delegate = self
        categoryPicker.dataSource = self
       // category2Picker.dataSource = self
        pickupLocationTF.delegate = self
        dropoffLocationTF.delegate = self
        //categoryLists = [[""], LawnCareCategoryList, installationsCategoryList, assemblyCategoryList, movingCategoryList, [""]]

        // Do any additional setup after loading the view.
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return categoryList1.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return categoryList1[row]
        
    }
    
    @IBOutlet weak var pickupLocationTF: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var toolButton: UIButton!
    @IBOutlet weak var dropoffLocationTF: UITextField!
    //reload somewhere else b/c crashing when speed pick   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
       if categoryList1[row] == "Moving(Home-To-Home)"{
        pickupLocationTF.isHidden = false
        dropoffLocationTF.isHidden = false
        locationLabel.isHidden = false
        
        
       } else {
        pickupLocationTF.isHidden = true
        dropoffLocationTF.isHidden = true
        locationLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JPStepOneToStepTwo"{
            if let vc = segue.destination as? SelectWorkerNumberViewController{
                vc.jobPost = self.jobPost
            }
            
        }
        
    }
    
    /*public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        
        return false
    }*/
    var tfSelected = String()
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == pickupLocationTF{
            self.tfSelected = "pickup"
        } else {
            self.tfSelected = "dropoff"
        }
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        return false
        
    }
    
    var place: GMSPlace?

   


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

extension JobPostCategoryViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        if self.tfSelected == "pickup"{
            self.pickupLocationTF.text = place.formattedAddress
            self.jobPost.pickupLocation = place.formattedAddress
        } else {
            self.dropoffLocationTF.text = place.formattedAddress
            self.jobPost.dropOffLocation = place.formattedAddress
        }
        self.place = place
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

