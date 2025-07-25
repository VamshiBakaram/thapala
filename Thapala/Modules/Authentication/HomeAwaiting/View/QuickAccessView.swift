//
//  QuickAccessView.swift
//  Thapala
//
//  Created by Ahex-Guest on 24/06/24.
//

import SwiftUI
struct QuickAccessView: View {
    @Environment(\.presentationMode) var closeView
    @StateObject var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var themesviewModel = themesViewModel()
    @Binding var isQuickAccessVisible: Bool
//    @Binding var homeAwaitingViewModel: Bool
    
    var body: some View {
        ZStack {
            themesviewModel.currentTheme.windowBackground
                .ignoresSafeArea()
                .onTapGesture {
                    isQuickAccessVisible = false
                }
            
            VStack(alignment: .trailing, spacing: 0) {
                Spacer()
                
                HStack(spacing: 5) {
                    Spacer()
                    Text("New Messages")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom("Poppins-Regular", size: 14, relativeTo: .title))
                    Button {
                        if !homeAwaitingViewModel.isComposeEmail {
                            homeAwaitingViewModel.isComposeEmail = true
//                            isQuickAccessVisible = true
                        }
                    } label: {
                        Image("pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24) // Size of the image itself
                            .padding() // Optional: add padding inside the button
                            .background(themesviewModel.currentTheme.colorAccent)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .clipShape(Circle())
                            .padding(.trailing,10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .fullScreenCover(isPresented: $homeAwaitingViewModel.isComposeEmail, onDismiss: {
                        homeAwaitingViewModel.isComposeEmail = false
                        isQuickAccessVisible = false
                    }) {
                        MailComposeView()
                    }
                }
                Spacer()
                    .frame(height: 15)


                
                HStack(spacing: 5) {
                    Text("New Event")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                    Button {
                    } label: {
                        Image("event")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24) // Size of the image itself
                            .padding() // Optional: add padding inside the button
                            .background(themesviewModel.currentTheme.colorAccent)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .clipShape(Circle())
                            .padding(.trailing,10)
                    }
                }
                Spacer()
                    .frame(height: 15)
                
                HStack(spacing: 5) {
                    Text("New Chat")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                    Button {
                    } label: {
                        Image("chat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24) // Size of the image itself
                            .padding() // Optional: add padding inside the button
                            .background(themesviewModel.currentTheme.colorAccent)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .clipShape(Circle())
                            .padding(.trailing,10)
                    }
                }
                Spacer()
//                Button {
//                    isQuickAccessVisible = false
//                } label: {
//                    Image("close")
//                }
            }
            .padding(.bottom, 10)
        }
        .frame(width: 220, height: 250)
    }
//        .frame(width: .infinity, height: .infinity)
//        .background(Color.black)
}
#Preview {
    QuickAccessView(isQuickAccessVisible: .constant(true))
}
