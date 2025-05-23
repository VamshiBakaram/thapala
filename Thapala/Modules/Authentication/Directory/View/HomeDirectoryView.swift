//
//  HomeDirectoryView.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/10/24.
//

import SwiftUI
struct HomeDirectoryView: View {
    @ObservedObject var homeDirectoryViewModel = HomeDirectoryViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var isHomeDirectoryVisible: Bool
    let imageUrl: String
    @State private var isMenuVisible = false
    @State private var isShowDialogue = false
    @State private var isProfileDialogue = false
    @State private var isVisible = false
    @State var firstname: String = ""
    @State var groupNamesArray: [String] = []
    @State var id: Int = 0
    @State private var isSearchDialogVisible = false
    @State private var isContactsDialogVisible = false
    @State private var isQuickAccessVisible = false
    var body: some View {
        GeometryReader{ reader in
            ZStack {
                themesviewModel.currentTheme.windowBackground
            VStack {
                VStack {
                    HStack{
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
                        VStack (alignment:.leading) {
                            Text("Directory")
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                        }
                        .padding(.leading,0)
                        Spacer()
                        Button(action: {
                            print("search button pressed")
                        }) {
                            Image("magnifyingglass")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                .font(Font.title.weight(.medium))
                            
                        }
                        .padding(.leading,15)
                        Button(action: {
                            print("bell button pressed")
                        }) {
                            Image("notification")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                .font(Font.title.weight(.medium))
                        }
                        .padding(.leading,15)
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
                        .padding([.leading,.trailing],15)
                        
                    }
                    .padding(.top , 30)
                    
                    
                ScrollView(.horizontal,showsIndicators: false){
                    HStack {
                        HStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeDirectoryViewModel.isTcontactsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.attachmentBGColor)
                                .frame(width: 120 , height: 40)
                                .onTapGesture {
                                    self.homeDirectoryViewModel.selectedOption = .tContacts
                                    print("Emailed clicked")
                                    homeDirectoryViewModel.GetDirectoryList()
                                    self.homeDirectoryViewModel.isTcontactsSelected = true
                                    self.homeDirectoryViewModel.isTestSelected = false
                                    self.homeDirectoryViewModel.isTest2Selected = false
                                    
                                }
                                .overlay(
                                    Group {
                                        HStack {
                                            Image("emailG")
                                                .renderingMode(.template)
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .background(themesviewModel.currentTheme.tabBackground)
                                            VStack {
                                                Text("TContacts")
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                    .foregroundColor(self.homeDirectoryViewModel.isTcontactsSelected ? Color.black : Color.white)
                                            }
                                        }
                                    }
                                )
                                .padding(.leading , 20)
                            Spacer()
                                .frame(width: 10)
                            
                            
                            
                        }
                        .padding(.top , 30)
                        
                        HStack{
                            ForEach(groupNamesArray.indices, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(self.homeDirectoryViewModel.isTestSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.attachmentBGColor)
                                    .frame(width: 120 , height: 40)
                                    .onTapGesture {
                                       self.homeDirectoryViewModel.selectedOption = .test
                                        print("Group clicked \(groupNamesArray[index])")
                                        self.homeDirectoryViewModel.isTcontactsSelected = false
                                        self.homeDirectoryViewModel.isTestSelected = true
                                        self.homeDirectoryViewModel.isTest2Selected = false
//                                        self.homeAwaitingViewModel.getEmailsData()
                                    }
                                    .overlay(
                                        Group {
                                            HStack {
                                                Image("NewGroups")
                                                    .renderingMode(.template)
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .background(themesviewModel.currentTheme.tabBackground)
                                                VStack {
                                                    Text(groupNamesArray[index])
                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                        .foregroundColor(Color.white)
                                                    
                                                }
                                            }
                                        }
                                    )
                                    .padding(.leading , 20)
                                Spacer()
                                    .frame(width: 10)
                                
                            }
                            
                        }
                        .padding(.top , 30)
                        
                    }
//                    .padding([.leading,.trailing],5)
                    }
                }
                .frame(height: 180)
                .background(themesviewModel.currentTheme.colorPrimary)
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .frame(width: 24, height: 24)
                            .padding(.leading, 12)
                            .onTapGesture {
                                homeDirectoryViewModel.getStatesAndCities()
                                isSearchDialogVisible = true
                            }
                        
                        TextField("Search by tCode or Name", text: $homeDirectoryViewModel.searchText)
                        //                                .onTapGesture {
                        //                                    isShowDialogue = true
                        //                                }
//                                    .padding()
//                                    .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .onTapGesture {
                                isSearchDialogVisible = true
                            }
                    }
                    
                    .padding()
                    .background(themesviewModel.currentTheme.AllGray)
                    .cornerRadius(10)
                    Button(action: {
                        isContactsDialogVisible = true
                    }) {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                            .padding()
                            .background(themesviewModel.currentTheme.AllGray)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                if let selectedOption = homeDirectoryViewModel.selectedOption {
                    switch selectedOption {
                    case .tContacts:
                        // Search bar and add button
                        HStack(alignment: .top) {
                            ScrollView {
//                                if homeDirectoryViewModel.isLoading {
//                                    VStack {
//                                        Spacer()
//                                        ProgressView("Loading...")
//                                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
//                                            .scaleEffect(1.5)
//                                        Spacer()
//                                    }
//                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                }
//                                else {
                                    VStack(alignment: .leading, spacing: 5) {
                                        ForEach(homeDirectoryViewModel.DirectoryData, id: \.firstname) { item in
                                            HStack {
                                                AsyncImage(url: URL(string: item.profile ?? "")) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        // Display system profile image when loading fails
                                                        Image("person")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        //                                                        .aspectRatio(contentMode: .fill)
                                                            .clipShape(Circle())
                                                            .frame(width: 40, height: 40)
                                                        //                                                        .foregroundColor(.gray)
                                                            .padding(.leading, 12)
                                                    case .success(let image):
                                                        // Display the image when it's successfully loaded
                                                        image
                                                            .resizable()
                                                            .frame(width: 40, height: 40)
                                                            .clipShape(Circle())
                                                            .padding(.leading, 12)
                                                    case .failure:
                                                        // Display a blue circle as a placeholder when loading fails
                                                        Circle()
                                                            .fill(themesviewModel.currentTheme.iconColor) // Set the background color to blue
                                                            .frame(width: 40, height: 40) // Define the size
                                                            .padding(.leading, 12)
                                                        
                                                    @unknown default:
                                                        // Default case for future versions
                                                        EmptyView()
                                                    }
                                                }
                                                
                                                
                                                
                                                Text(item.firstname)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom("Poppins-SemiBold", size: 14)) // Update font name and size
                                                    .padding(.leading, 8)
                                                Text(item.lastname)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom("Poppins-SemiBold", size: 14)) // Update font name and size
                                                Spacer()
                                            }
                                            .onTapGesture{
                                                homeDirectoryViewModel.GetProfileByID(selectId: item.id)
                                                isProfileDialogue.toggle()
                                                id = item.id
                                                print("let check the id     \(id)")
                                                
                                                isProfileDialogue = true
                                            }
                                            .padding(.vertical, 5)
                                            Divider()
                                                .background(Color.black)
                                                .padding(.horizontal, 12)
                                            
                                        }
                                        
                                    }
                                    .padding(.vertical, 10)
//                                }
                            }
                            .refreshable {
                                homeDirectoryViewModel.GetDirectoryList()
                            }
                        }
                        
                    case .test:
                        VStack {
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(themesviewModel.currentTheme.windowBackground)

                    case .test2:
                        VStack{
                            Text("Test2")
                        }
                        //
                    }
                }
                
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                if isProfileDialogue {
                    ZStack {
                        VStack {
                            if let diary = homeDirectoryViewModel.DirectoryData.first(where: { $0.id == id }) {
                                HStack{
                                    // Profile image and name
                                    AsyncImage(url: URL(string: diary.profile ?? "")) { phase in
                                        switch phase {
                                        case .empty:
                                            Image("person")
                                                .resizable()
                                                .clipShape(Circle())
                                                .frame(width: 40, height: 40)
                                                .padding(.leading, 12)
                                        case .success(let image):
                                            image
                                                .resizable()
//                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                                .padding(.leading, 12)
                                        case .failure:
                                            Circle()
//                                                .fill(themesviewModel.currentTheme.iconColor)
                                                .frame(width: 40, height: 40)
                                                .padding(.leading, 12)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .padding(.leading , 150)
                                    Spacer() // Push profile image & name to the right
                                    Image("cross")
                                        .resizable()
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                        .padding(.leading, 10)
                                        .onTapGesture {
                                            print("diary.profile \(diary.profile ?? "")")
                                            withAnimation {
                                                isProfileDialogue = false // Close dialog on tap
                                            }
                                        }
                                }
                                
                                Text("\(diary.firstname) \(diary.lastname)")
                                    .font(.custom("Poppins-SemiBold", size: 14))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 8)
                                
                                // tCode and Email
                                HStack {
                                        Text("tCode: \(diary.tCode.prefix(4))******")
                                            .font(.body)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        Image("profilemail")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .frame(width: 20, height: 20)
                                    
                                }
                                
                                // Location and Languages
                                HStack {
                                    Image("profileLocation")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                    
                                    Text(diary.place ?? "N/A")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    
                                    
                                    Text("|")
                                    
                                    Image("profileLanguage")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                    
                                    if let data = homeDirectoryViewModel.profileIdData.first(where: { $0.userId == diary.id }) {
                                        Text(data.languages ?? "N/A")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                    }
                                    else {
                                        Text("N/A")
                                    }
                                }
                                
                                Divider()
                                    .background(themesviewModel.currentTheme.AllGray)
                                    .padding(.horizontal, 12)
                                
                                // Icons
                                HStack {
                                    Image("profileContact")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .padding(5)
                                    Image("profileMove")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(5)
                                    Image("profileReport")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(5)
                                    Image("profileBlocked")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(5)
                                }
                            } else {
                                Text("else case")
                            }
                        }
                        .padding(20) // Padding inside the dialog
                        .background(themesviewModel.currentTheme.windowBackground) // Dialog background
                        .cornerRadius(12) // Rounded corners
                        .shadow(radius: 10) // Shadow for the dialog
                        .padding(.horizontal, 16) // Padding from the screen edges
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .onTapGesture {
                        withAnimation {
                            isProfileDialogue = false // Dismiss the dialog
                        }
                    }
                }
                
                VStack {
    //                        Spacer().frame(height: 100)
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
                                             homeDirectoryViewModel.isComposeEmail = true
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
            }
                
                
                
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                    print("✅ View appeared")
                    homeDirectoryViewModel.getStatesAndCities()
                if homeDirectoryViewModel.DirectoryData.isEmpty {
                    homeDirectoryViewModel.GetDirectoryList()
                    if homeDirectoryViewModel.groupList.isEmpty {
                        print("GetGroupList Data")
                        homeDirectoryViewModel.GetGroupList()
                    }
                }

                // Delay execution to ensure data is loaded before processing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // 500ms delay
                    if !homeDirectoryViewModel.DirectoryData.isEmpty {
                        // Map all titles into an array
                        let allTitles = homeDirectoryViewModel.DirectoryData.map { $0.firstname }
                        firstname = allTitles.joined(separator: ", ")
//                        print("firstname \(firstname)")
                        
                        let profiles = homeDirectoryViewModel.DirectoryData.map { $0.profile }
                        print("firstname \(firstname) , profiles \(profiles)")
                    }
                    if !homeDirectoryViewModel.groupList.isEmpty {
                        groupNamesArray = homeDirectoryViewModel.groupList
                            .compactMap { $0.groupName }
                            .flatMap { $0.components(separatedBy: ",") }
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                        print("groupNamesArray: \(groupNamesArray)")

                        for (index, group) in groupNamesArray.enumerated() {
                            print("Group \(index + 1): \(group)")
                        }
                    }

                    else {
                        print("DirectoryData is empty or invalid")
                    }
                }
            }
//            .onChange(of: homeDirectoryViewModel.countryCodes) { newList in
//                print("🌍 Loaded \(newList.count) countries:")
//                for (index, country) in newList.enumerated() {
//                    print("Country #\(index + 1) has \(country.states.count) states")
//                }
//            }


                
                if homeDirectoryViewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.5)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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

                if isSearchDialogVisible {
                    ZStack {
                        // Blur background
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isSearchDialogVisible = false
                                }
                            }
                        
                        VStack {
//                            FloatingTextField(text: $homeDirectoryViewModel.country, placeHolder: "Country", allowedCharacter: .defaultType)
//                                .padding(.horizontal, 10)
                            Menu {
                                ForEach(homeDirectoryViewModel.countryCodes.indices, id: \.self) { index in
                                    Button {
                                        homeDirectoryViewModel.selectCountry(at: index)
                                    } label: {
                                        Text(homeDirectoryViewModel.countryCodes[index].countryName)
                                    }
                                }
                            } label: {
                                Text(homeDirectoryViewModel.selectedCountryIndex != nil ?
                                     homeDirectoryViewModel.countryCodes[homeDirectoryViewModel.selectedCountryIndex!].countryName :
                                     "Select Country")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .background(themesviewModel.currentTheme.colorPrimary)
                                    .cornerRadius(8)
                            }
                            
                            // State menu
                            Menu {
                                ForEach(homeDirectoryViewModel.allStates.indices, id: \.self) { index in
                                    Button {
                                        homeDirectoryViewModel.selectState(at: index)
                                    } label: {
                                        Text(homeDirectoryViewModel.allStates[index].stateName)
                                    }
                                }
                            } label: {
                                Text(homeDirectoryViewModel.selectedStateIndex != nil ?
                                     homeDirectoryViewModel.allStates[homeDirectoryViewModel.selectedStateIndex!].stateName :
                                     "Select State")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .background(themesviewModel.currentTheme.colorPrimary)
                                    .cornerRadius(8)
                            }
                            
                            // City menu
                            Menu {
                                ForEach(homeDirectoryViewModel.citiesInSelectedState.indices, id: \.self) { index in
                                    Button {
                                        homeDirectoryViewModel.selectCity(at: index)
                                    } label: {
                                        Text(homeDirectoryViewModel.citiesInSelectedState[index])
                                    }
                                }
                            } label: {
                                Text(homeDirectoryViewModel.selectedCityIndex != nil ?
                                     homeDirectoryViewModel.citiesInSelectedState[homeDirectoryViewModel.selectedCityIndex!] :
                                     "Select City")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .background(themesviewModel.currentTheme.colorPrimary)
                                    .cornerRadius(8)
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("Button clicked!")
                                }) {
                                    Text("Reset")
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(themesviewModel.currentTheme.windowBackground)
                                        .background(themesviewModel.currentTheme.colorControlNormal)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 0.5) // Set border color and width
                                        )
                                }
                                .padding(.trailing, 16) // Align "Create" button to trailing
                                
                                Button(action: {
                                    print("Button clicked!")
                                }) {
                                    Text("Search")
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(themesviewModel.currentTheme.colorControlNormal)
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 16)
                            }

                        }
                        .padding(20)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 16)
                    }
                    .zIndex(1) // Ensure this is on top of other views
                    .onTapGesture {
                        print("zstack prints")
                        homeDirectoryViewModel.getStatesAndCities()
                        
                    }
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
                if isContactsDialogVisible {
                    ZStack {
                        // Blur background
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isContactsDialogVisible = false
                                }
                            }
                        
                        VStack {
                            HStack {
                                Text("Create new group")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 16)
                                Spacer()
                                Image("cross")
                                    .foregroundColor(Color.blue)
                                    .frame(width: 35 , height: 35)
                                    .onTapGesture {
                                        withAnimation {
                                            isContactsDialogVisible = false
                                        }
                                    }
                                
                            }
                            
                            floatingtextfield(text: $homeDirectoryViewModel.groupName, placeHolder: "Group name*", allowedCharacter: .defaultType)
                                .padding(.horizontal, 10)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("$homeDirectoryViewModel.groupName \(homeDirectoryViewModel.groupName)")
                                    homeDirectoryViewModel.createGRoup(groupname: homeDirectoryViewModel.groupName)
                                    isContactsDialogVisible = false
                                }) {
                                    Text("Create")
                                        .font(.headline)
                                        .padding()
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 16) // Align "Create" button to trailing
                            }
                        }
                        .padding(20)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 16)
                    }
                    .zIndex(1) // Ensure this is on top of other views
                }

                
        }
            
            .zIndex(0)
            .onTapGesture {
                print("main view zstack clicked")
                isSearchDialogVisible = false
                homeDirectoryViewModel.getStatesAndCities()
            }
            .navigationDestination(isPresented: $homeDirectoryViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }
        }

    }
}


struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a binding with a default value for isHomeDirectoryVisible
        let isHomeDirectoryVisible = Binding.constant(true)
        
        // Pass the binding and a sample image URL
        return HomeDirectoryView(isHomeDirectoryVisible: isHomeDirectoryVisible, imageUrl: "https://example.com/sample-profile.jpg")
    }
}
