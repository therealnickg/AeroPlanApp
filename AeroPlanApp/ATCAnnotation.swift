//
//  ATCAnnotation.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 10/28/23.
//

import Foundation
import MapKit

struct ATCAnnotation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let phoneNumber: String?
    

}

    
