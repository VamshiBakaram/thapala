//
//  VerifyOTPView.swift
//  Thapala
//
//  Created by ahex on 23/04/24.
//

import SwiftUI

struct VerifyOTPView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState private var otpFocus: Int?
    
    @ObservedObject private var verifyOTPViewModel: VerifyOTPViewModel
    let resetToken:String
    
    init(dialCode: String, phoneNumber: String,isfromForgot:Bool,resetToken:String,tCode:String) {
        self.verifyOTPViewModel = VerifyOTPViewModel(dialCode: dialCode, phoneNumber: phoneNumber, isfromForgot: isfromForgot, tCode: tCode)
        self.resetToken = resetToken
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Image("verify-code-bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 8) {
                    Text("Verification Code")
                        .font(.custom(.poppinsMedium, size: 22, relativeTo: .title))
                        .foregroundStyle(Color.white)
                        .padding(.top, 2)
                        .padding(.horizontal, 10)
                    VStack {
                        Text("We have sent the verification code to")
                            .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal)
                        Text(verifyOTPViewModel.phoneNumber)
                            .font(.custom(.poppinsMedium, size: 12, relativeTo: .title))
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 10)
                    }
                    HStack(spacing: 10) {
                        ForEach(0..<6, id: \.self) { index in
                            TextField("", text: $verifyOTPViewModel.otp[index], onEditingChanged: { editing in
                                if editing {
                                    verifyOTPViewModel.setTCode(code: verifyOTPViewModel.otp[index])
                                }
                            })
                            .foregroundColor(Color.white)
                            .keyboardType(.numberPad)
                            .frame(width: reader.size.width * 0.078, height: reader.size.width * 0.078)
                            .background(
                                RoundedRectangle(cornerRadius: 5.53)
                                    .stroke(Color.white)
                            )
                            .multilineTextAlignment(.center)
                            .focused($otpFocus, equals: index)
                            .focused($otpFocus, equals: index)
                            .tag(index)
                            .onChange(of: verifyOTPViewModel.otp[index]) { newValue in
                                if !newValue.isEmpty {
                                    if verifyOTPViewModel.otp[index].count > 1 {
                                        let currentValue = Array(verifyOTPViewModel.otp[index])
                                        if currentValue[0] == Character(verifyOTPViewModel.initialOTP) {
                                            verifyOTPViewModel.setOTPCodeIndex(index: index, code: String(verifyOTPViewModel.otp[index].suffix(1)))
                                        } else {
                                            verifyOTPViewModel.setOTPCodeIndex(index: index, code: String(verifyOTPViewModel.otp[index].prefix(1)))
                                        }
                                    }
                                    if index == 5 {
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
                    Button(action: {
                        otpFocus = nil
                        verifyOTPViewModel.validate()
                    }, label: {
                        if verifyOTPViewModel.isLoading {
                            CustomProgressView()
                        }else{
                            ThemeButtonLabel(title: "Verify")
                                .padding(.horizontal, 10)
                        }
                    })
                    .padding(.top, 20)
                    .padding([.leading,.trailing], 50)
                    
                    HStack(spacing:0) {
                        Text("Didn’t receive the code? ")
                            .font(.custom(.poppinsRegular, size: 10, relativeTo: .title))
                            .foregroundStyle(Color.white)
                        
                        Button(action: {
                            verifyOTPViewModel.resendCode()
                        }, label: {
                            Text("Resend")
                                .foregroundColor(Color.themeColor)
                                .font(.custom(.poppinsRegular, size: 10, relativeTo: .title))
                        })
                    }
                    .padding(.top,20)
                    
                }
                .frame(width: 350, height: 350)
                .background(Color.clear)
                .clipShape(Circle())
                .padding(.all, 25)
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
            .onTapGesture {
                otpFocus = nil
            }
        }
        .toast(message: $verifyOTPViewModel.error)
        .navigationDestination(isPresented: $verifyOTPViewModel.isNavigateToPassword) {
            if verifyOTPViewModel.isNavigateToPassword{
                ResetForgotPasswordView(resetToken: resetToken)
                   .toolbar(.hidden)
            }
        }
        .navigationDestination(isPresented: $verifyOTPViewModel.isNavigateToSecurutyQuestions) {
            if verifyOTPViewModel.isNavigateToSecurutyQuestions{
                SecurityQuestionsView()
                   .toolbar(.hidden)
            }
        }
    }
}

#Preview {
    VerifyOTPView(dialCode: "989", phoneNumber: "3131", isfromForgot: true, resetToken: "1233", tCode: "123")
}
