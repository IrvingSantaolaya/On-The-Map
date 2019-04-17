//
//  UserRequest.swift
//  On The Map
//
//  Created by Irving Martinez on 4/12/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation

struct UserRequest: Codable {
    
    let firstName: String?
    let lastName: String?
    
    
    enum CodingKeys: String, CodingKey {
        
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
    
