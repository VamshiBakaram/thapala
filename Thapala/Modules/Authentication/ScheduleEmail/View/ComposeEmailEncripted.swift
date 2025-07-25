//
//  ComposeEmailEncripted.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import SwiftUI

struct ComposeEmailEncripted: View {
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var isEmailEncript: Bool
    @ObservedObject private var composeEmailEncriptedViewModel = ComposeEmailEncriptedViewModel()
    
    var body: some View {
        ZStack{
            Color(red: 255/255, green: 255/255, blue: 255/255)
              //  .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isEmailEncript = false
                }
            VStack{
                HStack {
                    Button(action: {
                        self.isEmailEncript = false
                    }, label: {
                        Image("reply_left")
                            .renderingMode(.template)
                            .padding(.horizontal , 16)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                        
                })
                    .padding(.top,20)
                    Spacer()
                }
                HStack{
                    
                    Text("Password protected mail")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .fontWeight(.bold)
                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                        .padding(.top,25)
                        .padding(.leading,10)
                       // .padding(.horizontal)
                    Spacer()
                   /*
                    Button(action: {
                        self.isEmailEncript = false
                    }, label: {
                        Image("cross")
                    })
                    .padding(.top,25)
                    .padding(.trailing, 15)
                    */
                    
                    
                }
                
                HStack {
                    Text("Send an encrypted, password protected message")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                        .padding(.leading,10)
                    //.padding(.horizontal)
                    .padding(.top,5)
                    Spacer()
                }
           
                HStack {
                    Floatingtextfield(text: $composeEmailEncriptedViewModel.password, placeHolder: "Password", allowedCharacter: .defaultType)
                       // .padding(.horizontal)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.top,10)
                        .padding(.leading,10)
                        .overlay(
                            HStack{
                                Spacer()
                                Button(action: {
                                }, label: {
                                    Image(systemName: "eye")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                })
                                .padding(.trailing,20)
                                .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                            }
                            
                    )
                    Image("copy")
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                       // .padding(.trailing)
//                        .onTapGesture {
//                            UIPasteboard.general.string = composeEmailEncriptedViewModel.password
//                        }
                }
                
                HStack {
                    Text("Don’t forget to share the password with the recipient.")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                    .padding(.horizontal)
                    Spacer()
                }

                Floatingtextfield(text: $composeEmailEncriptedViewModel.hint, placeHolder: "Hint", allowedCharacter: .defaultType)
                    .padding(.horizontal)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                
                HStack {
                    Spacer()
                    Button(action: {
                        composeEmailEncriptedViewModel.validate()
                        self.isEmailEncript = false
                    }, label: {
                        Text("Confirm")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(themesviewModel.currentTheme.colorPrimary)
                            .cornerRadius(10)
                    })
                    .padding(.trailing , 16)
                }
                Spacer()
            }
            .background(themesviewModel.currentTheme.windowBackground)
//            .clipShape(RoundedRectangle(cornerRadius: 15.3))
//            .padding(.horizontal, 25)
        }
        .navigationDestination(isPresented: $composeEmailEncriptedViewModel.isPasswordProtected) {
            MailComposeView().toolbar(.hidden)
        }
        .toast(message: $composeEmailEncriptedViewModel.error)
    }
}

#Preview {
    ComposeEmailEncripted(isEmailEncript: .constant(false))
}


