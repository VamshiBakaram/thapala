//
//  InsertFileFromRecordsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/08/24.
//

import SwiftUI

struct InsertFileFromRecordsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var themesviewModel = themesViewModel()
    @State private var selectedTab: String = "Work"
    let folderItems = ["My files", "My mails", "My pictures", "My videos"]

    var body: some View {
      
            VStack {
                
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    Spacer()
                }
                .padding([.leading,.top],20)
                
                HStack {
                    Text("Insert file from records")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsSemiBold, size: 14))
                        .padding(.top,30)
                    Spacer()
                }
                .padding(.leading,30)

                HStack {
                    TabButton(title: "Work", selectedTab: $selectedTab)
                    TabButton(title: "Archive", selectedTab: $selectedTab)
                    TabButton(title: "Locker", selectedTab: $selectedTab)
                }
                .padding()
                .foregroundColor(themesviewModel.currentTheme.textColor)
                .frame(height: 44)
                .padding([.leading,.trailing],15)
                .padding(.top,20)

                
                HStack {
                    Text("Folders")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsLight, size: 14))
                    .padding(.horizontal)
                    .padding(.top,15)
                    Spacer()
                }
                .padding([.leading,.trailing],15)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                    ForEach(folderItems, id: \.self) { name in
                        FolderView(title: name)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical)

                Spacer()
               
                HStack {
                    Spacer()
                    Button(action: {
                       
                    }) {
                        Text("cancel")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .padding([.leading,.trailing],15)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }

                    Button(action: {
                      
                    }) {
                        Text("Insert")
                            .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                            .padding([.leading,.trailing],15)
                            .padding()
                            .background(Color.themeColor)
                            .cornerRadius(8)
                    }
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
//                Spacer()
            }
            .background(themesviewModel.currentTheme.windowBackground)
        
    }
}

struct TabButton: View {
    var title: String
    @Binding var selectedTab: String

    var body: some View {
        Button(action: {
            selectedTab = title
        }) {
            Text(title)
                .fontWeight(selectedTab == title ? .bold : .regular)
                .foregroundColor(selectedTab == title ? .white : .black)
                .padding([.leading,.trailing],15)
                .padding([.top,.bottom],10)
                .frame(maxWidth: .infinity)
                .background(selectedTab == title ? Color.themeColor : Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedTab == title ? Color.clear : Color.gray, lineWidth: 1)
                )
        }
    }
}

struct FolderView: View {
    @ObservedObject var themesviewModel = themesViewModel()
    var title: String

    var body: some View {
        HStack {
            Image(systemName: "folder")
                .renderingMode(.template)
                .foregroundColor(themesviewModel.currentTheme.iconColor)
            Text(title)
                .foregroundColor(themesviewModel.currentTheme.iconColor)
                .font(.body)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1))
    }
}
#Preview {
    InsertFileFromRecordsView()
}
