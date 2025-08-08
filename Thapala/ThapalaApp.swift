//
//  ThapalaApp.swift
//  Thapala
//
//  Created by ahex on 22/04/24.
//

import SwiftUI

@main
struct ThapalaApp: App {
    @StateObject var sessionManager = SessionManager()
        var body: some Scene {
        WindowGroup {
            if sessionManager.isShowSplashView {
                SplashView()
                    .environmentObject(sessionManager)
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            withAnimation {
                                sessionManager.isShowSplashView = false
                            }
                        })
                    })
            }else{
                if sessionManager.isShowLogin {
                    LoginView()
                        .environmentObject(sessionManager)
                }else{
                    HomeRecordsView(imageUrl: "")
//                    HomeNavigatorView(imageUrl: "")
//                    HomeAwaitingView(imageUrl: "")
                            .environmentObject(sessionManager)
                }
            }
        }
    }
}
