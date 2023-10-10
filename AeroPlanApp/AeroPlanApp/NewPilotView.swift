//
//  NewPilotView.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 4/29/23.
//

import SwiftUI

struct NewPilotView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var newPilot = ""
    var body: some View {
        VStack{
            TextField("Pilot", text: $newPilot)
            
            Button {
                dataManager.addPilot(pilotName: newPilot)
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
}

struct NewPilotView_Previews: PreviewProvider {
    static var previews: some View {
        NewPilotView()
    }
}
