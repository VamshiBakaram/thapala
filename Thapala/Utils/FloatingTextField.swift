//
//  FloatingTextField.swift
//  Thapala
//
//  Created by ahex on 23/04/24.
//

import Foundation
import SwiftUI

enum AllowedCharacter {
    case alphabetic
    case defaultType
}

struct FloatingTextField: View {
    @Binding var text: String
    let placeHolder: String
    let allowedCharacter: AllowedCharacter
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text)
                .modifier(TextFieldLabel(flotingTextField: true))
                .onChange(of: text) { newValue in
                    if allowedCharacter == .alphabetic {
                        self.text = newValue.filter { $0.isLetter }
                    }
                }
            Text(placeHolder)
                .modifier(TextFieldPlaceHolderLabel())
                .foregroundColor(.gray)
        }
    }
}

struct floatingtextfield: View {
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var text: String
    var placeHolder: String
    var allowedCharacter: AllowedCharacter
    var isSecure: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeHolder)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .padding(.leading, 8)
            }

            if isSecure {
                SecureField("", text: $text)
                    .keyboardType(.numberPad)
                    .padding(8)
            } else {
                TextField("", text: $text)
                    .keyboardType(.numberPad)
                    .padding(8)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
        )
    }
}


struct Floatingtextfield: View {
    @Binding var text: String
    var placeHolder: String
    var allowedCharacter: AllowedCharacter
    var isSecure: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeHolder)
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
            }

            if isSecure {
                SecureField("", text: $text)
                    .keyboardType(.numberPad)
                    .padding(8)
                    .onChange(of: text) { newValue in
                        text = String(newValue.prefix(4))
                    }
            } else {
                TextField("", text: $text)
                    .keyboardType(.numberPad)
                    .padding(8)
                    .onChange(of: text) { newValue in
                        text = String(newValue.prefix(4))
                    }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
        )
//        .padding(.horizontal)
    }
}



struct FloatingTextEditor: View {
    
    @Binding var text: String
    let placeHolder: String
    let allowedCharacter: AllowedCharacter
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .modifier(TextEditorLabel(floatingTextEditor: true))
                .onChange(of: text) { newValue in
                    if allowedCharacter == .alphabetic {
                        self.text = newValue.filter { $0.isLetter }
                    }
                }
                Text(placeHolder)
                    .modifier(TextEditorPlaceHolderLabel())
        }
    }
}

struct GreyBgFloatingTextField: View {
    
    @Binding var text: String
    let placeHolder: String
    let allowedCharacter: AllowedCharacter
    let textColorCode:Color
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text)
                .foregroundColor(textColorCode)
                .modifier(TextFieldLabel(flotingTextField: true))
                .onChange(of: text) { newValue in
                    if allowedCharacter == .alphabetic {
                        self.text = newValue.filter { $0.isLetter }
                    }
                }
            Text(placeHolder)
                .modifier(GreyBgTextFieldPlaceHolderLabel())
        }
    }
}

struct PasswordTextField: View {
    
    @Binding var text: String
    @Binding var showPassword: Bool
    let placeHolder: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if showPassword {
                HStack {
                    TextField("", text: $text)
                        .modifier(TextFieldLabel(flotingTextField: false))
                    Button(action: {
                        showPassword.toggle()
                    }, label: {
                        Image("password1")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .scaledToFill()
                    })
                    .padding(.trailing)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.grayColor)
                }
            }else{
                HStack {
                    SecureField("", text: $text)
                        .modifier(TextFieldLabel(flotingTextField: false))
                    Button(action: {
                        showPassword.toggle()
                    }, label: {
                        Image("password1")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .scaledToFill()
                    })
                    .padding(.trailing)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.grayColor)
                }
            }
            Text(placeHolder)
                .modifier(GreyBgTextFieldPlaceHolderLabel())
        }
    }
}

struct TextFieldLabel: ViewModifier {
    let flotingTextField: Bool
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .font(.custom(.poppinsRegular, size: 16))
            .frame(maxWidth: .infinity)
            .padding(.all, 14)
            .background(flotingTextField ? RoundedRectangle(cornerRadius: 8).stroke(Color.grayColor) : RoundedRectangle(cornerRadius: 0).stroke(Color.clear))
            .foregroundStyle(Color.grayColor)
    }
}

struct TextFieldPlaceHolderLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title3))
            .padding(.horizontal, 5)
            .background(Color.white)
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 55, trailing: 0))
            .foregroundStyle(Color.grayColor)
    }
}

struct GreyBgTextFieldPlaceHolderLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title3))
            .padding(.horizontal, 5)
            .background(Color(red: 170/255, green: 170/255, blue: 170/255).opacity(0.64))
            .padding(EdgeInsets(top: 0, leading: 12, bottom: 55, trailing: 0))
            .foregroundStyle(Color.white)
    }
}

struct TextEditorLabel: ViewModifier {
    let floatingTextEditor: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .font(.custom(.poppinsRegular, size: 16))
            .padding(.all, 14)
            .background(floatingTextEditor ? RoundedRectangle(cornerRadius: 8).stroke(Color.grayColor) : RoundedRectangle(cornerRadius: 0).stroke(Color.clear))
            .foregroundStyle(Color.grayColor)
    }
}

struct TextEditorPlaceHolderLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title3))
            .padding(.horizontal, 5)
            .background(Color.white)
            .padding(EdgeInsets(top: -10, leading: 12, bottom: 55, trailing: 0))
            .foregroundStyle(Color.grayColor)
    }
}

