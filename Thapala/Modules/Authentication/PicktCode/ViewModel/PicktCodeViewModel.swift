//
//  PicktCodeViewModel.swift
//  Thapala
//
//  Created by ahex on 30/04/24.
//

import Foundation

class PicktCodeViewModel: ObservableObject {
    @Published var tCode: [String] = Array(repeating: "", count: 10)
    @Published var initialTCode = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var tCodeError: String = ""
    @Published var isDisplayError = false
    @Published var isNavigatePassword = false
    
    @Published var suggestedTCodes: [Int] = []
    @Published var isShowTCodes = false
    
    @Published var generateTCodeData:String = ""
    @Published var createTCodeData:String = ""
    
    init() {
            generateTCode()
        }
    
    func setTCode(code: String) {
        initialTCode = code
    }
    
    func setTCodeIndex(index: Int, code: String) {
        tCode[index] = code
    }
    
    func removeError() {
        self.isDisplayError = false
    }
    
    func selectetCode(code: Int) {
        for (codeIndex, codeValue) in String(code).enumerated() {
            tCode[codeIndex] = String(codeValue)
        }
    }
    
    func showtCodes() {
        self.isShowTCodes.toggle()
        self.isDisplayError = false
    }
    
    func validate() {
        if tCode.joined(separator: "").count == 0 {
            error = "Please enter tCode"
            return
        }
        if tCode.joined(separator: "").count != 10 {
            error = "Please enter 10 digit tCode"
            return
        }
        veriftTCode()
    }
    
    func submitValidate() {
        if tCode.joined(separator: "").count == 0 {
            error = "Please enter tCode"
            return
        }
        if tCode.joined(separator: "").count != 10 {
            error = "Please enter 10 digit tCode"
            return
        }
        createTCode()
    }
    
    func generateTCode(){
        self.isLoading = true
        NetworkManager.shared.request(type: GenerateTCodeModel.self, endPoint: EndPoint.generateTCode, httpMethod: .post, isSessionIdRequited: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    self.generateTCodeData = response.tCode ?? ""
                    self.tCode.append(self.generateTCodeData )
                    self.tCode.removeAll()
                    for character in self.generateTCodeData{
                               if let digit = character.wholeNumberValue {
                                   self.tCode.append("\(digit)")
                               }
                           }
                    self.veriftTCode()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let error):
                        DispatchQueue.main.async {
                            self.error = error
                        }
                    case .sessionExpired(error: _ ):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func veriftTCode() {
        self.isLoading = true
        let parameters = VerifytCode(tCode: tCode.joined(separator: ""))
        NetworkManager.shared.request(type: VerifytCodeModel.self, endPoint: EndPoint.verifytCode, httpMethod: .post, parameters: parameters, isTokenRequired: false, isSessionIdRequited: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let _ = response.status {
                        self.tCodeError = response.message ?? ""
                        self.suggestedTCodes = response.suggestions ?? []
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.isDisplayError = true
                            self.isShowTCodes = true
                        })
                        
                    }else{
                        self.error = response.message ?? ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.isNavigatePassword = false
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
    
    func createTCode(){
        self.isLoading = true
        let parameters = CreateTCode(tCode: tCode.joined(separator: ""))
        NetworkManager.shared.request(type: CreateTCodeModel.self, endPoint: EndPoint.createTCode, httpMethod: .post, parameters: parameters, isTokenRequired: false, isSessionIdRequited: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.createTCodeData = response.message ?? ""
                    self.isNavigatePassword = true
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
}
