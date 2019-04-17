//
//  UdacityClient.swift
//  On The Map
//
//  Created by Irving Martinez on 4/8/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation
import MapKit

class UdacityClient {
    
    // MARK: - Properties
    
    static let loginUrl = "https://onthemap-api.udacity.com/v1/session"
    static var userDataUrl = {
        return URL(string: "https://onthemap-api.udacity.com/v1/users/\(SharedStudentInfo.uniqueKey)")!
    }
    
    
    // MARK: - Functions
    
    // GET Request
    
    class func getCurrentUser(key: String, completion: @escaping(Bool, Error?) -> Void) {
        
        // Build request and fire
        let request = URLRequest(url: UdacityClient.userDataUrl())
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // No valid data
            guard let data = data else {
                completion(false, error)
                return
            }
            // Ignore first 5 characters
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            //print(String(data: newData, encoding: .utf8)!)
            
            // Decode
            do {
                
                let user = try JSONDecoder().decode(UserRequest.self, from: newData)
                
                DispatchQueue.main.async {
                    SharedStudentInfo.studentFirstName = user.firstName ?? ""
                    SharedStudentInfo.studentLastName = user.lastName ?? ""
                    completion(true, nil)
                }
                
            }
            // Decode error
            catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
        }
        task.resume()
        
    }
    
    
    // POST Request
    class func createSession(username: String, password: String, completion: @escaping(Bool, Error?) -> Void) {
        
        guard let url = URL(string: loginUrl) else {
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        
        // API call
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            // Ignore the first 5 characters
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            // Parse into Codable struct
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: newData)
                
                // If login successful
                if loginResponse.account.registered {
                    
                    DispatchQueue.main.async {
                        SharedStudentInfo.sessionId = loginResponse.session.id
                        SharedStudentInfo.uniqueKey = loginResponse.account.key
                        completion(true, nil)
                    }
                }
                    
                // If login unsuccessful
                else if loginResponse.account.registered == false {
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                    
                }
            }
            catch {
                // Handle error
                completion(false, error)
            }
            
        }
        task.resume()
    }
    
    // DELETE Request
    class func deleteSession(completion: @escaping(Bool, Error?) -> Void) {
        
        // Create Request
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        // Create dataTask
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            // No error, logout successful
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            SharedStudentInfo.sessionId = ""
            SharedStudentInfo.uniqueKey = ""
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
        task.resume()
    }
    
}
