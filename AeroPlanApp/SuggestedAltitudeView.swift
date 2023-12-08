//
//  SuggestedAltitudeView.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 11/14/23.
//

import SwiftUI
import Foundation

func fetchData(lat: Double, long: Double) -> String {
    // Replace with your actual API URL
    let apiKey = "AIzaSyBNdquDaE5Sdih7JKu6gQMyy1nngh6FKnM"
    let apiUrl = "https://maps.googleapis.com/maps/api/"
    let latitude = lat
    let longitude = long

    let urlString = apiUrl + "elevation/json?locations=\(latitude)%2C\(longitude)&key=\(apiKey)"
    let url = URL(string: urlString)!

    var result = ""
    let semaphore = DispatchSemaphore(value: 0)

    URLSession.shared.dataTask(with: url) { data, _, error in
        defer { semaphore.signal() }

        if let error = error {
            print("Error: \(error)")
            return
        }

        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            result = responseString
        }
    }.resume()

    semaphore.wait()
    return result
}


func getElevation(jsonString: String) -> Int {
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {

                // Check if "results" key exists and contains an array
                if let resultsArray = json["results"] as? [[String: Any]] {
                    // Check if the first result in the array has the "elevation" key
                    if let elevation = resultsArray.first?["elevation"] as? Double {
                        // Convert the elevation in meters to feet as Int
                        let elevationInt = Int(elevation*3.28084)
                        //print("Elevation: \(elevationInt)")
                        return elevationInt
                    } else {
                        print("Elevation key not found in the results")
                    }
                } else {
                    print("Results key not found or not an array")
                }

            } else {
                print("Invalid JSON format")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    return 0
}

func degreesToRadians(_ degrees: Double) -> Double {
    return degrees * Double.pi / 180.0
}

func radiansToDegrees(_ radians: Double) -> Double {
    return radians * 180.0 / .pi
}

func haversineDistance(apt1lat: Double, apt1long: Double, apt2lat: Double, apt2long: Double) -> Double {
    let R = 3440.065 // Earth radius in miles
    
    let deltaLat = degreesToRadians(apt2lat - apt1lat)
    let deltaLon = degreesToRadians(apt2long - apt1long)
    
    let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
            cos(degreesToRadians(apt1lat)) * cos(degreesToRadians(apt2lat)) *
            sin(deltaLon / 2) * sin(deltaLon / 2)
    
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    
    let distance = R * c // Distance in miles
    let roundedMiles = ceil(distance * 10) / 10
    return roundedMiles
}

func getMaxAltitude(airport1: String, airport2: String) -> String {
    let lat1 = 33.81769943
    let long1 = -118.1520004
    let lat2 = 34.21369934082031
    let long2 = -119.09400177001953
    
    let distance = haversineDistance(apt1lat: lat1, apt1long: long1, apt2lat: lat2, apt2long: long2)
    
    let airportString = fetchData(lat: lat1, long: long1)
    return "\(getElevation(jsonString: airportString))\"\n\(distance) nm"
}

struct SuggestedAltitudeView: View {
    @State private var maxElevation: String = getMaxAltitude(airport1: "KLGB", airport2: "KCMA")
    
    var body: some View {
        Text(maxElevation)
    }
}

#Preview {
    SuggestedAltitudeView()
}
