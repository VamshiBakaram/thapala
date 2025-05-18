//
//  CustomToast.swift
//  Thapala
//
//  Created by ahex on 24/04/24.
//

import Foundation
import SwiftUI

extension View {
    func toast(message: Binding<String?>, duration: TimeInterval = 2.0) -> some View {
        modifier(ToastModifier(message: message, duration: duration))
    }
}

struct ToastModifier: ViewModifier {
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var message: String?
    let duration: TimeInterval
    func body(content: Content) -> some View {
        ZStack {
            content
            if !(message ?? "").isEmpty {
                VStack {
                    Spacer()
                    Text(self.message ?? "")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(themesviewModel.currentTheme.tabBackground)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .transition(.slide)
                    .frame(minWidth: 0, maxWidth: .infinity)
                }
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                        withAnimation {
                            message = nil
                        }
                    })
                }
            }
        }
    }
}
