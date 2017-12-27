//
//  CreatePosterStep2.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 11/2/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import CoreLocation

class CreatePosterStep2: UIViewController, UITextFieldDelegate {
    var crypt = String()
    var locDict = [String:Any]()
    var promoData = [String:Any]()
    var promoSuccess = Bool()
    var promoSenderID = String()
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        if addressTextField.text != "Address" && addressTextField.hasText {
            
            poster.address = addressTextField.text
            //poster.phone = cellTextField.text
            performSegue(withIdentifier: "PosterStep2ToStep3", sender: self)
            
            
            
        } 
        
        performSegue(withIdentifier: "PosterStep2ToStep3", sender: self)
    }
   // @IBOutlet weak var cellTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressTextField.delegate = self
        
        
        
        
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        return false

    }
    
    var place: GMSPlace?
    var profPic = UIImage()
    var poster = JobPoster()
    var promoType = String()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? CreatePosterStep3ViewController{
            
            vc.poster = self.poster
            vc.profPic = self.profPic
            vc.crypt = self.crypt
            vc.locDict = self.locDict
            //vc.sender = "step2"
            vc.promoSenderID = self.promoSenderID
            vc.promoType = self.promoType
            vc.promoData = self.promoData
            vc.promoSuccess = self.promoSuccess
           // vc.promoData = self.promoData
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
}


extension CreatePosterStep2: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        addressTextField.text = place.formattedAddress
        poster.address = place.formattedAddress
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


