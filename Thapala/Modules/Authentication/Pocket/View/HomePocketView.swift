//
//  HomePocketView.swift
//  Thapala
//
//  Created by Ahex-Guest on 19/06/24.
//

import SwiftUI
struct HomePocketView: View {
    @State private var isMenuVisible = false
    @State private var isQuickAccessVisible = false
    @StateObject var homePocketViewModel = HomePocketViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    let imageUrl: String
    @State private var isSearchView = false
    @State private var iNotificationAppBarView = false
    
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                themesviewModel.currentTheme.windowBackground
                    .ignoresSafeArea()
                VStack {
                    VStack{
                        HStack(spacing:20){
                            Image("contactW")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 35, height: 35)
                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                .background(
                                    Circle()
                                        .fill(themesviewModel.currentTheme.colorPrimary) // Inner background
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2) // Border
                                )
                                .clipShape(Circle())
                                .padding(.leading, 16)
                            
                            Text("Pocket")
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                            
                            Spacer()
                            Button(action: {
                                appBarElementsViewModel.isSearch = true
                            }) {
                                Image("magnifyingglass")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            .padding(.leading,15)
                            
                            Button(action: {
                                iNotificationAppBarView = true
                            }) {
                                Image("notification")
                            }
                            .padding(.leading,15)
                            
                            
                            Button(action: {
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            }) {
                                Image("MenuIcon")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            .padding(.leading,15)
                            .padding(.trailing , 30)
                            
                        }
                        .padding(.top , -reader.size.height * 0.01)
                        

                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .overlay(
                                            Group{
                                                HStack{
                                                 Image("compose")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    VStack{
                                                        Text("tReturns")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("printIcon")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    
                                                    VStack{
                                                        Text("tTransactions")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                            
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("chatBox")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    
                                                    VStack{
                                                        Text("tBank")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                }
                                .padding([.leading,.trailing,],5)
                                .padding(.bottom , 10)
                     
                        
                    }
                    .frame(height: reader.size.height * 0.16)
                    .background(themesviewModel.currentTheme.tabBackground)
                    ZStack {
                        Color.clear // Background to help center the image
                        Image("coming soon") // Replace with the actual image name
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .scaledToFit()
                            .frame(width: 160, height: 111.02)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.clear)
                    
                    VStack {
                         HStack {
                             Spacer()
                             RoundedRectangle(cornerRadius: 30)
                                 .fill(themesviewModel.currentTheme.colorPrimary)
                                 .frame(width: 150, height: 48)
                                 .overlay(
                                     HStack {
                                         Text("New Email")
                                             .font(.custom(.poppinsBold, size: 14))
                                             .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                             .padding(.trailing, 8)
                                             .onTapGesture {
                                                 homePocketViewModel.isComposeEmail = true
                                             }
                                         Spacer()
                                             .frame(width: 1, height: 24)
                                             .background(themesviewModel.currentTheme.inverseIconColor)
                                         Image("dropdown 1")
                                             .foregroundColor(themesviewModel.currentTheme.iconColor)
                                             .onTapGesture {
                                                 isQuickAccessVisible = true
                                             }
                                     }
                                 )
                                 .padding(.trailing, 20)
                                 .padding(.bottom, 20)
                         }
                     }
                    
                    TabViewNavigator()
                        .frame(height: 40)
                        .padding(.bottom, 10)

                }
                

                
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                
                if isQuickAccessVisible {
                    ZStack {
                        Color.gray.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isQuickAccessVisible = false
                            }
                        QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
                            .background(Color.white) // Background color for the Quick Access View
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing) // Align at the bottom right
                            .padding([.bottom, .trailing], 20)
                    }
                }
                
                
                if iNotificationAppBarView {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    iNotificationAppBarView = false
                                }
                            }
                        NotificationAppBarView()
                        .frame(height: .infinity)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(20)
                        .padding(.horizontal,20)
                        .padding(.bottom,50)
                        .padding(.top,80)
                        .transition(.scale)
                        .animation(.easeInOut, value: iNotificationAppBarView)
                    }
                }

            }
            .navigationDestination(isPresented: $appBarElementsViewModel.isSearch) {
                SearchView(appBarElementsViewModel: appBarElementsViewModel)
                    .toolbar(.hidden)
            }
            .navigationDestination(isPresented: $homePocketViewModel.isComposeEmail) {
                    MailComposeView().toolbar(.hidden)
                }
            .toast(message: $homePocketViewModel.error)
        }
    }
}

#Preview {
    HomePocketView(imageUrl: "")
}
