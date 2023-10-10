//
//  LogsView.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 9/16/23.
//


//
//var flightLogs:  [FlightLogBook] {
//    [
//        FlightLogBook(date: formattedDate("01/01/2023") ?? Date(), departureAirport: "LAX", arrivalAirport: "LongBeach" ,altitude: 35000, speed: 450, distance: 1000, flightTime: 2 * 3600, landings: 1, instrumentApproaches: 3, notes: "None")
//        // Add more placeholder flight logs here
//    ]
import Foundation
import SwiftUI
// create a placeholder LogsView
struct LogsView: View {
    @State private var logEntries: [FlightLogEntry] = []
    @State private var editMode: Bool = false
    @State private var selectedLog: FlightLogEntry?
    
    
    init() {
        // Add some initial log entries
        logEntries.append(FlightLogEntry(date: Date(), departureAirport: "LAX", arrivalAirport: "JFK", altitude: 35000, speed: 450, distance: 2500, flightTime: 2 * 3600, landings: 1, instrumentApproaches: 2, notes: "Clear skies."))
        }

    var body: some View {
        NavigationView {
            List {
                ForEach(logEntries, id: \.ID) { log in
                    LogEntryRow(log: log)
                        .onTapGesture {
                            selectedLog = log
                            editMode = true
                        }
                }
                if editMode {EditLogEntryForm(log: $selectedLog, isEditing: $editMode)}
            }
            
            .navigationBarItems(trailing: Button(action: {
                addLogEntry()
                editMode = true
            }) {
                Image(systemName: "plus")
            })
            .navigationBarTitle("Flight Logs")
        }
    }
    
    
    private func addLogEntry() {
        logEntries.append(FlightLogEntry(
            date: Date(),
            departureAirport: "",
            arrivalAirport: "",
            altitude: 0,
            speed: 0,
            distance: 0,
            flightTime: 0,
            landings: 0,
            instrumentApproaches: 0,
            notes: ""
        ))
    }

    private func deleteLogEntry(at offsets: IndexSet) {
           logEntries.remove(atOffsets: offsets)
       }
    // Helper function to format time interval as HH:mm:ss
    private func formattedTime(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timeInterval) ?? ""
    }
    
    private func formattedDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.date(from: dateString)
    }
}
