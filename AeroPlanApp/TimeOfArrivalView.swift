//
//  TimeOfArrivalView.swift
//  AeroPlanApp
//
//  Created by Aaron Yu on 10/28/23.
//

import SwiftUI

struct FlightTimeCalculatorView: View {
    @State private var startingCity = ""
    @State private var destinationCity = ""
    @State private var speedInKnots = ""
    @State private var timeOfArrival = ""
    
    // Create an array of City objects
    let cities: [City] = [
        City(name: "Los Angeles", coordinates: (34.0522, -118.2437)),
        City(name: "San Francisco", coordinates: (37.7749, -122.4194)),
        City(name: "Sacramento", coordinates: (38.5758, -121.4784)),
        City(name: "Seattle", coordinates: (47.6062, -122.3321)),
        // Add more cities here
    ]

    // Filtered city list based on search text
      var filteredCities: [City] {
          if startingCity.isEmpty {
              return cities
          } else {
              return cities.filter { $0.name.lowercased().contains(startingCity.lowercased()) }
          }
      }
      
      var body: some View {
          NavigationView {
              ZStack {
                  // Background image
                  Image("sunsetCALC")
                      .resizable()
                      .scaledToFill()
                      .edgesIgnoringSafeArea(.all)
                  
                  VStack {
                      // Button for starting city selection
                      NavigationLink(destination: CitySelectionView(selectedCity: $startingCity, cities: cities)) {
                          ButtonWithImage(imageName: "starting", buttonText: "Select Starting City")
                          }
                      
                      // Button for destination city selection
                      NavigationLink(destination: CitySelectionView(selectedCity: $destinationCity, cities: cities)) {
                          ButtonWithImage(imageName: "destination", buttonText: "Select Destination City")
                      }
                      .padding(.top, -20)
                      
                      Text("Speed in Knots")
                          .foregroundColor(.black)
                          .font(.system(size: 40))
                      
                      Text("Speed In Knots")
                          .foregroundColor(.white) // Set the outline color
                          .font(.system(size: 40))
                          .offset(y: -47) // Adjust the offset for the outline
                    
                      // Text field for entering speed
                      TextField("Enter Speed in Knots 300-1000", text: $speedInKnots)
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                          .padding(.horizontal, 175)
                          .padding(.top, -70)
                      
                      ButtonWithImage2(imageName: "calculate", buttonText: "Calculate Time of Arrival", calculateAction: {
                          calculateTimeOfArrival(startingCity: startingCity, destinationCity: destinationCity, speedInKnots: speedInKnots, timeOfArrival: $timeOfArrival, cities: cities)
                      })
                      
                      Spacer()
                  }
                  .padding()
              }
          }
      }
  }




// Function to calculate time of arrival
private func calculateTimeOfArrival(startingCity: String, destinationCity: String, speedInKnots: String, timeOfArrival: Binding<String>, cities: [City]) {
    guard let startingCoordinates = getCoordinates(for: startingCity, cities: cities),
          let destinationCoordinates = getCoordinates(for: destinationCity, cities: cities),
             let speed = Double(speedInKnots) else {
           timeOfArrival.wrappedValue = "Invalid input. Check your entries."
           return
       }

       // Calculate distance using Haversine formula
       let distance = haversineDistance(
           lat1: startingCoordinates.latitude,
           lon1: startingCoordinates.longitude,
           lat2: destinationCoordinates.latitude,
           lon2: destinationCoordinates.longitude
       )

       // Calculate time of arrival in hours
       let timeInHours = distance / speed
       let hours = Int(timeInHours)
       
       // Calculate remaining minutes
       let minutes = Int((timeInHours - Double(hours)) * 60)
       
       timeOfArrival.wrappedValue = "\(hours) hours and \(minutes) minutes"
    // Present an alert with the calculated time of arrival
            showAlert(title: "Time of Arrival", message: "\(hours) hours and \(minutes) minutes")
   }
  
  // Helper function to get coordinates for a city
private func getCoordinates(for city: String, cities: [City]) -> (latitude: Double, longitude: Double)? {
      guard let selectedCity = cities.first(where: { $0.name.lowercased() == city.lowercased() }) else {
          return nil
      }
      return selectedCity.coordinates
  }
  
  // Helper function to calculate Haversine distance between two points
  private func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
      let R = 6371.0 // Earth radius in kilometers

      let dlat = (lat2 - lat1).toRadians()
      let dlon = (lon2 - lon1).toRadians()

      let a = sin(dlat / 2) * sin(dlat / 2) +
              cos(lat1.toRadians()) * cos(lat2.toRadians()) *
              sin(dlon / 2) * sin(dlon / 2)
      let c = 2 * atan2(sqrt(a), sqrt(1 - a))

      return R * c
  }


extension Double {
  func toRadians() -> Double {
      return self * .pi / 180
  }
}

private func showAlert(title: String, message: String) {
       let alertController = UIAlertController(
           title: title,
           message: message,
           preferredStyle: .alert
       )

       alertController.addAction(UIAlertAction(title: "OK", style: .default))

       // Present the alert in a UIKit context (if needed)
       if let viewController = UIApplication.shared.windows.first?.rootViewController {
           viewController.present(alertController, animated: true, completion: nil)
       }
   }

struct City: Identifiable {
    var id = UUID()
    var name: String
    var coordinates: (Double, Double)
}

// Custom Button with Image
struct ButtonWithImage: View {
    var imageName: String
    var buttonText: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text(buttonText)
                .foregroundColor(.white)
        }
        .padding(20)
        .background(Color.blue)
        .cornerRadius(10)
        .foregroundColor(.white)
        .frame(width: 200, height: 200)
    }
}

struct ButtonWithImage2: View {
        var imageName: String
        var buttonText: String
        var calculateAction: () -> Void // Closure for the calculate action

        @State private var showingAlert = false

        var body: some View {
            
            Button(action: {
                showingAlert = true
            }) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text(buttonText)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(20)
            .background(Color.blue)
            .cornerRadius(10)
            .foregroundColor(.white)
            .frame(width: 300, height: 200)
            .padding(.top, -30)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Calculate ETA"),
                    message: Text("Do you want to calculate the ETA?"),
                    primaryButton: .default(Text("Yes")) {
                        calculateAction() // Call the provided calculate action
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
    }


struct CitySelectionView: View {
    @Binding var selectedCity: String
    var cities: [City]

    @State private var searchText = ""

    var filteredCities: [City] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText, placeholder: "Search Cities")
                .padding(.horizontal)

            List(filteredCities, id: \.name) { city in
                HStack {
                    Text(city.name)
                    Spacer()
                    if city.name == selectedCity {
                        Image(systemName: "checkmark") // Display checkmark if the city is selected
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCity = city.name
                }
            }
            .navigationTitle("Select City")
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .foregroundColor(.primary)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
}

struct FlightTimeCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        FlightTimeCalculatorView()
    }
}
