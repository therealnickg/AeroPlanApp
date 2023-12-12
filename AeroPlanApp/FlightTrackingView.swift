import SwiftUI
import MapKit
import CoreLocation
import Combine

class LocationManager2: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager2 = CLLocationManager()

    @Published var userLocation: CLLocationCoordinate2D?
    
    // Ensure that you declare a delegate property
    weak var delegate: CLLocationManagerDelegate?

    override init() {
        super.init()
        setupLocationManager()
    }

    func setupLocationManager() {
        locationManager2.delegate = self
        locationManager2.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationPermission() {
        locationManager2.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        locationManager2.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager2.stopUpdatingLocation()
    }

    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            userLocation = location
        }
    }
}

class FlightTrackingViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locations: [FlightLocation] = []
    @Published var isRecording = false
    @Published var isMapViewVisible = false
    @Published var userTrackingMode: MKUserTrackingMode = .follow
    @Published var region: MKCoordinateRegion?
    @Published var shouldUpdatePolyline = false
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var mapView: MKMapView?
    
    
    // Inject the location manager
    var locationManager2: LocationManager2
    
    init(locationManager2: LocationManager2) {
        self.locationManager2 = locationManager2
        super.init()
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager2.delegate = self
        locationManager2.requestLocationPermission()
        locationManager2.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last?.coordinate {
                userLocation = location

                // Update the region when the user location changes
                if region == nil {
                    region = MKCoordinateRegion(
                        center: location,
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                } else {
                    region?.center = location
                }
            }
        }
    
    // Simplified method to adjust the zoom level
        func adjustMapZoomLevel(factor: Double) {
            guard let mapView = mapView else { return }
            
            let region = mapView.region
            let span = MKCoordinateSpan(
                        latitudeDelta: region.span.latitudeDelta * factor,
                        longitudeDelta: region.span.longitudeDelta * factor
                    )
                    let adjustedRegion = MKCoordinateRegion(center: region.center, span: span)

                    mapView.setRegion(adjustedRegion, animated: true)
        }

    // Additional methods related to FlightTrackingView can be added here
}



struct FlightLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


struct FlightTrackingView: View {
    @StateObject private var viewModel = FlightTrackingViewModel(locationManager2: LocationManager2())

    var body: some View {
        NavigationView {
            ZStack {
                Image("flighttrack")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // main viewable code
                VStack {
                    if !self.viewModel.isMapViewVisible { // Only show in the main menu
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
                    
                    if self.viewModel.isMapViewVisible {
                        MapViewRepresentable(
                            locations: $viewModel.locations,
                            userTrackingMode: $viewModel.userTrackingMode,
                            region: $viewModel.region,
                            shouldUpdatePolyline: $viewModel.shouldUpdatePolyline,
                            mapView: $viewModel.mapView
                        )
                        .edgesIgnoringSafeArea(.all)
                        .navigationBarTitle("Flight Tracking")
                        .navigationBarItems(
                            leading: Button("Back") {
                                self.viewModel.isMapViewVisible = false
                            }
                                .foregroundColor(Color.white)
                                .font(.system(size: 24)),
                            trailing: Button(action: {
                                self.viewModel.userTrackingMode = .follow
                            }) {
                                Image(systemName: "location.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        )
                        .onAppear {
                            // Request location permission
                            self.viewModel.locationManager2.requestLocationPermission()
                            
                            // Set the delegate to receive location updates
                            self.viewModel.locationManager2.delegate = self.viewModel
                            
                            // Start updating location
                            self.viewModel.locationManager2.startUpdatingLocation()
                        }
                        
                        
                        // "Start Flight" button only visible in the View Map screen
                        Button(action: {
                            // Toggle recording state when "Start Flight" is pressed
                            self.viewModel.isRecording.toggle()
                            self.viewModel.shouldUpdatePolyline = self.viewModel.isRecording
                        }) {
                            Text(viewModel.isRecording ? "Finish Flight" : "Start Flight")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(viewModel.isRecording ? Color.red : Color.blue)
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        HStack {
                            // Zoom out button
                            Button(action: {
                                self.viewModel.adjustMapZoomLevel(factor: 1.5)
                            }) {
                                Image(systemName: "minus.circle")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }



                            // Zoom in button
                            Button(action: {
                                self.viewModel.adjustMapZoomLevel(factor: 1.0 / 1.5)
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                            .opacity(self.viewModel.isMapViewVisible ? 1.0 : 0.0)
                        }

                        
                    }else {
                    // Main content without the map
                    Button(action: {
                        self.viewModel.isMapViewVisible = true
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
            }
                
                .onAppear {
                    // Request location permission
                    self.viewModel.locationManager2.requestLocationPermission()
                    
                    //set the delegate to recieve location updates
                    self.viewModel.locationManager2.delegate = self.viewModel
                    
                    // Start updating location
                    self.viewModel.locationManager2.startUpdatingLocation()
                }
            }
        }
    }
            
        

    private func startRecording() {
        viewModel.isRecording = true
        viewModel.shouldUpdatePolyline = true
        viewModel.locations.removeAll()
    }

    private func finishRecording() {
        viewModel.isRecording = false
        viewModel.shouldUpdatePolyline = false
        viewModel.locationManager2.stopUpdatingLocation()
    }

}

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var locations: [FlightLocation]
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var region: MKCoordinateRegion?
    @Binding var shouldUpdatePolyline: Bool
    
    @Binding var mapView: MKMapView?

    let testLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
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
        
        //ensure that the map view reference is updated
        mapView = uiView
        
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
        


struct FlightTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        FlightTrackingView()
    }
}

