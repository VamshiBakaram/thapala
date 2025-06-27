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
    @StateObject var themesviewModel = themesViewModel()
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
                            
                            Text("Pocket")
                            //                            .padding(.leading,20)
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            Spacer()
                            Button(action: {
                                print("search button pressed")
                                appBarElementsViewModel.isSearch = true
                            }) {
                                Image("magnifyingglass")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            .padding(.leading,15)
                            
                            Button(action: {
                                print("bell button pressed")
                                iNotificationAppBarView = true
                            }) {
                                Image("notification")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                                    .padding(.trailing , 16)
                            }
                            
                            Button(action: {
                                print("line.3.horizontal button pressed")
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            .padding(.trailing,15)
                            
                        }
                        .padding(.top , -reader.size.height * 0.01)
                        
                        HStack {
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .overlay(
                                            Group{
                                                HStack{
                                                 Image("compose")
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    VStack{
                                                        Text("tReturns")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("printIcon")
                                                       .frame(width: 20, height: 20)
                                                       .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                       .background(themesviewModel.currentTheme.tabBackground)
                                                    
                                                    VStack{
                                                        Text("tTransactions")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                            
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("chatBox")
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    
                                                    VStack{
                                                        Text("tBank")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                }
                                .padding(.horizontal , 16)
                            }
                        }
                        
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
                        Color.white.opacity(0.8) // Optional: semi-transparent background
                            .ignoresSafeArea()
                            .blur(radius: 10) // Blur effect for the background
                        QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
                            .background(Color.white) // Background color for the Quick Access View
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing) // Align at the bottom right
                            .padding([.bottom, .trailing], 20)
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
