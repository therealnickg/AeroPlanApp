    import SwiftUI
    import MapKit
    import CoreLocation


struct LostComView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    
    var body: some View{
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: locationManager.atcSearchResults)
            { result in
                MapMarker(coordinate: result.coordinate)
            }
            .onAppear{
                locationManager.requestLocationAccess()
                locationManager.searchATCs()
                
            }
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    
                    Button(action: {
                        self.userTrackingMode = .follow
                    }) {
                        Image(systemName: "location.fill")
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
                
                // The overlay view
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.9))
                    .overlay(
                        VStack {
                            Text("Nearby ATC")
                                .font(.headline)
                                .padding()
                            
                            // Display the top 10 results
                            ScrollView {
                                VStack(spacing: 10) {  // Add spacing between elements
                                    ForEach(locationManager.atcSearchResults.prefix(10)) { atc in
                                        if let phoneNumber = atc.phoneNumber {
                                            Button(action: {
                                                if let url = URL(string: "tel:\(phoneNumber)") {
                                                    UIApplication.shared.open(url)
                                                }
                                            })
                                            {
                                                Text("\(atc.name): \(phoneNumber)")
                                                    .padding(.horizontal)  // Padding on each side
                                                    .frame(maxWidth: .infinity, alignment: .leading)  // Ensure each Text takes up full width with left alignment
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    )
                    .frame(height: UIScreen.main.bounds.height / 3)
                
            }
        }
    }
    
}
