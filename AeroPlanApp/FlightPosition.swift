//
//  FlightPosition.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 11/24/23.
//

import Foundation
import MapKit

class FlightPosition: ObservableObject, Identifiable {
    @Published var coordinate: CLLocationCoordinate2D
    var id = UUID()

    init(latitude: Double, longitude: Double) {
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func updatePosition(latitude: Double, longitude: Double) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.id = UUID()
    }
}
