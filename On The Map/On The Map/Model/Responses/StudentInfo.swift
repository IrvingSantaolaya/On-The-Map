//
//  StudentLocation.swift
//  On The Map
//
//  Created by Irving Martinez on 4/10/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation


struct StudentInfo: Codable {
    
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}

struct AllStudentInfo: Codable {
    
    let results: [StudentInfo]
}
