//
//  FlightTrackingView.swift
//  AeroPlanApp
//
//  Created by Aaron Yu on 10/28/23.
//



import SwiftUI
import MapKit
import CoreLocation

struct FlightLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct Polyline: Shape {
    var points: [CLLocationCoordinate2D]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let first = points.first else {
            return path
        }

        path.move(to: CGPoint(x: first.latitude, y: first.longitude))

        for point in points {
            path.addLine(to: CGPoint(x: point.latitude, y: point.longitude))
        }

        return path
    }
}



final class FlightTrackingView: NSObject, View{
    @State private var locations: [FlightLocation] = []
    @State private var isRecording = false
    @State private var isMapViewVisible = false
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var region: MKCoordinateRegion?
    @State private var shouldUpdatePolyline = false
    @State private var locationManager = CLLocationManager()
    
    let testLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    let testEndLocation = CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3321)
    
    
    
    var body: some View {
        NavigationView {
            
            // background image for the main menu
            ZStack{
                Image("flighttrack")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // main viewable code
                VStack {
                    if !isMapViewVisible { // Only show in the main menu
                        Text("Flight Data Tracker")
                            .font(.system(size: 45))
                            .padding(10)
                            .foregroundColor(Color.black)
                        Text("Flight Data Tracker")
                            .font(.system(size: 45))
                            .offset(y: -79)
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    if isMapViewVisible {
                        MapViewRepresentable(
                            locations: $locations,
                            userTrackingMode: $userTrackingMode,
                            region: $region,
                            shouldUpdatePolyline: $shouldUpdatePolyline
                        )
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarTitle("Flight Tracking")
                        .navigationBarItems(
                            leading: Button("Back") {
                                self.isMapViewVisible = false
                            }
                            .foregroundColor(Color.white)
                            .font(.system(size: 24)),
                            trailing: Button(action: {
                                self.userTrackingMode = .follow
                            }) {
                                Image(systemName: "location.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        )
                        .onAppear {
                            // Request location permission
                            self.locationManager.requestWhenInUseAuthorization()

                            // Set the delegate to receive location updates
                            self.locationManager.delegate = self

                            // Start updating location
                            self.locationManager.startUpdatingLocation()
                        }
                        
                        
                        // "Start Flight" button only visible in the View Map screen
                       Button(action: {
                           // Toggle recording state when "Start Flight" is pressed
                           self.isRecording.toggle()
                           self.shouldUpdatePolyline = self.isRecording
                       }) {
                           Text(isRecording ? "Finish Flight" : "Start Flight")
                               .font(.headline)
                               .foregroundColor(.white)
                               .padding()
                               .background(isRecording ? Color.red : Color.blue)
                               .cornerRadius(10)
                       }
                       .padding()
                        
                        //this is zoom button
                        HStack {
                            // Zoom out button
                            Button(action: {
                                // Adjust the span to zoom out
                                self.region?.span.latitudeDelta *= 1.5
                                self.region?.span.longitudeDelta *= 1.5
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }

                            // Zoom in button
                            Button(action: {
                                // Adjust the span to zoom in
                                self.region?.span.latitudeDelta /= 1.5
                                self.region?.span.longitudeDelta /= 1.5
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            .offset(y: 50) // Adjust the offset as needed
                            .opacity(isMapViewVisible ? 1.0 : 0.0)
                        }
                        .padding()
                        .offset(y: 0) // Adjust the offset as needed
                        .opacity(isMapViewVisible ? 1.0 : 0.0)
                        
                    } else {
                        // Main content without the map
                        Button(action: {
                            self.isMapViewVisible = true
                        }) {
                            HStack {
                                Image(systemName: "map") // Replace with the name of your icon
                                    .font(.title)
                                    .foregroundColor(.white)
                                
                                Text("View Map")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 170, height: 20)
                            .padding()
                            .background(
                                Rectangle()
                                    .fill(Color.blue)
                            )
                            .cornerRadius(10)
                        }
                        .contentShape(Rectangle())
                        .navigationBarTitle("")
                    }
                    
                    
                    Button(action: {
                        if self.isRecording {
                            // Finish recording
                            self.isRecording.toggle()
                            self.shouldUpdatePolyline = false
                        } else {
                            // Start recording
                            self.isRecording.toggle()
                            self.shouldUpdatePolyline = true
                        }
                    }) {
                        Text(isRecording ? "Finish Flight" : "Start Flight")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(isRecording ? Color.red : Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
    }
    
    private func startRecording() {
        self.isRecording = true
        self.shouldUpdatePolyline = true
        self.locations.removeAll()
    }

    private func finishRecording() {
        self.isRecording = false
        self.shouldUpdatePolyline = false
        self.locationManager.stopUpdatingLocation()
    }

}



struct MapViewRepresentable: UIViewRepresentable {
    @Binding var locations: [FlightLocation]
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var region: MKCoordinateRegion?
    @Binding var shouldUpdatePolyline: Bool

    let testLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Set the initial region with the test location
        let initialRegion = MKCoordinateRegion(
            center: testLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        mapView.setRegion(initialRegion, animated: false)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true
        uiView.setUserTrackingMode(userTrackingMode, animated: true)

        uiView.removeAnnotations(uiView.annotations)

        uiView.addAnnotations(locations.map { location in
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            return annotation
        })

        if shouldUpdatePolyline {
            let testAnnotation = MKPointAnnotation()
            testAnnotation.coordinate = testLocation
            uiView.addAnnotation(testAnnotation)

            let coordinates = locations.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            uiView.addOverlay(polyline)
        }

        if let unwrappedRegion = region {
            uiView.setRegion(unwrappedRegion, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }

        // Implement any delegate methods if needed
    }
}

extension FlightTrackingView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Update the location during recording
        guard isRecording, let location = locations.last?.coordinate else { return }
        self.locations.append(FlightLocation(coordinate: location))
    }
}


struct FlightTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        FlightTrackingView()
    }
}


//import UIKit
//import CoreLocation
//import MapKit
//
//class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var startStopButton: UIButton!
//
//    let locationManager = CLLocationManager()
//    var polyline: MKPolyline?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        requestLocationAuthorization()
//        mapView.delegate = self
//    }
//
//    // MARK: - Location Management
//
//    func requestLocationAuthorization() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//    }
//
//    @IBAction func startStopButtonTapped(_ sender: UIButton) {
//        if locationManager.isUpdatingLocation {
//            locationManager.stopUpdatingLocation()
//        } else {
//            polyline = nil  // Reset polyline when starting a new track
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        updateMapView(with: location.coordinate)
//    }
//
//    func updateMapView(with coordinate: CLLocationCoordinate2D) {
//        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//        mapView.setRegion(region, animated: true)
//
//        var coordinates = polyline?.coordinate ??
//            [CLLocationCoordinate2D(latitude: 0, longitude: 0)]
//        coordinates.append(coordinate)
//        polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
//
//        mapView.removeOverlays(mapView.overlays)
//        mapView.addOverlay(polyline!)
//    }
//
//    // MARK: - Map View Delegate
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if overlay is MKPolyline {
//            let renderer = MKPolylineRenderer(overlay: overlay)
//            renderer.strokeColor = UIColor.blue
//            renderer.lineWidth = 3
//            return renderer
//        }
//        return MKOverlayRenderer()
//    }
//}
