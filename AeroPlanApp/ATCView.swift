//
//  ATCView.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 10/1/23.
//
// front end

import SwiftUI
import AVFoundation

struct ATCView: View {
	@StateObject private var atcPractice = ATCQuestion()
	@State private var answerResult: String?
	// Create an instance of AVSpeechSynthesizer to handle the text-to-speech conversion.
	private let speechSynthesizer = AVSpeechSynthesizer()
	@State private var showAlert: Bool = false
	@Environment(\.presentationMode) var presentationMode
	@State private var isQuizCompleted: Bool = false
	@State private var scale: CGFloat = 1.0
	@State var trigger = 0

	var body: some View {
		NavigationView {
			VStack(spacing: 50) {
				/* Display Question Test field
				Text(atcPractice.currentQuestion?.text ?? "")
					  .font(.title)
					  .multilineTextAlignment(.center)
					  .padding()*/
				
				// Text-to-Speech Button
				Spacer()
				Button(action: readQuestion) {
					Image(systemName: "speaker.wave.3").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
						// Effect for iOS 17 only, not working
						//.scaleEffect(1)
						//.symbolEffect(.bounce.up.byLayer, value: trigger)
						.padding()
						.background(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xFB91BD, alpha:0.8), Color(hex: 0x4B64A5, alpha: 0.9)]), startPoint: .bottom,endPoint: .top))
						.foregroundColor(.white)
						.clipShape(Circle())
						.overlay(
							Circle()
								.stroke(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0x4B64A5, alpha:0.8), Color(hex: 0xFB91BD, alpha: 0.9)]), startPoint: .bottom,endPoint: .top), lineWidth: 2) // You can adjust lineWidth for border thickness
							)
				}.onAppear(perform: readQuestion)
				

				VStack(spacing: 15) {
					ForEach(0..<3) { row in
						HStack(spacing: 15) {
							ForEach(0..<3) { col in
								if let optionIndex = atcPractice.currentQuestion?.optionsIndex(row: row, col: col) {
									// Dont create a button in center
									if !(row == 1 && col == 1) {
										// Button Logic
										Button(action: {
											let selectedAnswer = atcPractice.currentQuestion?.options[optionIndex] ?? ""
											atcPractice.answerTapped(selectedAnswer)
												answerResult = nil
											// Check if the quiz is completed
												if atcPractice.currentQuestionIndex >= 6 { // Assuming you have 7 questions, indexed 0 through 6
													isQuizCompleted = true
												}
											
										}) {
											// Button UI
											Text(atcPractice.currentQuestion?.options[optionIndex] ?? "")
												.frame(width: 110, height: 90)
												.background(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xFB91BD, alpha:0.6), Color(hex: 0x4B64A5, alpha: 0.9)]), startPoint: .bottom,endPoint: .top))
												.foregroundColor(.white)
												.cornerRadius(8)
												.overlay(
												RoundedRectangle(cornerRadius: 8)
													.stroke(Color.black, lineWidth: 2) // You can adjust lineWidth for border thickness
											)
										}
									} else {
									      Spacer() // Empty space for row 1, col 1
										
										// DELETE
										/*if let result = answerResult {
											  Text(result)
												.foregroundColor(result == "Correct!" ? .green : .red)
												.padding()
										}*/
									}
								}
							}
						}
					}
				}
			Spacer()
		}
			.padding()
			
			// Background Image
			.background(Image("atcp-background-img")
				.resizable()
				.ignoresSafeArea())
			
			// Grade Alert
			.alert(isPresented: $isQuizCompleted) {
				Alert(title: Text("Quiz Completed!"),
					message: Text("Your score is \(atcPractice.score)/7"),
					dismissButton: .default(Text("Return to Tools")) {
						presentationMode.wrappedValue.dismiss()
					}
				)
			}
		}
	}
	// Function Reads the Question
	func readQuestion() {
		for voice in AVSpeechSynthesisVoice.speechVoices() {
			print("Voice: \(voice.name), Identifier: \(voice.identifier), Language: \(voice.language)")
		}
		do {
			try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print("Failed to set up audio session: \(error)")
			return
		}
		if speechSynthesizer.isSpeaking {
			speechSynthesizer.stopSpeaking(at: .immediate)
		}
		if let questionText = atcPractice.currentQuestion?.text {
			let speechUtterance = AVSpeechUtterance(string: questionText)
			speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
			//speechUtterance.rate = 1
			//speechUtterance.pitchMultiplier = 0.86
			speechUtterance.volume = 1
			speechSynthesizer.speak(speechUtterance)
		}
	}
}

struct ATCView_Previews: PreviewProvider {
	static var previews: some View {
		ATCView()
	}
}
