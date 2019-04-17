//
//  Errors.swift
//  On The Map
//
//  Created by Irving Martinez on 4/10/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation

class Errors {
    
    enum ErrorMessage: String {
        case incorrectCredentials
        case networkError
        case tryAgain
        case invalidUrl
        case loginFailed
        
        var string: String {
            switch self {
            case .incorrectCredentials: return "Incorrect Username or Password"
            case .networkError: return "There was a network error"
            case .tryAgain: return "Please try again"
            case .invalidUrl: return "Invalid Url"
            case .loginFailed: return "Login Failed"
            }
        }
    }

}


