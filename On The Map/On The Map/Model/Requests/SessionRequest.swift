//
//  SessionRequest.swift
//  On The Map
//
//  Created by Irving Martinez on 4/8/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation

struct SessionRequest: Codable {
    
    let udacity: [String:String]
    let username: String
    let password: String
}
