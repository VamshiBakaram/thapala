//
//  LoginView.swift
//  Thapala
//
//  Created by ahex on 22/04/24.
//

import SwiftUI

struct LoginView: View {
    
    @FocusState private var otpFocus: Int?
    @StateObject private var loginViewModel = LoginViewModel()
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        NavigationStack {
            GeometryReader(content: { reader in
                ZStack {
                    Image("background")
                        .resizable()
                        .ignoresSafeArea()
                    VStack(spacing: 16) {
                        Text("Sign In")
                            .font(.custom(.poppinsBold, size: 22, relativeTo: .title))
                            .foregroundStyle(Color.black)
                            .padding(.top, 25)
                        VStack(alignment: .leading) {
                            Text("tCode")
                                .foregroundStyle(Color.grayColor)
                            HStack(spacing: 2) {
                                ForEach(0..<10, id: \.self) { index in
                                    TextField("", text: $loginViewModel.tCode[index], onEditingChanged: { editing in
                                        if editing {
                                            loginViewModel.setTCode(code: loginViewModel.tCode[index])
                                        }
                                    })
                                    .keyboardType(.numberPad)
                                    .frame(width: reader.size.width * 0.078, height: reader.size.width * 0.078)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5.53)
                                            .stroke(Color.grayColor)
                                    )
                                    .multilineTextAlignment(.center)
                                    .focused($otpFocus, equals: index)
                                    .tag(index)
                                    .onChange(of: loginViewModel.tCode[index]) { newValue in
                                        if !newValue.isEmpty {
                                            if newValue.count > 1 {
                                                let currentValue = Array(newValue)
                                                if let firstChar = currentValue.first {
                                                    if firstChar == Character(loginViewModel.initialTCode) {
                                                        loginViewModel.setTCodeIndex(index: index, code: String(currentValue.suffix(1)))
                                                    } else {
                                                        loginViewModel.setTCodeIndex(index: index, code: String(currentValue.prefix(1)))
                                                    }
                                                }
                                            }
                                            if index == 9 {
                                                otpFocus = nil
                                            } else {
                                                otpFocus = (otpFocus ?? 0) + 1
                                            }
                                        } else {
                                            otpFocus = (otpFocus ?? 0) - 1
                                        }
                                    }

                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        FloatingTextField(text: $loginViewModel.password, placeHolder: "Password", allowedCharacter: .defaultType)
                            .padding(.horizontal, 10)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                loginViewModel.forgotUserData()
                            }, label: {
                                Text("Forgot Passcode?")
                                    .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                    .foregroundStyle(Color.themeColor)
                                    .padding(.trailing, 10)
                            })
                        }
                        if loginViewModel.isLoading {
                            CustomProgressView()
                        }else{
                            Button(action: {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                loginViewModel.validate {
                                    sessionManager.isShowLogin = false
                                }
                            }, label: {
                                ThemeButtonLabel(title: "Sign in")
                                    .padding(.horizontal, 10)
                            })
                        }
                        HStack(alignment: .center, spacing: 2) {
                            Text("Don’t have an account?")
                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title2))
                                .foregroundStyle(Color.black)
                            Text("Create Account")
                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title2))
                                .foregroundStyle(Color.themeColor)
                                .onTapGesture {
                                    loginViewModel.navigate()
                                }
                        }
                        .padding(.top, 4)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 22)
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15.3))
                    .padding(.horizontal, 25)
                    .shadow(radius: 5)
                    .frame(height: reader.size.height * 0.5)
                    
                }
                .onTapGesture {
                    otpFocus = nil
                }
            })
            .navigationDestination(isPresented: $loginViewModel.isPresenter, destination: {
                if loginViewModel.isShowCreateAccount {
                    CreateAccountView(sessionManager: sessionManager)
                        .toolbar(.hidden)
                }
                if loginViewModel.forgotPassword{
                    ResetPasswordView(tCode: loginViewModel.tCode.joined(separator: ""), forgotUserData: loginViewModel.forgotPasswordData ?? UserData(countryCode: "", phoneNumber: "", securityQuestion: SecurityQuestionModel(question: ""))).toolbar(.hidden)
                }
            })
            .navigationViewStyle(StackNavigationViewStyle())
            .toast(message: $loginViewModel.error)
        }
        .environmentObject(loginViewModel)
    }
}

#Preview {
    LoginView()
        .environmentObject(SessionManager())
}


