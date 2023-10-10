import SwiftUI


struct ProcedureStep {
    var content: String
    var isAction: Bool
    @State var isOn: Bool = false
}

struct EmergencyProceduresChecklistView: View {
    @State private var selectedProcedure: String? = nil
    @State private var currentNavigationTag: NavigationTag?
    @State private var searchResults: [String] = []
    @State var isFavorite: Bool = false
    
    let procedures: [String: [ProcedureStep]] = [
        "Power Loss in Flight": [
            ProcedureStep(content: "Best Glide - 68 KIAS ( 78 MPH)", isAction: false),
            ProcedureStep(content: "Note Wind Direction & Velocity", isAction: false),
            ProcedureStep(content: "Pick Landing Site", isAction: false),
            ProcedureStep(content: "Fuel shutoff valve", isAction: true, isOn: true),
            ProcedureStep(content: "Fuel pump", isAction: true, isOn: true),
            ProcedureStep(content: "Mixture - Full Rich", isAction: false),
            ProcedureStep(content: "Fuel Selector - Check / Both", isAction: false),
            ProcedureStep(content: "Magnetos - Check All", isAction: false),
            ProcedureStep(content: "Master", isAction: true, isOn: true),
            ProcedureStep(content: "Fuel  Pump", isAction: true),
        ],
        
        "Engine Fire in Flight": [
            ProcedureStep(content: "Throttle - Closed", isAction: false),
            ProcedureStep(content: "Mixture - Full Lean / Idle Cutoff", isAction: false),
            ProcedureStep(content: "Fuel Shutoff Valve", isAction: true),
            ProcedureStep(content: "AUX Fuel Pump", isAction: true),
            ProcedureStep(content: "Master", isAction: true),
            ProcedureStep(content: "Cabin Heat & Air", isAction: true),
            ProcedureStep(content: "Airspeed 100 KIAS or Hider", isAction: false),
            ProcedureStep(content: "PLEASE LAND ASAP", isAction: false),
        ],
        
        "Engine Fire During Start": [
            ProcedureStep(content: "Contine Cranking Engine", isAction: false),
            ProcedureStep(content: "Throttle Full Open", isAction: false),
            ProcedureStep(content: "Masster And Mags", isAction: true),
            ProcedureStep(content: "Evacuate / Fire Extingguisher", isAction: false),
        ],
        
        "Electrical Fire In Flight": [
            ProcedureStep(content: "ALL Electrical device", isAction: true),
            ProcedureStep(content: "Closed Vents, Cabin Heat, & Air", isAction: false),
            ProcedureStep(content: "Avionics Master", isAction: true),
            ProcedureStep(content: "If Fire Out- Master On Only if Crutial", isAction: false),
            ProcedureStep(content: "Vents Open", isAction: false),
            ProcedureStep(content: "Vents", isAction: true, isOn: true),
        ],
        
        "Power Loss After Takeoff": [
            ProcedureStep(content: "Maintain Aircraft Control", isAction: false),
            ProcedureStep(content: "Airspeed - 70 KIAS (81 MPH)", isAction: false),
            ProcedureStep(content: "Fuel Shutoff Valve", isAction: true),
            ProcedureStep(content: "Mixture - Full Lean / Idle Cutoff", isAction: false),
            ProcedureStep(content: "Flaps - Down", isAction: false),
            ProcedureStep(content: "Master & Mags", isAction: true),
        ],
        
        
        "Air Data System (ADS) Failure": [
            ProcedureStep(content: "Crosscheck with standby instruments", isAction: false),
            ProcedureStep(content: "Report failure to ATC", isAction: false),
            ProcedureStep(content: "Use backup instruments, if available", isAction: false),
            ProcedureStep(content: "Consider alternate landing location if required", isAction: false),
        ],
        
        "Attitude and Heading Reference System (AHRS) Failure": [
            ProcedureStep(content: "Crosscheck with other instruments", isAction: false),
            ProcedureStep(content: "Switch to standby AHRS, if available", isAction: false),
            ProcedureStep(content: "Maintain VFR conditions if possible", isAction: false),
            ProcedureStep(content: "Land as soon as practical", isAction: false)
        ],
        "Carburetor Icing": [
            ProcedureStep(content: "Detecting: Unexpected RPM drop or engine roughness", isAction: false),
            ProcedureStep(content: "Carburetor Heat - Apply", isAction: true, isOn: true),
            ProcedureStep(content: "Monitor RPM and engine behavior", isAction: false),
            ProcedureStep(content: "If RPM rises or engine smoothes out - Likely Carb Ice", isAction: false),
            ProcedureStep(content: "Continue with Carb Heat ON until landing or conditions improve", isAction: false)
        ],
        "Inadvertent IFR Entry": [
            ProcedureStep(content: "Stay calm and trust your instruments", isAction: false),
            ProcedureStep(content: "Level the wings using your attitude indicator", isAction: false),
            ProcedureStep(content: "Initiate a gentle climb to ensure obstacle clearance", isAction: false),
            ProcedureStep(content: "Turn 180 degrees to exit the condition if safe", isAction: false),
            ProcedureStep(content: "Contact ATC for assistance", isAction: false),
            ProcedureStep(content: "If equipped, turn on aircraft's anti-collision lights", isAction: true, isOn: true)
        ]
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Emergency Procedures")
                            .font(.system(size: 34, weight: .bold))
                            .padding(.top, 40)
                            .foregroundColor(Color(.systemBlue))
                        
                        ForEach(procedures.keys.reversed(), id: \.self) { procedureKey in
                            VStack(spacing: 0) {
                                Button(action: {
                                    withAnimation(.spring()) {
                                        self.selectedProcedure = self.selectedProcedure == procedureKey ? nil : procedureKey
                                    }
                                }) {
                                    HStack {
                                        Text(procedureKey)
                                            .font(.headline)
                                            .foregroundColor(Color(.label))
                                        Spacer()
                                        Image(systemName: self.selectedProcedure == procedureKey ? "chevron.up" : "chevron.down")
                                            .foregroundColor(Color(.systemBlue))
                                    }
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .clipShape(RoundedCorners(tl: 10, tr: 10))
                                }
                                
                                if self.selectedProcedure == procedureKey {
                                    VStack(spacing: 15) {
                                        ForEach(procedures[procedureKey]!, id: \.content) { step in
                                            if step.isAction {
                                                HStack {
                                                    Text(step.content)
                                                        .foregroundColor(Color(.secondaryLabel))
                                                    Spacer()
                                                    Button(action: {
                                                        step.isOn.toggle()
                                                    }) {
                                                        Text(step.isOn ? "On" : "Off")
                                                            .padding(.horizontal, 10)
                                                            .padding(.vertical, 5)
                                                            .background(Color.blue)
                                                            .foregroundColor(.white)
                                                            .cornerRadius(8)
                                                    }
                                                }
                                                .padding(.horizontal)
                                            } else {
                                                Text("• \(step.content)")
                                                    .foregroundColor(Color(.label))
                                                    .padding(.leading, 30)
                                            }
                                        }
                                    }
                                    .padding(.vertical, 10)
                                    .background(Color(.systemBackground))
                                    .clipShape(RoundedCorners(bl: 10, br: 10))
                                }
                            }
                            .padding(.top, 10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                        
                        Button(action: {
                            self.currentNavigationTag = .airportListView
                        }) {
                            Text("View Airport Information")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 20)
                        .background(
                            NavigationLink(
                                destination: AirportListView(),
                                tag: NavigationTag.airportListView,
                                selection: $currentNavigationTag
                            ) {
                                EmptyView()
                            }
                        )
                        
                        Spacer()
                    }
                    .padding([.leading, .trailing])
                }
            }
        }
    }

}

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.size.width
        let h = rect.size.height
        
        // Start
        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        return path
    }
}


struct EmergencyProceduresChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyProceduresChecklistView()
    }
}
