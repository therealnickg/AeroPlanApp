import SwiftUI
import Foundation

class FlightLogEntry: ObservableObject, Equatable, Identifiable {
    
    let ID: UUID
    @Published var date: Date
    @Published var departureAirport: String
    @Published var arrivalAirport: String
    @Published var altitude: Double
    @Published var speed: Double
    @Published var distance: Double
    @Published var flightTime: Double
    @Published var landings: Int
    @Published var instrumentApproaches: Int
    @Published var notes: String?

    // Initialize with default values
    init(ID: UUID = UUID()) {
        self.ID = ID
        self.date = Date()
        self.departureAirport = ""
        self.arrivalAirport = ""
        self.altitude = 0.0
        self.speed = 0.0
        self.distance = 0.0
        self.flightTime = 0.0
        self.landings = 0
        self.instrumentApproaches = 0
        self.notes = nil
    }
    
    // Initialize with custom values
    init(
        ID: UUID = UUID(),
        date: Date,
        departureAirport: String,
        arrivalAirport: String,
        altitude: Double,
        speed: Double,
        distance: Double,
        flightTime: Double,
        landings: Int,
        instrumentApproaches: Int,
        notes: String?
    ) {
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
