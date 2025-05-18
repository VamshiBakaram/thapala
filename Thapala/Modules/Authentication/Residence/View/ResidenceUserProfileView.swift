//
//  ResidenceUserProfileView.swift
//  Thapala
//
//  Created by Ahex-Guest on 18/06/24.
//

import SwiftUI

struct ResidenceUserProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
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
                        HStack{
                            Image("person")
                                .padding([.leading,.top],2)
                            Text("Jane Coopper")
                                .font(.custom(.poppinsBold, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        VStack(alignment:.leading){
                            Text("tCode")
                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            Text("5335813446")
                                .font(.custom(.poppinsSemiBold, size: 12, relativeTo: .title))
                        }
                        
                        VStack(alignment:.leading){
                            Text("Nationality")
                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            Text("Hyderabad,India")
                                .font(.custom(.poppinsSemiBold, size: 12, relativeTo: .title))
                        }
                        VStack(alignment:.leading){
                            Text("Language")
                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            Text("Telugu,Hindi,English")
                                .font(.custom(.poppinsSemiBold, size: 12, relativeTo: .title))
                        }
                        VStack(alignment:.leading){
                            Text("Website")
                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            Text("private")
                                .font(.custom(.poppinsSemiBold, size: 12, relativeTo: .title))
                        }
                        VStack(alignment:.leading){
                            Text("Website")
                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            Text("private")
                                .font(.custom(.poppinsSemiBold, size: 12, relativeTo: .title))
                        }
                        VStack(alignment:.leading){
                            Text("Profession")
                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            Text("private")
                                .font(.custom(.poppinsSemiBold, size: 12, relativeTo: .title))
                        }
                        VStack(alignment:.leading){
                            Text("Location")
                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            Text("Hyderbad")
                                .font(.custom(.poppinsSemiBold, size: 12, relativeTo: .title))
                        }
                        VStack(alignment:.leading){
                            Text("Account Type")
                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                            Text("private")
                                .font(.custom(.poppinsSemiBold, size: 12, relativeTo: .title))
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
                HStack{
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image("plus")
                            .font(Font.title.weight(.medium))
                            .foregroundColor(Color.white)
                    }
                    .padding(.trailing,15)
                }
            }
        }

    }
}

struct ResidenceUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ResidenceUserProfileView()
    }
}

