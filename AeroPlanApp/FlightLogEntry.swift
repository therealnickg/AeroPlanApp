//
//  FlightLogBook.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 9/16/23.
//

import SwiftUI
import Foundation

// Flight LogBook object
class FlightLogEntry: ObservableObject, Equatable{
    
    @Published var ID = UUID() // unique ID for each log
    @Published var date = Date()
    @Published var departureAirport = ""
    @Published var arrivalAirport = ""
    @Published var altitude: Double = 0.0 // Altitude in feet
    @Published var speed: Double = 0.0 // in knots
    @Published var distance: Double = 0.0 // in miles
    @Published var flightTime: TimeInterval = 0.0
    @Published var landings: Int = 0 // # of landings
    @Published var instrumentApproaches: Int = 0 // # of instrument approaches
    @Published var notes: String? = nil
    
    init(ID: UUID = UUID(), date: Date, departureAirport: String, arrivalAirport: String, altitude: Double, speed: Double, distance: Double, flightTime: TimeInterval, landings: Int, instrumentApproaches: Int, notes: String?) {
        
        self.ID = ID
        self.date = date
        self.departureAirport = departureAirport
        self.arrivalAirport = arrivalAirport
        self.altitude = altitude
        self.speed = speed
        self.distance = distance
        self.flightTime = flightTime
        self.landings = landings
        self.instrumentApproaches = instrumentApproaches
        self.notes = notes
      }
    
    // overloaded == comparison
    static func == (lhs: FlightLogEntry, rhs: FlightLogEntry) -> Bool {
          return lhs.ID == rhs.ID
    }
}

