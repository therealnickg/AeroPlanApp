//
//  ATCGameViewModel.swift
//  AeroPlanApp
//
//  Created by Jovanni Garcia on 10/7/23.
//
// game logic

import SwiftUI

extension Question {
	func optionsIndex(row: Int, col: Int) -> Int? {
		let index = row * 3 + col
		return index < options.count ? index : nil
    }
}

class ATCGameViewModel {
    private var questions: [Question]
    var currentQuestionIndex: Int

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
				print("Reached the end of questions. Current index: \(currentQuestionIndex)")  // Add this line
				return
			}
			currentQuestionIndex += 1
			print("Moved to the next question. New index: \(currentQuestionIndex)")  // Add this line
		}
}
