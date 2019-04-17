//
//  LoginViewController.swift
//  On The Map
//
//  Created by Irving Martinez on 4/7/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // Constants
    
    let signupUrl = "https://auth.udacity.com/sign-up"
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Inits
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    // MARK: - Functions
    
    // Login
    @IBAction func loginButtonPressed(_ sender: Any) {
        setLoggingIn(true)

        UdacityClient.createSession(username: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (success, error) in
            
            // There is an error
            if error != nil {
                self.showError(title: Errors.ErrorMessage.loginFailed.string,message: Errors.ErrorMessage.incorrectCredentials.string)
                self.setLoggingIn(false)
            }
            // Login successful
            else if error == nil && success {
                
                ParseClient.getStudentInfo(completion: { (success, error) in
                    if success {
                        self.loginSuccessful()
                        self.performSegue(withIdentifier: "LoginSegue", sender: self)
                        self.setLoggingIn(false)
                    }
                    else {
                        self.showError(title: Errors.ErrorMessage.networkError.string, message: Errors.ErrorMessage.tryAgain.string )
                        SharedStudentInfo.allInfo = []
                        self.performSegue(withIdentifier: "LoginSegue", sender: self)
                        self.setLoggingIn(false)
                    }
                })
            }
        }
    }
    
    // SignUp via web
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let app = UIApplication.shared
            if let url = URL(string: signupUrl) {
                
                // URL is valid
                app.open(url, options: [:], completionHandler: nil)
            }
            else {
                
                // URL is invalid
                showError(title: Errors.ErrorMessage.invalidUrl.string, message: Errors.ErrorMessage.tryAgain.string)
                print("Invalid URL")
            }
    }
    
    
    // MARK: - Helper Functions
    
    
    // Set up UI for viewdidload
    func setUpUI() {
        activityIndicator.isHidden = true
        loginButton.layer.cornerRadius = 5
    }
    
    // Update UI while logging in
    func setLoggingIn(_ loggingIn: Bool) {
        
        DispatchQueue.main.async {
            if loggingIn {
                self.activityIndicator.startAnimating()
            }
            else {
                self.activityIndicator.stopAnimating()
                
            }
            self.activityIndicator.isHidden = !loggingIn
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
        }
        }
    
    // Login successful, clear textfields
    
    func loginSuccessful() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // Show alert with failure message
    func showError(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
