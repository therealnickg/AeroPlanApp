//
//  Air.swift
//  AeroPlan
//


import SwiftUI

struct AirView: View {
	struct ButtonItem: Identifiable {
		let id = UUID()
		let title: String
		let destination: String
		let imageIcon: String
	}
    
	let buttons: [ButtonItem] = [
		ButtonItem(title: "Lost Communication Emergency Button",  destination: "LostCommunicationView", imageIcon: "lostcommIcon"),
		ButtonItem(title: "Backup Pilot Instructions",  destination: "BackupInstructionsView", imageIcon: "backupinsIcon"),
		ButtonItem(title: "Important Procedure Section",  destination: "ImportantProcedureView", imageIcon: "ipsIcon"),
		ButtonItem(title: "Moving Map",  destination: "MovingMapView", imageIcon: "movingmapIcon")
	]
	// Custom Font
	let customFont = Font.custom("Geologica-Light", size: 30)
    
    var body: some View {
		ZStack {
		    LinearGradient(gradient: Gradient(colors: [Color(hex: 0xE2C285, alpha: 0.9), Color(hex: 0x8AC1E7, alpha: 0.9)]),
					 startPoint: .bottom,
					 endPoint: .top)
			  .ignoresSafeArea()
		    
		    ScrollView {
			  VStack(spacing: 20) { // Adjust the spacing between buttons
				Image("fm-title")
				    .resizable()
				    .aspectRatio(contentMode: .fit)
				    .padding(20)
				
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
							  .padding(.leading, 250)
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
		case "LostCommunicationView":
			return AnyView(EmptyView())	// Change EmptyView()
		case "BackupInstructionsView":
			return AnyView(EmptyView())	// Change EmptyView()
		case "ImportantProcedureView":
			return AnyView(EmptyView())	// Change EmptyView()
		case "MovingMapView":
			return AnyView(NearestWaypoint())	// Change ToolsView()
		default:
			return AnyView(EmptyView()) // Handle the default case or provide an appropriate view
		}
	}
}

struct AirView_Previews: PreviewProvider {
    static var previews: some View {
		AirView()
    }
}

