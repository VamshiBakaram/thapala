//
//  ComposeEmailEncriptedViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import Foundation

class ComposeEmailEncriptedViewModel:ObservableObject{
    @Published var error:String?
    @Published var isLoading:Bool = false
    @Published var password = ""
    @Published var hint = ""
    
    @Published var isPasswordProtected:Bool = false
    
    func validate(){
        if password.isEmpty {
            error = "Please enter Password"
            return
        }
        if hint.isEmpty {
            error = "Please enter Hint"
            return
        }
        ComposeEmailData.shared.passwordHint = hint
        ComposeEmailData.shared.passwordHash = password
        ComposeEmailData.shared.isPasswordProtected = true
        self.isPasswordProtected = true
    }
}


class ComposeEmailData{
    var passwordHint:String = ""
    var isPasswordProtected:Bool = false
    var passwordHash:String = ""
    var timeStap:Double = 0.0
    var isScheduleCreated:Bool = false
    static let shared = ComposeEmailData()
    private init(){
        
    }
}
