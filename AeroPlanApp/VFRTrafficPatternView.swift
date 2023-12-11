//
//  VFRTrafficPatternView.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 11/8/23.
//

import SwiftUI
import MapKit

struct VFRTrafficPatternView: View {
    @State private var inputText: String = ""
    @State private var showMap: Bool = false
    @State private var airportString = ""
    @State private var airportCoords = (0.0,0.0)
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            Text("Traffic Pattern Visualization")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
            TextField("Enter Airport Code", text: $inputText)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Implement your logic to parse and update coordinates
                airportString = fetchAirportString(airport: inputText)
                airportCoords = parseAirportCoords(jsonString: airportString)
                if let coordinates = parseCoordinates(from: "\(airportCoords.0),\(airportCoords.1)") {
                    region.center = coordinates
                    showMap = true
                } else {
                    // Handle invalid input
                    print("Invalid code entered.")
                }
            }) {
                Text("Show Airport Map")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.yellow)
                    .cornerRadius(10)
            }

            if showMap {
                Map(coordinateRegion: $region)
                    .frame(height: 450)
                    .cornerRadius(10)
            }
        }
        .padding()
    }

    // Helper function to parse coordinates from the input string
    private func parseCoordinates(from input: String) -> CLLocationCoordinate2D? {
        let coordinates = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }

        guard coordinates.count == 2 else {
            return nil
        }

        return CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
    }
}

#Preview {
    VFRTrafficPatternView()
}
