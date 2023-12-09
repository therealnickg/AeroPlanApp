//
//  ToolsView.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 10/14/23.
//

import SwiftUI

struct ToolsView: View {
	struct ButtonItem: Identifiable {
		let id = UUID()
		let title: String
		let destination: String
		let imageIcon: String
	}
    
	let buttons: [ButtonItem] = [
		ButtonItem(title: "ATC - Communication Practice",  destination: "ATCView", imageIcon: "ipsIcon"),
		ButtonItem(title: "Traffic Pattern Visualization",  destination: "TrafficPatternVisualizationView", imageIcon: "backupinsIcon"),
		ButtonItem(title: "Experience Notes for Airports",  destination: "ExperienceNotesView", imageIcon: "ipsIcon"),
		ButtonItem(title: "METAR Decoder",  destination: "METARView", imageIcon: "lostcommIcon"),
		ButtonItem(title: "TAF Decoder",  destination: "TAFView", imageIcon: "movingmapIcon")
	]
	// Custom Font
	let customFont = Font.custom("", size: 30)
	let customTitleFont = Font.custom("", size: 50)
    
    var body: some View {
	  NavigationView {
		ZStack {
			// Background Color
			LinearGradient(gradient: Gradient(colors: [Color(hex: 0xE2C285, alpha: 0.9), Color(hex: 0x8AC1E7, alpha: 0.9)]),
					 startPoint: .bottom,
					 endPoint: .top)
			  .ignoresSafeArea()
		    
		    ScrollView {
			  VStack(spacing: 17) { // Adjust the spacing between buttons
				  
				  // Title Bar
				  Text("Tools")
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
    }
	// Helper function to determine the view based on destination string
	    private func getViewForDestination(_ destination: String) -> some View {
		  switch destination {
		  case "ATCView":
			return AnyView(ATCView())
		  case "TrafficPatternVisualizationView":
			return AnyView(EmptyView())	// Change EmptyView()
		  case "ExperienceNotesView":
			return AnyView(EmptyView())	// Change EmptyView()
		  case "METARView":
			return AnyView(METARView())
		  case "TAFView":
			return AnyView(TafView())
		  default:
			return AnyView(EmptyView()) // Handle the default case or provide an appropriate view
		  }
	    }
}


#Preview {
    ToolsView()
}
