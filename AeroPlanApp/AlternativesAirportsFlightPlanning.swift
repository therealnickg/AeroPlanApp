import SwiftUI

struct AlternativesAirportsFlightPlanning: View {
    
    @State private var searchText: String = ""
    @State private var selectedAirport: AlternateAirport? = nil
    
    let alternateAirports = [
        AlternateAirport(name: "John F. Kennedy International Airport", code: "JFK", distance: "15 miles", fuelCost: "$500", safetyProtocols: "Standard FAA safety protocols, 2 emergency runways."),
        AlternateAirport(name: "Los Angeles International Airport", code: "LAX", distance: "30 miles", fuelCost: "$750", safetyProtocols: "Standard FAA safety protocols, emergency medical available."),
        AlternateAirport(name: "Chicago O'Hare International Airport", code: "ORD", distance: "40 miles", fuelCost: "$900", safetyProtocols: "Standard FAA safety protocols, 3 emergency runways."),
        AlternateAirport(name: "Dallas/Fort Worth International Airport", code: "DFW", distance: "25 miles", fuelCost: "$650", safetyProtocols: "Standard FAA safety protocols, emergency fire crew available."),
        AlternateAirport(name: "Denver International Airport", code: "DEN", distance: "35 miles", fuelCost: "$800", safetyProtocols: "Equipped with snow removal equipment, 2 emergency runways."),
        AlternateAirport(name: "San Francisco International Airport", code: "SFO", distance: "20 miles", fuelCost: "$600", safetyProtocols: "Standard FAA safety protocols, coast guard available."),
        AlternateAirport(name: "Miami International Airport", code: "MIA", distance: "30 miles", fuelCost: "$700", safetyProtocols: "Standard FAA safety protocols, equipped with hurricane emergency measures."),
        AlternateAirport(name: "Orlando International Airport", code: "MCO", distance: "25 miles", fuelCost: "$650", safetyProtocols: "Standard FAA safety protocols, 2 emergency runways.")
    ]
    
    var filteredAirports: [AlternateAirport] {
            if searchText.isEmpty {
                return alternateAirports
            } else {
                return alternateAirports.filter { $0.name.contains(searchText) || $0.code.contains(searchText) }
            }
        }

    
    var body: some View {
        NavigationView {
            VStack {
                Text("Alternate Airports")
                    .font(.largeTitle)
                    .padding()
                SearchBarView(text: $searchText)
                
                Text("Based on your current flight plan, here are some alternate airport suggestions:")
                    .font(.body)
                    .padding()
                    .multilineTextAlignment(.center)
                
                List(alternateAirports) { airport in
                    NavigationLink(destination: AirportDetailView(airport: airport)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(airport.name)
                                    .font(.headline)
                                Text(airport.code)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(airport.distance)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Text("Fuel Cost: \(airport.fuelCost)")
                                    .font(.footnote)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AirportDetailView: View {
    let airport: AlternateAirport
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(airport.name)
                    .font(.largeTitle)
                    .padding(.top)
                
                HStack {
                    Text("Code:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(airport.code)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                Divider()
                
                HStack {
                    Text("Distance:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(airport.distance)
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                Divider()
                
                HStack {
                    Text("Estimated Fuel Cost:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(airport.fuelCost)
                        .font(.title2)
                        .foregroundColor(.green)
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Safety & Emergency Protocols:")
                        .font(.headline)
                        .padding(.vertical)
                    Text(airport.safetyProtocols)
                        .font(.body)
                        .padding(.bottom, 20)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct AlternativesAirportsFlightPlanning_Previews: PreviewProvider {
    static var previews: some View {
        AlternativesAirportsFlightPlanning()
    }
}

struct AlternateAirport: Identifiable {
    var id = UUID()
    let name: String
    let code: String
    let distance: String
    let fuelCost: String
    let safetyProtocols: String
}
