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
	@StateObject private var atcPractice = ATCPractice()
	@State private var answerResult: String?
	// Create an instance of AVSpeechSynthesizer to handle the text-to-speech conversion.
	private let speechSynthesizer = AVSpeechSynthesizer()
	@State private var showAlert: Bool = false
	@Environment(\.presentationMode) var presentationMode
	@State private var isQuizCompleted: Bool = false

	var body: some View {
		NavigationView {
			VStack(spacing: 50) {
				// Display Question Test field
				Text(atcPractice.currentQuestion?.text ?? "")
					  .font(.title)
					  .multilineTextAlignment(.center)
					  .padding()
				// Text-to-Speech Button
				Button(action: readQuestion) {
					Image(systemName: "speaker.3.fill")
						.padding()
						.background(LinearGradient(gradient: Gradient(colors:  [Color(hex: 0xFB91BD, alpha:0.8), Color(hex: 0x4B64A5, alpha: 0.9)]), startPoint: .bottom,endPoint: .top))
						.foregroundColor(.white)
						.clipShape(Circle())
						.overlay(
							Circle()
								.stroke(Color.black, lineWidth: 2) // You can adjust lineWidth for border thickness
							)
				}.onAppear(perform: readQuestion)

				Spacer()

				VStack(spacing: 10) {
					ForEach(0..<3) { row in
						HStack(spacing: 10) {
							ForEach(0..<3) { col in
								if let optionIndex = atcPractice.currentQuestion?.optionsIndex(row: row, col: col) {
									if !(row == 1 && col == 1) { // Not center cube
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
									      Spacer() // Empty space for row 2, col 2
										if let result = answerResult {
											  Text(result)
												.foregroundColor(result == "Correct!" ? .green : .red)
												.padding()
										}
									}
								}
							}
						}
					}
				}
			Spacer()
		}
			.padding()
			.background(Image("atcp-background-img")
				.resizable()
				.ignoresSafeArea())
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
