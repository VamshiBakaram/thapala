//
//  CreateLabelView.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import SwiftUI

struct CreateLabelView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var createLabelViewModel = CreateLabelViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var favoriteEmails: [String] = []
    var body: some View {
            ZStack{
                Color(red: 255/255, green: 255/255, blue: 255/255)
                   // .opacity(0.3)
                    .ignoresSafeArea()
                VStack{
                    HStack{
                        Text("Label as")
                            .font(.custom(.poppinsSemiBold, size: 14))
                            .padding([.leading,.top],20)
                        Spacer()
                        Button {
                            print("Done")
                          
                        } label: {
                            Text("Done")
                                .font(.custom(.poppinsRegular, size: 14))
                                .padding([.trailing,.top],20)
                        }
                    }
                    Spacer()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 112/255, green: 112/255, blue: 112/255))
                        .padding(.top,5)
                        .padding([.leading,.trailing],25)
                    
                    TextField("Filter label", text: $createLabelViewModel.filterLabelTF)
                        .padding(.all,10)
                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 112/255, green: 112/255, blue: 112/255))
                        }
                        .padding()
                    
                    HStack{
                        Image(systemName: "plus")
                        Text("Create label")
                            Spacer()
                    }
                    .foregroundColor(Color.themeColor)
                    .padding(.leading,20)
                    .onTapGesture {
                        print("H clicked")
                        createLabelViewModel.moveToCreateNewlabelView = true
                    }
                    
                    List(favoriteEmails, id: \.self) { email in
                        HStack{
                            Image("unchecked")
                            Text(email)
                                .padding(.leading,10)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .scrollContentBackground(.hidden)
                    .offset(y: -20)
                }
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $createLabelViewModel.moveToCreateNewlabelView) {
                CreateNewLabelView().toolbar(.hidden)
            }
            .onAppear {
                        loadFavoriteEmails()
                    }
    }
    
    private func loadFavoriteEmails() {
        if let decodedEmails = try? JSONDecoder().decode([String].self, from: sessionManager.favoriteEmailsData) {
            favoriteEmails = decodedEmails
        }
    }
}

#Preview {
    CreateLabelView()
}

