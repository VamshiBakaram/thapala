//
//  CreateNewFolderView.swift
//  Thapala
//
//  Created by Ahex-Guest on 19/06/24.
//

import SwiftUI

struct CreateNewFolderView: View {
    
     @Binding var isNewGroupVisible: Bool
     @ObservedObject private var createNewFolderViewModel = CreateNewFolderViewModel()
     
     var body: some View {
         ZStack{
             Color(red: 0, green: 0, blue: 0)
                 .opacity(0.3)
                 .ignoresSafeArea()
             VStack(spacing:16){
                 HStack{
                     Spacer()
                     Text("Create new group")
                         .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                         .padding(.top,25)
                         .padding(.horizontal)
                     Spacer()
                     Button(action: {
                         self.isNewGroupVisible = false
                     }, label: {
                         Image("cross")
                     })
                     .padding(.top,25)
                     .padding(.trailing, 15)
                 
                 }
                
                 FloatingTextField(text: $createNewFolderViewModel.folderName, placeHolder: "Folder name", allowedCharacter: .defaultType)
                     .padding(.horizontal)
                 
                 Button(action: {
                     
                 }, label: {
                     Text("Create Folder")
                 })
                 .padding(.all,10)
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
    CreateNewFolderView(isNewGroupVisible: .constant(true))
}
