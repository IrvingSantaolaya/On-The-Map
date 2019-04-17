//
//  ParseClient.swift
//  On The Map
//
//  Created by Irving Martinez on 4/10/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation

class ParseClient {
    
    // MARK: - Properties
    static let parseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    static let studentInfoUrl =  {
        return URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!
    }
    static let postLocationUrl = {
        return URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
    }
    static let appIdHeader = "X-Parse-Application-Id"
    static let apiKeyHeader = "X-Parse-REST-API-Key"
    
    
    // MARK: - Functions
    
    
    // GET REQUESTS
    // Request student locations
    
    class func getStudentInfo(completion: @escaping (Bool, Error?) -> Void) {
        
        // Build Request
        var request = URLRequest(url: studentInfoUrl())
        request.addValue(parseAppId, forHTTPHeaderField: appIdHeader)
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeader)
        
        // Create task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // There is no data retrieved
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            //print(String(data: data, encoding: .utf8)!)
            
            // Decode data into results and pass via completion
            do {
                let results = try JSONDecoder().decode(AllStudentInfo.self, from: data)
                DispatchQueue.main.async {
                    SharedStudentInfo.allInfo = results.results
                    completion(true, nil)
                }
            }
                // There was an error decoding
            catch {
                print(error)
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
            
        }
        task.resume()
        
        
    }
    
    // POST REQUESTS
    
    class func postLocation(studentInfo: PostLocation, completion: @escaping(Bool, Error?) -> Void) {
        
        
        // Build request
        var request = URLRequest(url: postLocationUrl())
        request.httpMethod = "POST"
        request.addValue(parseAppId, forHTTPHeaderField: appIdHeader)
        request.addValue(apiKey, forHTTPHeaderField: apiKeyHeader)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Encode data that will be sent in request
        let encoder = JSONEncoder()
        do {
        let encodedData = try encoder.encode(studentInfo)
            request.httpBody = encodedData
            print(String(data: encodedData, encoding: .utf8))
            
            // Create task
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               
                // If there is valid data
                guard let data = data else {
                    
                    // Return failure
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                    return
                }
                // If successful
                
                do {
                    let decodedData = try JSONDecoder().decode(PostResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
                
            }
            task.resume()
        }
            // Failure
        catch {
            print(error)
            completion(false, error)
        }
        
//        request.httpBody = "{\"uniqueKey\": \"\(studentInfo.uniqueKey!)\", \"firstName\": \"\(studentInfo.firstName!)\", \"lastName\": \"\(studentInfo.lastName!)\",\"mapString\": \"\(studentInfo.mapString!)\", \"mediaURL\": \"\(studentInfo.mediaURL!)\",\"latitude\": \(studentInfo.latitude!), \"longitude\": \(studentInfo.longitude!)}".data(using: .utf8)

        
    }
}
