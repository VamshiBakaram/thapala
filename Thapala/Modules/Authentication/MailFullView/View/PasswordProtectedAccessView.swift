//
//  PasswordProtectedAccessView.swift
//  Thapala
//
//  Created by Ahex-Guest on 05/07/24.
//

import SwiftUI

struct PasswordProtectedAccessView: View {
    @Binding var isPasswordProtected: Bool
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @ObservedObject private var passwordProtectedAccessViewModel = PasswordProtectedAccessViewModel()
    let emailId:Int
    @State var passwordHint:String
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var AwaitingView: Bool = false
    var body: some View {
        ZStack{
            Color(red: 0, green: 0, blue: 0)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isPasswordProtected = false
                }
            VStack(spacing:16){
                HStack{
                    Spacer()
                    Text("Password protected mail")
                        .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                        .padding(.top,25)
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        self.isPasswordProtected = false
                    }, label: {
                        Image("cross")
                    })
                    .padding(.top,25)
                    .padding(.trailing, 15)
                    
                }
                
                FloatingTextField(text: $passwordProtectedAccessViewModel.password, placeHolder: "Password", allowedCharacter: .defaultType)
                    .padding(.horizontal)
                    .overlay(
                        HStack{
                            Spacer()
                            Button(action: {
                                print("eye clicked")
                            }, label: {
                                Image(systemName: "eye")
                            })
                            .padding(.trailing,30)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                        }
                        
                    )
                FloatingTextField(text: $passwordHint, placeHolder: "Hint", allowedCharacter: .defaultType)
                    .padding(.horizontal)
                
                Button(action: {
                    passwordProtectedAccessViewModel.validate(idEmail: emailId)
                }, label: {
                    Text("Confirm")
                })
                .padding(.all,10)
                .frame(width:100)
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.bottom,20)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15.3))
            .padding(.horizontal, 25)
        }
        .navigationDestination(isPresented: $passwordProtectedAccessViewModel.isPasswordProtected) {
            MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView, conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: emailId, passwordHash: passwordProtectedAccessViewModel.password, StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
        }
        .toast(message: $passwordProtectedAccessViewModel.error)
    }
}

#Preview {
    PasswordProtectedAccessView(isPasswordProtected: .constant(false), emailId: 0, passwordHint: "")
}

