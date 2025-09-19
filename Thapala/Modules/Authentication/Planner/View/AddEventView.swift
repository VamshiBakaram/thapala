//
//  AddEventView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import SwiftUI

struct AddEventView: View {
    
    @Binding var isAddEventVisible: Bool
    @StateObject private var addEventViewModel = AddEventViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    
    var body: some View {
        ZStack{
            Color(red: 0, green: 0, blue: 0)
                .opacity(0.3)
                .ignoresSafeArea()
            VStack(spacing:16){
                
                HStack{
                    Spacer()
                    Text("Add Event")
                        .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                        .padding(.top,25)
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        self.isAddEventVisible = false
                    }, label: {
                        Image("cross")
                    })
                    .padding(.top,25)
                    .padding(.trailing, 15)
                }
                
                floatingTextField(placeHolder : "Title", text:  $addEventViewModel.title)
                    .padding(.horizontal)
                HStack {
                    floatingTextField(placeHolder : "Start Date", text:  $addEventViewModel.startDate)
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .padding(.horizontal)
                    floatingTextField(placeHolder : "Time", text:   $addEventViewModel.startTime)
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .padding(.horizontal)
                }
                
                HStack {
                    floatingTextField(placeHolder : "End Date", text:   $addEventViewModel.endDate)
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .padding(.horizontal)
                    floatingTextField(placeHolder : "Time", text:   $addEventViewModel.startTime)
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .padding(.horizontal)
                }
                floatingTextField(placeHolder : "Repeat", text:   $addEventViewModel.repeatEvent)
                    .foregroundColor(themesviewModel.currentTheme.allBlack)
                    .padding(.horizontal)
                floatingTextField(placeHolder : "Note", text:   $addEventViewModel.note)
                    .foregroundColor(themesviewModel.currentTheme.allBlack)
                    .padding(.horizontal)
                
                Button(action: {
                    
                }, label: {
                    Text("Add Event")
                })
                .padding(.all,10)
                .padding([.leading,.trailing],10)
                .background(Color.themeColor)
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.bottom,20)
                
                
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15.3))
            .padding(.horizontal, 25)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddEventView(isAddEventVisible: .constant(true))
}
