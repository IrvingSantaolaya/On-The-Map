//
//  PostLocation.swift
//  On The Map
//
//  Created by Irving Martinez on 4/15/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation

// Codable struct for Parse POST request
struct PostLocation : Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
