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
    @State private var crosswind: String = ""
    @State private var runwayLength: String = ""
    @State private var runwayWidth: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Minimum Visibility (SM)")) {
                    TextField("Statute Miles", text: $visibility)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Minimum Cloud Ceiling")) {
                    TextField("Feet", text: $cloudCeiling)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Maximum Wind Speed")) {
                    TextField("Knots", text: $windSpeed)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Maximum Crosswind")) {
                    TextField("Knots", text: $crosswind)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Minimum Runway Length")) {
                    TextField("Feet", text: $runwayLength)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Minimum Runway Width")) {
                    TextField("Feet", text: $runwayWidth)
                        .keyboardType(.numberPad)
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
