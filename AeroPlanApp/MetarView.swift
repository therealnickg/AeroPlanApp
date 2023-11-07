//
//  MetarView.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 09/14/23.
//

import SwiftUI

class METARViewModel: ObservableObject {
    @Published var airportCode = ""
    @Published var metarData = ""
    @Published var isFetching = false

    func getMETAR() {
	  isFetching = true

	  let apiKey = "dVu8sPyDDM7K7MfkH2582AddlqTI4vnS"
	  let apiUrl = "https://aeroapi.flightaware.com/aeroapi/"

	  let authHeader = ["x-apikey": apiKey]

	  let urlString = apiUrl + "airports/\(airportCode)/weather/observations"
	  let url = URL(string: urlString)!

	  var request = URLRequest(url: url)
	  request.httpMethod = "GET"
	  request.allHTTPHeaderFields = authHeader

	  let task = URLSession.shared.dataTask(with: request) { data, response, error in
		DispatchQueue.main.async {
		    self.isFetching = false
		}

		if let error = error {
		    print("Error: \(error)")
		    return
		}

		guard let data = data else {
		    print("No data received")
		    return
		}

		do {
		    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
			 let metar = json["raw_data"] as? String {
			  DispatchQueue.main.async {
				self.metarData = metar
			  }
		    } else {
			    print("Failed to parse JSON or extract METAR data")
					print("Received JSON: \(String(data: data, encoding: .utf8) ?? "Unable to convert to string")")
				  }
		} catch {
		    print("Error parsing JSON: \(error)")
		}
	  }

	  task.resume()
    }
}

struct METARView: View {
	@ObservedObject var viewModel = METARViewModel()
	
	var body: some View {
		NavigationView {
			VStack {
				TextField("Enter Airport Code", text: $viewModel.airportCode)
					.padding()
					.textFieldStyle(RoundedBorderTextFieldStyle())
				
				Button(action: {
					viewModel.getMETAR()
				}) {
					Text("Get METAR")
				}
				.padding()
				
				if viewModel.isFetching {
					ProgressView("Fetching METAR...")
						.padding()
				} else {
					if let metarDetails = parseMETARDetails(from: viewModel.metarData) {
						METARDetailsView(metarDetails: metarDetails)
					} else {
						Text("Unable to extract METAR details")
							.padding()
					}
				}
			}
			.padding()
			.navigationTitle("METAR Viewer")
		}
	}
	
	private func parseMETARDetails(from metarData: String) -> METARDetails? {
		let jsonData = Data(metarData.utf8)
		
		do {
			let decoder = JSONDecoder()
			let metarResponse = try decoder.decode(METARResponse.self, from: jsonData)
			
			if let observation = metarResponse.observations.first {
				return METARDetails(
					temperature: observation.temp_air,
					windDirection: observation.wind_direction,
					windSpeed: observation.wind_speed,
					visibility: observation.visibility
				)
			} else {
				print("No observation data found")
			}
		} catch {
			print("Error decoding JSON: \(error)")
		}
		
		return nil
	}
}

struct METARDetailsView: View {
    let metarDetails: METARDetails

    var body: some View {
	  VStack(alignment: .leading) {
		Text("Temperature: \(metarDetails.temperature)°C")
		Text("Wind: \(metarDetails.windDirection)° at \(metarDetails.windSpeed) knots")
		Text("Visibility: \(metarDetails.visibility) miles")
	  }
	  .padding()
    }
}

struct METARDetails {
    let temperature: Int
    let windDirection: Int
    let windSpeed: Int
    let visibility: Int
}

struct METARResponse: Decodable {
    let observations: [Observation]
	
	private enum CodingKeys: String, CodingKey {
			case observations = "weather"
		}
}

struct Observation: Decodable {
	let airport_code: String
	let cloud_friendly: String
	let clouds: [Cloud]
	let conditions: String?
	let pressure: Double
	let pressure_units: String
	let raw_data: String
	let temp_air: Int
	let temp_dewpoint: Int
	let temp_perceived: Int
	let relative_humidity: Int
	let time: String
	let visibility: Int
	let visibility_units: String
	let wind_direction: Int
	let wind_friendly: String
	let wind_speed: Int
	let wind_speed_gust: Int
	let wind_units: String
}

struct Cloud: Decodable {
	let altitude: Int?
	let symbol: String
	let type: String
}
