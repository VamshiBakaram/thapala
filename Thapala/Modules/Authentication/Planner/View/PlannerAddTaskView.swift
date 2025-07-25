//
//  PlannerAddTaskView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import SwiftUI

struct PlannerAddTaskView: View {
    
    @Binding var isAddTaskVisible: Bool
    @ObservedObject private var plannerAddTaskViewModel = PlannerAddTaskViewModel()
    var body: some View {
        ZStack {
            Color(red: 0, green: 0, blue: 0)
                .opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Header Section
                HStack {
                    Spacer()
                    Spacer()
                    Button(action: {
                        self.isAddTaskVisible = false
                    }, label: {
                        Image("cross")
                    })
                    
                }
                .padding(.top, 25)
                .padding(.trailing, 15)
                // Form Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        FloatingTextField(text: $plannerAddTaskViewModel.title, placeHolder: "Start Date", allowedCharacter: .defaultType)
                            .padding(.leading , 16)
                        
                        FloatingTextField(text: $plannerAddTaskViewModel.title, placeHolder: "End Date", allowedCharacter: .defaultType)
                            .padding(.trailing , 16)
                    }
                    
                    FloatingTextEditor(text: $plannerAddTaskViewModel.note, placeHolder: "Label", allowedCharacter: .defaultType)
                        .padding(.horizontal, 16)
                        .frame(height: 35)
                }
                
                // Action Buttons Section
                HStack(spacing: 16) {
                    Button(action: {
                    }) {
                        Image("bellnotification")
                            .resizable()
                            .frame(width: 20, height: 22)
                            .foregroundColor(.black)
//                            .background(Color.red)
                    }
                    .padding(.leading, 15)
                    
                    Spacer()
                    
                    Button(action: {
                        // Reset Action
                    }, label: {
                        Text("Reset")
                    })
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    
                    Button(action: {
                        // Search Action
                    }, label: {
                        Text("Search")
                    })
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.themeColor)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .padding(.top, 10)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15.3))
            .padding(.horizontal, 25)
            .padding(.vertical, 25)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PlannerAddTaskView(isAddTaskVisible: .constant(true))
}
