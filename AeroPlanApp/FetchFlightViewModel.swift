//
//  FetchFlight.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 11/17/23.
//

import Foundation
import SwiftUI
import Combine
import MapKit


class FetchFlightViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var mapRegion: MKCoordinateRegion
    @Published var flightPosition = FlightPosition(latitude: 0, longitude: 0)
    @Published var searchText = ""
    @Published var startDate = Date()
    @Published var endDate = Date()

    private var cancellables: Set<AnyCancellable> = []
    private var positionUpdateTimer: Timer?

    
    private var lastFetchedPosition: (latitude: Double, longitude: Double)?
    private var samePositionCount = 0
    private let maxSamePositionCount = 5

    
    @Published var fa_id: String?
    @State private var currentTime = Date()
    
    init() {
            isLoading = false
            let initialLocation = CLLocationCoordinate2D(latitude: 33.8161, longitude: -118.1513)
            self.mapRegion = MKCoordinateRegion(
                center: initialLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            flightPosition = FlightPosition(latitude: initialLocation.latitude, longitude: initialLocation.longitude)
            setupSubscriptions()
    }
    
    private func setupSubscriptions() {
            $searchText
                .debounce(for: .seconds(1), scheduler: RunLoop.main)
                .sink { [weak self] _ in self?.fetchFlightData() }
                .store(in: &cancellables)
        }
    
    deinit {
        cancellables.removeAll()
    }
    
    func viewAppeared() {
        startPositionUpdates()
        }

    func viewDisappeared() {
        stopPositionUpdates()
    }
    
    func updateMapRegion(latitude: Double, longitude: Double) {
           let newRegion = MKCoordinateRegion(
               center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
               span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
           )
           DispatchQueue.main.async {
               self.mapRegion = newRegion
               self.flightPosition.updatePosition(latitude: latitude, longitude: longitude)
           }
       }
    
    
    func fetchFlightData() {
        
        guard !searchText.isEmpty else { return }
        
        let apiKey = "dVu8sPyDDM7K7MfkH2582AddlqTI4vnS"
        let apiUrl = "https://aeroapi.flightaware.com/aeroapi/"

        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]

        let formattedStartDate = dateFormatter.string(from: startDate)
        let formattedEndDate = dateFormatter.string(from: endDate)

        let urlString = apiUrl + "flights/\(searchText)" + "?start=\(formattedStartDate)&end=\(formattedEndDate)"
        
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-apikey")


        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
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
                       let flights = json["flights"] as? [[String: Any]] {
                        for flight in flights {
                            if let faFlightId = flight["fa_flight_id"] as? String {
                                self?.fa_id = faFlightId
                                print(faFlightId)
                                
                                self?.fetchFlightPosition()
                                self?.startPositionUpdates()
                                
                            }
                        }
                    } else {
                        print("Failed to parse JSON")
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }

        task.resume()
    }
    
    func fetchFlightPosition() {
        guard let faFlightId = self.fa_id else {
            print("FA Flight ID not available")
            return
        }

        print("Fetching position for FA Flight ID: \(faFlightId)")

        let apiKey = "dVu8sPyDDM7K7MfkH2582AddlqTI4vnS"
        let apiUrl = "https://aeroapi.flightaware.com/aeroapi/"
        let flightPositionEndpoint = "flights/\(faFlightId)/track"
        
//        let flightPositionEndpoint = "flights/AAL27-1700674656-airline-51p/track"

        guard let url = URL(string: apiUrl + flightPositionEndpoint) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-apikey")

        isLoading = true

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
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
                       let positions = json["positions"] as? [[String: Any]],
                       let lastPosition = positions.last,
                       let latitude = lastPosition["latitude"] as? Double,
                       let longitude = lastPosition["longitude"] as? Double {
                                
                        
                        self?.flightPosition.updatePosition(latitude: latitude, longitude: longitude)
                        if let lastFetched = self?.lastFetchedPosition, lastFetched.latitude == latitude && lastFetched.longitude == longitude {
                            self?.samePositionCount += 1

                            // Use optional coalescing to provide a default value (0) if samePositionCount is nil
                            let count = self?.samePositionCount ?? 0
                            let maxCount = self?.maxSamePositionCount ?? 10

                            if count >= maxCount {
                                self?.stopPositionUpdates()
                            }
                        } else {
                            self?.samePositionCount = 0
                            self?.lastFetchedPosition = (latitude, longitude)
                        }
                        DispatchQueue.main.async {
                                        self?.updateMapRegion(latitude: latitude, longitude: longitude)
                        }

        
                        print("Latest Latitude: \(latitude), Latest Longitude: \(longitude)")
                    } else {
                        print("Failed to parse positions from JSON")
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }

        task.resume()
    }
    
    func updateFlightPosition(latitude: Double, longitude: Double) {
            flightPosition.updatePosition(latitude: latitude, longitude: longitude)
            
            // Update mapRegion to center on the new position
            let newRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
            
            DispatchQueue.main.async {
                self.mapRegion = newRegion
            }
        }
    
    func startPositionUpdates() {
            positionUpdateTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
                self?.fetchFlightPosition()
            }
        }

    func stopPositionUpdates() {
        positionUpdateTimer?.invalidate()
        positionUpdateTimer = nil
    }


    
    func fetchWeatherData(){
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
                    print("Error: (error)")
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
                    print("Error parsing JSON: (error)")
                }
            }
            
            task.resume()
        }
        
    }
    


