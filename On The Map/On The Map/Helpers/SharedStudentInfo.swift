//
//  SharedStudentInfo.swift
//  On The Map
//
//  Created by Irving Martinez on 4/14/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation
import MapKit

class SharedStudentInfo {
    
    static var sessionId = ""
    static var uniqueKey = ""
    static var studentFirstName = ""
    static var studentLastName = ""
    static var coordinate: CLLocationCoordinate2D?
    static var latitude: Double = 0.0
    static var longitude: Double = 0.0
    static var mapString = ""
    static var mediaURL = ""
    
    static var allInfo: [StudentInfo] = []
    
}
