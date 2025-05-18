//
//  CreateNewLabelView.swift
//  Thapala
//
//  Created by Ahex-Guest on 27/08/24.
//

import SwiftUI

struct CreateNewLabelView: View {
    @State private var labelName: String = ""
    @EnvironmentObject var sessionManager: SessionManager
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var createNewLabelViewModel = CreateNewLabelViewModel()
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Create Label")
                    .font(.custom(.poppinsSemiBold, size: 14))
                Spacer()
                Button(action: {
                    if !labelName.isEmpty {
                        addFavoriteEmail(labelName)
                    }
                }) {
                    Text("Save")
                        .foregroundColor(labelName.isEmpty ? Color(UIColor.systemGray) : Color.blue)
                }
            }
            .padding()
            Text("Name")
                .font(.custom(.poppinsSemiBold, size: 14))
                .padding(.leading, 16)
            
            TextField("Add label name", text: $labelName)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 16)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    private func addFavoriteEmail(_ email: String) {
        createNewLabelViewModel.favoriteEmails.append(email)
        saveFavoriteEmails()
    }
    
    private func saveFavoriteEmails() {
        if let data = try? JSONEncoder().encode(createNewLabelViewModel.favoriteEmails) {
            sessionManager.favoriteEmailsData = data
        }
    }
}

class CreateNewLabelViewModel:ObservableObject{
    @Published var favoriteEmails: [String] = []
}

//#Preview {
//    CreateNewLabelView()
//}
