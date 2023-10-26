//
//  EditLogEntryForm.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 9/16/23.
//
import Foundation
import SwiftUI

struct EditLogEntryForm: View {
    @Binding var log: FlightLogEntry?
    @Binding var isEditing: Bool

    // Create @State properties for mutable values
    @State private var editedDate = Date() // Provide an initial value
    @State private var editedDepartureAirport = ""
    @State private var editedArrivalAirport = ""
    @State private var editedAltitude = 0.0
    @State private var editedSpeed = 0.0
    @State private var editedDistance = 0.0

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $editedDate)
                TextField("Departure Airport", text: $editedDepartureAirport)
                TextField("Arrival Airport", text : $editedArrivalAirport)
                TextField("Altitude", value: $editedAltitude, formatter: NumberFormatter())
                TextField("Speed", value: $editedSpeed, formatter: NumberFormatter())
                TextField("Distance", value: $editedDistance, formatter: NumberFormatter())
                

                Button("Save") {
                    // Check if log is not nil before attempting to modify it
                    if let log = log {
                        // Update the properties with edited values
                        log.date = editedDate
                        log.departureAirport = editedDepartureAirport
                        log.arrivalAirport = editedArrivalAirport
                        log.altitude = editedAltitude
                                    log.speed = editedSpeed
                                    log.distance = editedDistance

                        // Assign the modified log back to the binding
                        self.log = log
                    }
                    isEditing = false
                }
            }
        }
        .onAppear {
            // Initialize the @State properties with the log's values
            if let log = log {
                editedDate = log.date
                editedDepartureAirport = log.departureAirport
                editedArrivalAirport = log.arrivalAirport
            }
        }
    }
}
