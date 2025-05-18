//
//  ResetForgotPasswordView.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/05/24.
//

import SwiftUI

struct ResetForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var resetForgotPasswordViewModel = ResetForgotPasswordViewModel()
    let resetToken:String
     var body: some View {
        ZStack {
            Image("confirm-bg")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 8) {
                VStack(spacing: 8) {
                    Text("Reset Password")
                        .font(.custom(.poppinsMedium, size: 22, relativeTo: .title))
                        .foregroundStyle(Color.black)
                        .padding(.top, 25)
                        .padding(.horizontal, 10)
                    PasswordTextField(text: $resetForgotPasswordViewModel.password, showPassword: $resetForgotPasswordViewModel.isShowPassword, placeHolder: "Password")
                        .padding(.horizontal, 10)
                        .padding(.top, 25)
                    PasswordTextField(text: $resetForgotPasswordViewModel.confirmPassword, showPassword: $resetForgotPasswordViewModel.isShowConfirmPassword, placeHolder: "Confirm password")
                        .padding(.horizontal, 10)
                    Button(action: {
                        resetForgotPasswordViewModel.validate(resetToken: resetToken)
                    }, label: {
                        if resetForgotPasswordViewModel.isLoading {
                            CustomProgressView()
                        }else{
                            ThemeButtonLabel(title: "Next")
                                .padding(.horizontal, 10)
                        }
                    })
                    .padding(.top, 16)
                    .padding(.bottom, 25)
                }
                .background(Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 15.3))
                .padding(.horizontal, 25)
                .shadow(radius: 5)
            }
        }
        .overlay(alignment: .topLeading) {
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
        }
        .navigationDestination(isPresented: $resetForgotPasswordViewModel.isNavigateSuccess) {
            PasswordSuccessView()
                .toolbar(.hidden)
        }
        .toast(message: $resetForgotPasswordViewModel.error)
    }
}

#Preview {
    ResetForgotPasswordView(resetToken: "1213")
}
