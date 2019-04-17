//
//  ConfirmLocationViewController.swift
//  On The Map
//
//  Created by Irving Martinez on 4/14/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

            setUpMapView(coordinate: SharedStudentInfo.coordinate!)
        
        // Do any additional setup after loading the view.
    }
    // MARK: - IBActions
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        // Create student info object
        
        let newLocation = PostLocation(uniqueKey: SharedStudentInfo.uniqueKey, firstName: SharedStudentInfo.studentFirstName, lastName: SharedStudentInfo.studentLastName, mapString: SharedStudentInfo.mapString, mediaURL: SharedStudentInfo.mediaURL, latitude: SharedStudentInfo.coordinate!.latitude, longitude: SharedStudentInfo.coordinate!.longitude)
        
        ParseClient.postLocation(studentInfo: newLocation) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print(error)
                self.showAlert()
            }
        }
    }
    // MARK: - Helper Functions
    

    // Configure UI
    func setUpMapView(coordinate: CLLocationCoordinate2D) {
        
        submitButton.layer.cornerRadius = 5
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations([annotation], animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: Errors.ErrorMessage.networkError.string, message: Errors.ErrorMessage.tryAgain.string, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
