//
//  Ground.swift
//  AeroPlan
//
//  Created by Nguyen Vo on 8/22/23.
//
//  UI/UX implemented by Jovanni Garcia on 9/16/2023

import SwiftUI

struct GroundView: View {
	// In Swift, a struct is a lightweight data type that can contain properties and methods.
	// Identifiable is a protocol in SwiftUI. When a struct or class conforms to the Identifiable protocol, it must provide a property called id that uniquely identifies each instance of the struct or class. This is typically used when working with collections of data, such as in SwiftUI's List or ForEach views, to help SwiftUI understand which elements have changed and need to be updated.
	struct ButtonItem: Identifiable{
		// let id = UUID(): Here, you define a property named id of type UUID. A UUID (Universally Unique Identifier) is a randomly generated 128-bit value that is guaranteed to be unique. By assigning a new UUID to the id property, you ensure that each ButtonItem instance has a unique identifier.
		let id = UUID()
		let title: String
		let hexColor: UInt
		let imageName: String // Add imageName property for the button image
		let destination: String
		
		var fontColor: Color {
			return Color(hex: hexColor, alpha: 1.0)
		}
	}
	
	let buttons: [ButtonItem] = [
		ButtonItem(title:"Pre-flight", hexColor: 0xE2C285, imageName: "Preflight", destination: "Pre-flight"),
		ButtonItem(title: "Tools", hexColor: 0x8AC1E7, imageName: "Tools", destination: "Tools")
	]
	
	// FIX
	// custom font not working only font size
	let customFont = Font.custom("Geologica-Black", size: 49)
	
	var body: some View {
			NavigationView {
				// ZStack(color gradient, VStack(title, buttons
				ZStack{
					LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xE2C285, alpha:0.9), Color(hex: 0x8AC1E7, alpha: 0.9)]),
							   startPoint: .bottom,
							   endPoint: .top)
						.ignoresSafeArea()
					
					VStack {
						// Ground Mode Title add image font not plain text
						//Text("Ground Mode")
							//.font(customFont)
						Image("gm-title")
								    .resizable()
								    .aspectRatio(contentMode: .fit)
								    .padding(20)
						
						ForEach(buttons) { button in
							NavigationLink(destination: getViewForDestination(button.destination)) { // Updated destination
								ZStack{
									Image(button.imageName)	// Image
										.resizable()
										.aspectRatio(contentMode: .fit)
										.cornerRadius(10)
									
									Text(button.title)
										.foregroundColor(button.fontColor)
										.padding(.trailing, 100) // move text left by adding space to the right
										.font(customFont)
								}
							}
					}
					.padding(10)	// Space buttons from side edges
				}
			}
		}
	}
	// Helper function to determine the view based on destination string
	    private func getViewForDestination(_ destination: String) -> some View {
		  switch destination {
		  case "Pre-flight":
			return AnyView(PersonalMinimumsView())
		  case "Tools":
			return AnyView(GroundView())
		  default:
			return AnyView(EmptyView()) // Handle the default case or provide an appropriate view
		  }
	    }
}
		
struct GroundView_Previews: PreviewProvider {
    static var previews: some View {
	    GroundView()
    }
}


