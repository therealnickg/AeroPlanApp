//
//  CompassViewModel.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 11/20/23.
//

import SwiftUI
import CoreLocation

class CompassViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var heading: Double = 0
	private var locationManager: CLLocationManager?

	override init() {
		super.init()
		self.locationManager = CLLocationManager()
		self.locationManager?.delegate = self
		self.locationManager?.startUpdatingHeading()
	}

	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		DispatchQueue.main.async {
			self.heading = newHeading.trueHeading // trueHeading for geographic North
		}
	}
}

