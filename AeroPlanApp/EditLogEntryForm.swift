//
// EditLogEntryForm.swift
// AeroPlan
//
// Created by Nguyen Vo on 9/16/23.
//
import Foundation
import SwiftUI

struct EditLogEntryForm: View {
    
    
    @Binding var log: FlightLogEntry?
    @Binding var isEditing: Bool
    @ObservedObject var dataManager =  DataManager()
    let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        return f
      }()
    
    // Create @State properties for mutable values
    @State private var editedDate: Date = Date()
    @State private var editedDepartureAirport: String = ""
    @State private var editedArrivalAirport: String = ""
    @State private var editedAltitude: Double = 0.0
    @State private var editedSpeed: Double = 0.0
    @State private var editedDistance: Double = 0.0
    @State private var editedFlightTime: Double = 0.0
    @State private var editedLandings: Int = 0
    @State private var editedInstrumentApproaches: Int = 0
    @State private var editedNotes = ""
   
    var body: some View {
        
        NavigationView {
            Form {
                DatePicker("Date", selection: $editedDate)
                TextField("Departure Airport", text: $editedDepartureAirport)
                TextField("Arrival Airport", text: $editedArrivalAirport)
                TextField("Altitude", value: $editedAltitude, formatter: numberFormatter)
                TextField("Speed", value: $editedSpeed, formatter: numberFormatter)
                TextField("Distance", value: $editedDistance, formatter: numberFormatter)
                TextField("FlightTime", value: $editedFlightTime, formatter: numberFormatter)
                TextField("Landings", value: $editedLandings, formatter: NumberFormatter())
                TextField("Instrument Approaches", value : $editedInstrumentApproaches, formatter: NumberFormatter())
                TextField("Notes", text: $editedNotes)
                
                Button("Save") {
                    if let log = log {
                        // Update the properties with edited values
                        log.date = editedDate
                        log.departureAirport = editedDepartureAirport
                        log.arrivalAirport = editedArrivalAirport
                        log.altitude = editedAltitude
                        log.speed = editedSpeed
                        log.distance = editedDistance
                        log.flightTime = editedFlightTime
                        log.landings = editedLandings
                        log.instrumentApproaches = editedInstrumentApproaches
                        log.notes = editedNotes
                        
                        // Update existing entry
                        dataManager.updateFlightEntry(flightEntry: log) { (success) in
                            if success {
                                print("Successfully updated flight entry.")
                            }
                        }
                    }
                    isEditing = false
                }
            }
            .onAppear{
                if let log = log
                {
                    editedDate = log.date
                    editedDepartureAirport = log.departureAirport
                    editedArrivalAirport = log.arrivalAirport
                    editedAltitude = log.altitude
                    editedSpeed = log.speed
                    editedDistance = log.distance
                    editedFlightTime = log.flightTime
                    editedLandings = log.landings
                    editedInstrumentApproaches = log.instrumentApproaches
                    editedNotes = log.notes ?? ""
                }
                

            }
            
        }

    }

}

