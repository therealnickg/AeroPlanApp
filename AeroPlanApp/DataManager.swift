//
//  DataManager.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 4/29/23.
//

import SwiftUI
import Firebase

protocol LoginDelegate: AnyObject {
    func didLogin(username: String)
}

class DataManager: ObservableObject, LoginDelegate {
    @Published var pilots: [Pilot] = []
    @Published var isLoggedIn = false
    @Published var email: String = ""
    @Published var password: String = ""

    func didLogin(username: String) {
            isLoggedIn = true
    }
    
    init() {
        fetchPilots()
    }
    
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
}

