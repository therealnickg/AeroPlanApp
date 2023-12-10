//
//  DataManager.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 4/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

protocol LoginDelegate: AnyObject {
    func didLogin(username: String)
}

class DataManager: ObservableObject, LoginDelegate {
    @Published var pilots: [Pilot] = []
    @Published var flightEntries: [FlightLogEntry] = []

    @Published var isLoggedIn = false
    @Published var email: String = ""
    @Published var password: String = ""
    
    func didLogin(username: String) {
        isLoggedIn = true
    }
    
//    init(fetchPilots: Bool = true, fetchFlightEntries: Bool = true) {
//        if fetchPilots {
//            self.fetchPilots()
//        }
//        
//        if fetchFlightEntries {
//            self.fetchFlighEntries()
//        }
//    }
    
    func fetchPilots(){
        pilots.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Pilots")
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    
                    let pilot = Pilot(id: id, name: name)
                    self.pilots.append(pilot)
                }
            }
        }
    }
    
    func addPilot(pilotName: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Pilots").document(pilotName)
        ref.setData(["name" : pilotName, "id" : UUID().uuidString ]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func fetchFlighEntries(){
        flightEntries.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("FlightEntries")
        
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    print("Fetched log with document ID: \(document.documentID)")

                    let data = document.data()
                    
                    if let dateTimestamp = data["date"] as? Timestamp,
                       let departureAirport = data["departureAirport"] as? String,
                       let arrivalAirport = data["arrivalAirport"] as? String,
                       let altitude = data["altitude"] as? Double,
                       let speed = data["speed"] as? Double,
                       let distance = data["distance"] as? Double,
                       let flightTime = data["flightTime"] as? Double,
                       let landings = data["landings"] as? Int,
                       let instrumentApproaches = data["instrumentApproaches"] as? Int,
                       let notes = data["notes"] as? String,
                       let uuid = UUID(uuidString: document.documentID){
                        // Create a FlightLogEntry instance
                        let flightLogEntry = FlightLogEntry(
                            ID: uuid,
                            date: dateTimestamp.dateValue(),
                            departureAirport: departureAirport,
                            arrivalAirport: arrivalAirport,
                            altitude: altitude,
                            speed: speed,
                            distance: distance,
                            flightTime: flightTime,
                            landings: landings,
                            instrumentApproaches: instrumentApproaches,
                            notes: notes
                        )
                        
                        // Append the entry to the flightEntries array
                        self.flightEntries.append(flightLogEntry)
                    }
                }
            }
        }
        
        
    }
    
    func addFlightEntry(flightEntry: FlightLogEntry) {
        
        print("Adding flight entry with ID: \(flightEntry.ID.uuidString)")
        
        let db = Firestore.firestore()
        let ref = db.collection("FlightEntries").document(flightEntry.ID.uuidString) // Use your custom ID
      
        // Convert the FlightLogEntry to a dictionary
        let flightEntryData: [String: Any] = [
            "date": flightEntry.date,
            "departureAirport": flightEntry.departureAirport,
            "arrivalAirport": flightEntry.arrivalAirport,
            "altitude": flightEntry.altitude,
            "speed": flightEntry.speed,
            "distance": flightEntry.distance,
            "flightTime": flightEntry.flightTime,
            "landings": flightEntry.landings,
            "instrumentApproaches": flightEntry.instrumentApproaches,
            "notes": flightEntry.notes ?? "",
            
        ]
        
        ref.setData(flightEntryData) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            }
        }
    }
    
    
    func updateFlightEntry(flightEntry: FlightLogEntry, completion: @escaping (Bool) -> Void) {
        print("Updating flight entry with ID: \(flightEntry.ID.uuidString)")
        
        // Ensure you have a reference to your Firestore database
        let db = Firestore.firestore()
        let ref = db.collection("FlightEntries")
        
        // Convert the flightEntry to a dictionary manually
        let flightEntryData: [String: Any] = [
            "date": flightEntry.date,
            "departureAirport": flightEntry.departureAirport,
            "arrivalAirport": flightEntry.arrivalAirport,
            "altitude": flightEntry.altitude,
            "speed": flightEntry.speed,
            "distance": flightEntry.distance,
            "flightTime": flightEntry.flightTime,
            "landings": flightEntry.landings,
            "instrumentApproaches": flightEntry.instrumentApproaches,
            "notes": flightEntry.notes ?? "",
        ]

        // Update the Firestore document with the new data
        ref.document(flightEntry.ID.uuidString).updateData(flightEntryData) { error in
            if let error = error {
                print("Error updating flight entry: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Flight entry updated successfully.")
                completion(true)
            }
        }
    }

    
    
}

    
  

