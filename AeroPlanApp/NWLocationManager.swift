//
//  LocationManager.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 11/20/23.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var currentLocation: CLLocationCoordinate2D?
	private let locationManager = CLLocationManager()

	override init() {
		super.init()
		self.locationManager.delegate = self
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
		self.locationManager.requestWhenInUseAuthorization()
		self.locationManager.startUpdatingLocation()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		currentLocation = locations.first?.coordinate
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error getting location: \(error)")
	}
}
