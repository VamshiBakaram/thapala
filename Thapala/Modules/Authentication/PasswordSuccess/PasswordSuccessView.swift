//
//  PasswordSuccessView.swift
//  Thapala
//
//  Created by ahex on 30/04/24.
//

import SwiftUI

struct PasswordSuccessView: View {
    
//    @EnvironmentObject var loginViewModel: LoginViewModel
    @State var loginNavigate:Bool = false
        
    var body: some View {
            ZStack {
                Image("success-bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 8) {
                    Spacer()
                        .frame(width: 80, height: 80)
                        .background(Color.themeColor)
                        .clipShape(Circle())
                        .overlay {
                            Image("right")
                        }
                        .padding(.top, 30)
                    Text("Password  Changed!")
                        .font(.custom(.poppinsMedium, size: 22, relativeTo: .title))
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 10)
                        .multilineTextAlignment(.center)
                    Text("Your password has been changed\nsuccessfully.")
                        .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                        .foregroundStyle(Color.black)
                        .padding(.horizontal, 10)
                        .multilineTextAlignment(.center)
                    Button(action: {
                        loginNavigate = true
                    }, label: {
                        ThemeButtonLabel(title: "Login")
                            .padding(.horizontal, 10)
                    })
                    .padding(.top, 16)
                    .padding(.bottom, 25)
                }
                .background(Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.64))
                .clipShape(RoundedRectangle(cornerRadius: 15.3))
                .padding(.horizontal, 25)
                .shadow(radius: 5)
            }
            .navigationDestination(isPresented: $loginNavigate) {
                LoginView()
            }
    }
}

#Preview {
    PasswordSuccessView()
}

