//
//  HomeRecordsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 19/06/24.
//

import SwiftUI

struct HomeRecordsView: View {
    @State private var isMenuVisible = false
    @ObservedObject var homeRecordsViewModel = HomeRecordsViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    let imageUrl: String
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                VStack{
                    VStack {
                        AsyncImage(url: URL(string: imageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .padding(.leading,20)
                            case .failure:
                                Image("person")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .padding(.leading,20)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        HStack(spacing:20){
                            Text("Records")
                                .padding(.leading,20)
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            Spacer()
                            Button(action: {
                                print("search button pressed")
                            }) {
                                Image("magnifyingglass")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            
                            Button(action: {
                                print("bell button pressed")
                            }) {
                                Image("bell")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            
                            Button(action: {
                                print("line.3.horizontal button pressed")
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .font(Font.title.weight(.medium))
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                            }
                            .padding(.trailing,15)
                        }
                        .padding(.top , -50)
                        HStack {
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeRecordsViewModel.isWorkSelected ?themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            self.homeRecordsViewModel.selectedOption = .work
                                            self.homeRecordsViewModel.isWorkSelected = true
                                            self.homeRecordsViewModel.isArchiveSelected = false
                                            self.homeRecordsViewModel.isLockerSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("workSpace")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    VStack{
                                                        Text("WorkSpace")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeRecordsViewModel.isArchiveSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            self.homeRecordsViewModel.selectedOption = .archive
                                            self.homeRecordsViewModel.isWorkSelected = false
                                            self.homeRecordsViewModel.isArchiveSelected = true
                                            self.homeRecordsViewModel.isLockerSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("Archieve")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    //  .padding()
                                                    VStack{
                                                        Text("Archive")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                            
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeRecordsViewModel.isLockerSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            self.homeRecordsViewModel.selectedOption = .locker
                                            self.homeRecordsViewModel.isWorkSelected = false
                                            self.homeRecordsViewModel.isArchiveSelected = false
                                            self.homeRecordsViewModel.isLockerSelected = true
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("Locker")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    VStack{
                                                        Text("Locker")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                }
                                .padding([.leading,.trailing])
                            }
                            
                        }
//                        .padding(.top , 1)
                      
                    }
                    
                    .frame(height: 120)
                    .background(themesviewModel.currentTheme.tabBackground)
                    

                    HStack {
                        Spacer()
                        HStack {
                            /*
                             Button {
                                 homeRecordsViewModel.isSubMenu = true
                                 print("New Pressed")
                             } label: {
                                 Text("New")
                                     .foregroundColor(Color.white)
                                     .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                         }
                             Image("add")
                                 .onTapGesture {
                                     homeRecordsViewModel.isSubMenu = true
                                 }
                             */
                            Menu {
                                Button(action: {
                                    homeRecordsViewModel.isNewFolder = true
                                }) {
                                    Text("New Folder")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                }
                                Button(action: {
                                    homeRecordsViewModel.isFileUpload = true
                                }) {
                                    Text("File upload")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                }
                            } label: {
                                Text("New")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                Image("add")
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                        }
                        .padding([.leading,.trailing],10)
                        .padding([.top,.bottom],5)
                        .background(themesviewModel.currentTheme.tabBackground)
                        .cornerRadius(10)
                        .padding(.trailing,20)
                        .popover(isPresented: $homeRecordsViewModel.isSubMenu, content: {
                            addNewView
                                .presentationCompactAdaptation(.popover)
                        })
                        
                    }
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            homeRecordsViewModel.isPlusBtn = true
                        }) {
                            Image("plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // You can adjust size here
                                .padding()
                                .background(themesviewModel.currentTheme.tabBackground)
                                .clipShape(Circle())
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding(.trailing,15)
                    }
                }
                .background(themesviewModel.currentTheme.windowBackground)
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                if homeRecordsViewModel.isPlusBtn {
                    QuickAccessView(isQuickAccessVisible: $homeRecordsViewModel.isPlusBtn)
                        .transition(.opacity)
                }
                
            }
            .navigationDestination(isPresented: $homeRecordsViewModel.isComposeEmail) {
               // MailComposeView().toolbar(.hidden)
            }
//            .navigationDestination(isPresented: $homeResidenceViewModel.isDetailedData) {
//                ResidenceUserProfileView().toolbar(.hidden)
//            }
            .toast(message: $homeRecordsViewModel.error)
            
            if homeRecordsViewModel.isNewFolder {
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                AddNewGroupView(isNewGroupVisible: $homeRecordsViewModel.isNewFolder)
                    .transition(.opacity)
            }
        }
    }
    
    var addNewView: some View {
        VStack(spacing: 16) {
            Button {
               
            } label: {
                Text("New Folder")
                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
            }
            Button {
               
            } label: {
                Text("File Upload")
                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    HomeRecordsView(imageUrl: "")
}
