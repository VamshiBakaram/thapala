//
//  ChangePasswordView.swift
//  Thapala
//
//  Created by ahex on 30/04/24.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var changePasswordViewModel = ChangePasswordViewModel()
    let tCode: String
    
    var body: some View {
        ZStack {
            Image("confirm-bg")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 8) {
                Text("Your tCode has been created successfully \(tCode)")
                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
                Text("Create password to register")
                    .font(.custom(.poppinsMedium, size: 17, relativeTo: .title))
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 22)
                VStack(spacing: 8) {
                    PasswordTextField(text: $changePasswordViewModel.password, showPassword: $changePasswordViewModel.isShowPassword, placeHolder: "Password")
                        .padding(.horizontal, 10)
                        .padding(.top, 25)
                    PasswordTextField(text: $changePasswordViewModel.confirmPassword, showPassword: $changePasswordViewModel.isShowConfirmPassword, placeHolder: "Confirm password")
                        .padding(.horizontal, 10)
                    Button(action: {
                        changePasswordViewModel.validate()
                    }, label: {
                        if changePasswordViewModel.isLoading {
                            CustomProgressView()
                        }else{
                            ThemeButtonLabel(title: "Register")
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
        .navigationDestination(isPresented: $changePasswordViewModel.isNavigateSuccess) {
            PasswordCreatedSuccessView()
                .toolbar(.hidden)
        }
        .toast(message: $changePasswordViewModel.error)
    }
}

#Preview {
    ChangePasswordView(tCode: "123456")
}

enum isNavigatingFrom{
    case fromTcode
    case passwordRecovery
}
