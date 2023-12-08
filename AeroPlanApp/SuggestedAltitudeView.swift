//
//  SuggestedAltitudeView.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 11/14/23.
//

import SwiftUI
import Foundation


// THIS IS EVERYTHING RELATED TO GETTING THE ELEVATION API DATA
func fetchElevationData(lat: Double, long: Double) -> String {
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

// THIS IS EVERYTHING RELATED TO GETTING THE COORDINATES API DATA
func fetchAirportString(airport: String) -> String {
    // Replace with your actual API URL\
    let apiKey = "dVu8sPyDDM7K7MfkH2582AddlqTI4vnS"
    let apiUrl = "https://aeroapi.flightaware.com/aeroapi/"

    let authHeader = ["x-apikey": apiKey]

    let urlString = apiUrl + "airports/\(airport)"
    let url = URL(string: urlString)!

    var result = ""
    let semaphore = DispatchSemaphore(value: 0)
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = authHeader

    URLSession.shared.dataTask(with: request) { data, _, error in
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
    //print(result)
    return result
}

// THIS IS EVERYTHING RELATED TO PARSING THE ALTITUDE
func parseElevation(jsonString: String) -> Int {
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

// THIS IS EVERYTHING RELATED TO PARSING THE NAME OF THE AIRPORT
func parseAirportName(jsonString: String) -> String {
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            // Parse JSON data
            if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                // Access the "name" field
                if let airportName = json["name"] as? String {
                    return airportName
                } else {
                    return "Airport not found."
                }
            } else {
                print("Invalid JSON format.")
            }
        } catch {
            return "Airport not found"
        }
    }
    return "Error in Parsing"
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
    //let roundedMiles = ceil(distance * 10) / 10
    return distance
}

func initialBearing(apt1lat: Double, apt1long: Double, apt2lat: Double, apt2long: Double) -> Double {
    let lat1 = degreesToRadians(apt1lat)
    let lon1 = degreesToRadians(apt1long)
    let lat2 = degreesToRadians(apt2lat)
    let lon2 = degreesToRadians(apt2long)

    let dLon = lon2 - lon1

    let x = sin(dLon) * cos(lat2)
    let y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)

    let bearing = atan2(x, y)

    return (radiansToDegrees(bearing) + 360.0).truncatingRemainder(dividingBy: 360.0)
}

func calculateDestinationPoint(startLat: Double, startLong: Double, bearing: Double, distance: Double) -> (Double, Double) {
    let R = 3440.065  // Earth's radius in nautical miles

    let lat1 = degreesToRadians(startLat)
    let lon1 = degreesToRadians(startLong)

    let lat2 = asin(sin(lat1) * cos(distance / R) + cos(lat1) * sin(distance / R) * cos(bearing))
    let lon2 = lon1 + atan2(sin(bearing) * sin(distance / R) * cos(lat1), cos(distance / R) - sin(lat1) * sin(lat2))

    return (radiansToDegrees(lat2), radiansToDegrees(lon2))
}

func getMaxAltitude(airport1: String, airport2: String) -> String {
    let lat1 = 33.81769943
    let long1 = -118.1520004
    let lat2 = 34.21369934082031
    let long2 = -119.09400177001953
    
    let distance = haversineDistance(apt1lat: lat1, apt1long: long1, apt2lat: lat2, apt2long: long2)
    let bearing = initialBearing(apt1lat: lat1, apt1long: long1, apt2lat: lat2, apt2long: long2)
    
    var distanceCovered: Double = 0.0
    var maxElevation = 0
    while distanceCovered <= distance
    {
        let currentPoint = calculateDestinationPoint(startLat: lat1, startLong: long1, bearing: bearing, distance: distanceCovered)
        let elevationJsonString = fetchElevationData(lat: currentPoint.0, long: currentPoint.1)
        let elevation = parseElevation(jsonString: elevationJsonString)
        
        if (elevation > maxElevation)
        {
            maxElevation = elevation
        }
        print("Coordinates at \(distanceCovered), Nautical miles: \(currentPoint), Altitude: \(elevation)")
        distanceCovered += 3.0
    }
    
    return "Maximum Terrain Elevation:\n\t\(maxElevation)\"\nDistance between airports:\n\t\(distance) nm\nBearing:\n\t\(bearing)"
}




// ALL THE UI STUFF
/*
struct SuggestedAltitudeView: View {
    //@State private var maxElevation: String = getMaxAltitude(airport1: "KLGB", airport2: "KCMA")
    
    var body: some View {
        Text("Hello darkness my old friend")
        //Text(maxElevation)
    }
}*/

struct SuggestedAltitudeView: View {
    @State private var airport1 = ""
    @State private var airport2 = ""
    @State private var airport1String = ""
    @State private var airport2String = ""
    @State private var airport1coords = (0.0,0.0)
    @State private var airport2coords = (0.0,0.0)
    @State private var departing = ""
    @State private var arriving = ""
    @State private var maximumElevation = 0
    @State private var distanceBetween = 0
    @State private var bearingBetween = 0
    @State private var suggestAltitude = 0
    @State private var vfrORifrString = "VFR"
    @State private var vfrORifr = true

    var body: some View {
        VStack {
            Text("Suggested Altitude")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()

            VStack(alignment: .leading, spacing: 16) {
                TextField("Enter the departure airport", text: $airport1)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.blue, lineWidth: 1))
                    .disableAutocorrection(true)

                TextField("Enter the destination airport", text: $airport2)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.blue, lineWidth: 1))
                    .disableAutocorrection(true)

                HStack(spacing: 20) {
                    Button(action: {
                        getSuggestedAltitude()
                        findAirport1(apt1: airport1)
                        findAirport2(apt2: airport2)
                    }) {
                        Text("Find Best Altitude")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        toggleAction()
                    }) {
                        Text("\(vfrORifrString)")
                            .padding()
                            .foregroundColor(.white)
                            .background(vfrORifr ? Color.green : Color.red)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))

            List {
                Section(header: Text("Result").font(.headline)) {
                    Text("Departing: \(departing)")
                        .padding()
                    Text("Arriving: \(arriving)")
                        .padding()
                    Text("Highest Terrain:\n\t\(maximumElevation) ft")
                        .padding()
                    Text("Suggested Minimum Altitude:\n\t\(suggestAltitude) ft")
                        .padding()
                    Text("Distance Between Airports:\n\t\(distanceBetween) NM")
                        .padding()
                    Text("Bearing:\n\t\(bearingBetween)°")
                        .padding()
                }
            }
            .listStyle(GroupedListStyle())
        }
        .padding()
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
    
    // Function to grab API string of airport1
    private func findAirport1(apt1: String) {
        airport1String = fetchAirportString(airport: apt1)
        departing = parseAirportName(jsonString: airport1String)
        arriving = parseAirportName(jsonString: airport2String)
    }
    // Function to grab API string of airport2
    private func findAirport2(apt2: String) {
        airport2String = fetchAirportString(airport: apt2)
    }
    // Function to return suggested altitude
    private func getSuggestedAltitude() {
        suggestAltitude = 1000
    }
    // Toggle between VFR and IFR
    private func toggleAction() {
        vfrORifr.toggle()
        if (vfrORifr) {
            vfrORifrString = "VFR"
        } else {
            vfrORifrString = "IFR"
        }
    }
}

#Preview {
    SuggestedAltitudeView()
}
