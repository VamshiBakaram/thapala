//
//  PicktCodeView.swift
//  Thapala
//
//  Created by ahex on 30/04/24.
//

import SwiftUI

struct PicktCodeView: View {
    
    @FocusState private var tCodeFocus: Int?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var picktCodeViewModel = PicktCodeViewModel()
    @State private var tCodeToPass: String = ""
    
    var body: some View {
        GeometryReader(content: { reader in
            ZStack {
                Image("pick-tcode-bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Pick your tCode")
                        .font(.custom(.poppinsMedium, size: 22, relativeTo: .title))
                        .foregroundStyle(Color.black)
                        .padding(.top, 25)
                    VStack{
                        VStack(alignment: .leading) {
                            Text("tCode")
                                .foregroundStyle(Color.grayColor)
                            HStack(spacing: 2) {
                                ForEach(0..<10, id: \.self) { index in
                                    TextField("", text: $picktCodeViewModel.tCode[index], onEditingChanged: { editing in
                                        if editing {
                                            picktCodeViewModel.setTCode(code: picktCodeViewModel.tCode[index])
                                            picktCodeViewModel.removeError()
                                        }
                                    })
                                    .keyboardType(.numberPad)
                                    .frame(width: reader.size.width * 0.078, height: reader.size.width * 0.078)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5.53)
                                            .stroke(Color.grayColor)
                                    )
                                    .multilineTextAlignment(.center)
                                    .focused($tCodeFocus, equals: index)
                                    .tag(index)
                                    .onChange(of: picktCodeViewModel.tCode[index]) { newValue in
                                        if !newValue.isEmpty {
                                            if picktCodeViewModel.tCode[index].count > 1 {
                                                let currentValue = Array(picktCodeViewModel.tCode[index])
                                                if currentValue[0] == Character(picktCodeViewModel.initialTCode) {
                                                    picktCodeViewModel.setTCodeIndex(index: index, code: String(picktCodeViewModel.tCode[index].suffix(1)))
                                                } else {
                                                    picktCodeViewModel.setTCodeIndex(index: index, code: String(picktCodeViewModel.tCode[index].prefix(1)))
                                                }
                                            }
                                            if index == 9 {
                                                tCodeFocus = nil
                                            } else {
                                                tCodeFocus = (tCodeFocus ?? 0) + 1
                                            }
                                        } else {
                                            tCodeFocus = (tCodeFocus ?? 0) - 1
                                        }
                                    }
                                    .allowsHitTesting(false)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        if picktCodeViewModel.isDisplayError {
                            HStack {
                                Text(picktCodeViewModel.tCodeError)
                                    .font(.custom(.poppinsRegular, size: 12))
                                    .foregroundStyle(Color(red: 236/255.0, green: 86/255.0, blue: 86/255.0))
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                    Text("Note : The chosen tCode can be changed twice in a lifetime.")
                        .font(.custom(.poppinsRegular, size: 14))
                        .frame(maxWidth: .infinity)
                        .padding(.all, 6)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.themeColor.opacity(0.2))
                                
                        })
                        .padding(.horizontal, 10)
                    if picktCodeViewModel.isLoading {
                        CustomProgressView()
                    }else{
                        Button(action: {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            picktCodeViewModel.submitValidate()
                            tCodeToPass = picktCodeViewModel.tCode.joined()
                        }, label: {
                            ThemeButtonLabel(title: "Submit")
                                .padding(.horizontal, 10)
                        })
                        .padding(.bottom, 30)
                    }
                }
                .background(Color(red: 255/255, green: 255/255, blue: 255/255).opacity(0.64))
                .clipShape(RoundedRectangle(cornerRadius: 15.3))
                .padding(.horizontal, 25)
                .shadow(radius: 5)
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
                tCodeFocus = nil
            }
            .navigationDestination(isPresented: $picktCodeViewModel.isNavigatePassword) {
                if picktCodeViewModel.isNavigatePassword {
                    ChangePasswordView(tCode: tCodeToPass)
                        .toolbar(.hidden)
                }
            }
            .toast(message: $picktCodeViewModel.error)
        })
    }
}

#Preview {
    PicktCodeView()
}
