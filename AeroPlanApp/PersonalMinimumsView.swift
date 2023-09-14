//
//  PersonalMinimums.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 9/14/23.
//

import SwiftUI

struct PersonalMinimumsView: View {
    @State private var visibility: String = ""
    @State private var cloudCeiling: String = ""
    @State private var windSpeed: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Minimum Visibility (SM)")) {
                    TextField("Statute Miles", text: $visibility)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Minimum Cloud Ceiling")) {
                    TextField("Feet", text: $visibility)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Maximum Wind Velocity")) {
                    TextField("Knots", text: $visibility)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Minimum Runway Length")) {
                    TextField("Feet", text: $visibility)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Minimum Runway Width")) {
                    TextField("Feet", text: $visibility)
                        .keyboardType(.numberPad)
                }

                Section {
                    Button(action: {
                        // Save the entered minimums to your data model or perform any other action.
                    }) {
                        Text("Save")
                    }
                }
            }
            .navigationBarTitle("Personal Minimums")
        }
    }
}

struct PersonalMinimumsView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalMinimumsView()
    }
}
