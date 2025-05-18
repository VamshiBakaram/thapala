//
//  PlannerDetailedView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import SwiftUI

struct PlannerDetailedView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var plannerDetailedViewModel = PlannerDetailedViewModel()
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(Color.black)
                    })
                    Text("Back")
                        .font(.custom(.poppinsMedium, size: 11, relativeTo: .title))
                    Spacer()
                }
                .padding([.leading,.top],20)
                
                ScrollView{
                    VStack(alignment: .leading, spacing:20){
                        HStack(alignment:.top){
                            Image("person")
                                .padding([.leading,.top],5)
                            VStack(alignment:.leading){
                                Text("How to build a loyal community online and offline")
                                    .font(.custom(.poppinsBold, size: 16, relativeTo: .title))
                                TextEditor(text: $plannerDetailedViewModel.detailedPlanner)
                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                    .padding(.trailing, 10)
                                    .frame(minHeight: 100, maxHeight: .infinity)
                                    .allowsHitTesting(false)
                            }
                        }
                        
                        HStack {
                            Spacer()
                            HStack {
                                Text("15 May 2020 8:00 pm")
                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                    .padding(.trailing,15)
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "pencil.line")
                                        .foregroundColor(Color.black)
                                })
                                .padding(.trailing,8)
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(Color.black)
                                })
                            }
                            .padding(.trailing,15)
                        }

                    }
                    .padding([.leading,.top,.bottom],20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .padding()
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PlannerDetailedView()
}
