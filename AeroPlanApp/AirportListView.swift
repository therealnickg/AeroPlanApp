import SwiftUI

struct AirportListView: View {
    
    let airports: [Airport] = [
        // Los Angeles Area
        Airport(name: "Los Angeles International Airport (LAX)", atcFrequency: "133.9", latitude: 33.9428, longitude: -118.4085),
        Airport(name: "Bob Hope Airport (BUR)", atcFrequency: "118.7", latitude: 34.2006, longitude: -118.3587),
        Airport(name: "Long Beach Airport (LGB)", atcFrequency: "119.4", latitude: 33.8177, longitude: -118.1516),
        Airport(name: "John Wayne Airport (SNA)", atcFrequency: "126.8", latitude: 33.6762, longitude: -117.8675),
        Airport(name: "Ontario International Airport (ONT)", atcFrequency: "120.6", latitude: 34.0560, longitude: -117.6012),
        Airport(name: "Van Nuys Airport (VNY)", atcFrequency: "119.3", latitude: 34.2097, longitude: -118.4890),
        Airport(name: "Santa Monica Municipal Airport (SMO)", atcFrequency: "120.1", latitude: 34.0160, longitude: -118.4513),
        Airport(name: "Hawthorne Municipal Airport (HHR)", atcFrequency: "121.1", latitude: 33.9228, longitude: -118.3351),
        
        // San Diego Area
        Airport(name: "San Diego International Airport (SAN)", atcFrequency: "118.3", latitude: 32.7338, longitude: -117.1933),
        Airport(name: "McClellan-Palomar Airport (CRQ)", atcFrequency: "118.6", latitude: 33.1283, longitude: -117.2800),
        Airport(name: "Brown Field Municipal Airport (SDM)", atcFrequency: "128.25", latitude: 32.5721, longitude: -116.9802),
        Airport(name: "Gillespie Field (SEE)", atcFrequency: "120.7", latitude: 32.8262, longitude: -116.9725),
        
        //Bay Area
        Airport(name: "San Francisco International Airport (SFO)", atcFrequency: "120.5", latitude: 37.6213, longitude: -122.3790),
        Airport(name: "Oakland International Airport (OAK)", atcFrequency: "127.2", latitude: 37.7110, longitude: -122.2120),
        Airport(name: "San Jose International Airport (SJC)", atcFrequency: "124.0", latitude: 37.3626, longitude: -121.9290),
        
        // Central California
        Airport(name: "Fresno Yosemite International Airport (FAT)", atcFrequency: "119.6", latitude: 36.7761, longitude: -119.7181),
        Airport(name: "Monterey Regional Airport (MRY)", atcFrequency: "118.4", latitude: 36.5870, longitude: -121.8429),
        Airport(name: "Santa Maria Public Airport (SMX)", atcFrequency: "124.3", latitude: 34.8989, longitude: -120.4579),
        
        // Northern California
        Airport(name: "Sacramento International Airport (SMF)", atcFrequency: "125.5", latitude: 38.6954, longitude: -121.5908),
        Airport(name: "Redding Municipal Airport (RDD)", atcFrequency: "126.8", latitude: 40.5087, longitude: -122.2934),
        
        // Southern California
        Airport(name: "Palm Springs International Airport (PSP)", atcFrequency: "118.25", latitude: 33.8303, longitude: -116.5070),
        Airport(name: "Santa Barbara Municipal Airport (SBA)", atcFrequency: "125.4", latitude: 34.4262, longitude: -119.8404),
        Airport(name: "Bakersfield Meadows Field Airport (BFL)", atcFrequency: "118.2", latitude: 35.4338, longitude: -119.0568),

    ]


    
    @State private var searchText = ""
    
    var filteredAirports: [Airport] {
        if searchText.isEmpty {
            return airports
        } else {
            return airports.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack {
            SearchBarView(text: $searchText)
                .padding(.bottom, 10)
            
            List(filteredAirports, id: \.name) { airport in
                VStack(alignment: .leading) {
                    Text(airport.name)
                        .font(.headline)
                        .foregroundColor(Color.blue)
                    Text("ATC Frequency: \(airport.atcFrequency)")
                        .font(.subheadline)
                        .foregroundColor(Color.black.opacity(0.7))
                    Text("Coordinates: \(airport.latitude), \(airport.longitude)")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
                .padding(.vertical, 10)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Airports in California", displayMode: .inline)
        }
        .background(Color(.systemBackground))
    }
}

struct Airport: Identifiable {
    var id: String { name }
    let name: String
    let atcFrequency: String
    let latitude: Double
    let longitude: Double
}

struct AirportListView_Previews: PreviewProvider {
    static var previews: some View {
        AirportListView()
    }
}
