//
//  CreateAccountView.swift
//  Thapala
//
//  Created by ahex on 23/04/24.
//

import SwiftUI

struct CreateAccountView: View {

    @ObservedObject private var createAccountViewModel: CreateAccountViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var numberPadFocus: Bool
    
    init(sessionManager: SessionManager) {
        self.createAccountViewModel = CreateAccountViewModel(sessionManager: sessionManager)
    }
    var body: some View {
        ZStack {
            Image("sign-up")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 12) {
                Text("Create Account")
                    .font(.custom(.poppinsMedium, size: 22, relativeTo: .title))
                    .foregroundStyle(Color.black)
                    .padding(.top, 25)
                
              //  GreyBgFloatingTextField(text: $createAccountViewModel.firstName, placeHolder: "First Name*", allowedCharacter: .alphabetic)
                GreyBgFloatingTextField(text: $createAccountViewModel.firstName, placeHolder: "First Name*", allowedCharacter: .defaultType, textColorCode: Color.white)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.white)
                    
                
               // GreyBgFloatingTextField(text: $createAccountViewModel.lastName, placeHolder: "Last Name*", allowedCharacter: .alphabetic)
                GreyBgFloatingTextField(text: $createAccountViewModel.lastName, placeHolder: "Last Name*", allowedCharacter: .defaultType, textColorCode: Color.white)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.white)
                
                ZStack(alignment: .leading) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                createAccountViewModel.isShowCountryDropdown.toggle()
                            }
                        }, label: {
                            HStack(spacing: 5) {
                                Image(createAccountViewModel.selectedCountryCode?.code ?? "")
                                    .resizable()
                                    .frame(width: 20, height: 15)
                                    .scaledToFill()
                                    .background(Color.lineColor)
                                    .padding(.leading, 6)
                                Text(createAccountViewModel.selectedCountryCode?.dial_code ?? "")
                                    .font(.custom(.poppinsMedium, size: 15))
                                    .foregroundStyle(Color.white)
                                Image("dropdown1")
                            }
                            .padding(.leading, 4)
                        })
                        Spacer()
                            .frame(width: 1, height: 25)
                            .background(Color.lineColor)
                            .padding(.horizontal, 0.5)
                        TextField("", text: $createAccountViewModel.phoneNumber)
                            .frame(maxWidth: .infinity)
                            .font(.custom(.poppinsRegular, size: 16))
                            .frame(maxWidth: .infinity)
                            .padding(.all, 14)
                            .foregroundStyle(Color.white)
                            .keyboardType(.numberPad)
                            .focused($numberPadFocus)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.grayColor)
                    )
                    Text("Phone Number*")
                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title3))
                        .padding(.horizontal, 5)
                        .background(Color(red: 170/255, green: 170/255, blue: 170/255).opacity(0.64))
                        .padding(EdgeInsets(top: 0, leading: 12, bottom: 55, trailing: 0))
                        .foregroundStyle(Color.white)
                        .foregroundColor(Color.white)
                }
                .padding(.horizontal, 10)
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    createAccountViewModel.validate()
                }, label: {
                    if createAccountViewModel.isLoading {
                        CustomProgressView()
                    }else{
                        ThemeButtonLabel(title: "Next")
                            .padding(.horizontal, 10)
                    }
                })
                HStack(alignment: .center, spacing: 2) {
                    Text("have an account?")
                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title2))
                        .foregroundStyle(Color.black)
                    Text("Sign in")
                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title2))
                        .foregroundStyle(Color.themeColor)
                        .onTapGesture {
                            dismiss.callAsFunction()
                        }
                }
                .padding(.top, 4)
                .padding(.horizontal, 10)
                .padding(.bottom, 22)
            }
            .background(Color(red: 170/255, green: 170/255, blue: 170/255).opacity(0.64))
            .clipShape(RoundedRectangle(cornerRadius: 15.3))
            .padding(.horizontal, 25)
            .shadow(radius: 5)
            .overlay {
                VStack {
                    VStack {
                        if createAccountViewModel.isShowCountryDropdown {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    ForEach(createAccountViewModel.countryCodes, id: \.self) { countryCode in
                                        Button(action: {
                                            withAnimation {
                                                createAccountViewModel.selectedCountryCode = countryCode
                                                createAccountViewModel.handleDropdown()
                                            }
                                            
                                        }, label: {
                                            HStack(alignment: .center, spacing: 8) {
                                                Image(countryCode.code)
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .scaledToFill()
                                                    .background(Color.lineColor)
                                                    .padding(.leading, 10)
                                                Text(countryCode.dial_code)
                                                    .font(.custom(.poppinsRegular, size: 15))
                                                    .foregroundStyle(Color.black)
                                                Text(countryCode.name)
                                                    .font(.custom(.poppinsRegular, size: 15))
                                                    .foregroundStyle(Color.black)
                                                    .padding(.leading, 0)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                            }
                                            .padding(.vertical, 5)
                                            .overlay(content: {
                                                if let name = createAccountViewModel.selectedCountryCode?.name {
                                                    if countryCode.name == name {
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .fill(Color.themeColor.opacity(0.2))
                                                    }
                                                }
                                            })
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                        })
                                    }
                                }
                            }
                            .frame(height: 200)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 40)
                            .shadow(radius: 3)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .offset(y: 190)
                .zIndex(100)
            }
        }
        .onTapGesture(perform: {
            self.numberPadFocus = false
        })
        .toast(message: $createAccountViewModel.error)
        .navigationDestination(isPresented: $createAccountViewModel.isNavigateToOtpView) {
            if createAccountViewModel.isNavigateToOtpView {
                VerifyOTPView(dialCode: createAccountViewModel.selectedCountryCode?.dial_code ?? "", phoneNumber: createAccountViewModel.phoneNumber, isfromForgot: false, resetToken: "", tCode: "")
                    .toolbar(.hidden)
            }
        }
    }
}

#Preview {
    CreateAccountView(sessionManager: SessionManager())
}
