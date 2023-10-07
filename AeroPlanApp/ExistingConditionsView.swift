//
//  ExistingConditionsView.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 9/16/23.
//

import SwiftUI

struct ExistingConditionsView: View {

    @State private var currentVisibility: Double = 0.0
    @State private var currentCloudCeiling: Double = 0.0
    @State private var currentWindSpeed: Double = 0.0
    @State private var runwayLength: String = ""
    @State private var runwayWidth: String = ""
    @State private var readyToFly: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    func readyToFlyBool() -> Bool {
        var visibilityBool: Bool = false
        var ceilingBool: Bool = false
        var windSpeedBool: Bool = false
        if (currentVisibility >= 3)
        {
            visibilityBool = true
        }
        if (currentCloudCeiling >= 1500)
        {
            ceilingBool = true
        }
        if (currentWindSpeed < 15)
        {
            windSpeedBool = true
        }
        if (visibilityBool && ceilingBool && windSpeedBool)
        {
            return true
        }
        return false
    }

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                            }) {
                                NavigationLink(destination: PersonalMinimumsView()) {
                                                    Text("Edit Personal Minimums")
                                                        .font(.headline)
                                                        .padding()
                                                        .background(Color.gray)
                                                        .foregroundColor(Color.white)
                                                        .cornerRadius(10)
                                                }
                            }
                            .padding()
                
                Text("Airport Conditions")
                    .font(.largeTitle)
                    .padding()

                Slider(value: $currentVisibility, in: 0...10, step: 0.1)
                Text("Current Visibility: \(currentVisibility, specifier: "%.1f") miles")

                Slider(value: $currentCloudCeiling, in: 0...5000, step: 100)
                Text("Current Cloud Ceiling: \(Int(currentCloudCeiling)) feet")

                Slider(value: $currentWindSpeed, in: 0...30, step: 1)
                Text("Current Wind Speed: \(Int(currentWindSpeed)) knots\n\n")
                Form {
                    Section(header: Text("Runway Length")) {
                        TextField("Feet", text: $runwayLength)
                            .keyboardType(.numberPad)
                    }
                   
                }
                
                if (readyToFlyBool())
                {
                    Text("You are ready to fly!")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
                else {
                    Text("You are not ready to fly!")
                        .font(.headline)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

struct ExistingConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        ExistingConditionsView()
    }
}
