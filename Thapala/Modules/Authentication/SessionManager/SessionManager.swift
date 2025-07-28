//
//  SessionManager.swift
//  Thapala
//
//  Created by ahex on 22/04/24.
//

import Foundation
import SwiftUI

enum MainOption {
    case isMainView
}

class SessionManager: ObservableObject {
    @Published var isShowSplashView = true
    @AppStorage("isShowLogin") var isShowLogin = true
    @Published var mainOption: MainOption = .isMainView
    @AppStorage("sessionId") var sessionId = ""
    @AppStorage("token") var token = ""
    @AppStorage("userTcode") var userTcode = ""
    @AppStorage("userName") var userName = ""
    @AppStorage("lastName") var lastName = ""
    @AppStorage("userId") var userId: Int = 0
    @AppStorage("favoriteEmails") var favoriteEmailsData: Data = Data()
    @AppStorage("selectedTheme") var selectedTheme = ""
    @AppStorage("pin") var pin = ""
    @AppStorage("password") var password = ""
}
 
class UserDataManager {
    static let shared = UserDataManager()
    private init() {}
    @AppStorage("sessionId") var sessionId = ""
    @AppStorage("token") var token = ""
}
