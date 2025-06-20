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
            Group {
            if sessionManager.isShowSplashView {
                SplashView()
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            withAnimation {
                                sessionManager.isShowSplashView = false
                            }
                        })
                    })
            }else{
//                PostBoxView()
                if sessionManager.isShowLogin {
                    LoginView()
//                        .environmentObject(sessionManager)
                }else{
                    switch sessionManager.mainOption {
                    case .isMainView:
//                       HomeScreenView()
//                        HomeAwaitingView(imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person")
                        HomeAwaitingView(imageUrl: "")
//                            .environmentObject(sessionManager)
                    case .isNavigator:
                        NavigationView()
//                            .environmentObject(sessionManager)
                    }
                }
            }
          }
            .environmentObject(sessionManager)
        }
    }
}
