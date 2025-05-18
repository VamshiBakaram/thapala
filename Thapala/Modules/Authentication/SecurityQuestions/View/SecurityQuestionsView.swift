//
//  SecurityQuestionsView.swift
//  Thapala
//
//  Created by ahex on 29/04/24.
//

import SwiftUI

struct SecurityQuestionsView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var securityQuestionsViewModel = SecurityQuestionsViewModel()

    var body: some View {
        ZStack {
            Image("security-bg")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Security Question  (s) below. These \n questions will help us verPify your identity \n if you forget your passcode.")
                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                    .foregroundStyle(Color.white)
                    .padding(.top, 25)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 25)
                VStack(spacing: 8) {
                  //  DropdownButtonLabel(title: $securityQuestionsViewModel.selectedQuestion, placeHolder: "Security Question")
                    GreyBgDropdownButtonLabel(title: $securityQuestionsViewModel.selectedQuestion, placeHolder: "Security Question")
                    .padding(.horizontal, 10)
                    .padding(.top, 25)
                    .onTapGesture {
                        securityQuestionsViewModel.showQuestions()
                    }
                  //  FloatingTextField(text: $securityQuestionsViewModel.answer, placeHolder: "Security Answer", allowedCharacter: .defaultType)
                    GreyBgFloatingTextField(text: $securityQuestionsViewModel.answer, placeHolder: "Security Answer", allowedCharacter: .defaultType, textColorCode: Color.white)
                        .padding(.horizontal, 10)
                    Button(action: {
                        securityQuestionsViewModel.validate()
                    }, label: {
                        ThemeButtonLabel(title: "Submit")
                            .padding(.horizontal, 10)
                    })
                    .padding(.top, 16)
                    .padding(.bottom, 25)
                }
                .background(Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 15.3))
                .padding(.horizontal, 25)
                .shadow(radius: 5)
            }
        }
        .overlay(alignment: .topLeading) {
            HStack {
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    HStack(alignment: .center, spacing: 0) {
                        Image("back_icon")
                            .padding(.top, 6)
                        Text("Back")
                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                            .foregroundStyle(Color.white)
                    }
                    .padding(.leading)
                })
                Spacer()
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Text("Skip")
                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                        .foregroundStyle(Color.white)
                })
                .padding(.trailing)
            }
        }
        .sheet(isPresented: $securityQuestionsViewModel.isShowQuestions, content: {
            if securityQuestionsViewModel.isShowQuestions {
                QuestionsView(securityQuestionsViewModel: securityQuestionsViewModel)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            }
        })
        .navigationDestination(isPresented: $securityQuestionsViewModel.isNavigatePicktCode) {
            if securityQuestionsViewModel.isNavigatePicktCode {
                PicktCodeView()
                    .toolbar(.hidden)
            }
        }
        .toast(message: $securityQuestionsViewModel.error)
    }
}

#Preview {
    SecurityQuestionsView()
}
