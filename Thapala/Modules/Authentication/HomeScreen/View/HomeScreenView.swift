//
//  HomeScreenView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import SwiftUI

struct HomeScreenView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var homeScreenViewModel = HomeScreenViewModel()
    @ObservedObject var ConsoleviewModel = consoleviewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @State var Gettheme: String = ""
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack(spacing: 20) {
                        Spacer()
                        Button(action: {
                        }) {
                            Image("magnifyingglass")
                                .renderingMode(.template)
                                .font(Font.title.weight(.medium))
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        
                        NavigationLink(destination: MailComposeView().toolbar(.hidden)) {
                            Image("pencil")
                                .renderingMode(.template)
                                .font(Font.title.weight(.medium))
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        
                        Button(action: {
                        }) {
                            Image("bell")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .font(Font.title.weight(.medium))
                        }
                        
                        Button(action: {
                            withAnimation {
                                homeScreenViewModel.isMenuVisible.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .font(Font.title.weight(.medium))
                        }
                        .padding(.trailing, 15)
                        
                    }
                    .frame(height: 60)
                    .background(themesviewModel.currentTheme.colorPrimary)
                    Spacer()
                    
                    HStack {
                        Text("Welcome,")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                        Text("\(sessionManager.userName)!")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsBold, size: 14, relativeTo: .title))
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            homeScreenViewModel.isPlusBtn = true
                        }) {
                            Image("plus")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .background(themesviewModel.currentTheme.tabBackground)
                                .font(Font.title.weight(.medium))
                                .frame(width: 35 , height: 35)
                                .clipShape(.circle)
                        }
                        .padding(.trailing, 15)
                    }
                }
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear {
                    
                    // First, fetch settings data
                    if ConsoleviewModel.GetUserSettings.isEmpty {
                        ConsoleviewModel.getUserSettings()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let settings = ConsoleviewModel.GetUserSettings.first {
                            sessionManager.SelectedTheme = settings.theme
                        }
                      }
                    }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            if homeScreenViewModel.isMenuVisible {
                HomeMenuView(isSidebarVisible: $homeScreenViewModel.isMenuVisible)
            }
            if homeScreenViewModel.isPlusBtn {
                QuickAccessView(isQuickAccessVisible: $homeScreenViewModel.isPlusBtn)
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
