//
//  LogOut.swift
//  On The Map
//
//  Created by Irving Martinez on 4/10/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation
import UIKit

class Logout {
    
    class func toLoginScreen(currentController: UIViewController) {
        
        UdacityClient.deleteSession { (success, error) in
            
            if success {
                currentController.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            else {
                print(error)
            }
        }
        
    }
}
