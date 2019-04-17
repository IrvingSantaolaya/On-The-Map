//
//  MapViewController.swift
//  On The Map
//
//  Created by Irving Martinez on 4/7/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    //  Grab instance of student info
    var allStudentInfo = SharedStudentInfo.allInfo
    
    // Create annotations
    var annotations = [MKPointAnnotation]()
    
    
    // MARK: - Inits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAnnotations()
        loadUserInfo()
    }
    
    // MARK: - Functions
    
    func configureAnnotations() {
        
        // Iterate through all of the info that was retrieved
        for info in allStudentInfo {
            
            // Grab the latitude and longitude of each student object
            let lat = CLLocationDegrees(info.latitude ?? 0)
            let long = CLLocationDegrees(info.longitude ?? 0)
            
            // Create coordinate object from lat and long
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Set student info and assign default values in case of nil
            let first = info.firstName ?? ""
            let last = info.lastName ?? ""
            let mediaURL = info.mediaURL ?? ""
            
            // Create annotation with all of the grabbed info
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    // Get user info
    func loadUserInfo(){
        
        // Call Udacityclient and parse response
        UdacityClient.getCurrentUser(key: SharedStudentInfo.uniqueKey) { (success, error) in
            // Got the current user info
            if success {
                print("\(SharedStudentInfo.studentFirstName) \(SharedStudentInfo.studentLastName)")
            }
            // Did not get user info
            else {
                // Not necessary to alert user, name will just be blank
                print(error)
            }
        }
    }
    
    
    // Logout
    @IBAction func logoutButtonPressed(_ sender: Any) {
        Logout.toLoginScreen(currentController: self)
    }
    
    // Add new marker w/ student info
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let postlocationNavController = storyboard?.instantiateViewController(withIdentifier: "postLocationNVC") as! UINavigationController
        // Present Modaly
        present(postlocationNavController, animated: true, completion: nil)
        
    }
    
    // Reload data
    @IBAction func refreshButtonPressed(_ sender: Any) {
        // Get data to display
        ParseClient.getStudentInfo { (success, error) in
            
            // Success, reload mapview
            if success {
                self.allStudentInfo = SharedStudentInfo.allInfo
                self.configureAnnotations()
            }
                // Failure, show message
            else {
                self.showError(title: Errors.ErrorMessage.networkError.string, message: Errors.ErrorMessage.tryAgain.string)
            }
        }
    }
}


// MARK: - MKMapViewDelegate Methods
extension MapViewController: MKMapViewDelegate {
    
    // Create and configure annotation for each student
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // Respond to tap and go to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if var toOpen = view.annotation?.subtitle! {
                // Check to see if there is not a avalid prefix
                if !toOpen.hasPrefix("https://") || !toOpen.hasPrefix("http://") {
                    // Add prefix
                    toOpen = "https://\(toOpen)"
                }
                
                if let url = URL(string: toOpen) {
                    
                    // URL is valid
                    app.open(url, options: [:], completionHandler: nil)
                }
                else {
                    
                    // URL is invalid
                    print("Invalid URL")
                }
            }
        }
    }
    // Error Message
    func showError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
