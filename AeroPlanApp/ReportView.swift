
//  ReportView.swift
//  AeroPlanApp
//
//  Created by Guest Use on 9/9/23.
//  Owner Om kakadiya

import SwiftUI

// Data model for the IMSAFE report.

struct Report {
    var illness: String
    var medication: String
    var stress: String
    var alcohol: String
    var fatigue: String
    var emotions: String
    var overallStatus: String
    var notes: String
    var dateTime: Date
}
// View representing the generated IMSAFE report.

struct ReportView: View {
    var report: Report?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Display the report if available, else show "No Report Available" message.

                if let report = report {
                
                    // Display the overall status of the pilot.
                    Text(report.overallStatus)
                    // Styling for the overall status.

                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .padding()
                        .background(Color(report.overallStatus == "Safe to Fly" ? .green : .red))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .padding([.top, .horizontal])
                    
                    // Display the date and time when the report was generated.

                    Text("Report generated on: \(report.dateTime.formatted())")
                    // Styling for the date and time.

                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .padding(.top)
                    
                    // Information cards displaying details of each IMSAFE factor.

                    InfoCard(title: "Illness", value: report.illness, iconName: "thermometer")
                    // ... (other InfoCards)

                    InfoCard(title: "Medication", value: report.medication, iconName: "pills")
                    InfoCard(title: "Alcohol", value: report.alcohol, iconName: "wineglass")
                    InfoCard(title: "Stress", value: report.stress, iconName: "exclamationmark.triangle")
                    InfoCard(title: "Fatigue", value: report.fatigue, iconName: "bed.double.fill")
                    InfoCard(title: "Emotions", value: report.emotions, iconName: "heart.fill")
                    InfoCard(title: "Notes", value: report.notes, iconName: "note")
                    Text(report.overallStatus)
                    
                } else {
                        Text("No Report Available")
                            .font(.title)
                            .padding()
                    }
                }
            Button(action: {
                // Button to share the generated report.

                if report != nil {
                    shareReport()
                }
            }) {
                Text("Share Report")
                Image(systemName: "square.and.arrow.up")
                // Styling for the Share button.

            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 20)
            
        }
        
            .navigationBarTitle("IMSAFE Report", displayMode: .inline)
        }
    // Function to facilitate sharing of the IMSAFE report.

        func shareReport() {
            if let currentReport = report {
                let reportText = "IMSAFE Analysis Report: \(currentReport.overallStatus) ... "
                let activityViewController = UIActivityViewController(activityItems: [reportText], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
            }
        }
        
    }
// View representing the generated IMSAFE report.
// UI component to display individual IMSAFE factors with their respective icons.

struct InfoCard: View {
    var title: String
    var value: String
    var iconName: String
    // Dynamic color change based on the value of each factor.

    var valueColor: Color {
        // Define conditions for color changes.

        if value == "None" {
            return .gray
        } else if value == "Feeling Sick" || value == "On Medication" || value == "> 0.04%" || value == "High Stress" || value == "Fatique" || value == "Emotionally Distress" {
            return .red
        } else {
            return .green
        }
    }

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding(.leading, 20)
            
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.medium)
                    .font(.title2)
                Text(value)
                    .font(.title3)
                    .fontWeight(value == "None" ? .regular : .bold)
                    .foregroundColor(valueColor)
            }
            .padding(.vertical)
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .padding(.horizontal)
                }
            }

// Preview provider for SwiftUI Canvas.

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView(report: Report(illness: "None", medication: "None", stress: "None", alcohol: "None", fatigue: "None", emotions: "None", overallStatus: "None", notes: "None", dateTime: Date()))
    }
}