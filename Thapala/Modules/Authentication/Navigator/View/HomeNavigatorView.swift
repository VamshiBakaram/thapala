//
//  HomeNavigatorView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import SwiftUI

struct HomeNavigatorView: View {
    @State private var isMenuVisible = false
    @StateObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var isQuickAccessVisible = false
    @StateObject var ConsoleviewModel = ConsoleNavigatiorViewModel()
    let imageUrl: String
    @State private var iNotificationAppBarView = false
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                VStack{
                    VStack {
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
                            
                            Text("Navigator")
                                .padding(.leading,20)
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            Spacer()
                            Button(action: {
                                appBarElementsViewModel.isSearch = true
                            }) {
                                Image("magnifyingglass")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                                    .padding(.trailing , 16)
                            }
                            
                            Button(action: {
                                iNotificationAppBarView = true
                            }) {
                                Image("notification")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            
                            Button(action: {
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
                        
                        HStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isAdobeSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: reader.size.width/3 - 10, height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .adobe
                                    self.homeNavigatorViewModel.isAdobeSelected = true
                                    self.homeNavigatorViewModel.isBioSelected = false
                                    self.homeNavigatorViewModel.isControlSelected = false
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("AdobeIcon")
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .background(themesviewModel.currentTheme.tabBackground)
                                            VStack{
                                                Text("Adobe")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                            }
                                        }
                                    }
                                )
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isBioSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: reader.size.width/3 - 10, height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .bio
                                    self.homeNavigatorViewModel.isAdobeSelected = false
                                    self.homeNavigatorViewModel.isBioSelected = true
                                    self.homeNavigatorViewModel.isControlSelected = false
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("BioIcon")
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .background(themesviewModel.currentTheme.tabBackground)
                                            VStack{
                                                Text("Bio")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                            }
                                        }
                                    }
                                )
                            
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isControlSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: reader.size.width/3 - 10, height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .controlPanel
                                    self.homeNavigatorViewModel.isAdobeSelected = false
                                    self.homeNavigatorViewModel.isBioSelected = false
                                    self.homeNavigatorViewModel.isControlSelected = true
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("consoleNavigator")
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .background(themesviewModel.currentTheme.tabBackground)
                                            VStack{
                                                Text("Console")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                    
                                            }
                                        }
                                    }
                                    
                                )
                        }
                        .padding([.leading,.trailing])
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
                            ControlHeaderView()
                        }
                    }
                    
                    Spacer()
                    
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
                                                 homeNavigatorViewModel.isComposeEmail = true
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

    struct ControlHeaderView_Previews: PreviewProvider {
        static var previews: some View {
            ControlHeaderView()
        }
    }

}

#Preview {
    HomeNavigatorView(imageUrl: "")
}
