//
//  ListView.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 4/29/23.
//

import Firebase
import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            List(dataManager.pilots, id: \.id) { pilot in
                Text(pilot.name)
            }
            .navigationTitle("Pilots")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        showPopup.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showPopup) {
                NewPilotView()
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environmentObject(DataManager())
    }
}

