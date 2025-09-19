//
//  SecurityAnswerView.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/05/24.
//

import SwiftUI

struct SecurityAnswerView: View {
    
    @ObservedObject var securityAnswerViewModel:SecurityAnswerViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var verifyCodeViewModel:VerifyCodeViewModel
    let question:String
    
    init(tCode:String,question:String,verifyCodeViewModel:VerifyCodeViewModel){
        self._securityAnswerViewModel = ObservedObject(wrappedValue: SecurityAnswerViewModel(tCode: tCode))
        self.question = question
        self.verifyCodeViewModel = verifyCodeViewModel
    }
    
    var body: some View {
        ZStack {
            Color.themeColor
                .ignoresSafeArea()
            Image("reset-bg-image")
                .resizable()
                .ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("back")
                            .font(.largeTitle)
                            .padding(.leading,15)
                    }
                    Text("Back")
                        .foregroundColor(Color.white)
                    Spacer()
                }
                Spacer()
            }
            VStack{
                Text("Here’s the Security Question you gave us when you were setting up your account.")
                    .multilineTextAlignment(.center)
                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 25)
                
                Text(question)
                    .font(.custom(.poppinsMedium, size: 18, relativeTo: .title))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 25)
                    .padding()

                VStack(spacing: 8) {
                    GreyBgFloatingTextField(text: $securityAnswerViewModel.securityAnswer, placeHolder: "Security Answer", allowedCharacter: .defaultType, textColorCode: Color.white)
                        .padding(.horizontal)
                        .padding(.top,25)
                        .overlay {
                            HStack{
                                Spacer()
                                Button(action: {
                                    securityAnswerViewModel.isshowPassword.toggle()
                                }, label: {
                                    Image(systemName: securityAnswerViewModel.isshowPassword ? "eye.slash": "eye")
                                        .foregroundColor(Color.white)
                                })
                            }
                            .padding(.trailing,35)
                            .padding(.top,25)
                        }
                    
                    Button(action: {
                        securityAnswerViewModel.validate()
                    }, label: {
                        ThemeButtonLabel(title: "Submit")
                    })
                    .padding(.top, 16)
                    .padding(.bottom, 25)
                    .padding([.leading,.trailing],20)
                }
                .background(Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 15.3))
                .padding(.horizontal, 25)
            }
        }
        .navigationDestination(isPresented: $securityAnswerViewModel.navigateToResetPass) {
            ResetForgotPasswordView(resetToken: securityAnswerViewModel.resetToken ).toolbar(.hidden)
        }
        .toast(message: $securityAnswerViewModel.error)
    }
}

#Preview {
    SecurityAnswerView(tCode: "123", question: "What", verifyCodeViewModel: VerifyCodeViewModel(tCode: "131"))
}

