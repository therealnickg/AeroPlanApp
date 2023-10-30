//
//  ATCView.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 10/7/23.
//

import SwiftUI

class AirTrafficComModel {
    private var questions: [Question]
    private var currentQuestionIndex: Int

    init(questions: [Question]) {
	  self.questions = questions
	  self.currentQuestionIndex = 0
    }

    func getCurrentQuestion() -> Question? {
	  guard currentQuestionIndex < questions.count else {
		return nil
	  }
	  return questions[currentQuestionIndex]
    }

    func checkAnswer(_ selectedAnswer: String) -> Bool {
	  guard let currentQuestion = getCurrentQuestion() else {
		return false
	  }
	  return selectedAnswer == currentQuestion.correctAnswer
    }

    func moveToNextQuestion() {
	  guard currentQuestionIndex < questions.count - 1 else {
		return
	  }
	  currentQuestionIndex += 1
    }
}
