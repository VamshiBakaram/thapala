//
//  HomeNavigatorView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import SwiftUI

struct HomeNavigatorView: View {
    @StateObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var isMenuVisible = false
    @State private var isQuickAccessVisible = false
    @StateObject var ConsoleviewModel = ConsoleNavigatiorViewModel()
    let imageUrl: String
    @State private var iNotificationAppBarView = false
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                VStack{
                    VStack {
                        HStack{
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
                                
                                
                                    Text("Navigator")
                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                        .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                                        .padding(.leading,0)
                            
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
                        .padding(.top, -reader.size.height * 0.01)
                        
                        HStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isAdobeSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .adobe
                                    self.homeNavigatorViewModel.isAdobeSelected = true
                                    self.homeNavigatorViewModel.isBioSelected = false
                                    self.homeNavigatorViewModel.isControlSelected = false
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("emailG")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .padding(5)
                                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(themesviewModel.currentTheme.tabBackground)
                                                )
                                            VStack{
                                                Text("Adobe")
                                                    .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                            }
                                        }
                                    }
                                )
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isBioSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .bio
                                    self.homeNavigatorViewModel.isAdobeSelected = false
                                    self.homeNavigatorViewModel.isBioSelected = true
                                    self.homeNavigatorViewModel.isControlSelected = false
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("plannerIcon")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .padding(5)
                                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(themesviewModel.currentTheme.tabBackground)
                                                )
                                            VStack{
                                                Text("Bio")
                                                    .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                            }
                                        }
                                    }
                                )
                            
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isControlSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .controlPanel
                                    self.homeNavigatorViewModel.isAdobeSelected = false
                                    self.homeNavigatorViewModel.isBioSelected = false
                                    self.homeNavigatorViewModel.isControlSelected = true
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("navigatorStorage")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .padding(5)
                                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(themesviewModel.currentTheme.tabBackground)
                                                )
                                            VStack{
                                                Text("Console")
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
                    if let selectedOption = homeNavigatorViewModel.selectedOption {
                        switch selectedOption {
                        case .adobe:
                           // AdobeView
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
                            
                        case .bio:
                            BioView(imageUrl: "")
                        case .controlPanel:
                            ControlHeaderView(sessionManager: sessionManager)
                        }
                    }
                    
                    Spacer()

                    if ConsoleviewModel.isContactsDialogVisible == false{
                        TabViewNavigator()
                            .frame(height: 40)
                            .padding(.bottom, 10)
                    }
                    
                }
                .navigationBarBackButtonHidden(true)
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear{
                    self.homeNavigatorViewModel.selectedOption = .controlPanel
                    self.homeNavigatorViewModel.isControlSelected = true
                }
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                
                if homeNavigatorViewModel.isPlusbtn {
                    QuickAccessView(isQuickAccessVisible: $homeNavigatorViewModel.isPlusbtn)
                        .transition(.opacity)
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
            .navigationDestination(isPresented: $homeNavigatorViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }

        }

       
    }

//    struct ControlHeaderView_Previews: PreviewProvider {
//        static var previews: some View {
//            ControlHeaderView()
//        }
//    }

}

#Preview {
    HomeNavigatorView(imageUrl: "")
}
