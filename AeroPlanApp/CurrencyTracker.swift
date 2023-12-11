//
//  CurrencyTracker.swift
//  AeroPlanApp
//
//  Created by Nicolas Guardado Guardado on 10/6/23.
//

import SwiftUI

struct CurrencyView: View {
    @State private var vfrCurrencyDate1: Date = Date()
    @State private var vfrCurrencyDate2: Date = Date()
    @State private var vfrCurrencyDate3: Date = Date()
    @State private var nightVfrCurrencyDate1: Date = Date()
    @State private var nightVfrCurrencyDate2: Date = Date()
    @State private var nightVfrCurrencyDate3: Date = Date()
    @State private var ifrCurrencyDate1: Date = Date()
    @State private var ifrCurrencyDate2: Date = Date()
    @State private var ifrCurrencyDate3: Date = Date()
    @State private var ifrCurrencyDate4: Date = Date()
    @State private var ifrCurrencyDate5: Date = Date()
    @State private var ifrCurrencyDate6: Date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("VFR Currency")) {
                    DatePicker("3rd Last VFR Flight", selection: $vfrCurrencyDate3, in: ...Date(), displayedComponents: .date)
                    DatePicker("2nd Last VFR Flight", selection: $vfrCurrencyDate2, in: ...Date(), displayedComponents: .date)
                    DatePicker("Last VFR Flight", selection: $vfrCurrencyDate1, in: ...Date(), displayedComponents: .date)
                }
                
                Section(header: Text("Night VFR Currency")) {
                    DatePicker("Last VFR Flight", selection: $nightVfrCurrencyDate3, in: ...Date(), displayedComponents: .date)
                    DatePicker("Last VFR Flight", selection: $nightVfrCurrencyDate2, in: ...Date(), displayedComponents: .date)
                    DatePicker("Last VFR Flight", selection: $nightVfrCurrencyDate1, in: ...Date(), displayedComponents: .date)
                }
                
                Section(header: Text("IFR Currency")) {
                    DatePicker("Last IFR Flight", selection: $ifrCurrencyDate6, in: ...Date(), displayedComponents: .date)
                    DatePicker("Last IFR Flight", selection: $ifrCurrencyDate5, in: ...Date(), displayedComponents: .date)
                    DatePicker("Last IFR Flight", selection: $ifrCurrencyDate4, in: ...Date(), displayedComponents: .date)
                    DatePicker("Last IFR Flight", selection: $ifrCurrencyDate3, in: ...Date(), displayedComponents: .date)
                    DatePicker("Last IFR Flight", selection: $ifrCurrencyDate2, in: ...Date(), displayedComponents: .date)
                    DatePicker("Last IFR Flight", selection: $ifrCurrencyDate1, in: ...Date(), displayedComponents: .date)
                }
                
                Section(header: Text("Currency Status")) {
                    Text("VFR Currency Status: \(vfrCurrencyStatus())")
                        .fontWeight(.bold)
                        .foregroundColor(vfrCurrencyStatus() == "Current" ? .green : .red)
                    Text("Night VFR Currency Status: \(nightVfrCurrencyStatus())")
                        .fontWeight(.bold)
                        .foregroundColor(nightVfrCurrencyStatus() == "Current" ? .green : .red)
                    Text("IFR Currency Status: \(ifrCurrencyStatus())")
                        .fontWeight(.bold)
                        .foregroundColor(ifrCurrencyStatus() == "Current" ? .green : .red)
                }
            }
            .navigationBarTitle("Currency Tracker")
        }
        .background(Color.blue)
    }
    
    func vfrCurrencyStatus() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.day], from: vfrCurrencyDate3, to: currentDate)
        if let daysSinceLastVFRFlight = components.day, daysSinceLastVFRFlight <= 90 {
            return "Current"
        } else {
            return "Expired"
        }
    }
    
    func nightVfrCurrencyStatus() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.day], from: nightVfrCurrencyDate3, to: currentDate)
        if let daysSinceLastVFRFlight = components.day, daysSinceLastVFRFlight <= 90 {
            return "Current"
        } else {
            return "Expired"
        }
    }
    
    func ifrCurrencyStatus() -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.day], from: ifrCurrencyDate6, to: currentDate)
        if let daysSinceLastFIRFlight = components.day, daysSinceLastFIRFlight <= 180 {
            return "Current"
        } else {
            return "Expired"
        }
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
