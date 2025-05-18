//
//  SplashView.swift
//  Thapala
//
//  Created by ahex on 22/04/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.themeColor
                .ignoresSafeArea()
            VStack {
                Image("splash_icon")
                Text("Thapala")
                    .font(.system(size: 23.6, weight: .regular))
                    .foregroundStyle(Color.themeColor)
            }
            .padding(.all, 30)
            .background(Color.white)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    SplashView()
}
