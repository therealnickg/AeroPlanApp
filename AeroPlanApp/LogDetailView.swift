//
//  LogDetailView.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 9/16/23.
//

import Foundation
import SwiftUI

struct LogDetailView: View {
    @ObservedObject var logEntry: FlightLogEntry

    var body: some View {
        Form {
            Section(header: Text("Log Entry Details")) {
                DatePicker("Date", selection: $logEntry.date, displayedComponents: .date)
                TextField("Departure Airport", text: $logEntry.departureAirport)
                TextField("Arrival Airport", text: $logEntry.arrivalAirport)
                
            }
        }
        .navigationTitle("Log Entry Details")
    }
}
