//
//  HomeRecordsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 19/06/24.
//

import SwiftUI
import AVKit
import _PhotosUI_SwiftUI
import PhotosUI
struct HomeRecordsView: View {
    @State private var isMenuVisible = false
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject var homeRecordsViewModel = HomeRecordsViewModel()
    @StateObject var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var consoleViewModel = consoleviewModel()
    @StateObject var themesviewModel = themesViewModel()
    @State private var selectedTabID : Int = 1059
    @State private var Foldertype : String = "work"
    @State private var subFoldertype : String = "files"
    @State private var selectedTAB: String = "work"
    @State private var workspace: Bool = true
    @State private var isfilesView: Bool = false
    @State private var ismailsView: Bool = false
    @State private var isPicturesView: Bool = false
    @State private var isvideosView: Bool = false
    @State private var typeview: Bool = true
    @State private var showViewer = false // video
    @State private var selectedURL: URL? = nil
    @State private var confirmedURL: URL? = nil
    @State private var isVideo = false // video
    @State private var isMoreSheetvisible: Bool = false
    @State private var emailID: Int = 0
    @State private var fieldID: Int = 0
    @State private var recordID: Int = 0
    @State private var FileAzureName: String = ""
    @State private var foldername: String = ""
    @State private var createdAt: String = ""
    @State private var UpdatedAt: String = ""
    @State private var filesize: String = ""
    @State private var AzureLink: String = ""
    @State private var fileType: String = ""
    @State private var fileFormat: String = ""
    @State private var plusmark: Bool = false
    @State private var createFolder: Bool = false
    @State private var newFolderName: String = ""
    @State private var isFilePickerPresent: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showPhotoPicker = false
    @State private var selectedImages: [UIImage] = []
    @State private var fileclicks: Bool = false
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var AwaitingView: Bool = false
    @State private var lockerView: Bool = false
    @State private var newPinView: Bool = false
    @State private var subFolderView: Bool = false
    @State private var subFolderViewFiles: Bool = false
//    @State private var setPin: String = ""
    @State private var password: String = ""
    @State private var newPin: String = ""
    @State private var confirmPin: String = ""
    @State private var LockerPin: String = ""
    @State private var Lockerpassword: String = ""
    @State private var lockerfilesView: Bool = false
    @State private var MainselectedTabID : [Int] = []
    @State private var workTabIDs: [Int] = []
    @State private var archiveTabIDs: [Int] = []
    @State private var lockerTabIDs: [Int] = []
    let subFolders = ["files", "mails", "pictures", "videos"]
    @State private var toastMessage: String? = nil
    @State private var subfoldersViewIds: Int = 0
    @State private var subfoldersViewType: String = ""
    @State private var isSearchView = false
    @State private var iNotificationAppBarView = false

    func subFolderIndex(for name: String) -> Int? {
        return subFolders.firstIndex(of: name)
    }

    let imageUrl: String
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
                            
                            Text("Records")
                                .padding(.leading,20)
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
                        .padding(.top, -reader.size.height * 0.01)
                        HStack {
                            ScrollView(.horizontal,showsIndicators: false){
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeRecordsViewModel.isWorkSelected ?themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            selectedTAB = "work"
                                            isfilesView = false
                                            typeview = false
                                            lockerView = false
                                            subFolderView = false
                                            subFolderViewFiles = false
                                            workspace = true
                                            Foldertype = "work"; subFoldertype = "files"
                                            homeRecordsViewModel.getRecordsData(selectedTabID: MainselectedTabID[0], Type: Foldertype, SubFoldersType: subFoldertype)
//                                            print("archive TypeselectedTabID \(TypeselectedTabID)")
//                                            print("archive TypeselectedTabID index 0 \(TypeselectedTabID[0])")
//                                            print("archive TypeselectedTabID index 1 \(TypeselectedTabID[1])")
//                                            print("archive TypeselectedTabID index 2 \(TypeselectedTabID[2])")
//                                            print("archive TypeselectedTabID index 2 \(TypeselectedTabID[3])")
                                            
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
                                            selectedTAB = "archive"
                                            isfilesView = false
                                            typeview = false
                                            lockerView = false
                                            subFolderView = false
                                            subFolderViewFiles = false
                                            workspace = true
                                            Foldertype = "archive"; subFoldertype = "files"
                                            homeRecordsViewModel.getRecordsData(selectedTabID: MainselectedTabID[1], Type: Foldertype, SubFoldersType: subFoldertype)
//                                            TypeselectedTabID = homeRecordsViewModel.defaultRecordsData.map { $0.id }
//                                                print("archive TypeselectedTabID \(TypeselectedTabID)")
//                                                print("archive TypeselectedTabID index 0 \(TypeselectedTabID[0])")
//                                            print("archive TypeselectedTabID index 1 \(TypeselectedTabID[1])")
//                                            print("archive TypeselectedTabID index 2 \(TypeselectedTabID[2])")
//                                            print("archive TypeselectedTabID index 2 \(TypeselectedTabID[3])")
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
                                            selectedTAB = "Locker"
                                            workspace = false
                                            ismailsView = false
                                            typeview = false
                                            isfilesView = false
                                            subFolderView = false
                                            subFolderViewFiles = false
                                            lockerView = true
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
                    
                    .frame(height: reader.size.height * 0.16)
                    .background(themesviewModel.currentTheme.tabBackground)
                    

                    HStack {
                        Text("workspace")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .padding(.leading,16)
                        Spacer()
                        Image(typeview ? "printIcon" : "GrId")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 5)
                            .background(themesviewModel.currentTheme.tabBackground)
                            .cornerRadius(10)
                            .padding(.trailing, 20)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                print("before typeview.toggle() \(typeview)")
                                typeview.toggle()
                                print("After typeview.toggle() \(typeview)")
                            }
                    }
                    if workspace {
                        if homeRecordsViewModel.recordsData.count != 0 {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Folders")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .fontWeight(.bold)
                                    .padding(.leading, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                // Define flexible columns to wrap horizontally
                                let columns = [
                                    GridItem(.flexible(minimum: 100), spacing: 10),
                                    GridItem(.flexible(minimum: 100), spacing: 10),
                                    GridItem(.flexible(minimum: 100), spacing: 10)
                                ]
                                
                                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                                    ForEach(homeRecordsViewModel.recordsData.indices, id: \.self) { index in
                                        let folder = homeRecordsViewModel.recordsData[index]
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Image(systemName: "folder.fill")
                                                    .resizable()
                                                    .frame(width: 50, height: 40)
                                                    .foregroundColor(.yellow)
                                                Spacer()
                                                Button(action: {
                                                    isMoreSheetvisible.toggle()
                                                    fileType = "folder"
                                                    fileclicks = false
                                                    print("selectedTabID \(selectedTabID )Foldertype \(Foldertype) SubFoldersType \(subFoldertype) ")
                                                }) {
                                                    Image("dots")
                                                        .resizable()
                                                        .frame(width: 30, height: 30, alignment: .topTrailing)
                                                        .padding(.top, 1)
                                                        .padding(.trailing, 1)
                                                        .foregroundColor(.black)
                                                }
                                                
                                            }
                                            
                                            Text(folder.folderName)
                                                .foregroundColor(.black)
                                        }
                                        .onTapGesture{
                                            subfoldersViewIds = folder.id
                                            subfoldersViewType = folder.type
                                            
                                            print("on click of folder")
//                                            homeRecordsViewModel.getRecordsData(selectedTabID: folder.id, Type: folder.type, SubFoldersType: "")
                                            print("before subFolderView \(subFolderView)")
                                            workspace = false
                                            typeview = false
                                            isfilesView = false
                                            subFolderView = true
                                            subFolderViewFiles = true
                                            print("After subFolderView \(subFolderView)")
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    
                    if subFolderView {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Folders")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .fontWeight(.bold)
                                    .padding(.leading, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                // Define flexible columns to wrap horizontally
                                let columns = [
                                    GridItem(.flexible(minimum: 100), spacing: 10),
                                    GridItem(.flexible(minimum: 100), spacing: 10),
                                    GridItem(.flexible(minimum: 100), spacing: 10)
                                ]
                                
                                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                                    ForEach(homeRecordsViewModel.defaultRecordsData.indices, id: \.self) { index in
                                        let folder = homeRecordsViewModel.defaultRecordsData[index]
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Image(systemName: "folder.fill")
                                                    .resizable()
                                                    .frame(width: 50, height: 40)
                                                    .foregroundColor(.yellow)
                                                Spacer()
                                            }
                                            
                                            Text(folder.folderName)
                                                .foregroundColor(.black)
                                        }
                                        .onAppear{
                                            print("sub folder view appears")
                                            print("folder \(folder)")
                                            print("folder.folderName \(folder.folderName)")
                                            
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                    }
                                }
                                .padding(.horizontal, 16)
                                Spacer()
                                    .frame(height: reader.size.height )
                            }
                            .onAppear{
                                homeRecordsViewModel.getSubRecordsData(selectedTabID: subfoldersViewIds, Type: subfoldersViewType)
                                print("check appears")
                                print("folder id is \(subfoldersViewIds)")
                                print("subfoldersViewType is \(subfoldersViewType)")
                            }

                        
                    }
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            plusmark = true
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
                    Spacer()
                        .frame(height: 15)
                    // Replace your current bottom navigation HStack with this version:

                    HStack{
                        Button(action: {
                            print("file button clicked")
                            if selectedTAB == "work" {
                                selectedTabID = MainselectedTabID[0]+1 ; Foldertype = "work"; subFoldertype = "files"
                                
                                homeRecordsViewModel.folderID = MainselectedTabID[0]+1 ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "files"
                                homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                ismailsView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true
                            }
                            else if selectedTAB == "archive" {
                                selectedTabID = MainselectedTabID[1]+1 ;Foldertype = "archive"; subFoldertype = "files"
                                homeRecordsViewModel.folderID = MainselectedTabID[1]+1 ; homeRecordsViewModel.fileType = "archive" ; homeRecordsViewModel.subfoldertype = "files"
                                homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                ismailsView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true
                            }
                            else if selectedTAB == "Locker"{
                                selectedTabID = MainselectedTabID[2]+1 ;Foldertype = "locker"; subFoldertype = "files"
                                homeRecordsViewModel.folderID = MainselectedTabID[2]+1 ; homeRecordsViewModel.fileType = "locker" ; homeRecordsViewModel.subfoldertype = "files"
                                homeRecordsViewModel.getLockerData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                ismailsView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true
                            }
                        }) {
                            Image("RecordFiles")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .contentShape(Rectangle())
                        Spacer()

                        Button(action: {
                            print("mails button clicked")
                            if selectedTAB == "work" {
                                selectedTabID = MainselectedTabID[0]+2 ; Foldertype = "work"; subFoldertype = "mails"
                                homeRecordsViewModel.folderID = MainselectedTabID[0]+2 ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "mails"
                                homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                isfilesView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = false
                                ismailsView = true
                            }
                            else if selectedTAB == "archive" {
                                selectedTabID = MainselectedTabID[1]+2 ; Foldertype = "archive"; subFoldertype = "mails"
                                homeRecordsViewModel.folderID = MainselectedTabID[1]+2 ; homeRecordsViewModel.fileType = "archive" ; homeRecordsViewModel.subfoldertype = "mails"
                                homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                isfilesView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = false
                                ismailsView = true
                            }
                            else if selectedTAB == "Locker" {
                                selectedTabID = MainselectedTabID[2]+2; Foldertype = "locker"; subFoldertype = "mails"
                                homeRecordsViewModel.folderID = MainselectedTabID[2]+2 ; homeRecordsViewModel.fileType = "locker" ; homeRecordsViewModel.subfoldertype = "mails"
                                homeRecordsViewModel.getLockerData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                isfilesView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = false
                                ismailsView = true
                            }
                        }) {
                            Image("RecordMails")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .contentShape(Rectangle())
                        Spacer()

                        Button(action: {
                            print("pictures button clicked")
                            if selectedTAB == "work" {
                                selectedTabID = MainselectedTabID[0]+3 ;Foldertype = "work"; subFoldertype = "pictures"
                                homeRecordsViewModel.folderID = MainselectedTabID[0]+3 ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "pictures"
                                homeRecordsViewModel.getRecordsData(selectedTabID: MainselectedTabID[0]+3, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                ismailsView = false
                                isPicturesView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true
                            }
                            else if selectedTAB == "archive" {
                                selectedTabID = MainselectedTabID[1]+3 ;Foldertype = "archive"; subFoldertype = "pictures"
                                homeRecordsViewModel.folderID = MainselectedTabID[1]+3 ; homeRecordsViewModel.fileType = "archive" ; homeRecordsViewModel.subfoldertype = "pictures"
                                homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                ismailsView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true
                            }
                            else if selectedTAB == "Locker" {
                                selectedTabID = MainselectedTabID[2]+3 ; Foldertype = "locker"; subFoldertype = "pictures"
                                homeRecordsViewModel.folderID = MainselectedTabID[2]+3 ; homeRecordsViewModel.fileType = "locker" ; homeRecordsViewModel.subfoldertype = "pictures"
                                homeRecordsViewModel.getLockerData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                ismailsView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true
                            }
                        }) {
                            Image("picture")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .contentShape(Rectangle())
                        Spacer()
                        
                        Button(action: {
                            print("videos button clicked")
                            if selectedTAB == "work" {
                                selectedTabID = MainselectedTabID[0]+4 ;Foldertype = "work"; subFoldertype = "videos"

                                homeRecordsViewModel.folderID = 1063 ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "videos"
                                homeRecordsViewModel.getRecordsData(selectedTabID: MainselectedTabID[0]+4, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                isfilesView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true

                            }
                            else if selectedTAB == "archive" {
                                selectedTabID = MainselectedTabID[1]+4 ; Foldertype = "archive"; subFoldertype = "videos"
                                homeRecordsViewModel.folderID = 1068 ; homeRecordsViewModel.fileType = "archive" ; homeRecordsViewModel.subfoldertype = "videos"
                                homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                isfilesView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true
                            }
                            else if selectedTAB == "Locker" {
                                selectedTabID = MainselectedTabID[2]+4 ; Foldertype = "locker"; subFoldertype = "videos"
                                homeRecordsViewModel.folderID = 1073 ; homeRecordsViewModel.fileType = "locker" ; homeRecordsViewModel.subfoldertype = "videos"
                                homeRecordsViewModel.getLockerData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                workspace = false
                                isfilesView = false
                                subFolderView = false
                                subFolderViewFiles = false
                                typeview = true
                                isfilesView = true
                            }
                        }) {
                            Image(systemName: "video")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .contentShape(Rectangle())
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                    .background(themesviewModel.currentTheme.windowBackground)
                    .zIndex(1000)
                    
                }
                .toast(message: $homeRecordsViewModel.error)
                .toast(message: $consoleViewModel.error)
                .toast(message: $toastMessage)

                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear{
                    if homeRecordsViewModel.mainRecords.isEmpty {
                        homeRecordsViewModel.getMainRecordsData()
                    }
                    homeRecordsViewModel.setPin = sessionManager.pin
                    homeRecordsViewModel.password = sessionManager.password
                    password = sessionManager.password
                    print("check pin \(homeRecordsViewModel.setPin)")
                    print("password \(password)")
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        let records = homeRecordsViewModel.mainRecords
                        if !records.isEmpty {
                            // Dynamically map tab IDs from the model
                            MainselectedTabID = records.map { $0.id }

                            // Optional: Default to Work tab (index 0)
                            if MainselectedTabID.indices.contains(0) {
                                selectedTabID = MainselectedTabID[0]
                                Foldertype = "work"
                                subFoldertype = "files"

                                homeRecordsViewModel.getRecordsData(
                                    selectedTabID: selectedTabID,
                                    Type: Foldertype,
                                    SubFoldersType: subFoldertype
                                )

                                print("MainselectedTabID: \(MainselectedTabID)")
                                print("Initial selectedTabID: \(selectedTabID)")
                            }
                        } else {
                            print("mainRecords is still empty.")
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                    }
                }


//                .fileImporter(isPresented: $isFilePickerPresent, allowedContentTypes: [.image, .pdf, .plainText], allowsMultipleSelection: true) { result in
//                    switch result {
//                    case .success(let urls):
//                        mailComposeViewModel.selectedFiles.append(contentsOf: urls)
//                        mailComposeViewModel.uploadFiles(fileURLs: urls)
//                    case .failure(let error):
//                        print("Failed to select files: \(error.localizedDescription)")
//                    }
//                }
//                if homeRecordsViewModel.isLoading {
//                    CustomProgressView()
//                }
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }

                
                if ismailsView {
                    if homeRecordsViewModel.emailsData.count != 0 {
                        VStack {
                            ForEach(homeRecordsViewModel.emailsData.indices, id: \.self) { index in
                                let folder = homeRecordsViewModel.emailsData[index]
                                HStack {
                                    Button(action: {
                                    }) {
                                        Image("unchecked")
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .padding([.trailing, .leading], 5)
                                            .frame(width: 34, height: 34)
                                            .clipShape(Circle())
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("\(folder.firstname)\(folder.lastname)")
                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            
                                            Text("Draft")
                                                .foregroundColor(Color.red)
                                            
                                            Spacer()
                                            if let unixTimestamp = folder.sentAt,
                                               let istDateStringFromISO = convertToIST(dateInput: unixTimestamp) {
                                                Text(istDateStringFromISO)
                                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .padding(.top, 0)
                                                    .padding(.trailing , 10)
                                                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                                            }
                                        }
                                        HStack {
                                            Text(folder.subject)
                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            
                                            Spacer()
                                            
                                            Image(folder.starred == 1 ? "star" : "emptystar")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .padding(.trailing , 10)
                                                .foregroundColor(folder.starred == 1 ? themesviewModel.currentTheme.colorAccent : .white)
                                            //                                            .onTapGesture {
                                            //                                                let threadID = homeRecordsViewModel.emailsData[index].threadId
                                            //                                                if let threadID {
                                            //                                                    print("thread id:", threadID)
                                            //                                                    // Toggle the 'starred' status
                                            //                                                    homeRecordsViewModel.emailsData[index].starred =
                                            //                                                        homeRecordsViewModel.emailsData[index].starred == 1 ? 0 : 1
                                            //                                                    homeAwaitingViewModel.getStarredEmail(selectedEmail: threadID)
                                            //                                                } else {
                                            //                                                    print("threadID is nil")
                                            //                                                }
                                            //                                            }
                                            
                                        }
                                    }
                                }
                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                .onTapGesture {
                                    homeRecordsViewModel.selectedId = folder.threadId
                                    homeRecordsViewModel.isEmailScreen = true
                                }
                            }
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)
                        }
                        .background(themesviewModel.currentTheme.windowBackground)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.leading, 16)
                        .padding(.top , 180)
                        .padding(.bottom, 80)
                    }
                }


                    // GRID VIEW
                    if isfilesView {
                        if typeview == true{
                        VStack {
                            // FOLDERS GRID
                            if homeRecordsViewModel.recordsData.count != 0 {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Folders")
                                        .font(.custom(.poppinsBold, size: 16))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .fontWeight(.bold)
                                    
                                    let columns = [
                                        GridItem(.flexible(minimum: 100), spacing: 10),
                                        GridItem(.flexible(minimum: 100), spacing: 10),
                                        GridItem(.flexible(minimum: 100), spacing: 10)
                                    ]
                                    
                                    LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                                        ForEach(homeRecordsViewModel.recordsData.indices, id: \.self) { index in
                                            let folder = homeRecordsViewModel.recordsData[index]
                                            
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Image(systemName: "folder.fill")
                                                        .resizable()
                                                        .frame(width: 50, height: 40)
                                                        .foregroundColor(.yellow)
                                                    Spacer()
                                                    Button(action: {
                                                        isMoreSheetvisible.toggle()
                                                        print("selectedTabID \(selectedTabID )Foldertype \(Foldertype) SubFoldersType \(subFoldertype) ")
                                                        emailID = 0
                                                        fieldID = 0
                                                        recordID = folder.id
                                                        FileAzureName = ""
                                                        foldername = folder.folderName
                                                        createdAt = folder.createdAt
                                                        UpdatedAt = folder.updatedAt
                                                        filesize = ""
                                                        fileType = "folder"
                                                        fileclicks = false
                                                        print("foldername \(foldername)  createdAt  \(createdAt) UpdatedAt \(UpdatedAt) filesize \(filesize)")
                                                    }) {
                                                        Image("dots")
                                                            .resizable()
                                                            .frame(width: 30, height: 30, alignment: .topTrailing)
                                                            .padding(.top, 1)
                                                            .padding(.trailing, 1)
                                                            .foregroundColor(.black)
                                                    }

                                                }
                                                
                                                Text(folder.folderName)
                                                    .foregroundColor(.black)
                                                    .font(.custom(.poppinsRegular, size: 14))
                                                    .lineLimit(1)
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                            .background(Color.white)
                                            .cornerRadius(12)
                                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                        }
                                    }
                                }
                                .padding(.top, 180)
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }

                            // FILES GRID
                            if homeRecordsViewModel.FilesData.count != 0 {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Files")
                                        .font(.custom(.poppinsBold, size: 16))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .fontWeight(.bold)
                                    
                                    let columns = [
                                        GridItem(.flexible(minimum: 100), spacing: 20),
                                        GridItem(.flexible(minimum: 100), spacing: 20),
                                        GridItem(.flexible(minimum: 100), spacing: 0)
                                    ]
                                        LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                                            ForEach(homeRecordsViewModel.FilesData.indices, id: \.self) { index in
                                                let file = homeRecordsViewModel.FilesData[index]
                                                VStack(alignment: .leading, spacing: 8) {
                                                    HStack(alignment: .top, spacing: 10) {
                                                        let fileURL = URL(string: file.fileLink)
                                                        
                                                        Group {
                                                            if file.fileLink.lowercased().hasSuffix(".mp4") || file.fileLink.lowercased().hasSuffix(".mov") || file.fileLink.lowercased().hasSuffix(".3gp") || file.fileLink.lowercased().hasSuffix(".asf") || file.fileLink.lowercased().hasSuffix(".avi") || file.fileLink.lowercased().hasSuffix(".f4v") || file.fileLink.lowercased().hasSuffix(".flv") || file.fileLink.lowercased().hasSuffix(".hevc") ||
                                                                file.fileLink.lowercased().hasSuffix(".m2ts") || file.fileLink.lowercased().hasSuffix(".m2v") || file.fileLink.lowercased().hasSuffix(".m4v") || file.fileLink.lowercased().hasSuffix(".mjpeg") || file.fileLink.lowercased().hasSuffix(".mpg") || file.fileLink.lowercased().hasSuffix(".mts") ||
                                                                file.fileLink.lowercased().hasSuffix(".mxf") || file.fileLink.lowercased().hasSuffix(".ogv") || file.fileLink.lowercased().hasSuffix(".rm") || file.fileLink.lowercased().hasSuffix(".swf") || file.fileLink.lowercased().hasSuffix(".ts") || file.fileLink.lowercased().hasSuffix(".vob") || file.fileLink.lowercased().hasSuffix(".webm") || file.fileLink.lowercased().hasSuffix(".wmv") ||
                                                                file.fileLink.lowercased().hasSuffix(".wtv") {
                                                                if let url = fileURL {
                                                                    ZStack {
                                                                        VideoPlayer(player: AVPlayer(url: url))
                                                                            .frame(width: 50, height: 40)
                                                                            .cornerRadius(8)
                                                                            .disabled(true) // prevents autoplay here
                                                                        Image(systemName: "play.circle.fill")
                                                                            .resizable()
                                                                            .frame(width: 30, height: 30)
                                                                            .foregroundColor(.white)
                                                                    }
                                                                    .onTapGesture {
                                                                        print("on click of video")
                                                                        if let safeURL = fileURL {
                                                                            confirmedURL = safeURL
                                                                            isVideo = true

                                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                                showViewer = true
                                                                            }

                                                                            print("confirmedURL = \(confirmedURL!)")
                                                                        }
                                                                    }



                                                                }
                                                            }
                                                            else if isDocumentOrAudioOrArchive(file.fileLink) {
                                                                    ZStack {
                                                                        RoundedRectangle(cornerRadius: 8)
                                                                            .fill(Color.gray.opacity(0.2))
                                                                            .frame(width: 50, height: 40)
                                                                        Image(systemName: "doc.fill") // you can customize based on extension
                                                                            .resizable()
                                                                            .frame(width: 24, height: 30)
                                                                            .foregroundColor(.blue)
                                                                    }
                                                                    .onTapGesture {
                                                                        print("click on file format")
                                                                        toastMessage = "Format not supported for preview"
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                            toastMessage = nil // hide the toast after 2 seconds
                                                                        }
                                                                    }

                                                                }
                                                            
                                                            else {
                                                                AsyncImage(url: fileURL) { phase in
                                                                    if let image = phase.image {
                                                                        image
                                                                            .resizable()
                                                                            .scaledToFill()
                                                                            .frame(width: 50, height: 40)
                                                                            .clipped()
                                                                            .cornerRadius(8)
                                                                            .onTapGesture {
                                                                                print("on click of image")
                                                                                if let safeURL = fileURL {
                                                                                    confirmedURL = safeURL
                                                                                    isVideo = false
                                                                                    print("confirmedURL = \(safeURL)")
                                                                                }
                                                                            }


                                                                    } else if phase.error != nil {
                                                                        Image(systemName: "xmark.octagon")
                                                                            .resizable()
                                                                            .frame(width: 50, height: 40)
                                                                            .foregroundColor(.red)
                                                                    } else {
                                                                        ProgressView()
                                                                            .frame(width: 50, height: 40)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        Spacer()
                                                            .frame(width: 5)
                                                        Button(action: {
                                                            isMoreSheetvisible.toggle()
                                                            print("selectedTabID \(selectedTabID )Foldertype \(Foldertype) SubFoldersType \(subFoldertype) ")
                                                            emailID = 0
                                                            fieldID = file.id
                                                            recordID = 0
                                                            FileAzureName = file.azureFileName
                                                            foldername = file.fileName
                                                            createdAt = file.createdAt
                                                            UpdatedAt = file.updatedAt
                                                            filesize = file.fileSize
                                                            AzureLink = file.fileLink
                                                            fileType = "file"
                                                            fileFormat = URL(fileURLWithPath: file.fileName).pathExtension.lowercased()
                                                            fileclicks = true
                                                            print("foldername \(foldername)  createdAt  \(createdAt) UpdatedAt \(UpdatedAt) filesize \(filesize)  AzureLink  \(AzureLink)")
                                                        }) {
                                                            Image("dots")
                                                                .resizable()
                                                                .frame(width: 25, height: 25, alignment: .topTrailing)
                                                                .padding(.top, 1)
                                                                .padding(.trailing, 1)
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                    Text(file.fileName)
                                                        .foregroundColor(.black)
                                                        .font(.custom(.poppinsRegular, size: 12))
                                                        .lineLimit(1)
                                                }
                                                .padding(5)
                                                .padding(.trailing, (index % 3 == 2) ? 16 : 0)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                )
                                                .background(Color.white)
                                                .cornerRadius(12)
                                                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                            }
                                        }
                                    
                                }
                                .padding(.top, homeRecordsViewModel.recordsData.count == 0 ? 180 : 0)
                                .padding(.leading, 16)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .fullScreenCover(isPresented: Binding<Bool>(
                                    get: { confirmedURL != nil },
                                    set: { newValue in
                                        if !newValue {
                                            confirmedURL = nil // Clear URL when dismissed
                                        }
                                    })
                                ) {
                                    ZStack {
                                        Color.black.ignoresSafeArea()

                                        if let url = confirmedURL {
                                            if isVideo {
                                                VideoPlayer(player: AVPlayer(url: url))
                                                    .edgesIgnoringSafeArea(.all)
                                            } else {
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        CustomProgressView()
                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    case .failure:
                                                        Text("Failed to load image")
                                                            .foregroundColor(.white)
                                                    @unknown default:
                                                        CustomProgressView()
                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    }
                                                }
                                                .background(Color.black)
                                            }
                                        }

                                        // Top-right Close Button
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    confirmedURL = nil
                                                }) {
                                                    Image("wrongmark")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 32, height: 32)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .padding()
                                                }
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                            
                    }
                        else if typeview == false {
                            // LIST VIEW using SwiftUI's List
                            GeometryReader { geometry in
                                VStack {
                                    List {
                                        // FOLDERS SECTION
                                        if homeRecordsViewModel.recordsData.count != 0 {
                                            Section(header: Text("Folders")
                                                .font(.custom(.poppinsBold, size: 16))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .fontWeight(.bold)
                                            ) {
                                                ForEach(homeRecordsViewModel.recordsData.indices, id: \.self) { index in
                                                    let folder = homeRecordsViewModel.recordsData[index]
                                                    HStack(spacing: 12) {
                                                        Image(systemName: "folder.fill")
                                                            .resizable()
                                                            .frame(width: 40, height: 30)
                                                            .foregroundColor(.yellow)
                                                        
                                                        Text(folder.folderName)
                                                            .foregroundColor(.black)
                                                        Spacer()
                                                        Button(action: {
                                                            isMoreSheetvisible.toggle()
                                                            print("selectedTabID \(selectedTabID )Foldertype \(Foldertype) SubFoldersType \(subFoldertype) ")
                                                            emailID = 0
                                                            fieldID = 0
                                                            recordID = folder.id
                                                            FileAzureName = ""
                                                            FileAzureName = ""
                                                            foldername = folder.folderName
                                                            createdAt = folder.createdAt
                                                            UpdatedAt = folder.updatedAt
                                                            filesize = ""
                                                            fileType = "folder"
                                                            fileclicks = false
                                                            print("foldername \(foldername)  createdAt  \(createdAt) UpdatedAt \(UpdatedAt) filesize \(filesize)")
                                                        }) {
                                                            Image("dots")
                                                                .resizable()
                                                                .frame(width: 30, height: 30, alignment: .topTrailing)
                                                                .padding(.top, 1)
                                                                .padding(.trailing, 1)
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                    .padding()
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                    )
                                                    .background(Color.white)
                                                    .cornerRadius(12)
                                                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                                    .listRowBackground(Color.clear)
                                                }
                                            }
                                        }
                                        
                                            if homeRecordsViewModel.FilesData.count != 0 {
                                                Section(header: Text("Files")
                                                    .font(.custom(.poppinsBold, size: 16))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .fontWeight(.bold)
                                                    .padding(.leading)
                                                ) {
                                                    ForEach(homeRecordsViewModel.FilesData.indices, id: \.self) { index in
                                                        let file = homeRecordsViewModel.FilesData[index]
                                                        let fileURL = URL(string: file.fileLink)

                                                        HStack(spacing: 12) {
                                                            Group {
                                                                if file.fileLink.lowercased().hasSuffix(".mp4") || file.fileLink.lowercased().hasSuffix(".mov") {
                                                                    if let url = fileURL {
                                                                        ZStack {
                                                                            VideoPlayer(player: AVPlayer(url: url))
                                                                                .frame(width: 60, height: 50)
                                                                                .cornerRadius(8)
                                                                                .disabled(true)

                                                                            Image(systemName: "play.circle.fill")
                                                                                .resizable()
                                                                                .frame(width: 20, height: 20)
                                                                                .foregroundColor(.white)
                                                                        }
                                                                        .onTapGesture {
                                                                            print("on click of video")
                                                                            confirmedURL = url
                                                                            isVideo = true
                                                                        }
                                                                    }
                                                                } else {
                                                                    AsyncImage(url: fileURL) { phase in
                                                                        if let image = phase.image {
                                                                            image
                                                                                .resizable()
                                                                                .scaledToFill()
                                                                                .frame(width: 60, height: 50)
                                                                                .clipped()
                                                                                .cornerRadius(8)
                                                                                .onTapGesture {
                                                                                    print("on click of image")
                                                                                    if let safeURL = fileURL {
                                                                                        confirmedURL = safeURL
                                                                                        isVideo = false
                                                                                    }
                                                                                }
                                                                        } else if phase.error != nil {
                                                                            Image(systemName: "xmark.octagon")
                                                                                .resizable()
                                                                                .frame(width: 30, height: 30)
                                                                                .foregroundColor(.red)
                                                                        } else {
                                                                            ProgressView()
                                                                                .frame(width: 30, height: 30)
                                                                        }
                                                                    }
                                                                }
                                                            }

                                                            Text(file.fileName)
                                                                .foregroundColor(.black)
                                                                .lineLimit(1)

                                                            Spacer()

                                                            Button(action: {
                                                                isMoreSheetvisible.toggle()
                                                                print("selectedTabID \(selectedTabID) Foldertype \(Foldertype) SubFoldersType \(subFoldertype)")
                                                                emailID = 0
                                                                fieldID = file.id
                                                                recordID = 0
                                                                FileAzureName = file.azureFileName
                                                                foldername = file.fileName
                                                                createdAt = file.createdAt
                                                                UpdatedAt = file.updatedAt
                                                                filesize = file.fileSize
                                                                AzureLink = file.fileLink
                                                                fileType = "file"
                                                                fileFormat = URL(fileURLWithPath: file.fileName).pathExtension.lowercased()
                                                                fileclicks = true
                                                                print("foldername \(foldername) createdAt \(createdAt) UpdatedAt \(UpdatedAt) filesize \(filesize) AzureLink \(AzureLink)")
                                                            }) {
                                                                Image("dots")
                                                                    .resizable()
                                                                    .frame(width: 30, height: 30)
                                                                    .padding(.top, 1)
                                                                    .padding(.trailing, 1)
                                                                    .foregroundColor(.black)
                                                            }
                                                        }
                                                        .padding()
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                        )
                                                        .background(Color.white)
                                                        .cornerRadius(12)
                                                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                                        .listRowBackground(Color.clear)
                                                    }
                                                }
                                                .padding(.horizontal)
                                                .fullScreenCover(isPresented: Binding<Bool>(
                                                    get: { confirmedURL != nil },
                                                    set: { newValue in
                                                        if !newValue {
                                                            confirmedURL = nil
                                                        }
                                                    })
                                                ) {
                                                    ZStack {
                                                        Color.black.ignoresSafeArea()

                                                        if let url = confirmedURL {
                                                            if isVideo {
                                                                VideoPlayer(player: AVPlayer(url: url))
                                                                    .edgesIgnoringSafeArea(.all)
                                                            } else {
                                                                AsyncImage(url: url) { phase in
                                                                    switch phase {
                                                                    case .empty:
                                                                        CustomProgressView()
                                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                                    case .success(let image):
                                                                        image
                                                                            .resizable()
                                                                            .scaledToFit()
                                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                                    case .failure:
                                                                        Text("Failed to load image")
                                                                            .foregroundColor(.white)
                                                                    @unknown default:
                                                                        CustomProgressView()
                                                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                                    }
                                                                }
                                                                .background(Color.black)
                                                            }
                                                        }

                                                        // ❌ Close Button
                                                        VStack {
                                                            HStack {
                                                                Spacer()
                                                                Button(action: {
                                                                    confirmedURL = nil
                                                                }) {
                                                                    Image("wrongmark")
                                                                        .resizable()
                                                                        .renderingMode(.template)
                                                                        .frame(width: 32, height: 32)
                                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                        .padding()
                                                                }
                                                            }
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                            }
                                        

                                        // ✅ Fullscreen Viewer for Image / Video

                                        
                                        
                                        
                                    }
                                    .frame(height: geometry.size.height - 380)
                                    .listStyle(PlainListStyle())
                                    .scrollContentBackground(.hidden)
                                    .background(themesviewModel.currentTheme.windowBackground)
                                    
                                }
                                .padding(.leading, 16)
                                .padding(.top, 180)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                        }

                }
                    
                if subFolderViewFiles {
                        if homeRecordsViewModel.FilesData.count != 0 {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Files")
                                    .font(.custom(.poppinsBold, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .fontWeight(.bold)
                                
                                let columns = [
                                    GridItem(.flexible(minimum: 100), spacing: 20),
                                    GridItem(.flexible(minimum: 100), spacing: 20),
                                    GridItem(.flexible(minimum: 100), spacing: 0)
                                ]
                                LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                                    ForEach(homeRecordsViewModel.FilesData.indices, id: \.self) { index in
                                        let file = homeRecordsViewModel.FilesData[index]
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack(alignment: .top, spacing: 10) {
                                                let fileURL = URL(string: file.fileLink)
                                                
                                                Group {
                                                    if file.fileLink.lowercased().hasSuffix(".mp4") || file.fileLink.lowercased().hasSuffix(".mov") || file.fileLink.lowercased().hasSuffix(".3gp") || file.fileLink.lowercased().hasSuffix(".asf") || file.fileLink.lowercased().hasSuffix(".avi") || file.fileLink.lowercased().hasSuffix(".f4v") || file.fileLink.lowercased().hasSuffix(".flv") || file.fileLink.lowercased().hasSuffix(".hevc") ||
                                                        file.fileLink.lowercased().hasSuffix(".m2ts") || file.fileLink.lowercased().hasSuffix(".m2v") || file.fileLink.lowercased().hasSuffix(".m4v") || file.fileLink.lowercased().hasSuffix(".mjpeg") || file.fileLink.lowercased().hasSuffix(".mpg") || file.fileLink.lowercased().hasSuffix(".mts") ||
                                                        file.fileLink.lowercased().hasSuffix(".mxf") || file.fileLink.lowercased().hasSuffix(".ogv") || file.fileLink.lowercased().hasSuffix(".rm") || file.fileLink.lowercased().hasSuffix(".swf") || file.fileLink.lowercased().hasSuffix(".ts") || file.fileLink.lowercased().hasSuffix(".vob") || file.fileLink.lowercased().hasSuffix(".webm") || file.fileLink.lowercased().hasSuffix(".wmv") ||
                                                        file.fileLink.lowercased().hasSuffix(".wtv") {
                                                        if let url = fileURL {
                                                            ZStack {
                                                                VideoPlayer(player: AVPlayer(url: url))
                                                                    .frame(width: 50, height: 40)
                                                                    .cornerRadius(8)
                                                                    .disabled(true) // prevents autoplay here
                                                                Image(systemName: "play.circle.fill")
                                                                    .resizable()
                                                                    .frame(width: 30, height: 30)
                                                                    .foregroundColor(.white)
                                                            }
                                                            .onTapGesture {
                                                                print("on click of video")
                                                                if let safeURL = fileURL {
                                                                    confirmedURL = safeURL
                                                                    isVideo = true
                                                                    
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                        showViewer = true
                                                                    }
                                                                    
                                                                    print("confirmedURL = \(confirmedURL!)")
                                                                }
                                                            }
                                                            
                                                            
                                                            
                                                        }
                                                    }
                                                    else if isDocumentOrAudioOrArchive(file.fileLink) {
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(Color.gray.opacity(0.2))
                                                                .frame(width: 50, height: 40)
                                                            Image(systemName: "doc.fill") // you can customize based on extension
                                                                .resizable()
                                                                .frame(width: 24, height: 30)
                                                                .foregroundColor(.blue)
                                                        }
                                                        .onTapGesture {
                                                            print("click on file format")
                                                            toastMessage = "Format not supported for preview"
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                toastMessage = nil // hide the toast after 2 seconds
                                                            }
                                                        }
                                                        
                                                    }
                                                    
                                                    else {
                                                        AsyncImage(url: fileURL) { phase in
                                                            if let image = phase.image {
                                                                image
                                                                    .resizable()
                                                                    .scaledToFill()
                                                                    .frame(width: 50, height: 40)
                                                                    .clipped()
                                                                    .cornerRadius(8)
                                                                    .onTapGesture {
                                                                        print("on click of image")
                                                                        if let safeURL = fileURL {
                                                                            confirmedURL = safeURL
                                                                            isVideo = false
                                                                            print("confirmedURL = \(safeURL)")
                                                                        }
                                                                    }
                                                                
                                                                
                                                            } else if phase.error != nil {
                                                                Image(systemName: "xmark.octagon")
                                                                    .resizable()
                                                                    .frame(width: 50, height: 40)
                                                                    .foregroundColor(.red)
                                                            } else {
                                                                ProgressView()
                                                                    .frame(width: 50, height: 40)
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                Spacer()
                                                    .frame(width: 5)
                                                Button(action: {
                                                    isMoreSheetvisible.toggle()
                                                    fileType = "folder"
                                                    fileclicks = true
                                                    homeRecordsViewModel.getSubRecordsData(selectedTabID: subfoldersViewIds, Type: subfoldersViewType)
//                                                    isMoreSheetvisible.toggle()
//                                                    selectedTabID = subfoldersViewIds
//                                                    print("isMoreSheetvisible \(isMoreSheetvisible)")
//                                                    print("selectedTabID \(selectedTabID) Foldertype \(Foldertype) SubFoldersType \(subFoldertype)")
//                                                    emailID = 0
//                                                    fieldID = file.id
//                                                    recordID = 0
//                                                    FileAzureName = file.azureFileName
//                                                    foldername = file.fileName
//                                                    createdAt = file.createdAt
//                                                    UpdatedAt = file.updatedAt
//                                                    filesize = file.fileSize
//                                                    AzureLink = file.fileLink
//                                                    fileType = "file"
//                                                    fileFormat = URL(fileURLWithPath: file.fileName).pathExtension.lowercased()
//                                                    fileclicks = true
//                                                    print("foldername \(foldername) createdAt \(createdAt) UpdatedAt \(UpdatedAt) filesize \(filesize) AzureLink \(AzureLink)")
                                                }) {
                                                    Image("dots")
                                                        .resizable()
                                                        .frame(width: 25, height: 25, alignment: .topTrailing)
                                                        .padding(.top, 1)
                                                        .padding(.trailing, 1)
                                                        .foregroundColor(.black)
                                                }
                                            }
                                            Text(file.fileName)
                                                .foregroundColor(.black)
                                                .font(.custom(.poppinsRegular, size: 12))
                                                .lineLimit(1)
                                        }
                                        .padding(5)
                                        .padding(.trailing, (index % 3 == 2) ? 16 : 0)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                    }
                                }
                                
                            }
                    
                            .padding(.top, reader.size.height*0.6)
                            .padding(.leading, 16)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .fullScreenCover(isPresented: Binding<Bool>(
                                get: { confirmedURL != nil },
                                set: { newValue in
                                    if !newValue {
                                        confirmedURL = nil // Clear URL when dismissed
                                    }
                                })
                            ) {
                                ZStack {
                                    Color.black.ignoresSafeArea()
                                    
                                    if let url = confirmedURL {
                                        if isVideo {
                                            VideoPlayer(player: AVPlayer(url: url))
                                                .edgesIgnoringSafeArea(.all)
                                        } else {
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    CustomProgressView()
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                case .failure:
                                                    Text("Failed to load image")
                                                        .foregroundColor(.white)
                                                @unknown default:
                                                    CustomProgressView()
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                }
                                            }
                                            .background(Color.black)
                                        }
                                    }
                                    
                                    // Top-right Close Button
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Button(action: {
                                                confirmedURL = nil
                                            }) {
                                                Image("wrongmark")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .frame(width: 32, height: 32)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .padding()
                                            }
                                        }
                                        Spacer()
                                    }

                                }
                            }
                        }
                    
                }
                
                if isMoreSheetvisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    print("dismiss isMoreSheetvisible")
                                    isMoreSheetvisible = false
                                }
                            }
                                
                                VStack {
                                    Spacer() // Pushes the sheet to the bottom
                                    RecordsThreeDotsView(selectedTabID: $selectedTabID, folderName: $Foldertype, subFolderName: $subFoldertype, emailIds: $emailID, recordIDs: $recordID, fieldIDs: $fieldID, azureName: $FileAzureName, FileName: $foldername, createdTime: $createdAt, UpdatedTime: $UpdatedAt, Foldersize: $filesize, azureLink: $AzureLink , filetype: $fileType , formatFile: $fileFormat, fileClicked: $fileclicks)
                                        .transition(.move(edge: .bottom))
                                        .animation(.easeInOut, value: isMoreSheetvisible)
                                }
                            
                    }
                }
                if plusmark {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    plusmark = false
                                }
                            }

                        VStack {
                            Spacer() // Push content to bottom

                            VStack(alignment: .leading){
                                
                                Text("work")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 16))
                                    .fontWeight(.bold)
                                    .padding(.leading,16)

                                Divider()
                                    .frame(height: 1)
                                    .background(themesviewModel.currentTheme.customEditTextColor)
                                    .padding([.leading, .trailing], 16)

                                HStack {
                                    Button {
                                        createFolder = true
                                        newFolderName = ""
                                    } label: {
                                        Image("createFolder")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .padding(.leading,16)
                                        Text("Create Folder")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 16))
                                            .fontWeight(.bold)
                                            .padding(.leading,20)
                                    }
                                    Spacer()
                                }
                                
                                HStack {
                                    Button {
//                                        isFilePickerPresent = true
                                        showPhotoPicker = true
                                    } label: {
                                        Image("uploadFile")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .padding(.leading,16)
                                        
                                        Text("Upload File")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 16))
                                            .fontWeight(.bold)
                                            .padding(.leading,20)
                                    }
                                    .sheet(isPresented: $showPhotoPicker) {
                                        PhotoPicker(selectedImages: $selectedImages)
                                            .onDisappear {
                                                homeRecordsViewModel.uploadImages(selectedImages)
                                            }
                                    }
                                    Spacer()
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: plusmark)
                            }
                            .frame(height: 200)
                            .background(themesviewModel.currentTheme.windowBackground)
                            .cornerRadius(20)
                            .padding(.horizontal,10)
                            .padding(.bottom, 20) // Optional bottom padding
                        }
                    }
                }
                
                if createFolder {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    createFolder = false
                                }
                            }
                        
                        VStack (alignment: .leading, spacing: 10){
                            Text("Create New Folder")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16))
                                .fontWeight(.bold)
                                .padding(.leading , 16)
                            
                            floatingtextfield(text: $newFolderName, placeHolder: "Folder name", allowedCharacter: .defaultType)
                                .padding(.horizontal)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            HStack {
                                Spacer()
                                Button{
                                    homeRecordsViewModel.createNewFolder(folderName: newFolderName, parentID: selectedTabID, Type: selectedTAB, subFolderType: subFoldertype)
                                    print("newFolderName  \(newFolderName)")
                                    print("selectedTabID  \(selectedTabID)")
                                    print("selectedTAB  \(selectedTAB)")
                                    print("subFoldertype  \(subFoldertype)")
                                    createFolder = false
                                }label: {
                                    Text("Create")
                                        .padding()
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14))
                                        .cornerRadius(15)
                                        .padding(.trailing,16)
                                        .fontWeight(.bold)
                                        .padding(.bottom,5)
                                }
                            }
                        }
                        .frame(height: 200)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(20)
                        .padding(.horizontal,10)
                        .transition(.scale)
                        .animation(.easeInOut, value: createFolder)
                    }
                }
                if lockerView {
                    if homeRecordsViewModel.setPin.isEmpty {
                        VStack {
                            HStack {
                                Text("set Pin")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 16))
                                    .fontWeight(.bold)
                                    .padding(.leading , 16)
                                
                                Spacer()
                                Button{
                                    newPinView = true
                                    newPin = ""
                                    confirmPin = ""
                                }label: {
                                    Text("Add")
                                        .padding()
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14))
                                        .cornerRadius(15)
                                        .padding(.trailing,16)
                                        .fontWeight(.bold)
                                        .padding(.bottom,5)
                                }
                                
                            }
                            Spacer()
                        }
                        .padding(.top , 200)
                    }
                    else {
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.3))
                                .ignoresSafeArea(edges: .bottom)
                            VStack {
                                Spacer()
                                VStack (alignment: .leading, spacing: 20){
                                    HStack {
                                        Text("Locker")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 16))
                                            .fontWeight(.bold)
                                            .padding(.leading , 16)
                                        
                                        Spacer()
                                        Image("wrongmark")
                                            .resizable()
                                            .renderingMode(.template)
                                            .frame(width: 25,  height: 25)
                                            .padding(.trailing , 16)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .onTapGesture {
                                                withAnimation {
                                                    lockerView = false
                                                }
                                            }
                                    }
                                    Floatingtextfield(text: $LockerPin, placeHolder: "Pin*", allowedCharacter: .defaultType)
                                        .padding(.horizontal)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    
                                    floatingtextfield(text: $Lockerpassword, placeHolder: "Password", allowedCharacter: .defaultType)
                                        .padding(.horizontal)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    HStack {
                                        Spacer()
                                        Button{
                                            lockerView = false
                                            homeRecordsViewModel.setPin = LockerPin
                                                homeRecordsViewModel.getLockerData(selectedTabID: MainselectedTabID[2], Type: "locker", SubFoldersType: "locker")
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                workspace = true
//                                                lockerfilesView = true
                                            
                                            LockerPin = ""
                                            Lockerpassword = ""
                                        }label: {
                                            Text("Submit")
                                                .padding()
                                                .background(themesviewModel.currentTheme.colorPrimary)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 14))
                                                .cornerRadius(10)
                                                .padding(.trailing,16)
                                                .fontWeight(.bold)
                                                .padding(.bottom,5)
                                        }
                                    }
                                    .transition(.move(edge: .bottom))
                                    .animation(.easeInOut, value: lockerView)
                                }
                                .frame(height: 250)
                                .background(themesviewModel.currentTheme.windowBackground)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                
                if newPinView {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea(edges: .bottom)
                        VStack {
                            Spacer()
                            VStack (alignment: .leading, spacing: 20){
                                HStack {
                                    Text("set pin")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 16))
                                        .fontWeight(.bold)
                                        .padding(.leading , 16)
                                    
                                    Spacer()
                                    Image("wrongmark")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 25,  height: 25)
                                        .padding(.trailing , 16)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .onTapGesture {
                                            withAnimation {
                                                newPinView = false
                                            }
                                        }
                                }
                                Floatingtextfield(text: $newPin, placeHolder: "Enter New Pin*", allowedCharacter: .defaultType)
                                    .padding(.horizontal)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                
                                Floatingtextfield(text: $confirmPin, placeHolder: "Enter New Confirm Pin", allowedCharacter: .defaultType)
                                    .padding(.horizontal)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                HStack{
                                    Text("Note:")
                                        .foregroundColor(Color.red)
                                        .padding(.leading , 16)
                                    
                                    Text("Pin must be exactly 4 digits")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading , 10)
                                }
                                HStack {
                                    Spacer()
                                    Button{
                                        consoleViewModel.setPin(Newpin: newPin, confirmationPin: confirmPin)
                                        newPinView = false
                                        lockerView = true
                                        print(".toast(message: $consoleViewModel.error) \($consoleViewModel.error)")
                                        if newPin == confirmPin {
                                            sessionManager.pin = newPin
                                        }
                                    }label: {
                                        Text("Submit")
                                            .padding()
                                            .background(themesviewModel.currentTheme.colorPrimary)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 14))
                                            .cornerRadius(10)
                                            .padding(.trailing,16)
                                            .fontWeight(.bold)
                                            .padding(.bottom,5)
                                    }
                                }
                            }

                        }
                        
                        .frame(height: 280)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(20)
                        .padding(.horizontal,10)
                        .transition(.scale)
                        .animation(.easeInOut, value: createFolder)
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
            .navigationDestination(isPresented: $homeRecordsViewModel.isEmailScreen) {
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView , emailId: homeRecordsViewModel.selectedId ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
                
            }
            

        }
    }
    func isDocumentOrAudioOrArchive(_ path: String) -> Bool {
        let supportedExtensions = ["pdf", "doc", "docx", "odt", "rtf", "txt", "xls", "xlsx", "ods", "ppt", "pptx", "odp", "mp3", "wav", "zip", "rar"]
        return supportedExtensions.contains(where: { path.lowercased().hasSuffix(".\($0)") })
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // allow multiple selections
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let uiImage = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(uiImage)
                            }
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    HomeRecordsView(imageUrl: "")
}
