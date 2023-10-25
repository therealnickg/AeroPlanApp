import SwiftUI

struct BackupPilotInstructionsView: View {
    @State private var selectedSegment: Int? = nil
    @State private var showConversion: Bool = false
    @State private var searchText: String = ""
    @State private var showFAQs: Bool = false
    @State private var showResources: Bool = false

    let segments = ["General Procedures", "Landing Assistance", "Emergency Landing", "Tutorials", "Calm Assistant"]
    let icons = ["list.bullet", "airplane.circle", "exclamationmark.triangle", "checkmark.seal", "play.rectangle", "speaker.wave.2"]
    
    // Expanding instructions for more depth
    let detailedInstructions: [String: [String]] = [
        "General Procedures": [
            "Stay Calm: Taking a deep breath, your primary goal is to keep the plane stable and communicate.",
            "Fasten Seatbelt: Ensure your seatbelt is securely fastened.",
            "Hands on the Yoke: Push forward to go down. Pull back to go up. Turn left or right to turn the aircraft.",
            "Identify Nearest Airports: Use the onboard GPS to identify the nearest airports.",
            "Turn on Emergency Lights: Ensure you're visible to other aircrafts.",
            "If nighttime, adjust instrument panel lights."
        ],
        "Landing Assistance": [
            "Align with the runway.",
            "Lower landing gear if applicable.",
            "Flaps down for a slower approach.",
            "Maintain steady descent rate.",
            "Keep wings level.",
            "Apply brakes upon touch down."
        ],
        "Emergency Landing": [
                "Assess the Situation: Understand the reason for the emergency.",
                "Stay Calm: Deep breaths. Clear mind. Avoid panicking.",
                "Establish Communication: If possible, contact Air Traffic Control.",
                "Secure the Aircraft: Fasten seatbelts, turn on emergency lights.",
                "Find a Suitable Landing Site: Look for open fields, roads, or water.",
                "Maintain Safe Airspeed: Ensure you're not flying too fast or too slow.",
                "Landing Approach: Align the aircraft with the intended landing area.",
                "Use Flaps: Control speed and descent. Extend fully if needed.",
                "Brace for Impact: Protect your head and face.",
                "Shutdown and Evacuate: Once landed, shut down systems and evacuate if safe.",
                "After Landing: Contact emergency services if not done so.",
                "Stay With the Aircraft: If in a remote location, it's easier for rescuers to spot."
            ]
    ]
    
    let FAQs: [String] = [
        "How do I communicate with ATC?",
        "What's the best way to ensure I'm visible to other planes?",
        "How do I know which buttons not to press?",
        "How can I identify the nearest airport?",
        "How long can the plane remain airborne?",
        "What if there's bad weather?"
    ]
    
    
    let resources: [String] = [
        "Online Flight Tutorial Video",
        "ATC Communication Guide",
        "Landing Checklist",
        "Weather Analysis Tool",
        "Nearest Airports Locator",
        "Emergency Signals Guide"
    ]

    var body: some View {
        NavigationView {
            VStack {
                Text("Back-Up Pilot Instructions")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color.blue)
                    .padding(.top, 20)

                SearchBar(text: $searchText)
                    .padding(.horizontal)

                ScrollView {
                    ForEach(0..<segments.count, id: \.self) { index in
                        if segments[index].contains(searchText) || searchText.isEmpty {
                            NavigationLink(destination: InstructionsView(segment: segments[index], instructions: detailedInstructions[segments[index]] ?? [])) {
                                HStack {
                                    Image(systemName: icons[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color.blue)
                                    Text(segments[index])
                                }
                            }
                            .padding()
                            .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.1), Color.white]), startPoint: .top, endPoint: .bottom)
                                )
                            .edgesIgnoringSafeArea(.all)  // To make the background extend to the edges
                            .navigationBarTitle("", displayMode: .inline)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }

                    Button(action: { showConversion.toggle() }) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                            Text("Unit Conversion")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showConversion) {
                        UnitConversionView()
                    }

                    Button(action: { showFAQs.toggle() }) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text("FAQs")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showFAQs) {
                        FAQsView(faqs: FAQs)
                    }

                    Button(action: { showResources.toggle() }) {
                        HStack {
                            Image(systemName: "book.circle")
                            Text("Resources")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding()
                    .sheet(isPresented: $showResources) {
                        ResourcesView(resources: resources)
                    }

                    EmergencyButton()
                        .padding(.top, 20)
                }
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct InstructionsView: View {
    var segment: String
    var instructions: [String]
    @State private var selectedInstruction: Int? = nil

    var body: some View {
        VStack {
            Text(segment)
                .font(.largeTitle)
                .foregroundColor(Color.blue)
                .padding(.top, 20)
            
            List {
                ForEach(0..<instructions.count, id: \.self) { index in
                    Button(action: {
                        withAnimation {
                            if selectedInstruction == index {
                                selectedInstruction = nil
                            } else {
                                selectedInstruction = index
                            }
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(instructions[index])
                                .font(.headline)
                                .foregroundColor(Color.black)
                                .padding(.vertical)
                            if index == selectedInstruction {
                                Text("Detailed instruction for this step can go here.")
                                    .font(.subheadline)
                                    .transition(.opacity)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct FAQsView: View {
    var faqs: [String]

    var body: some View {
        VStack {
            Text("Frequently Asked Questions")
                .font(.largeTitle)
                .padding(.top, 20)
            
            List(faqs, id: \.self) { faq in
                Text(faq)
            }
        }
        .padding()
    }
}

struct ResourcesView: View {
    var resources: [String]

    var body: some View {
        VStack {
            Text("Important Resources")
                .font(.largeTitle)
                .padding(.top, 20)
            
            List(resources, id: \.self) { resource in
                Text(resource)
            }
        }
        .padding()
    }
}



struct FeedbackButton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "bubble.left.and.bubble.right")
                Text("Provide Feedback")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.orange)
            .cornerRadius(10)
        }
    }
}

struct EmergencyButton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: "phone.fill.arrow.up.right")
                Text("Emergency Call")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(10)
        }
    }
}

struct UnitConversionView: View {
    @State private var inputAmount: String = ""
    @State private var selectedUnit = 0
    let units = ["Feet", "Meters"]
    
    var convertedAmount: Double {
        let amount = Double(inputAmount) ?? 0
        switch selectedUnit {
        case 0: // Feet to Meters
            return amount * 0.3048
        case 1: // Meters to Feet
            return amount / 0.3048
        default:
            return 0
        }
    }

    var body: some View {
        VStack {
            Text("Unit Conversion")
                .font(.largeTitle)
                .padding()

            TextField("Enter Amount", text: $inputAmount)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            Picker("Select Unit", selection: $selectedUnit) {
                ForEach(units.indices) { index in
                    Text(units[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            Text("\(convertedAmount, specifier: "%.2f")")
                .font(.largeTitle)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}

struct BackupPilotInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        BackupPilotInstructionsView()
    }
}
