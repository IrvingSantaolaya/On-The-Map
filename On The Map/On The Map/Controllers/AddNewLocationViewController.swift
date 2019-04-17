//
//  AddNewLocationViewController.swift
//  On The Map
//
//  Created by Irving Martinez on 4/12/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit
import MapKit

class AddNewLocationViewController: UIViewController {

    // Properties
    @IBOutlet weak var locationTextfield: UITextField!
    @IBOutlet weak var urlTextfield: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupUI()
    }

    // MARK: - IBActions
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        // Change UI to loading
        findingLocation(true)
        
        // Grab string in textfield and convert to location
        getCoordinate(addressString: locationTextfield.text!) { (coordinate, error) in
            
            // If there is no error
            if error == nil {
                
                // Grab coordinate and share with sharedStudentInfo
                SharedStudentInfo.coordinate = coordinate
                SharedStudentInfo.mapString = self.locationTextfield.text!
                SharedStudentInfo.mediaURL = self.urlTextfield.text ?? ""
                self.urlTextfield.endEditing(true)
                self.locationTextfield.endEditing(true)
                
                // Move to next VC to confirm before posting
                self.performSegue(withIdentifier: "toConfirmVC", sender: nil)
                self.locationTextfield.text = ""
                self.findingLocation(false)
            }
            // There was an error
            else {
                print(error)
                self.findingLocation(false)
                self.locationTextfield.text = ""
                self.showAlert()
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    

    // MARK: - Helper functions
    
    func setupUI() {
        findLocationButton.layer.cornerRadius = 5
        activityIndicator.isHidden = true
    }
    
    // Convert string to location
    func getCoordinate(addressString: String, completion: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        
        // Create geocoder
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            
            // Check for error
            if error == nil {
                
                // Grab first location from array
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completion(location.coordinate, nil)
                }
            }
            else {
                completion(kCLLocationCoordinate2DInvalid, error as NSError?)
            }
            
        }
    }
    
    // Show alert with failure message
    func showAlert() {
        let alert = UIAlertController(title: "Invalid Location", message: Errors.ErrorMessage.tryAgain.string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // Update UI while finding location or not
    func findingLocation(_ finding: Bool) {
        
        if finding {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
        
        locationTextfield.isEnabled = !finding
        urlTextfield.isEnabled = !finding
        findLocationButton.isEnabled = !finding
        activityIndicator.isHidden = !finding
    }
    
}
