//
//  ResetPasswordView.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/05/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var verifyCodeViewModel:VerifyCodeViewModel
    @StateObject var securityAnswerViewModel:SecurityAnswerViewModel
    
    let forgetUserData: UserData
    init(tCode:String,forgotUserData:UserData){
        self._verifyCodeViewModel = StateObject(wrappedValue: VerifyCodeViewModel(tCode: tCode))
        self.forgetUserData = forgotUserData
        self._securityAnswerViewModel = StateObject(wrappedValue: SecurityAnswerViewModel(tCode: tCode))
    }
    
    var body: some View {
        NavigationStack{
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
                
                VStack(spacing: 8) {
                    Text("Reset Password")
                        .font(.custom(.poppinsMedium, size: 22, relativeTo: .title))
                        .foregroundStyle(Color.black)
                        .padding(.top, 25)
                    HStack(alignment: .center){
                        Text("Choose how you want to reset your passcode.")
                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                            .foregroundStyle(Color.grayColor)
                            .padding(.leading,10)
                        Spacer()
                    }
                    
                    Button(action: {
                        verifyCodeViewModel.otpTapBorderColor = true
                        verifyCodeViewModel.otherWayTapBorderColor = false
                    }, label: {
                        HStack{
                            Image("cell")
                            let phoneLast = "\(forgetUserData.phoneNumber?.prefix(2) ?? "")*** ***\((forgetUserData.phoneNumber?.suffix(2)) ?? "")"
                            Text("Get a verification code to \(phoneLast)")
                                .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                        }
                    })
                    .padding()
                    .overlay(
                        Group {
                            if verifyCodeViewModel.otpTapBorderColor {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue,lineWidth:2)
                                    .onTapGesture {
                                        self.verifyCodeViewModel.otpTapBorderColor = false
                                    }
                            }
                        }
                    )
                    
                    Button(action: {
                        verifyCodeViewModel.otpTapBorderColor = false
                        verifyCodeViewModel.otherWayTapBorderColor = true
                    }, label: {
                        HStack{
                            Image("question")
                            Text("Try another way to reset password")
                                .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                        }
                    })
                    .padding()
                    .overlay(
                        Group {
                            if verifyCodeViewModel.otherWayTapBorderColor {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue,lineWidth:2)
                                    .onTapGesture {
                                        self.verifyCodeViewModel.otherWayTapBorderColor = false
                                    }
                            }
                        }
                    )
                    
                    Button(action: {
                        verifyCodeViewModel.borderAlert()
                        if verifyCodeViewModel.otpTapBorderColor{
                            verifyCodeViewModel.verifyCode()
                        }
                        if verifyCodeViewModel.otherWayTapBorderColor{
                            securityAnswerViewModel.isPresenter = true
                        }
                        
                    }, label: {
                        ThemeButtonLabel(title: "Next")
                    })
                    .padding(.top, 16)
                    .padding(.bottom, 25)
                    .padding([.leading,.trailing],20)
                    
                }
                .background(Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.64))
                .clipShape(RoundedRectangle(cornerRadius: 15.3))
                .padding(.horizontal, 25)
            }
            .navigationDestination(isPresented: $securityAnswerViewModel.isPresenter, destination: {
                SecurityAnswerView(tCode: securityAnswerViewModel.tCode,question: forgetUserData.securityQuestion?.question ?? "",verifyCodeViewModel:VerifyCodeViewModel(tCode: verifyCodeViewModel.tCode)).toolbar(.hidden)

            })
            .toast(message: $securityAnswerViewModel.error)
            .navigationDestination(isPresented: $verifyCodeViewModel.isPresenter, destination: {
                if verifyCodeViewModel.isOtpTapNextNavigateView{
                    VerifyOTPView(dialCode: forgetUserData.countryCode ?? "", phoneNumber: forgetUserData.phoneNumber ?? "", isfromForgot: true, resetToken: verifyCodeViewModel.resetToken, tCode: verifyCodeViewModel.tCode ).toolbar(.hidden)
                        
                }else {
                    EmptyView()
                }
            })
            .navigationViewStyle(StackNavigationViewStyle())
            .toast(message: $verifyCodeViewModel.error)
        }
    }
}

#Preview {
    ResetPasswordView(tCode: "12345", forgotUserData: UserData(countryCode: "91", phoneNumber: "97979797", securityQuestion: SecurityQuestionModel(question: "What is tyou pet name")))
}
