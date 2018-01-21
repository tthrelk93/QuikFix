//
//  JobPostLocationPickerViewController.swift
//  QuikFix
//
//  Created by Thomas Threlkeld on 10/12/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import FirebaseDatabase
import FirebaseAuth

class JobPostLocationPickerViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var jobPost = JobPost()
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func continuePressed(_ sender: Any) {
        
        //jobPost.location = self.place?.formattedAddress
        if locationLabel.text == nil || locationLabel.text == ""{
            
        } else {
        if edit == true{
            performSegue(withIdentifier: "EditLocToPostJob", sender: self)
        } else {
            performSegue(withIdentifier: "Step5ToFinalize", sender: self)
        }
        }
        
        
        
    }
   
    
    @IBAction func defaultAddressButtonPressed(_ sender: Any) {
        
        Database.database().reference().child("jobPosters").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    if snap.key == "address"{
                        //print("snapVal:\((snap.value as! [String]).first)")
                        if (snap.value as! [String]).first == "n/a"{
                            let alert = UIAlertController(title: "No Default Address", message: "You must finish creating your account to store a default address.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        self.locationLabel.text = (snap.value as! [String]).first!
                        if self.edit == true{
                            self.jobPostEdit.location = (snap.value as! [String]).first!
                            
                        }
                        self.jobPost.location = (snap.value as! [String]).first!
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(self.jobPost.location!) { (placemarks, error) in
                            guard
                                let placemarks = placemarks,
                                let location = placemarks.first?.location?.coordinate
                                else {
                                    // handle no location found
                                    print("locError")
                                    return
                            }
                           
                            self.placeCoord = CLLocation(latitude: location.latitude, longitude: location.longitude)
                             print("jobCoordCreatedDefault: \(self.placeCoord)")
                            if self.edit == true{
                                self.performSegue(withIdentifier: "EditLocToPostJob", sender: self)
                            } else {
                             self.performSegue(withIdentifier: "Step5ToFinalize", sender: self)
                            }
                            // Use your location
                        }
                       
                       // print("loc: \(self.jobPost.location)")
                    }
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        //searchController?.searchBar = searchBar
        searchBar = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false*/
    }
    var edit = Bool()
    var jobPostEdit = JobPost()
    var toolCount = Int()
    
    var placeAddress = String()
    var place: GMSPlace?
    var placeCoord = CLLocation()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Step5ToFinalize"{
            if let vc = segue.destination as? Finalize{
                vc.jobPost = self.jobPost
                vc.placeCoord = self.placeCoord
            }
        }
        if segue.identifier == "EditLocToPostJob"{
            if let vc = segue.destination as? ActualFinalizeViewController{
                vc.jobCoord = self.placeCoord
                vc.jobPost = self.jobPostEdit
                vc.timeDifference = Int(jobPostEdit.jobDuration!)!
                vc.toolCount = self.toolCount
                
            }
        }
    }

}

// Handle the user's selection.
extension JobPostLocationPickerViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        self.placeCoord = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        print("placeCoord: \(self.placeCoord)")
        locationLabel.text = place.formattedAddress
        jobPost.location = place.formattedAddress
        if edit == true{
            jobPostEdit.location = place.formattedAddress
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
