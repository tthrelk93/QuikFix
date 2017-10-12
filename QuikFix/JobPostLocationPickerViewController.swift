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
        
        jobPost.location = self.place?.formattedAddress
        
        performSegue(withIdentifier: "Step5ToFinalize", sender: self)
        
        
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
    var placeAddress = String()
    var place: GMSPlace?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Step5ToFinalize"{
            if let vc = segue.destination as? Finalize{
                vc.jobPost = self.jobPost
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
        locationLabel.text = place.formattedAddress
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
