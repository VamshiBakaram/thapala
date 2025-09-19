//
//  HomeMenuView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//


import SwiftUI
struct HomeMenuView: View {
    @StateObject var homeMenuViewModel = HomeMenuViewModel()
    @StateObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @StateObject var homeDirectoryViewModel = HomeDirectoryViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject private var blueprintViewModel = BlueprintViewModel()
    @StateObject var infoViewViewModel = InfoViewViewModel()
    @StateObject var TrashedViewModel = TrashViewModel()
    @StateObject var consoleViewModel = ConsoleViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var notificationTime: Int?
    
    let menuData: [HomeMenuData] = [
        .init(image: "queue", menuType: "Queue"),
        .init(image: "postboxW", menuType: "Postbox"),
        .init(image: "conveyedW", menuType: "Conveyed"),
        .init(image: "blueprintW", menuType: "Blueprint"),
        .init(image: "plannerW", menuType: "Planner"),
        .init(image: "pocketW", menuType: "Pocket"),
        .init(image: "direct", menuType: "Directory"),
        .init(image: "recordsW", menuType: "Records"),
        .init(image: "navigatorW", menuType: "Navigator")
    ]
    
    let quickAccessData: [HomeMenuData] = [
        .init(image: "contactW", menuType: "Contacts"),
        .init(image: "chatW", menuType: "Quick Chat"),
        .init(image: "console", menuType: "Console"),
        .init(image: "info", menuType: "Info"),
        .init(image: "snooze", menuType: "Snoozed"),
        .init(image: "starred", menuType: "Starred"),
        .init(image: "delete", menuType: "Trash")
    ]
    
    let mailsData: [HomeMenuData] = [
        .init(image: "", menuType: "Labels"),
        .init(image: "", menuType: "Planner")
    ]
    
    @EnvironmentObject private var sessionManager: SessionManager
    @Binding var isSidebarVisible: Bool
    @State private var selectedOption: HomeMenuData? = .init(image: "queue", menuType: "Queue")
    @State private var path: [HomeMenuData] = []
    @State private var showAlert = false
    @State private var isCancel = false
    @State private var navigateToLoginView = false
    @State private var showEditProfileDialog: Bool = false
    
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {

                if let selected = selectedOption {
                    destinationViewForMenuItem(selected)
                }

                if isSidebarVisible {
                    HStack {
                        Spacer()
                        content
                            .frame(width: UIScreen.main.bounds.width * 0.75)
                            .transition(.move(edge: .trailing))
                    }
                    .background(
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    isSidebarVisible = false
                                    // no reset — last selectedOption remains
                                }
                            }
                    )
                }
            }
            .navigationDestination(for: HomeMenuData.self) { menuItem in
                destinationViewForMenuItem(menuItem).toolbar(.hidden)
            }
            .onAppear {
                homeNavigatorViewModel.getNavigatorBio(userId: sessionManager.userId)
            }
            .toast(message: $homeMenuViewModel.error)
            .overlay {
                if showEditProfileDialog {
                    EditProfileDialog(
                        imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person",
                        name: "\(homeNavigatorViewModel.navigatorBioData?.user?.firstName ?? "") \(homeNavigatorViewModel.navigatorBioData?.user?.lastName ?? "")",
                        tCode: homeNavigatorViewModel.navigatorBioData?.user?.tCode ?? "",
                        isVisible: $showEditProfileDialog
                    )
                }
            }
        }
    }



    
    var content: some View {
        GeometryReader{ reader in
            HStack {
                Spacer()
                ScrollView {
                    VStack {
                        profileHeader
                        Divider()
                            .frame(height: 2)
                            .background(themesviewModel.currentTheme.customEditTextColor)
                            .padding([.leading, .trailing], 10)
                        
                        menuListView(menuData: menuData, selectedOption: $selectedOption)
                        Divider()
                            .frame(height: 1)
                            .background(themesviewModel.currentTheme.customEditTextColor)
                            .padding([.leading, .trailing], 10)
                        
                        quickAccessSection
                        Divider()
                            .frame(height: 1)
                            .background(themesviewModel.currentTheme.customEditTextColor)
                            .padding([.leading, .trailing], 10)
                        
                        mailsSection
                        Divider()
                            .frame(height: 1)
                            .background(themesviewModel.currentTheme.customEditTextColor)
                            .padding([.leading, .trailing], 10)
                        
                        Spacer()
                            .frame(height: 10)
                        signOutSection
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.75)
                .background(
                    themesviewModel.currentTheme.colorPrimary
                        .clipShape(
                            RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft])
                        )
                )

                .padding(.top , 5)
            }
        }
    }
    
    var profileHeader: some View {
        HStack {
            Image("contactW")
                .resizable()
                .renderingMode(.template)
                .frame(width: 40, height: 40)
                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                .background(
                    Circle()
                        .fill(themesviewModel.currentTheme.colorPrimary)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2) // Border
                )
                .clipShape(Circle())
                .padding(.leading, 16)
            
            VStack(alignment: .leading) {
                Text("\(sessionManager.userName) \(sessionManager.lastName)" )
                    .font(.custom(.poppinsSemiBold, size: 18))
                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
            
                Text(sessionManager.userTcode)
                    .font(.custom(.poppinsSemiBold, size: 16))
                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
            }
            Image(systemName: "chevron.down")
                .resizable()
                .frame(width: 12, height: 8)
                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
            Spacer()
        }
        .padding([.leading, .top], 15)
                .onTapGesture {
                    showEditProfileDialog.toggle()
        }
    }
    
    func menuListView(menuData: [HomeMenuData], selectedOption: Binding<HomeMenuData?>) -> some View {
        VStack {
            ForEach(menuData) { data in
                HStack {
                    Image(data.image)
                        .renderingMode(.template)
                        .padding(.leading, 20)
                        .foregroundColor(
                            selectedOption.wrappedValue?.menuType == data.menuType ?
                            themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.inverseIconColor
                        )
                    Text(data.menuType)
                        .padding(.leading, 5)
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(
                            selectedOption.wrappedValue?.menuType == data.menuType ?
                            themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.inverseIconColor
                        )

                    Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 5)
                .background(
                    selectedOption.wrappedValue?.menuType == data.menuType ?
                    Color.white : Color.clear
                )
                .cornerRadius(8)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedOption.wrappedValue = data
                    path.append(data)
                }
            }
        }
        .padding(.leading, 5)
    }


    
    var quickAccessSection: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Quick Access")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .padding(.leading, 10)
                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                Spacer()
                
                Button {
                    homeNavigatorViewModel.error = "Need to add above functionality"
                } label: {
                    Image("add1")
                        .padding(.trailing,20)
                }
            }
            menuListView(menuData: quickAccessData, selectedOption: $selectedOption)
        }
    }
    
    var mailsSection: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Mails")
                    .font(.custom("Poppins-SemiBold", size: 14))
                    .padding(.leading, 10)
                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                Spacer()
            }
            menuListView(menuData: mailsData, selectedOption: $selectedOption)
        }
    }
    
    var signOutSection: some View {
        VStack {
            Divider().padding([.leading, .trailing], 10)
            HStack {
                Image("signout")
                Text("Sign Out")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                Spacer()
            }
            .padding(.leading, 10)
            .onTapGesture {
                showAlert = true
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Sign Out"),
                message: Text("Are you sure you want to sign out?"),
                primaryButton: .destructive(Text("Sign Out")) {
                    // Navigate to LoginView
                    homeMenuViewModel.logout(userID: sessionManager.userId)
                    sessionManager.isShowLogin = true
                },
                secondaryButton: .cancel {
                    showAlert = false
                }
            )
        }
    }

    
    
    func destinationViewForMenuItem(_ menuItem: HomeMenuData) -> some View {
        switch menuItem.menuType {
        case "Queue":
            return AnyView(HomeAwaitingView(imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"))
        case "Blueprint":
            return AnyView(BlueprintView(imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"))
            
        case "Conveyed":
            return AnyView(HomeConveyedView(imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"))
        case "Postbox":
            return AnyView(HomePostboxView(imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person", selectedID: 0 , passwordHash: ""))
        case "Planner":
            return AnyView(HomePlannerView())
        case "Pocket":
            return AnyView(HomePocketView( imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"))
        case "Directory":
            return AnyView(HomeDirectoryView(isHomeDirectoryVisible: $homeDirectoryViewModel.directoryUpdate, imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"))
        case "Records":
            return AnyView(HomeRecordsView(imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"))
        case "Navigator":
            return AnyView(HomeNavigatorView(imageUrl: homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"))
        case "Console":
            return AnyView(ConsoleView( selectedID: consoleViewModel.selectedID))
        case "Info":
            return AnyView(InfoView())
        case "Trash":
            return AnyView(TrashView(isTrashViewVisible: $TrashedViewModel.trashupdateView))
        case "Contacts":
            return AnyView(ContactsView())
        case "Snoozed":
            return AnyView(SnoozedMailsView())
        case "Starred":
            return AnyView(StarredMailsView())
        case "Labels":
            return AnyView(LabeledMailsView())
        default:
            return AnyView(EmptyView())
        }
    }
    struct EditProfileDialog: View {
        let imageUrl: String
        let name: String
        let tCode: String
        @Binding var isVisible: Bool

        var body: some View {
            VStack(spacing: 10) {
                // Close button in the top-right corner
                HStack {
                    Spacer()
                    Button(action: {
                        isVisible = false  // Dismiss the dialog
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color.gray)
                            .padding(8)
                    }
                }

                // Profile image with shield icon overlay
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        case .failure:
                            Image("person")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }

                    // Shield icon
                    Image("Tag")
                        .foregroundColor(Color.green)
                        .background(Circle().fill(Color.white).frame(width: 24, height: 24))
                        .offset(x: 8, y: -8)
                }

                // Name and tCode
                Text(name)
                    .font(.headline)
                    .padding(.top, 8)

                HStack(spacing: 4) {
                    Text("tCode: \(tCode)")
                        .foregroundColor(.black)
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.gray)
                }

                // Action buttons
                HStack(spacing: 16) {
                    Button(action: {
                        // Request a feature action
                    }) {
                        Text("Request a feature")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Divider()
                        .frame(height: 20)
                    Button(action: {
                        // Report a problem action
                    }) {
                        Text("Report a problem")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                // My Bio button
                Button(action: {
                    // My Bio action
                }) {
                    Text("My Bio")
                        .frame(minWidth: 100, minHeight: 44)
                        .background(Color.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .padding()
            .frame(width: 320, height: 280)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }


}


#Preview {
    HomeMenuView(isSidebarVisible: .constant(false))
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
