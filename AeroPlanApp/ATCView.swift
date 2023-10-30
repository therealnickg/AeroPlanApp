//
//  AirTrafficView.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 10/1/23.
//
// front end

import SwiftUI

struct AirTrafficView: View {
    @StateObject private var airTrafficCom = AirTrafficCom()

    var body: some View {
	  NavigationView {
		VStack {
		    Text(airTrafficCom.currentQuestion?.text ?? "")
			  .font(.title)
			  .multilineTextAlignment(.center)
			  .padding()

		    Spacer()

		    VStack(spacing: 10) {
			  ForEach(0..<3) { row in
				HStack(spacing: 10) {
				    ForEach(0..<3) { col in
					  if let optionIndex = airTrafficCom.currentQuestion?.optionsIndex(row: row, col: col) {
						if !(row == 1 && col == 1) { // Not row 2, col 2
						    Button(action: {
							  airTrafficCom.answerTapped(airTrafficCom.currentQuestion?.options[optionIndex] ?? "")
						    }) {
							  Text(airTrafficCom.currentQuestion?.options[optionIndex] ?? "")
								.frame(width: 110, height: 80)
								.background(Color.blue)
								.foregroundColor(.white)
								.cornerRadius(8)
						    }
						} else {
						    Spacer() // Empty space for row 2, col 2
						}
					  }
				    }
				}
			  }
		    }

		    Spacer()
		}
		.padding()
		.navigationBarTitle("ATC Practice ")
	  }
	  .onAppear {
		airTrafficCom.loadNextQuestion()
	  }
    }
}

struct AirTrafficView_Previews: PreviewProvider {
    static var previews: some View {
	  AirTrafficView()
    }
}
