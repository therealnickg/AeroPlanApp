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
		ButtonItem(title: "Personal Minimums Tracker",  destination: "PersonalMinimumsView", imageIcon: "backupinsIcon"),
		ButtonItem(title: "Currency (VFR & IFR) Tracker",  destination: "CurrencyView", imageIcon: "ipsIcon"),
		ButtonItem(title: "Aircraft Preflight",  destination: "AircraftPreflightView", imageIcon: "lostcommIcon"),
		ButtonItem(title: "Time Arrival",  destination: "TimeArrivalView", imageIcon: "movingmapIcon")
	]
	// Custom Font
	let customFont = Font.custom("Geologica-Light", size: 30)
	let customTitleFont = Font.custom("", size: 49)
    
    var body: some View {
		ZStack {
			// Background Color
			LinearGradient(gradient: Gradient(colors: [Color(hex: 0xE2C285, alpha: 0.9), Color(hex: 0x8AC1E7, alpha: 0.9)]),
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
						Text(button.title)
							.font(customFont)
							.foregroundColor(Color(hex: 0xE2C285, alpha: 1.0))
							.padding(.trailing, 100) // Space buttons from side edges
						Image(button.imageIcon)
							.resizable()
							.frame(width: 50.0, height: 50.0)
							.padding(.leading, 250) // left side spacing from center
					}
					}
				}
			}
			.padding(10) // Add padding around the VStack to center it
			}
		}
	}
    
	// Helper function to determine the view based on destination string
	private func getViewForDestination(_ destination: String) -> some View {
		switch destination {
		case "IMSAFEAnalysisView":
			return AnyView(EmptyView())	// Change ToolsView()
		case "PersonalMinimumsView":
			return AnyView(PersonalMinimumsView())	// Change EmptyView()
		case "CurrencyView":
			return AnyView(EmptyView())	// Change EmptyView()
		case "AircraftPreflightView":
			return AnyView(EmptyView())	// Change EmptyView()
		case "TimeArrivalView":
			return AnyView(FlightTimeCalculatorView())	// Change EmptyView()
		default:
			return AnyView(EmptyView()) // Handle the default case or provide an appropriate view
		}
	}
}

#Preview {
    PreflightView()
}
