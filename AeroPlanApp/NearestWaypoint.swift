//
//  NearestWaypoint.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 11/19/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct NearestWaypoint: View {
	@State private var cameraPosition: MapCameraPosition = .region(.userRegion)
	@State private var searchText = ""
	@State private var results = [MKMapItem]()
	
	@StateObject var locationManager = LocationManager()
	let directionLabels: [String] = []
	
	var body: some View {
		Map(position: $cameraPosition){
			Annotation("Flight", coordinate: .userLocation) {
				// user icon
				ZStack {
					Circle()
						.frame(width: 60, height: 30)
						.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:1), Color(hex: 0x3473B7, alpha: 1)]), startPoint: .bottom,endPoint: .top))
					Circle()
						.frame(width: 70, height: 20)
						.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x3473B7, alpha:1), Color(hex: 0xDC89E6, alpha: 1)]), startPoint: .bottom,endPoint: .top))
					Circle()
						.frame(width: 80, height: 10)
						.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:1), Color(hex: 0x3473B7, alpha: 1)]), startPoint: .bottom,endPoint: .top))
				}
			}
			
			ForEach(results, id: \.self) { item in
				let placemark = item.placemark
				Marker(placemark.name ?? "", coordinate: placemark.coordinate)
			}
		}
		.overlay(alignment:. top) {
			TextField("Enter Airport ICAO Code", text: $searchText)
				.cornerRadius(0) // Optional: if you want rounded corners
				.foregroundColor(.blue) // Set the text color to white
				.padding(.horizontal, 80)
				.textFieldStyle(RoundedBorderTextFieldStyle())
		}
		// executes on search
		.onSubmit {
			Task { await searchPlaces() }
		}
		.mapControls {
			// while zooming compass
			MapCompass()
			// pinch view
			MapPitchToggle()
			MapUserLocationButton()
		}
		.navigationTitle("Nearest Waypoint")
		.foregroundColor(.black)
		.navigationBarTitleDisplayMode(.inline)
		.padding(.top, 15) // Reduce the top padding for the entire VStack
	}
}

extension NearestWaypoint {
	func searchPlaces() async {
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = searchText
		request.region = .userRegion
		
		let results = try? await MKLocalSearch(request: request).start()
		self.results = results?.mapItems ?? []
	}
}

extension CLLocationCoordinate2D {
	static var userLocation: CLLocationCoordinate2D {
		//Creates a location coordinate object.
		return .init(latitude: 34.07719, longitude: -117.727665)
	}
}

extension MKCoordinateRegion{
	static var userRegion: MKCoordinateRegion{
		return .init(center: .userLocation,
		latitudinalMeters: 35000,
		longitudinalMeters: 35000)
	}
}


//Arrow Compass
struct CompassView: View {
	@StateObject var viewModel = CompassViewModel()

	var body: some View {
		ZStack{
			Circle()
				.stroke(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:5), Color(hex: 0x3473B7, alpha: 5)]), startPoint: .top,endPoint: .bottom), lineWidth: 2) // You can adjust lineWidth for border thickness
				// Fill in Circle
				.fill(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:0.5), Color(hex: 0x3473B7, alpha: 0.5)]), startPoint: .bottom,endPoint: .top))
				.frame(width: 100, height: 100)
			Image(systemName: "arrow.up")
				.resizable()
				.scaledToFit()
				.frame(width: 100, height: 100)
				.rotationEffect(Angle(degrees: viewModel.heading))
				.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:5), Color(hex: 0x3473B7, alpha: 5)]), startPoint: .bottom,endPoint: .top))
		}
	}
}

#Preview {
    NearestWaypoint()
}
