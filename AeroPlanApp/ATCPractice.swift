//
//  AirTrafficCom.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 9/27/23.
//
// Back end logic

import SwiftUI

struct Question {
    let text: String
    let correctAnswer: String
    let options: [String]
}

class AirTrafficCom: ObservableObject {
    @Published private var game: ATCGameViewModel

    init() {
	    let question1 = Question(text: "Traffic at 2 o'clock, 5 miles, same altitude.", correctAnswer: "2 o'clock", options: ["10 o'clock", "12 o'clock", "2 o'clock", "9 o'clock","3 o'clock", "3 o'clock","7 o'clock", "6 o'clock", "4 o'clock"])
	    let question2 = Question(text: "Traffic 12 o'clock, opposite direction, 2 miles, at 10,000 feet.", correctAnswer: "12 o'clock", options: ["10 o'clock", "12 o'clock", "2 o'clock", "9 o'clock","3 o'clock", "7 o'clock", "6 o'clock", "4 o'clock"])
	    
	  // Add more questions...

	  self.game = ATCGameViewModel(questions: [question1])
    }

    var currentQuestion: Question? {
	  game.getCurrentQuestion()
    }

    func loadNextQuestion() {
	  game.moveToNextQuestion()
	  objectWillChange.send()
    }

    func answerTapped(_ selectedAnswer: String) {
	  if game.checkAnswer(selectedAnswer) {
		print("Correct!")
	  } else {
		print("Wrong!")
	  }

	  loadNextQuestion()
    }
}
