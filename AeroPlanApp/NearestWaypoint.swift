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
	@StateObject var locationManager = LocationManager()
	let directionLabels: [String] = []
	
	var body: some View {
		VStack{
			TextField("Enter Airport ICAO Code", text: $searchText)
				.cornerRadius(0) // Optional: if you want rounded corners
				.foregroundColor(.blue) // Set the text color to white
				.overlay(RoundedRectangle(cornerRadius: 0)
					.stroke(LinearGradient(gradient: Gradient(colors: [Color(hex: 0xDC89E6, alpha:0.9), Color(hex: 0x3473B7, alpha: 1)]), startPoint: .bottom,endPoint: .top), lineWidth: 3)) // You can adjust lineWidth for border thickness
				.padding(.horizontal, 100)
				.textFieldStyle(RoundedBorderTextFieldStyle())
			CompassView()
			ZStack{
				Map(position: $cameraPosition){
					Annotation("Flight", coordinate: .userLocation) {
						ZStack {
							Circle()
								.frame(width: 60, height: 35)
								.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:0.9), Color(hex: 0x3473B7, alpha: 0.4)]), startPoint: .bottom,endPoint: .top))
							Circle()
								.frame(width: 70, height: 25)
								.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x3473B7, alpha:0.9), Color(hex: 0xDC89E6, alpha: 0.4)]), startPoint: .bottom,endPoint: .top))
							Circle()
								.frame(width: 100, height: 15)
								.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:2), Color(hex: 0x3473B7, alpha: 0.4)]), startPoint: .bottom,endPoint: .top))
						}
					}
				}
				// Gradient overlay
				LinearGradient(
					gradient: Gradient(colors: [Color(hex: 0x0C0B2D, alpha: 0.1), Color(hex: 0x000000, alpha: 0)]), startPoint: .bottom, endPoint: .center // Gradient ends at the center
				)
				.edgesIgnoringSafeArea(.all)
	
				// Map Overlay
				//TransparentWindowView()
					
			}
			// Map Outline
			.frame(width: 350, height: 600)
			.cornerRadius(30)
			.overlay(RoundedRectangle(cornerRadius: 30)
				.stroke(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:2), Color(hex: 0x050622, alpha: 1)]), startPoint: .top, endPoint: .bottom), lineWidth: 3)) // You can adjust lineWidth for border thickness
			.padding([.top, .horizontal], 20)
			.padding(3.14) // Optional: if you want rounded corners
			// Search TextField
			
			
			.mapControls {
				MapCompass()
					.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:0.9), Color(hex: 0x3473B7, alpha: 0.4)]), startPoint: .bottom,endPoint: .top))
				
				MapPitchToggle()
					.foregroundStyle(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xDC89E6, alpha:0.9), Color(hex: 0x3473B7, alpha: 0.4)]), startPoint: .bottom,endPoint: .top))
				MapUserLocationButton()
			}
		}
		.navigationTitle("Nearest Waypoint")
		.navigationBarTitleDisplayMode(.inline)
		.padding(.top, 15) // Reduce the top padding for the entire VStack
		.background(Image("nw-background-img")
			.resizable()
			.ignoresSafeArea())
	}
}
// Transparent Gradient on top of MAP
struct TransparentWindowView: View {
	var body: some View {
		VStack {
			Text("")
				.frame(width: 350, height: 600)
				.background(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x0C0B2D, alpha:1.5), Color.clear]), startPoint: .bottom, endPoint: .center))
				.cornerRadius(30)
				.edgesIgnoringSafeArea(.all)
		}
		.padding()
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
		latitudinalMeters: 25000,
		longitudinalMeters: 25000)
	}
}
/*
// COMPASS
struct CompassLayout: Layout{
	let offset: Double
	
	init(offset: Double = 0) {
		self.offset = offset
	}
	
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		// Return the largest possible square or 100x100
		let m = min(proposal.width ?? 100, proposal.height ?? 100)
		return .init(width: m, height: m)
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		// Calculate the spacing between the views
		let difference: Double = 360.0/Double(subviews.count)
		// Make an array with all the angles
		let angles: [Angle] = stride(from: offset, through: 360 + offset, by: difference)
			.map { d in
				//Correct for clockwise fill starting at North
				let correctedAngle: Double = (180.0 - d) + 180.0
				
				return Angle(degrees: correctedAngle)
			}
		// Get the Center Point
		let center = CGPoint(x: bounds.midX, y: bounds.midY)
		
		// Calculate radius
		let radius = (proposal.width ?? 100)/2
		
		// One angle for each subview
		for (subview, angle)in zip (subviews, angles) {
			// Get the point in the circle from the origin.
			let points:CGPoint = angel.getPoint(radius: -radius, origin: center)
			// Place the subview
			subview.place(at: point, anchor: .center, proposal: .infinity)
		}
	}
}

extension Angle{
	func getPoint(radius: Double, origin: CGPoint = .zero) -> CGPoint{
		let x = origin.x + radius * sin(self.radians)
		let y = origin.y + radius * cos(self.radians)
		
		return .init(x: x, y: y)
	}
}

struct CompassView: View {
	let directionLabels: [String] = ["N", "NE","E","SE","S","SW","W","NW",]
	// Creates an array of angels from 0 - 360 spaced by 10 degrees.
	var degreeLabelAngles: [Angle]{
		return stride(from: 0, to: 360, by: 10).map { i
			in
			Angle(degrees: Double(i))
		}
	}
	
	var body: some View{
		ZStack{
			CompassLayout{
				ForEach(directionLabels, id:\.description) { label in
					Text(label)
				}
			}.padding(24)
			CompassLayout{
				ForEach(degreeLabelAngles, id:\.degrees) { angle in
					Text(angle.degrees, format: .number)
						.rotationEffect(angle)
						.font(.caption)
				}
			}
		}.padding()
	}
}*/

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
