//
//  NavigatorEditView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import SwiftUI

struct NavigatorEditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var navigatorEditViewModel = NavigatorEditViewModel()
    
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
                    Spacer()
                }
                .padding([.leading,.top],20)
               
                ScrollView{
                    VStack(alignment: .leading, spacing:20){
                        HStack{
                            Image("person")
                                .padding([.leading,.top],2)
                        }
                        HStack{
                            Text("Name")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                .padding(.leading,5)
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.firstName)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        
                        HStack{
                            Text("tCode")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.tCode)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        HStack{
                            Text("Phone")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.phoneNumber)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        HStack{
                            Text("Birthdate")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.birthDate)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        HStack{
                            Text("Gender (Optional)")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.gender)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        HStack{
                            Text("Preferred gender pronouns (Optional)")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.preferredGender)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        HStack{
                            TextField("", text: $navigatorEditViewModel.nationality)
                                .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                .padding(.leading,5)
                                .frame(height:35)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.trailing,10)
                            Spacer()
                        }
                        Text("United States")
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                        HStack{
                            Text("Languages")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.language)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        HStack{
                            Text("Marital status (Optional)")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.maritalStatus)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        HStack{
                            Text("Private Account")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.acccountType)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        HStack{
                            Text("Government Id (verification)")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        Text("View Document")
                            .font(.custom(.poppinsBold, size: 14, relativeTo: .title))
                            .foregroundColor(Color(red: 69/255, green: 86/255, blue: 225/255))
                        HStack{
                            Text("Hobbies (Optional)")
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                            Spacer()
                        }
                        TextField("", text: $navigatorEditViewModel.hobbies)
                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                            .padding(.leading,5)
                            .frame(height:35)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .padding(.trailing,10)
                        
                        HStack {
                            Spacer()
                            Button {
                            } label: {
                                Text("Update Details")
                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(Color.themeColor)
                                    .cornerRadius(12)
                            }
                            Spacer()
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
    NavigatorEditView()
}
