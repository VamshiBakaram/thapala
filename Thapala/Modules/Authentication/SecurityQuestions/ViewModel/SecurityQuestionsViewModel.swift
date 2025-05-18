//
//  SecurityQuestionsViewModel.swift
//  Thapala
//
//  Created by ahex on 29/04/24.
//

import Foundation

class SecurityQuestionsViewModel: ObservableObject {
    @Published var selectedQuestion = "Select"
    @Published var answer = ""
    @Published var isShowQuestions = false
    @Published var isAddNewQuestion = false
    @Published var newQuestion = ""
    @Published var isNavigatePicktCode = false
    @Published var error: String?
    
    @Published var questions: [SecurityQuestion] = []
    @Published var isLoading = false
    
    private var selectedQuestionId: Int?

    
    init() {
        getQuestions()
    }
    
    func showQuestions() {
        self.isShowQuestions.toggle()
    }
    
    func showAddNewQuestion() {
        self.isAddNewQuestion.toggle()
    }
    
    func validate() {
        if selectedQuestion == "Select" {
            self.error = "Please select question or add question"
            return
        }
        if answer.isEmpty {
            self.error = "Please enter answer"
            return
        }
        saveQuestion()
    }
    
    func saveQuestion() {
        isLoading = true
        let parameters = SaveSecurityQuestion(questionId: selectedQuestionId ?? 0, securityAnswer: answer)
        NetworkManager.shared.request(type: SecurityQuestionResponseModel.self, endPoint: EndPoint.addQuestionAnswer, httpMethod: .post, parameters: parameters, isTokenRequired: false, isSessionIdRequited: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let _ = response.status {
                        self.error = response.message ?? ""
                    }else{
                        self.error = response.message ?? ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.isNavigatePicktCode = true
                        })
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let message):
                        self.error = message
                    case .sessionExpired(error: _ ):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func selecteQuestion(question: SecurityQuestion) {
        self.selectedQuestion = question.question ?? ""
        self.selectedQuestionId = question.id
    }
    
    func getQuestions() {
        NetworkManager.shared.request(type: SecurityQuestionsModel.self, endPoint: EndPoint.securityQuestions) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.questions = response.data ?? []
            case .failure(_):
                break
            }
        }
    }
}
