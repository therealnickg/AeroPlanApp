//
//  PreflightView.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 10/14/23.
//

import SwiftUI

struct PreflightView: View {
	struct ButtonItem: Identifiable {
		let id = UUID()
		let title: String
		let destination: String
		let imageIcon: String
	}
    
	let buttons: [ButtonItem] = [
		ButtonItem(title: "IMSAFE Analysis",  destination: "IMSAFEAnalysisView", imageIcon: "ipsIcon"),
		ButtonItem(title: "Personal Minimums Tracker",  destination: "ExistingConditionsView", imageIcon: "backupinsIcon"),
		ButtonItem(title: "Currency (VFR & IFR) Tracker",  destination: "CurrencyView", imageIcon: "ipsIcon"),
        ButtonItem(title: "Suggested Altitude",  destination: "SuggestedAltitude", imageIcon: "ipsIcon"),
		ButtonItem(title: "Time Arrival",  destination: "TimeArrivalView", imageIcon: "movingmapIcon"),
        ButtonItem(title: "General Aircraft Preflight Checklist", destination: "GAPCView", imageIcon: "ipsIcon")
	]
	// Custom Font
	let customFont = Font.custom("Geologica-Light", size: 25)
	let customTitleFont = Font.custom("", size: 49)
    
    var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color(hex: 0x5EC9EC, alpha: 0.9), Color(hex: 0x0F2038, alpha: 0.9)]),
					 startPoint: .bottom,
					 endPoint: .top)
			  .ignoresSafeArea()
			
			ScrollView {
			VStack(spacing: 20) { // Adjust the spacing between buttons

				// Title Bar
				Text("Pre-Flight Mode")
					.font(customTitleFont)
					.foregroundColor(Color(hex: 0xFFFFFF, alpha: 1.0))

				// Buttons
				ForEach(buttons) { button in
				NavigationLink(destination: getViewForDestination(button.destination)) {
					ZStack {
						Image("sky-small")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.cornerRadius(10)
							.frame(maxWidth: .infinity) // Take up the entire width
							.opacity(0.3)
						Text(button.title)
							.font(customFont)
							.foregroundColor(Color(hex: 0x0F2038, alpha: 1.0))
							.padding(.trailing, 100) // Space buttons from side edges
						Image(button.imageIcon)
							.resizable()
							.frame(width: 50.0, height: 50.0)
							.padding(.leading, 250) // left side spacing from center
					}
					}
				}.overlay(
					RoundedRectangle(cornerRadius: 10)
					 .stroke(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x2A4156, alpha:0.9), Color(hex: 0x8ABACD, alpha: 0.8)]), startPoint: .top,
						  endPoint: .bottom), lineWidth: 8) // You can adjust lineWidth for border thickness
				 )
			}
			.padding(10) // Add padding around the VStack to center it
			}
		}
	}
    
	// Helper function to determine the view based on destination string
	private func getViewForDestination(_ destination: String) -> some View {
		switch destination {
		case "IMSAFEAnalysisView":
			return AnyView(IMSAFE_analysis())	// Change ToolsView()
		case "ExistingConditionsView":
			return AnyView(ExistingConditionsView())	// Change EmptyView()
		case "CurrencyView":
			return AnyView(CurrencyView())	// Change EmptyView()
		//case "AircraftPreflightView":
			//return AnyView(EmptyView())	// Change EmptyView()
        case "SuggestedAltitude":
            return AnyView(SuggestedAltitudeView())    // Change EmptyView()
		case "TimeArrivalView":
			return AnyView(FlightTimeCalculatorView())	// Change EmptyView()
        case "GAPCView":
            return AnyView(GAPCView())
		default:
			return AnyView(EmptyView()) // Handle the default case or provide an appropriate view
		}
	}
}

#Preview {
    PreflightView()
}
