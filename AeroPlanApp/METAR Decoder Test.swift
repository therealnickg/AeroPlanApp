//
//  METAR Decoder.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 9/16/23.
//

import SwiftUI
import Foundation


var airportCode = ""

func getMETAR() -> String {
    let apiKey = "dVu8sPyDDM7K7MfkH2582AddlqTI4vnS"
    let apiUrl = "https://aeroapi.flightaware.com/aeroapi/"

    let payload = ["max_pages": 1]
    let authHeader = ["x-apikey": apiKey]

    let urlString = apiUrl + "airports/KLGB/weather/observations"
    let url = URL(string: urlString)!

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = authHeader

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(json)
            } else {
                print("Failed to parse JSON")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }

    task.resume()
    return "hello world"
}

struct METAR_Decoder: View {
    var body: some View {
        Text(getMETAR())
    }
}
/*
struct METAR_Decoder_Previews: PreviewProvider {
    static var previews: some View {
        METAR_Decoder()
    }
}*/
