//
//  LostViewModel.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 10/27/23.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    
    @Published var region = MKCoordinateRegion()
    @Published var autoCentering: Bool = false
    @Published var atcSearchResults: [ATCAnnotation] = []
    @State private var didSetInitialRegion = false
    let locationManager = CLLocationManager()
    
    
    
    // Function to save user's location in UserDefaults
        func saveLocationToUserDefaults(coordinate: CLLocationCoordinate2D) {
            UserDefaults.standard.set(coordinate.latitude, forKey: "userLatitude")
            UserDefaults.standard.set(coordinate.longitude, forKey: "userLongitude")
        }
        
        // Function to fetch user's location from UserDefaults
        func getLocationFromUserDefaults() -> CLLocationCoordinate2D? {
            let latitude = UserDefaults.standard.double(forKey: "userLatitude")
            let longitude = UserDefaults.standard.double(forKey: "userLongitude")
            
            if latitude != 0 && longitude != 0 {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            } else {
                return nil
            }
        }

    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        locationManager.distanceFilter = 200
        // If we have a location saved, use that as the initial location
                if let savedLocation = getLocationFromUserDefaults() {
                    region = MKCoordinateRegion(center: savedLocation, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    searchATCs() // Call searchATCs based on the saved location
                }
    }
    
    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func searchATCs() {
        
        var searchRegion: MKCoordinateRegion
        
        guard let currentLocation = locationManager.location?.coordinate else {
            return
        }
        searchRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        let queries = ["Air Traffic Control", "Airport"]
        let searchRequest = MKLocalSearch.Request()

        for query in queries {
            searchRequest.naturalLanguageQuery = query
            searchRequest.region = searchRegion
            
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                if let error = error {
                    print("Error searching for \(query): \(error)")
                    return
                }

                let newResults: [ATCAnnotation] = response?.mapItems.compactMap { item in
                    if let name = item.name, let coordinate = item.placemark.location?.coordinate {
                        return ATCAnnotation(name: name, coordinate: coordinate,phoneNumber: item.phoneNumber)
                    }
                    return nil
                } ?? []
                
                DispatchQueue.main.async {
                    self.atcSearchResults.append(contentsOf: newResults)
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        if let lastLocation = locations.last {
                    region = MKCoordinateRegion(center: lastLocation.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    saveLocationToUserDefaults(coordinate: lastLocation.coordinate) // Save the new location
                }
//        locations.last.map {
//            region = MKCoordinateRegion(
//                            center: $0.coordinate,
//                            span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
//                        )
//        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)")
    }

    
}
