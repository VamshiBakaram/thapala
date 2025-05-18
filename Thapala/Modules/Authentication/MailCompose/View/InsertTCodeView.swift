//
//  InsertTCodeView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/08/24.
//

import SwiftUI

struct InsertTCodeView: View {
    @Binding var isInsertVisible: Bool
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var insertTCodeViewModel = InsertTCodeViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    var onInsert: (([TCode], [TCode], [TCode]) -> Void)?
    var body: some View {
        ZStack{
            Color(red: 0, green: 0, blue: 0)
            //  .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isInsertVisible = false
                }
            VStack{
                VStack{
                    HStack{
                        Text("Insert tContacts")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                            .padding(.top,25)
                            .padding(.horizontal)
                        Spacer()
                        HStack {
                            Button(action: {
                                insertTCodeViewModel.selectOption(.to)
                            }) {
                                Text("To")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding([.leading,.trailing], 10)
                                    .background(insertTCodeViewModel.isToSelected ?themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                insertTCodeViewModel.selectOption(.cc)
                            }) {
                                Text("CC")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding([.leading,.trailing], 10)
                                    .background(insertTCodeViewModel.isCcSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: {
                                insertTCodeViewModel.selectOption(.bcc)
                            }) {
                                Text("BCC")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding([.leading,.trailing], 10)
                                    .background(insertTCodeViewModel.isBccSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .cornerRadius(12)
                            }
                        }
                        .padding([.leading,.trailing],10)
                        .background(themesviewModel.currentTheme.textColor)
                        .cornerRadius(20)
                        .padding([.leading,.trailing],10)
                        
                    }
                    Spacer()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 218/255, green: 221/255, blue: 249/255))
                        .padding(.top,5)
                    
                    HStack{
                        Text("Name")
                        foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 14))
                        Spacer()
                        Text("tCode")
                        foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 14))
                    }
                    .padding([.leading,.trailing],60)
                    .padding(.top,10)
                    
                    Spacer()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .padding(.top,5)
                    List($insertTCodeViewModel.contactsData) { $data in
                        VStack {
                            HStack{
//                                Image("Check")
                                Image(data.isSelected ? "checkbox" : "Check")
                                    .resizable()
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .frame(width: 24,height: 24)
                                    .padding([.trailing,.leading],5)
                                    .onTapGesture {
                                        insertTCodeViewModel.toggleSelection(for: data)
                                    }
                                    
                                Text(data.firstname ?? "")
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .font(.custom(.poppinsRegular, size: 14))
                                    .padding(.leading,10)
                                Spacer()
                                Text(data.tCode ?? "")
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .font(.custom(.poppinsRegular, size: 14))
                            }
                            Spacer()
                                .frame(height: 1)
                                .frame(maxWidth: .infinity)
                                .background(themesviewModel.currentTheme.windowBackground)
                                .padding(.top,5)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                    .listRowSeparator(.hidden)
                    .scrollContentBackground(.hidden)
                    HStack{
                        Spacer()
                        Button {
                            onInsert?(insertTCodeViewModel.tCodes, insertTCodeViewModel.ccTCodes, insertTCodeViewModel.bccTCodes)
                            self.presentationMode.wrappedValue.dismiss()
                            
                        } label: {
                            Text("Insert")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                        }
                        .foregroundColor(Color.white)
                        .padding([.top,.bottom],6)
                        .padding([.trailing,.leading],12)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(12)
                        .padding([.trailing,.bottom],22)
                        
                    }
                }
                .background(themesviewModel.currentTheme.windowBackground)
            }
        }
        .toast(message: $insertTCodeViewModel.error)
    }
}

#Preview {
    InsertTCodeView(isInsertVisible: .constant(false))
}
