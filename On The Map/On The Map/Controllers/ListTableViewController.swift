//
//  ListTableViewController.swift
//  On The Map
//
//  Created by Irving Martinez on 4/7/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var allStudentInfo = SharedStudentInfo.allInfo
    
    // MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Functions

    @IBAction func logoutButtonPressed(_ sender: Any) {
        Logout.toLoginScreen(currentController: self)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let postlocationNavController = storyboard?.instantiateViewController(withIdentifier: "postLocationNVC") as! UINavigationController
        // Present Modaly
        present(postlocationNavController, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        // Get data to display
        ParseClient.getStudentInfo { (success, error) in
            
            // Success, reload data
            if success {
                self.allStudentInfo = SharedStudentInfo.allInfo
                self.tableView.reloadData()
            }
                // Failure, show message
            else {
                self.showError(title: Errors.ErrorMessage.networkError.string, message: Errors.ErrorMessage.tryAgain.string)
            }
        }
    }
    
    // Error message
    func showError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }

}

extension ListTableViewController {
    // MARK: - Table view data source and delegate methods
    
    // Generate the same amount of rows as there are students
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allStudentInfo.count
    }
    
    // Create cell for each student
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfo", for: indexPath)
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = "\(allStudentInfo[indexPath.row].firstName ?? "N/A") \(allStudentInfo[indexPath.row].lastName ?? "")"
        cell.detailTextLabel?.text = allStudentInfo[indexPath.row].mediaURL
        
        return cell
    }
    
    // Present URL when user taps on row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        if var toOpen = allStudentInfo[indexPath.row].mediaURL {
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
