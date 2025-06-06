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
            
            if let message = message, !message.isEmpty {
                VStack {
                    Spacer()
                    Text(message)
                        .font(.custom(.poppinsMedium, size: 16))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(themesviewModel.currentTheme.tabBackground.opacity(0.95))
                                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2)
                        )
                        .frame(maxWidth: 350)
                        .padding(.bottom, 30) // safe bottom margin
                        .accessibilityLabel(Text(message))
                        .onTapGesture {
                            withAnimation {
                                self.message = nil
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .animation(.easeInOut(duration: 0.3), value: message)
                }
                .padding(.horizontal, 20)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            self.message = nil
                        }
                    }
                }
            }
        }
    }
}
