//
//  ATCPractice.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 9/27/23.
//
// Back end logic

import SwiftUI

// Questions
struct Question {
	let text: String
	let correctAnswer: String
	let options: [String]
}

class ATCPractice: ObservableObject {
	@Published private var game: ATCGameViewModel
	@Published var score: Int = 0
	@Published var isQuizCompleted: Bool = false

	init() {
		let question1 = Question(text: "Traffic at 2 o'clock, 5 miles, same altitude.", correctAnswer: "2", options: ["10", "12", "2", "9","blank", "3","7", "6", "4"])
		let question2 = Question(text: "Traffic 12 o'clock, opposite direction, 2 miles, at 10,000 feet.", correctAnswer: "12", options: ["10", "12", "2", "9","blank", "3","7", "6", "4"])
		let question3 = Question(text: "Traffic at 9 o'clock, turning southeast, altitude indicates 8,000 feet.", correctAnswer: "9", options: ["10", "12", "2", "9","blank", "3","7", "6", "4"])
		let question4 = Question(text: "Traffic at 10 o'clock, converging, altitude unknown.", correctAnswer: "10", options: ["10", "12", "2", "9","blank", "3","7", "6", "4"])
		let question5 = Question(text: "Traffic at 2 o'clock, slightly below, type unknown.", correctAnswer: "2", options: ["10", "12", "2", "9","blank", "3","7", "6", "4"])
		let question6 = Question(text: "Caution, flock of birds 12 o'clock, low altitude.", correctAnswer: "12", options: ["10", "12", "2", "9","blank", "3","7", "6", "4"])
		let question7 = Question(text: "Traffic at 4 o'clock, climbing through 6,000 feet.", correctAnswer: "4", options: ["10", "12", "2", "9","blank", "3","7", "6", "4"])

		// Add more questions...

		self.game = ATCGameViewModel(questions: [question1, question2, question3, question4, question5, question6, question7])
	}

	var currentQuestion: Question? {
		game.getCurrentQuestion()
	}
	
	var currentQuestionIndex: Int {
		return game.currentQuestionIndex
	}

	// LOADS NEXT QUESTION
	func loadNextQuestion() {
		if !isQuizCompleted {
				game.moveToNextQuestion()
				isQuizCompleted = game.getCurrentQuestion() == nil
				objectWillChange.send()
			}
	}

    func answerTapped(_ selectedAnswer: String) {
		print("Answer tapped: \(selectedAnswer)")
		if game.checkAnswer(selectedAnswer) {
			print("Console test: Correct!")
			score += 1
			print("Score: \(score)/7")
			// loads next Q if correct A choosen
			//loadNextQuestion()
		} else {
			print("Console test: Wrong!")
			print("Score: \(score)/7")
		}
		// loads next Q regardless of A choosen. Use for scoring system
		loadNextQuestion()
		// Check for quiz completion after moving to the next question
			if currentQuestion == nil {
				isQuizCompleted = true
				objectWillChange.send()
			}
    }
}
