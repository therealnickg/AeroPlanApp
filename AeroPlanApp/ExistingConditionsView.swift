//
//  ExistingConditionsView.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 9/16/23.
//

import SwiftUI

struct ExistingConditionsView: View {
    var visibility: String
    var cloudCeiling: String
    var windSpeed: String

    @State private var currentVisibility: Double = 0.0
    @State private var currentCloudCeiling: Double = 0.0
    @State private var currentWindSpeed: Double = 0.0
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button(action: {
                            // Navigate back to the Edit Personal Minimums view
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Edit Personal Minimums")
                                .font(.headline)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
            
            Text("Airport Conditions")
                .font(.largeTitle)
                .padding()

            Slider(value: $currentVisibility, in: 0...10, step: 0.1)
            Text("Current Visibility: \(currentVisibility, specifier: "%.1f") miles")

            Slider(value: $currentCloudCeiling, in: 0...5000, step: 100)
            Text("Current Cloud Ceiling: \(Int(currentCloudCeiling)) feet")

            Slider(value: $currentWindSpeed, in: 0...50, step: 1)
            Text("Current Wind Speed: \(Int(currentWindSpeed)) knots\n\n")

            Button(action: {
                // Compare the current conditions with personal minimums here
                // You can implement your logic to compare and show a result.
                // For simplicity, you can just print a message for now.
                print("Comparing against personal minimums...")
            }) {
                Text("Compare")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Text("\n\n\nYou are ready to Fly!")
        }
        .padding()
    }
}

struct ExistingConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        ExistingConditionsView(visibility:"1",cloudCeiling:"2",windSpeed:"3")
    }
}
