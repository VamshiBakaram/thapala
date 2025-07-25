//
//  TabViewNavigator.swift
//  Thapala
//
//  Created by Ahex-Guest on 24/03/25.
//

import SwiftUI

struct TabViewNavigator: View {
    @ObservedObject var consoleViewModel = ConsoleViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @State private var isMailViewActive = false
    @State private var isBluePrintViewActive = false
    @State private var isQuickAccessViewActive = false
    @State private var isPlannerViewActive = false
    @State private var isConsoleViewActive = false
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var AwaitingView: Bool = false
    @State private var markAs : Int = 0
    var body: some View {
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Button(action: {
                            if !isMailViewActive {
                                isMailViewActive = true
                            }
                        }) {
                            Image("mailicon")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isMailViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                        }
                        Text("Mail")
                            .font(.system(size: 16))
                            .foregroundColor(isMailViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .navigationDestination(isPresented: $isMailViewActive) {
                        HomeAwaitingView(imageUrl: "")
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Button(action: {
                            if !isBluePrintViewActive {
                                isBluePrintViewActive = true
                            }
                        }) {
                            Image("plannerImage")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isBluePrintViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                        }
                        Text("Blue Print")
                            .font(.system(size: 12))
                            .foregroundColor(isBluePrintViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .navigationDestination(isPresented: $isBluePrintViewActive) {
                        BlueprintView(imageUrl: "")
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Button(action: {
                            if !isQuickAccessViewActive {
                                isQuickAccessViewActive = true
                            }
                        }) {
                            Image("QuickAcces")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isQuickAccessViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                        }
                        Text("Quick Access")
                            .font(.system(size: 12))
                            .foregroundColor(isQuickAccessViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .navigationDestination(isPresented: $isQuickAccessViewActive) {
                        MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView, conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars, markAs: $markAs)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Button(action: {
                            if !isPlannerViewActive {
                                isPlannerViewActive = true
                            }
                        }) {
                            Image("plannerIcon")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isPlannerViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                        }
                        Text("Planner")
                            .font(.system(size: 12))
                            .foregroundColor(isPlannerViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .navigationDestination(isPresented: $isPlannerViewActive) {
                        HomePlannerView()
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Button(action: {
                            if !isConsoleViewActive {
                                isConsoleViewActive = true
                            }
                        }) {
                            Image("ConsoleIcon")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isConsoleViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                        }
                        Text("Console")
                            .font(.system(size: 12))
                            .foregroundColor(isConsoleViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .navigationDestination(isPresented: $isConsoleViewActive) {
                        ConsoleView(selectedID: consoleViewModel.selectedID)
                    }
                }
                .background(themesviewModel.currentTheme.bottomSheetBG)
            }
        
    }
}



#Preview {
    TabViewNavigator()
}

