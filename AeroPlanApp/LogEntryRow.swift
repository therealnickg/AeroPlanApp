//
//  LogEntryRow.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 9/16/23.
//
import Foundation
import SwiftUI

struct LogEntryRow: View {
        var log: FlightLogEntry
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Date: \(formattedDate(log.date))")
                Text("Departure Airport: \(log.departureAirport)")
                Text("Altitude: \(log.altitude)")
                Text("Speed: \(log.speed)")
                Text("Distance: \(log.distance)")
                Text("FlightTime: \(log.flightTime)")
                Text("Landings: \(log.landings)")
                Text("Instrument Approaches: \(log.instrumentApproaches)")
                if let notes = log.notes {
                    Text("Notes: \(notes)")
                } else {
                    Text("No Notes")
                }
            }
        }
        
        private func formattedDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            return dateFormatter.string(from: date)
        }
}

