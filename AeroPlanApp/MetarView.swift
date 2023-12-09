//
//  MetarView.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 09/14/23.
//
// let apiKey = "dVu8sPyDDM7K7MfkH2582AddlqTI4vnS"
// let apiUrl = "https://aeroapi.flightaware.com/aeroapi/"

import SwiftUI

class METARViewModel: ObservableObject {
    @Published var airportCode = ""
    @Published var metarData = ""
    @Published var isFetching = false
	@Published var latestObservation: Observation?

    func getMETAR() {
		isFetching = true

		let apiKey = "dVu8sPyDDM7K7MfkH2582AddlqTI4vnS"
		let apiUrl = "https://aeroapi.flightaware.com/aeroapi/"

		let authHeader = ["x-apikey": apiKey]

		// Returns weather for an airport in the form of a decoded METAR, starting from the latest report and working backwards in time as more data is requested. Data is provided in parsed, human-readable, and raw formats.
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
		  
			// Print the raw JSON string for debugging
			let rawJSONString = String(data: data, encoding: .utf8)
			print("Received JSON: \(rawJSONString ?? "Invalid JSON")")

			do {
				let decoder = JSONDecoder()
				let metarResponse = try decoder.decode(METARResponse.self, from: data)
				if let latestObservation = metarResponse.observations.first {
					DispatchQueue.main.async {
						self.latestObservation = latestObservation
					}
				} else {
					print("No observation data found")
				}
			} catch {
				print("Error decoding JSON: \(error)")
			}
		}
		task.resume()
	}
}

struct METARView: View {
	@ObservedObject var viewModel = METARViewModel()
	
	var body: some View {
		NavigationView {
			VStack(spacing: 0) {
				// TextField
				TextField("Enter Airport ICAO Code", text: $viewModel.airportCode)
					.cornerRadius(20) // Optional: if you want rounded corners
					.foregroundColor(.blue) // Set the text color to white
					.overlay(RoundedRectangle(cornerRadius: 30)
						.stroke(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x3473B7, alpha: 0.44), Color(hex: 0x563, alpha: 0.8)]), startPoint: .bottom, endPoint: .top), lineWidth: 3)) // You can adjust lineWidth for border thickness
					.padding(.horizontal, 70)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding(.bottom, 18)
				// Search Button
				Button(action: {
					viewModel.getMETAR()
				}) {
					Image(systemName: "location.magnifyingglass").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				}.frame(width: 80, height: 45)
					.background(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x3473B7, alpha:0.9), Color(hex: 0xDCE9E6, alpha: 0.4)]), startPoint: .bottom,endPoint: .top))
					.foregroundColor(.white)
					.cornerRadius(8)
					.overlay(RoundedRectangle(cornerRadius: 8)
						.stroke(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDCE9E6, alpha:1), Color(hex: 0x563, alpha: 1)]), startPoint: .top,endPoint: .bottom), lineWidth: 3)) // You can adjust lineWidth for border thickness
				.padding(.bottom, 18) // Reduce the top padding for the button
				
				if viewModel.isFetching {
					ProgressView("Fetching METAR...")
						.padding()
				} else {
					ScrollView {
						if let observation = viewModel.latestObservation {
							METARDetailView(observation: observation)
						} 
					}
				}
			}
			.navigationTitle("Meterological Aerodrome Report")
			.navigationBarTitleDisplayMode(.inline)
			.padding(.top, 15) // Reduce the top padding for the entire VStack
			.background(Image("metar-background-img")
				.resizable()
				.ignoresSafeArea())
		}
	}
}

struct METARDetailView: View {
	let observation: Observation

	var body: some View {
		let columns = [
			GridItem(.flexible()),
			GridItem(.flexible())
		]

		LazyVGrid(columns: columns, alignment: .leading) {
			Text("ICAO Code:").bold()
			Text(observation.airport_code)
			
			Text("Cloud info:").bold()
			Text("")
			
			Text("   Cloud friendly:").bold()
			Text("\(observation.cloud_friendly)")
			// Add more fields as needed
	
			if let firstCloud = observation.clouds.first {
				if let altitude = firstCloud.altitude {
					Text("   Altitude:").bold()
					Text("\(altitude) feet")
				} else {
					Text("   Altitude:").bold()
					Text("N/A")
				}
				Text("   Symbol:").bold()
				Text(firstCloud.symbol)
				Text("   Type:").bold()
				Text(firstCloud.type)
			}
			
			Text("Pressure:").bold()
			Text("\(String(format: "%.2f", observation.pressure)) \(observation.pressure_units) \(String(format: "%.2f", observation.pressure * 33.86389)) hPa")
			
			Text("Temperature:").bold()
			Text("\(observation.temp_air)°C")
			
			Text("Dewpoint:").bold()
			Text("\(observation.temp_dewpoint)°C")
			
			Text("Temperature Perceived:").bold()
			Text("\(observation.temp_perceived)°C")
			
			Text("Relative Humidity:").bold()
			Text("\(observation.relative_humidity) %")
			
			Text("Visibility:").bold()
			Text("\(observation.visibility) \(observation.visibility_units)")
			
			Text("Wind Direction:").bold()
			Text("\(observation.wind_direction)°")
			
			Text("Wind Speed:").bold()
			Text("\(observation.wind_speed) \(observation.wind_units)")
			
			Text("Wind Gust Speed:").bold()
			Text("\(observation.wind_speed_gust) \(observation.wind_units)")
			
			Text("Time:").bold()
			Text(formatDate(from: observation.time))
			
			Text("Raw METAR Code:").bold()
				.alignmentGuide(.firstTextBaseline) { context in
					context[.top]
				}
			Text(observation.raw_data)
				.fixedSize(horizontal: false, vertical: true)
		}
		.padding([.top, .horizontal], 10)
		.padding(3.14)
		.background(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x5A9AE1, alpha:0.35), Color(hex: 0x135DB0, alpha: 0.6)]), startPoint: .bottom,endPoint: .top)) // Add this line for background
		.cornerRadius(30) // Optional: if you want rounded corners
		.foregroundColor(.white) // Set the text color to white
		.overlay(RoundedRectangle(cornerRadius: 30)
			.stroke(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x3473B7, alpha:1), Color(hex: 0xDCE9E6, alpha: 1)]), startPoint: .top,endPoint: .bottom), lineWidth: 3)) // You can adjust lineWidth for border thickness
		.padding(.horizontal, 20)
	}
		
}

struct METARResponse: Decodable {
    let observations: [Observation]
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

// Time Format
/*
 The "T" in the timestamp "2023-11-07T05:53:00Z" is a delimiter that separates the date and time components in an ISO 8601 formatted string. ISO 8601 is an international standard for date and time representations, and the format is widely used because it is well-defined and unambiguous.
 The "Z" stands for "Zulu time" and indicates that the time is given in UTC (Coordinated Universal Time), without any offset for time zones. "Zulu" is the radio call sign for the letter "Z" used by the military and in aviation and maritime communications.

 */
func formatDate(from isoDate: String) -> String {
	let isoFormatter = ISO8601DateFormatter()
	isoFormatter.formatOptions = [.withInternetDateTime] // Adjusted to remove fractional seconds
		
	if let date = isoFormatter.date(from: isoDate) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss 'UTC'"
		dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Use English abbreviations
		dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
		return dateFormatter.string(from: date)
	} else {
		return "Invalid date"
	}
}

struct METARView_Previews: PreviewProvider {
	static var previews: some View {
		METARView(viewModel: METARViewModel())
	}
}
