//
//  TafView.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 11/6/23.
//

import SwiftUI

class TAFViewModel: ObservableObject {
	@Published var airportCode = ""
	@Published var latestForecast: TAFResponse?
	@Published var isFetching = false

	func getTAF() {
		isFetching = true

		let apiKey = "dVu8sPyDDM7K7MfkH2582AddlqTI4vnS"
		let apiUrl = "https://aeroapi.flightaware.com/aeroapi/"

		let authHeader = ["x-apikey": apiKey]

		// Returns the weather forecast for an airport in the form of a decoded TAF (Terminal Area Forecast). Only a single result is returned.
		let urlString = apiUrl + "airports/\(airportCode)/weather/forecast"
		let url = URL(string: urlString)!

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = authHeader

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			DispatchQueue.main.async {
				self.isFetching = false
			}
			
			// Print the raw JSON string for debugging
			let rawJSONString = String(data: data!, encoding: .utf8)
			print("Received JSON: \(rawJSONString ?? "Invalid JSON")")


			if let error = error {
				print("Error: \(error)")
				return
			}

			guard let data = data else {
				print("No data received")
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let response = try decoder.decode(TAFResponse.self, from: data)
				DispatchQueue.main.async {
					self.latestForecast = response
				}
			} catch {
				print("Error decoding JSON: \(error)")
			}
		}
		task.resume()
	}
}

struct TafView: View {
	@ObservedObject var viewModel = TAFViewModel()
	
	var body: some View {
			VStack(spacing: 20) {
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
					viewModel.getTAF()
				}) {
					Image(systemName: "location.magnifyingglass").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
				}.frame(width: 80, height: 45)
					.background(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x3473B7, alpha:0.9), Color(hex: 0xDCE9E6, alpha: 0.4)]), startPoint: .bottom,endPoint: .top))
					.foregroundColor(.white)
					.cornerRadius(8)
					.overlay(RoundedRectangle(cornerRadius: 8)
						.stroke(LinearGradient(gradient: Gradient(colors: [Color(hex: 0xDCE9E6, alpha:1), Color(hex: 0x563, alpha: 1)]), startPoint: .top,endPoint: .bottom), lineWidth: 3)) // You can adjust lineWidth for border thickness
				.padding(.bottom, 18) // Reduce the top padding for the button
				
					// DISPLAY
					if viewModel.isFetching {
						ProgressView("Fetching TAF...")
						.padding()
					} else {
						ScrollView {
							if let latestForecast = viewModel.latestForecast {
								TAFDetailView(taf: latestForecast)
							}
						}
					}
				}
			.navigationTitle("Terminal Aerodrome Forecast")
			.navigationBarTitleDisplayMode(.inline)
			.padding(.top, 15) // Reduce the top padding for the entire VStack
			.background(Image("metar-background-img")
				.resizable()
				.ignoresSafeArea())
		
	}
}

struct TAFDetailView: View {
	let taf: TAFResponse

	var body: some View {

		LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading) {
			Text("ICAO Code:").bold()
			Text(taf.airport_code)
			
			Text("Time:").bold()
			Text(formatDate(from: taf.time))
			
			// Display Decoded Forecast
			let decodedForecast = taf.decoded_forecast
			Text("Forecast Start:").bold()
			Text(formatDate(from: decodedForecast.start))
			
			Text("Forecast End:").bold()
			Text(formatDate(from: decodedForecast.end))
			
			Spacer(minLength: 30)
			Spacer(minLength: 30)

			ForEach(decodedForecast.lines, id: \.start) { line in
				Text("Line Type:").bold()
				Text(line.type)
				
				Text("Line Start:").bold()
				Text(formatDate(from: line.start))
				// For Simple Optional Strings: You can use ?? "N/A" as you've done for String? types.
				Text("Line End:").bold()
				Text(line.end ?? "N/A")
				
				Text("Turbulence Layers:").bold()
				Text(line.turbulence_layers ?? "N/A")
				
				Text("Icing Layers:").bold()
				Text(line.icing_layers ?? "N/A")
				
				// int value
				if let barometric_pressure = line.barometric_pressure {
					Text("Barometric Pressure:").bold()
					Text("\(barometric_pressure)")
				} else {
					Text("Barometric Pressure:").bold()
					Text("N/A")
				}
				//Text("Barometric Pressure:").bold()
				//Text(line.barometric_pressure ?? "N/A")
				Text("Significant Weather:").bold()
				Text(line.significant_weather ?? "N/A")
				
				// For Complex Types (like Wind, WindShear, etc.): You need to check if the value exists with if let and then access its properties.
				if let winds = line.winds {
					Text("Wind Data:").bold()
					Text("")
					
					// str value
					Text("   Symbol:").bold()
					Text(winds.symbol ?? "N/A")
					
					// str value
					Text("   Wind Direction:").bold()
					Text(winds.direction ?? "N/A")
					
					// int value
					if let speed = winds.speed {
						Text("   Wind Speed").bold()
						Text("\(speed)")
					} else {
						Text("   Peak Gusts:").bold()
						Text("N/A")
					}
					
					// str value
					Text("   Wind Units:").bold()
					Text(winds.units ?? "N/A")
					
					// int value
					if let peakGusts = winds.peak_gusts {
						Text("   Peak Gusts:").bold()
						Text("\(peakGusts)")
					} else {
						Text("   Peak Gusts:").bold()
						Text("N/A")
					}
				} else {
					Text("Wind Data:").bold()
					Text("N/A")
				}
				// Windshear
				if let windshear = line.windshear {
					Text("WindShear Data:").bold()
					Text("")
					
					Text("   Symbol:").bold()
					Text(windshear.symbol ?? "N/A")
					
				    Text("   Height:").bold()
				    Text(windshear.height ?? "N/A")
						
					Text("   Direction:").bold()
					Text(windshear.direction ?? "N/A")
					
					Text("   Speed:").bold()
					Text(windshear.speed ?? "N/A")
						 
					Text("   Units:").bold()
					Text(windshear.units ?? "N/A")
					
				} else {
					Text("WindShear Data:").bold()
					Text("N/A")
				}
				// Visibility
				if let visibility = line.visibility {
					Text("Visibility Data:").bold()
					Text("")
					
					Text("   Symbol:").bold()
					Text(visibility.symbol ?? "N/A")
					
					Text("   Visibility:").bold()
					Text(visibility.visibility ?? "N/A")
					
					Text("   Units:").bold()
					Text(visibility.units ?? "N/A")
				} else {
					Text("visibility Data:").bold()
					Text("N/A")
				}
				/*	Handling Clouds
				 Handling Optional Collections: When you have an optional collection like clouds, which is an array, you need to handle it differently. You can't directly check if let clouds = line.clouds because clouds is an array. Instead, you should loop through the array if it's not nil.
				 */
				// Check if the clouds array is not empty
				if !line.clouds.isEmpty {
					Text("Cloud Data:").bold()
					Text("")

					ForEach(line.clouds, id: \.symbol) { cloud in
						Group {
							Text("   Symbol:").bold()
							Text(cloud.symbol ?? "N/A")

							Text("   Coverage:").bold()
							Text(cloud.coverage ?? "N/A")

							Text("   Altitude:").bold()
							Text(cloud.altitude ?? "N/A")

							Text("   Special:").bold()
							Text(cloud.special ?? "N/A")
						}
					}
				} else {
					Text("Cloud Data:").bold()
					Text("N/A")
				}
				Spacer(minLength: 40) // Space after ForEach
				Spacer(minLength: 40)
			} // Outside line forecast for loop
			Text("Raw TAF Forecast:").bold()
			VStack(alignment: .leading) {
				ForEach(taf.raw_forecast, id: \.self) { forecast in
					Text(forecast)
				}
			}
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

// Define a structure for TAF data
struct TAFResponse: Decodable {
	let airport_code: String
	let raw_forecast: [String]
	let time: String
	let decoded_forecast: DecodedForecast
}

struct DecodedForecast: Decodable {
	let start: String
	let end: String
	let lines: [ForecastLine]
}

struct ForecastLine: Decodable {
	let type: String
	let start: String
	let end: String?
	let turbulence_layers: String?
	let icing_layers: String?
	let barometric_pressure: Int?
	let significant_weather: String?
	let winds: Wind?
	let windshear: WindShear?
	let visibility: Visibility?
	let clouds: [Clouds]
}

struct Wind: Decodable {
	let symbol: String?
	let direction: String?
	let speed: Int?
	let units: String?
	let peak_gusts: Int?
}

struct WindShear: Decodable {
	let symbol: String?
	let height: String?
	let direction: String?
	let speed: String?
	let units: String?
}

struct Visibility: Decodable {
	let symbol: String?
	let visibility: String?
	let units: String?
}

struct Clouds: Decodable {
	let symbol: String?
	let coverage: String?
	let altitude: String?
	let special: String?
}

struct TAFView_Previews: PreviewProvider {
	static var previews: some View {
		TafView(viewModel: TAFViewModel())
	}
}
