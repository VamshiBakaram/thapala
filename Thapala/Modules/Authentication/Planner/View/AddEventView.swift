//
//  AddEventView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import SwiftUI

struct AddEventView: View {
    
    @Binding var isAddEventVisible: Bool
    @ObservedObject private var addEventViewModel = AddEventViewModel()
    
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
               
                FloatingTextField(text: $addEventViewModel.title, placeHolder: "Title", allowedCharacter: .defaultType)
                    .padding(.horizontal)
                HStack {
                    FloatingTextField(text: $addEventViewModel.startDate, placeHolder: "Start Date", allowedCharacter: .defaultType)
                        .padding(.horizontal)
                    FloatingTextField(text: $addEventViewModel.startTime, placeHolder: "Time", allowedCharacter: .defaultType)
                        .padding(.horizontal)
                }
                
                HStack {
                    FloatingTextField(text: $addEventViewModel.endDate, placeHolder: "End Date", allowedCharacter: .defaultType)
                        .padding(.horizontal)
                    FloatingTextField(text: $addEventViewModel.startTime, placeHolder: "Time", allowedCharacter: .defaultType)
                        .padding(.horizontal)
                }
                FloatingTextField(text: $addEventViewModel.repeatEvent, placeHolder: "Repeat", allowedCharacter: .defaultType)
                    .padding(.horizontal)
                FloatingTextField(text: $addEventViewModel.note, placeHolder: "Note", allowedCharacter: .defaultType)
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
