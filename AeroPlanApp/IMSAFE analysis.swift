
//  IMSAFE analysis.swift
//  AeroPlanApp
//
//  Created by Guest Use on 9/7/23.
//  Owner Om Kakadiya

import SwiftUI
import PDFKit

// Enumerations for defining various status types for different health indicators

enum IllnessStatus: Int {
    case none, feelingSick
}

enum MedicationStatus: Int {
    case none, prescribed, onMedication
}

enum StressStatus: Int {
    case noStress, midStress, highStress
}

enum AlcoholStatus: Int {
    case none, belowLimit, aboveLimit
}

enum FatigueStatus: Int {
    case wellRested, fatique
}

enum EmotionStatus: Int {
    case stable, emotionalDistress
}
// Enum for managing navigation to other views

enum NavigationTag {
    case reportView
    case airportListView
}
enum AskYourselfSection {
    case illness, medication, stress, alcohol, fatigue, emotions
}

struct IMSAFE_analysis: View {
    // State properties for keeping track of each health indicator's status

    @State private var illness: IllnessStatus = .none
    @State private var medication: MedicationStatus = .none
    @State private var stress: StressStatus = .noStress
    @State private var alcohol: AlcoholStatus = .none
    @State private var fatigue: FatigueStatus = .wellRested
    @State private var emotions: EmotionStatus = .stable
    @State private var showAlcoholInfo = false
    @State private var showIllnessInfo = false
    @State private var showMedicationInfo = false
    @State private var showStressInfo = false
    @State private var showFatigueInfo = false
    @State private var showEmotionsInfo = false
    @State private var notes: String = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showReportView: Bool = false
    @State private var reportData: Report? = nil
    @State private var currentNavigationTag: NavigationTag? = nil
    @State private var scaleEffect: CGFloat = 1.0


    var body: some View {
        NavigationView {
            VStack {
                // Title for the analysis screen.

                Text("IMSAFE Analysis")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 3, x: 0, y: 3)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                // Form UI: A structured way to present multiple controls.

                Form {
                    // here i am adding the PDF which includes more information and this function has code in there.
                    
                    GuidelinesLink()
                        .padding(.vertical, 10)
                    
                    // Picker Views for each health indicator

                    Section {
                        illnessPicker()// UI for selecting illness status.
                        medicationPicker()// UI for selecting medication status.
                        stressPicker() // UI for selecting stress levels.
                        alcoholPicker() // UI for indicating alcohol consumption.
                        fatiguePicker() // UI for indicating fatigue levels.
                        emotionsPicker() // UI for indicating emotional status.
                    }
                    // Notes section where users can type additional information.

                    Section(header: Text("Notes")) {
                        TextEditor(text: $notes)
                    }
                    // Submission button UI.

                    Section {
                        HStack {
                            Spacer()
                            Button(action: {
                                // Button animation and report generation.

                                withAnimation {
                                    self.scaleEffect = 1.5
                                }
                                reportData = generateReport()
                                currentNavigationTag = .reportView
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        self.scaleEffect = 1.0
                                    }
                                }
                            }) {
                                HStack {
                                    // Button content UI

                                    Spacer()
                                    Text("Submit")
                                    Spacer()
                                    Image(systemName: "arrow.right.circle.fill")
                                    Spacer()
                                }
                                // submit button effect and background color.
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .scaleEffect(scaleEffect)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(
                                NavigationLink(
                                    destination: ReportView(report: reportData),
                                    tag: NavigationTag.reportView,
                                    selection: $currentNavigationTag
                                )  {
                                    EmptyView()
                                }
                            )
                            .scaleEffect(scaleEffect)
                            Spacer() // Push button to the middle
                        }
                    }
                }
            }
            // Background image for the screen with blur effect.

            .background(
                Image("IMSAFE")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 6.0)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }


    
    func illnessPicker() -> some View {
        // Provides the UI for picking an illness status

        VStack(alignment: .leading) {
            HStack {
                Text("Illness")
                    .font(.headline)
                    .padding(.top)
                
                Spacer() // This will push the button to the edge

                Button(action: {
                    showIllnessInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.blue)
                }
                .alert(isPresented: $showIllnessInfo) {
                    Alert(title: Text("Illness Info"), message: Text("Feeling sick will make it difficult to perform your duties in the air. If you feel ill before you take off, you might get rapidly worse while flying. Blocked sinuses can cause extreme pain during takeoff and landing. \n\nEspecially if you fly solo, any illness including a stomach bug, cold, or flu is a reason to call off the flight."), dismissButton: .default(Text("Got it!")))
                }
            }

            Picker("", selection: $illness) {
                Text("None").tag(IllnessStatus.none)
                Text("Feeling Sick").tag(IllnessStatus.feelingSick)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
        }
    }
    
    func medicationPicker() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Medication")
                    .font(.headline)
                    .padding(.top)
                
                Spacer() // This will push the button to the edge

                Button(action: {
                    showMedicationInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.blue)
                }
                .alert(isPresented: $showMedicationInfo) {
                    Alert(title: Text("Medication Info"), message: Text("Per FAA regulations, the pilot in command is not allowed to fly if they are taking medications on the banned list and the required waiting period since the last dose has not expired. \n\n This includes some prescription and over the counter medications. Your aviation medical examiner can provide a full list of these medications and advise you.\n\n Some of these drugs are on the list because they interfere with body functions or might make the user lightheaded in low oxygen conditions. In general, pilots should not fly while feeling the effects of any medication that impacts their state of mind and reaction time or makes them drowsy."),
                        dismissButton: .default(Text("Got it!")))
                }
            }

            Picker("", selection: $medication) {
                Text("None").tag(MedicationStatus.none)
                Text("Prescribed").tag(MedicationStatus.prescribed)
                Text("On Medication").tag(MedicationStatus.onMedication)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
        }
    }
    
    func stressPicker() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Stress")
                    .font(.headline)
                    .padding(.top)
                
                Spacer() // This will push the button to the edge

                Button(action: {
                    showStressInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.blue)
                }
                .alert(isPresented: $showStressInfo) {
                    Alert(title: Text("Stress Info"), message: Text("An unusual amount of stress can also affect pilot performance. Stress is a physical body response and may cause increased heart rate and blood pressure, as well as shortness of breath. \n\nWhether you are under too much stress to fly safely is a subjective evaluation, but taking a moment to stop and check your stress level before you take off can help you avoid becoming “task saturated” or overwhelmed while in the air."),
                        dismissButton: .default(Text("Got it!")))
                }
            }

            Picker("", selection: $stress) {
                Text("No Stress").tag(StressStatus.noStress)
                Text("Mid Stress").tag(StressStatus.midStress)
                Text("High Stress").tag(StressStatus.highStress)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
        }
        
        
    }
    
    
    func alcoholPicker() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Alcohol")
                    .font(.headline)
                    .padding(.top)
                
                Spacer() // This will push the button to the edge

                Button(action: {
                    showAlcoholInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.blue)
                }
                .alert(isPresented: $showAlcoholInfo) {
                    Alert(title: Text("Alcohol Levels"), message: Text("BAC: Blood Alcohol Content. \n\nThe FAA alcohol rule states that a pilot and any crew member may not consume alcohol within 8 hours of flying and may never have a BAC exceeding. \n\nNone: No alcohol consumption.\n\n0.04%: Alcohol concentration in blood is up to 0.04%.\n\n> 0.04%: Alcohol concentration in blood exceeds 0.04%."), dismissButton: .default(Text("Got it!")))
                }
            }

            Picker("", selection: $alcohol) {
                Text("None").tag(AlcoholStatus.none)
                Text("0.04% BAC").tag(AlcoholStatus.belowLimit)
                Text("> 0.04% BAC").tag(AlcoholStatus.aboveLimit)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
        }
    }
    
    func fatiguePicker() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Fatigue")
                    .font(.headline)
                    .padding(.top)
                
                Spacer() // This will push the button to the edge

                Button(action: {
                    showFatigueInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.blue)
                }
                .alert(isPresented: $showFatigueInfo) {
                    Alert(title: Text("Fatigue Info"), message: Text("Fatigue is another factor that only the pilot can evaluate. Most pilots are hard-working individuals who have somewhere to be or a job to complete. Taking a moment to honestly evaluate your own level of fatigue will help you make logical decisions about whether you are too tired to fly. Fatigued pilots make mistakes and might even fall asleep in the cockpit."),
                        dismissButton: .default(Text("Got it!")))
                }
            }

            Picker("", selection: $fatigue) {
                Text("Well Rested").tag(FatigueStatus.wellRested)
                Text("Fatique").tag(FatigueStatus.fatique)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
        }
    }
    
    func emotionsPicker() -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Emotions")
                    .font(.headline)
                    .padding(.top)
                
                Spacer() // This will push the button to the edge

                Button(action: {
                    showEmotionsInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(Color.blue)
                }
                .alert(isPresented: $showEmotionsInfo) {
                    Alert(title: Text("Emotions Info"), message: Text("Powerful emotions have profound physical and mental effects. If a pilot is depressed, angry, grieving, or emotionally charged, their ability to make calm decisions in flight is impaired. Even a pilot’s strong desire to get where they are going can be emotionally driven and influence their ability to judge if they are truly fit to fly."),
                        dismissButton: .default(Text("Got it!")))
                }
            }

            Picker("", selection: $emotions) {
                Text("Stable").tag(EmotionStatus.stable)
                Text("Emotionally Distress").tag(EmotionStatus.emotionalDistress)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
        }
    }
    
    func isSafeToFly() -> Bool {
        // Determines whether it's safe to fly based on chosen indicators

        if illness == .feelingSick {
            return false
        }

        if alcohol == .aboveLimit {
            return false
        }
        
        if stress == .highStress{
            return false
        }
        
        if medication == .onMedication{
            return false
        }
        
        if fatigue == .fatique{
            return false
        }

        if emotions == .emotionalDistress{
            return false
        }
        return true
    }
    
    func generateReport() -> Report {
        // Generates a report based on the current status of the health indicators

        let overallStatus = isSafeToFly() ? "Safe to Fly" : "Not Safe to Fly"
        return Report(
            illness: description(for: illness),
            medication: description(for: medication),
            stress: description(for: stress),
            alcohol: description(for: alcohol),
            fatigue: description(for: fatigue),
            emotions: description(for: emotions),
            overallStatus: overallStatus,
            notes: notes,
            dateTime: Date()
        )
    }
    
    func description(for illness: IllnessStatus) -> String {
        switch illness {
            case .none: return "None"
            case .feelingSick: return "Feeling Sick"
        }
    }

    func description(for alcohol: AlcoholStatus) -> String {
        switch alcohol {
            case .none: return "None"
            case .belowLimit: return "0.04%"
            case .aboveLimit: return "> 0.04%"
        }
    }
    
    func description(for medication: MedicationStatus) -> String {
        switch medication {
        case .none: return "None"
        case .prescribed: return "Prescribed Medication"
        case .onMedication: return "On Medication"
        }
    }
    
    func description(for stress: StressStatus) -> String {
        switch stress {
        case .noStress: return "No Stress"
        case .midStress: return "Mid Stress"
        case .highStress: return "High Stress"
        }
    }
    
    func description(for fatigue: FatigueStatus) -> String {
        switch fatigue {
        case .wellRested: return "Well Rested"
        case .fatique: return "Fatique"
        }
    }
    
    func description(for emotions: EmotionStatus) -> String {
        switch emotions {
        case .stable: return "Stable"
        case .emotionalDistress: return "Emotionally Distress"
        }
    }
}

// View for providing a clickable link to open a guidelines PDF

struct GuidelinesLink: View {
    @State private var showPDF = false

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)

            Text("For more information,")
                .font(.body)
                .foregroundColor(.black)

            Button(action: {
                self.showPDF = true
            }) {
                Text("click here.")
                    .underline()
                    .foregroundColor(Color.blue)
                    .fontWeight(.semibold)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.all, 10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .sheet(isPresented: $showPDF) {
            PDFViewRepresentable(pdfName: "PAVE")
        }
    }
}

// UIViewRepresentable for displaying a PDF within SwiftUI.

struct PDFViewRepresentable: UIViewRepresentable {
    let pdfName: String

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if let docURL = Bundle.main.url(forResource: pdfName, withExtension: "pdf"),
           let document = PDFDocument(url: docURL) {
            uiView.document = document
        }
    }
}

struct IMSAFE_analysis_Previews: PreviewProvider {
    static var previews: some View {
        IMSAFE_analysis()
    }
}
