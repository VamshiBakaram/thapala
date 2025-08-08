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
import Bcrypt

struct HomeRecordsView: View {
    @State private var isMenuVisible = false
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject var homeRecordsViewModel = HomeRecordsViewModel()
    @StateObject var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var consoleViewModel = ConsoleNavigatiorViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var selectedTabID : Int = 1059
    @State private var Foldertype : String = "work"
    @State private var subFoldertype : String = "files"
    @State private var selectedTAB: String = "work"
    @State private var workspace: Bool = true
    @State private var isfilesView: Bool = false
    @State private var ismailsView: Bool = false
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
    @State private var markAs : Int = 0
    @State private var BottomBars: Bool = true
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
                            
                            Text("Records")
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
                        .padding(.top, -reader.size.height * 0.01)
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeRecordsViewModel.isWorkSelected ?themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .onTapGesture {
                                            selectedTAB = "work"
                                            isfilesView = false
                                            lockerView = false
                                            subFolderView = false
                                            subFolderViewFiles = false
                                            workspace = true
                                            typeview = true
                                            Foldertype = "work"; subFoldertype = "files"
                                            selectedTabID = MainselectedTabID[0]
                                            homeRecordsViewModel.folderID = MainselectedTabID[0] ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "files"
                                            homeRecordsViewModel.getRecordsData(selectedTabID: MainselectedTabID[0], Type: Foldertype, SubFoldersType: subFoldertype)
                                            
                                            self.homeRecordsViewModel.selectedOption = .work
                                            self.homeRecordsViewModel.isWorkSelected = true
                                            self.homeRecordsViewModel.isArchiveSelected = false
                                            self.homeRecordsViewModel.isLockerSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("workSpace")
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
                                                        Text("WorkSpace")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeRecordsViewModel.isArchiveSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .onTapGesture {
                                            selectedTAB = "archive"
                                            isfilesView = false
                                            lockerView = false
                                            subFolderView = false
                                            subFolderViewFiles = false
                                            workspace = true
                                            typeview = true
                                            Foldertype = "archive"
                                            subFoldertype = "files"
                                            selectedTabID = MainselectedTabID[1]
                                            homeRecordsViewModel.getRecordsData(selectedTabID: MainselectedTabID[1], Type: Foldertype, SubFoldersType: subFoldertype)
                                            self.homeRecordsViewModel.selectedOption = .archive
                                            self.homeRecordsViewModel.isWorkSelected = false
                                            self.homeRecordsViewModel.isArchiveSelected = true
                                            self.homeRecordsViewModel.isLockerSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("Archieve")
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
                                                        Text("Archive")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                            
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeRecordsViewModel.isLockerSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .onTapGesture {
                                            selectedTAB = "Locker"
                                            workspace = false
                                            ismailsView = false
                                            typeview = false
                                            isfilesView = false
                                            subFolderView = false
                                            subFolderViewFiles = false
                                            lockerView = true
                                            Foldertype = "locker"
                                            subFoldertype = "files"
                                            selectedTabID = MainselectedTabID[2]
                                            self.homeRecordsViewModel.selectedOption = .locker
                                            self.homeRecordsViewModel.isWorkSelected = false
                                            self.homeRecordsViewModel.isArchiveSelected = false
                                            self.homeRecordsViewModel.isLockerSelected = true
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("Locker")
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
                                                        Text("Locker")
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
                    VStack {
                        HStack {
                            Text("workspace")
                                .font(.custom(.poppinsRegular, size: 16))
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.leading,16)
                            Spacer()
                            Image(typeview ? "printIcon" : "GrId")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .padding(.trailing, 20)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    typeview.toggle()
                                }
                        }
                        
                        if workspace {
                                if typeview == true{
                                    GeometryReader { geometry in
                                        ScrollView(.vertical, showsIndicators: false) {
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
                                                                        Image("trashFolder")
                                                                            .resizable()
                                                                            .frame(width: 50, height: 40)
                                                                            .foregroundColor(.yellow)
                                                                        Spacer()
                                                                        
                                                                            Button(action: {
                                                                                isMoreSheetvisible.toggle()
                                                                                emailID = 1
                                                                                fieldID = 1
                                                                                recordID = folder.id
                                                                                FileAzureName = ""
                                                                                foldername = folder.folderName
                                                                                createdAt = folder.createdAt
                                                                                UpdatedAt = folder.updatedAt
                                                                                filesize = ""
                                                                                fileType = "folder"
                                                                                fileclicks = false
                                                                                homeRecordsViewModel.fileType = Foldertype
                                                                                homeRecordsViewModel.subfoldertype = subFoldertype
                                                                                homeRecordsViewModel.folderID = selectedTabID
                                                                            }) {
                                                                                Image("dots")
                                                                                    .resizable()
                                                                                    .renderingMode(.template)
                                                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                                    .frame(width: 24, height: 24, alignment: .topTrailing)
                                                                                    .padding(.top, 1)
                                                                                    .padding(.trailing, 1)
                                                                                    
                                                                            }
                                                                         
                                                                        
                                                                    }

                                                                        Text(folder.folderName)
                                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                            .font(.custom(.poppinsRegular, size: 12))
                                                                            .lineLimit(1)
                                                                    
                                                                }
                                                                .padding()
                                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                                .background(
                                                                    RoundedRectangle(cornerRadius: 12)
                                                                        .stroke(themesviewModel.currentTheme.allBlack.opacity(0.1), lineWidth: 1)
                                                                )
                                                                .background(themesviewModel.currentTheme.windowBackground)
                                                                .cornerRadius(12)
                                                                .shadow(color: themesviewModel.currentTheme.colorControlNormal.opacity(0.3), radius: 4, x: 0, y: 2)
                                                            }
                                                        }
                                                    }
                                                    .padding(.horizontal, 16)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                                                }
                                                
                                                // FILES GRID
                                                if homeRecordsViewModel.filesData.count != 0 {
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
                                                            ForEach(homeRecordsViewModel.filesData.indices, id: \.self) { index in
                                                                let file = homeRecordsViewModel.filesData[index]
                                                                VStack(alignment: .leading) {
    //                                                                HStack(alignment: .top, spacing: 10) {
                                                                        let fileURL = URL(string: file.fileLink)
                                                                        
                                                                        Group {
                                                                            if file.fileLink.lowercased().hasSuffix(".mp4") || file.fileLink.lowercased().hasSuffix(".mov") || file.fileLink.lowercased().hasSuffix(".3gp") || file.fileLink.lowercased().hasSuffix(".asf") || file.fileLink.lowercased().hasSuffix(".avi") || file.fileLink.lowercased().hasSuffix(".f4v") || file.fileLink.lowercased().hasSuffix(".flv") || file.fileLink.lowercased().hasSuffix(".hevc") ||
                                                                                file.fileLink.lowercased().hasSuffix(".m2ts") || file.fileLink.lowercased().hasSuffix(".m2v") || file.fileLink.lowercased().hasSuffix(".m4v") || file.fileLink.lowercased().hasSuffix(".mjpeg") || file.fileLink.lowercased().hasSuffix(".mpg") || file.fileLink.lowercased().hasSuffix(".mts") ||
                                                                                file.fileLink.lowercased().hasSuffix(".mxf") || file.fileLink.lowercased().hasSuffix(".ogv") || file.fileLink.lowercased().hasSuffix(".rm") || file.fileLink.lowercased().hasSuffix(".swf") || file.fileLink.lowercased().hasSuffix(".ts") || file.fileLink.lowercased().hasSuffix(".vob") || file.fileLink.lowercased().hasSuffix(".webm") || file.fileLink.lowercased().hasSuffix(".wmv") ||
                                                                                file.fileLink.lowercased().hasSuffix(".wtv") {
                                                                                if let url = fileURL {
                                                                                    ZStack {
                                                                                        if url != nil {
                                                                                            VideoPlayer(player: AVPlayer(url: url))
                                                                                                .scaledToFit()
                                                                                                .frame(width: .infinity, height: 60)
                                                                                                .cornerRadius(8)
                                                                                                .disabled(true) // prevents autoplay here
                                                                                        }
                                                                                        else {
                                                                                           ProgressView()
                                                                                               .frame(width: 50, height: 40)
                                                                                       }
                                                                                    }
                                                                                    .onTapGesture {
                                                                                        if let safeURL = fileURL {
                                                                                            confirmedURL = safeURL
                                                                                            isVideo = true
                                                                                            
                                                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                                                showViewer = true
                                                                                            }
                                                                                            
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                            else if isDocumentOrAudioOrArchive(file.fileLink) {
                                                                                ZStack {
                                                                                    RoundedRectangle(cornerRadius: 8)
                                                                                        .fill(Color.gray.opacity(0.2))
                                                                                    Image(systemName: "doc.fill") // you can customize based on extension
                                                                                        .resizable()
                                                                                        .frame(width: 24, height: 30)
                                                                                        .foregroundColor(.blue)
                                                                                }
                                                                                .onTapGesture {
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
                                                                                            .frame(width: .infinity, height: 60)
                                                                                            .scaledToFit()
                                                                                            .clipped()
                                                                                            .cornerRadius(8)
                                                                                            .onTapGesture {
                                                                                                if let safeURL = fileURL {
                                                                                                    confirmedURL = safeURL
                                                                                                    isVideo = false
                                                                                                }
                                                                                            }
                                                                                        
                                                                                        
                                                                                    }
    //                                                                                else if phase.error != nil {
    //                                                                                    Image(systemName: "xmark.octagon")
    //                                                                                        .resizable()
    //                                                                                        .frame(width: 50, height: 40)
    //                                                                                        .foregroundColor(.red)
    //                                                                                }
                                                                                    else {
                                                                                        ProgressView()
                                                                                            .frame(width: 50, height: 40)
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                        
                
    //                                                                }
                                                                    HStack {
                                                                        Text(file.fileName)
                                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                            .font(.custom(.poppinsRegular, size: 12))
                                                                            .lineLimit(1)
                                                                            .padding(.leading, 1)
                                                                        
                                                                        
                                                                        Spacer()
                                                                        Button(action: {
                                                                            isMoreSheetvisible.toggle()
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
                                                                        }) {
                                                                            Image("dots")
                                                                                .resizable()
                                                                                .renderingMode(.template)
                                                                                .frame(width: 25, height: 25, alignment: .topTrailing)
                                                                                .padding(.top, 1)
                                                                                .padding(.trailing, 1)
                                                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                        }
                                                                    }
                                                                }
    //                                                            .padding(.trailing, (index % 3 == 2) ? 16 : 0)
                                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                                .background(
                                                                    RoundedRectangle(cornerRadius: 12)
                                                                        .stroke(themesviewModel.currentTheme.allBlack.opacity(0.1), lineWidth: 1)
                                                                )
                                                                .background(themesviewModel.currentTheme.windowBackground)
                                                                .cornerRadius(12)
                                                                .shadow(color: themesviewModel.currentTheme.colorControlNormal.opacity(0.3), radius: 4, x: 0, y: 2)
                                                            }
                                                        }
                                                        
                                                    }
    //                                                .padding(.top, homeRecordsViewModel.recordsData.count == 0 ? 180 : 0)
                                                    .padding(.horizontal, 16)
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
                                                    Spacer()
                                                }
                                            }

                                            .background(themesviewModel.currentTheme.windowBackground)
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
                                                            
                                                    ) {
                                                        ForEach(homeRecordsViewModel.recordsData.indices, id: \.self) { index in
                                                            let folder = homeRecordsViewModel.recordsData[index]
                                                            HStack(spacing: 12) {
                                                                Image("trashFolder")
                                                                    .resizable()
                                                                    .frame(width: 40, height: 40)
                                                                
                                                                Text(folder.folderName)
                                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    .font(.custom(.poppinsMedium, size: 12))
                                                                Spacer()
                                                                Button(action: {
                                                                    isMoreSheetvisible.toggle()
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
                                                                    
                                                                }) {
                                                                    Image("dots")
                                                                        .resizable()
                                                                        .renderingMode(.template)
                                                                        .frame(width: 30, height: 30, alignment: .topTrailing)
                                                                        .padding(.top, 1)
                                                                        .padding(.trailing, 1)
                                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                }
                                                            }
                                                            .padding()
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(themesviewModel.currentTheme.allBlack.opacity(0.1), lineWidth: 1)
                                                            )
                                                            .background(themesviewModel.currentTheme.windowBackground)
                                                            .cornerRadius(12)
                                                            .shadow(color: themesviewModel.currentTheme.colorControlNormal.opacity(0.3), radius: 4, x: 0, y: 2)
                                                            .listRowBackground(Color.clear)
                                                        }
                                                    }
                                                }
                                                
                                                if homeRecordsViewModel.filesData.count != 0 {
                                                    Section(header: Text("Files")
                                                        .font(.custom(.poppinsBold, size: 16))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        .fontWeight(.bold)
                                                        .padding(.leading)
                                                    ) {
                                                        ForEach(homeRecordsViewModel.filesData.indices, id: \.self) { index in
                                                            let file = homeRecordsViewModel.filesData[index]
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
                                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    .font(.custom(.poppinsMedium, size: 12))
                                                                    .lineLimit(1)
                                                                
                                                                Spacer()
                                                                
                                                                Button(action: {
                                                                    isMoreSheetvisible.toggle()
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
                                                                }) {
                                                                    Image("dots")
                                                                        .resizable()
                                                                        .renderingMode(.template)
                                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                        .frame(width: 30, height: 30)
                                                                        .padding(.top, 1)
                                                                        .padding(.trailing, 1)
                                                                        
                                                                }
                                                            }
                                                            .padding()
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(themesviewModel.currentTheme.allBlack.opacity(0.1), lineWidth: 1)
                                                            )
                                                            .background(themesviewModel.currentTheme.windowBackground)
                                                            .cornerRadius(12)
                                                            .shadow(color: themesviewModel.currentTheme.colorControlNormal.opacity(0.3), radius: 4, x: 0, y: 2)
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
                                            .listStyle(PlainListStyle())
                                            .scrollContentBackground(.hidden)
                                            .background(themesviewModel.currentTheme.windowBackground)
                                            
                                        }
    //                                    .padding(.leading, 16)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    }
                                }
                            
                        }
                        
                        if isfilesView {
                            if typeview == true{
                                GeometryReader { geometry in
                                    ScrollView(.vertical, showsIndicators: false) {
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
                                                                    Image("trashFolder")
                                                                        .resizable()
                                                                        .frame(width: 50, height: 40)
                                                                        .foregroundColor(.yellow)
                                                                    Spacer()
                                                                    
                                                                        Button(action: {
                                                                            isMoreSheetvisible.toggle()
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
                                                                        }) {
                                                                            Image("dots")
                                                                                .resizable()
                                                                                .renderingMode(.template)
                                                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                                .frame(width: 24, height: 24, alignment: .topTrailing)
                                                                                .padding(.top, 1)
                                                                                .padding(.trailing, 1)
                                                                                
                                                                        }
                                                                     
                                                                    
                                                                }

                                                                    Text(folder.folderName)
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .font(.custom(.poppinsRegular, size: 12))
                                                                        .lineLimit(1)
                                                                
                                                            }
                                                            .padding()
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(themesviewModel.currentTheme.allBlack.opacity(0.1), lineWidth: 1)
                                                            )
                                                            .background(themesviewModel.currentTheme.windowBackground)
                                                            .cornerRadius(12)
                                                            .shadow(color: themesviewModel.currentTheme.colorControlNormal.opacity(0.3), radius: 4, x: 0, y: 2)
                                                        }
                                                    }
                                                }
                                                .padding(.horizontal, 16)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                                            }
                                            
                                            // FILES GRID
                                            if homeRecordsViewModel.filesData.count != 0 {
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
                                                        ForEach(homeRecordsViewModel.filesData.indices, id: \.self) { index in
                                                            let file = homeRecordsViewModel.filesData[index]
                                                            VStack(alignment: .leading) {
//                                                                HStack(alignment: .top, spacing: 10) {
                                                                    let fileURL = URL(string: file.fileLink)
                                                                    
                                                                    Group {
                                                                        if file.fileLink.lowercased().hasSuffix(".mp4") || file.fileLink.lowercased().hasSuffix(".mov") || file.fileLink.lowercased().hasSuffix(".3gp") || file.fileLink.lowercased().hasSuffix(".asf") || file.fileLink.lowercased().hasSuffix(".avi") || file.fileLink.lowercased().hasSuffix(".f4v") || file.fileLink.lowercased().hasSuffix(".flv") || file.fileLink.lowercased().hasSuffix(".hevc") ||
                                                                            file.fileLink.lowercased().hasSuffix(".m2ts") || file.fileLink.lowercased().hasSuffix(".m2v") || file.fileLink.lowercased().hasSuffix(".m4v") || file.fileLink.lowercased().hasSuffix(".mjpeg") || file.fileLink.lowercased().hasSuffix(".mpg") || file.fileLink.lowercased().hasSuffix(".mts") ||
                                                                            file.fileLink.lowercased().hasSuffix(".mxf") || file.fileLink.lowercased().hasSuffix(".ogv") || file.fileLink.lowercased().hasSuffix(".rm") || file.fileLink.lowercased().hasSuffix(".swf") || file.fileLink.lowercased().hasSuffix(".ts") || file.fileLink.lowercased().hasSuffix(".vob") || file.fileLink.lowercased().hasSuffix(".webm") || file.fileLink.lowercased().hasSuffix(".wmv") ||
                                                                            file.fileLink.lowercased().hasSuffix(".wtv") {
                                                                            if let url = fileURL {
                                                                                ZStack {
                                                                                    if url != nil {
                                                                                        VideoPlayer(player: AVPlayer(url: url))
                                                                                            .scaledToFit()
                                                                                            .frame(width: .infinity, height: 60)
                                                                                            .cornerRadius(8)
                                                                                            .disabled(true) // prevents autoplay here
                                                                                    }
                                                                                    else {
                                                                                       ProgressView()
                                                                                           .frame(width: 50, height: 40)
                                                                                   }
                                                                                }
                                                                                .onTapGesture {
                                                                                    if let safeURL = fileURL {
                                                                                        confirmedURL = safeURL
                                                                                        isVideo = true
                                                                                        
                                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                                            showViewer = true
                                                                                        }
                                                                                        
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                        else if isDocumentOrAudioOrArchive(file.fileLink) {
                                                                            ZStack {
                                                                                RoundedRectangle(cornerRadius: 8)
                                                                                    .fill(Color.gray.opacity(0.2))
                                                                                Image(systemName: "doc.fill") // you can customize based on extension
                                                                                    .resizable()
                                                                                    .frame(width: 24, height: 30)
                                                                                    .foregroundColor(.blue)
                                                                            }
                                                                            .onTapGesture {
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
                                                                                        .frame(width: .infinity, height: 60)
                                                                                        .scaledToFit()
                                                                                        .clipped()
                                                                                        .cornerRadius(8)
                                                                                        .onTapGesture {
                                                                                            if let safeURL = fileURL {
                                                                                                confirmedURL = safeURL
                                                                                                isVideo = false
                                                                                            }
                                                                                        }
                                                                                    
                                                                                    
                                                                                }
//                                                                                else if phase.error != nil {
//                                                                                    Image(systemName: "xmark.octagon")
//                                                                                        .resizable()
//                                                                                        .frame(width: 50, height: 40)
//                                                                                        .foregroundColor(.red)
//                                                                                }
                                                                                else {
                                                                                    ProgressView()
                                                                                        .frame(width: 50, height: 40)
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    
            
//                                                                }
                                                                HStack {
                                                                    Text(file.fileName)
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .font(.custom(.poppinsRegular, size: 12))
                                                                        .lineLimit(1)
                                                                        .padding(.leading, 1)
                                                                    
                                                                    
                                                                    Spacer()
                                                                    Button(action: {
                                                                        isMoreSheetvisible.toggle()
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
                                                                    }) {
                                                                        Image("dots")
                                                                            .resizable()
                                                                            .renderingMode(.template)
                                                                            .frame(width: 25, height: 25, alignment: .topTrailing)
                                                                            .padding(.top, 1)
                                                                            .padding(.trailing, 1)
                                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                    }
                                                                }
                                                            }
//                                                            .padding(.trailing, (index % 3 == 2) ? 16 : 0)
                                                            .frame(maxWidth: .infinity, alignment: .leading)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .stroke(themesviewModel.currentTheme.allBlack.opacity(0.1), lineWidth: 1)
                                                            )
                                                            .background(themesviewModel.currentTheme.windowBackground)
                                                            .cornerRadius(12)
                                                            .shadow(color: themesviewModel.currentTheme.colorControlNormal.opacity(0.3), radius: 4, x: 0, y: 2)
                                                        }
                                                    }
                                                    
                                                }
//                                                .padding(.top, homeRecordsViewModel.recordsData.count == 0 ? 180 : 0)
                                                .padding(.horizontal, 16)
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
                                                Spacer()
                                            }
                                        }

                                        .background(themesviewModel.currentTheme.windowBackground)
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
                                                        
                                                ) {
                                                    ForEach(homeRecordsViewModel.recordsData.indices, id: \.self) { index in
                                                        let folder = homeRecordsViewModel.recordsData[index]
                                                        HStack(spacing: 12) {
                                                            Image("trashFolder")
                                                                .resizable()
                                                                .frame(width: 40, height: 40)
                                                            
                                                            Text(folder.folderName)
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .font(.custom(.poppinsMedium, size: 12))
                                                            Spacer()
                                                            Button(action: {
                                                                isMoreSheetvisible.toggle()
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
                                                                
                                                            }) {
                                                                Image("dots")
                                                                    .resizable()
                                                                    .renderingMode(.template)
                                                                    .frame(width: 30, height: 30, alignment: .topTrailing)
                                                                    .padding(.top, 1)
                                                                    .padding(.trailing, 1)
                                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                            }
                                                        }
                                                        .padding()
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(themesviewModel.currentTheme.allBlack.opacity(0.1), lineWidth: 1)
                                                        )
                                                        .background(themesviewModel.currentTheme.windowBackground)
                                                        .cornerRadius(12)
                                                        .shadow(color: themesviewModel.currentTheme.colorControlNormal.opacity(0.3), radius: 4, x: 0, y: 2)
                                                        .listRowBackground(Color.clear)
                                                    }
                                                }
                                            }
                                            
                                            if homeRecordsViewModel.filesData.count != 0 {
                                                Section(header: Text("Files")
                                                    .font(.custom(.poppinsBold, size: 16))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .fontWeight(.bold)
                                                    .padding(.leading)
                                                ) {
                                                    ForEach(homeRecordsViewModel.filesData.indices, id: \.self) { index in
                                                        let file = homeRecordsViewModel.filesData[index]
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
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .font(.custom(.poppinsMedium, size: 12))
                                                                .lineLimit(1)
                                                            
                                                            Spacer()
                                                            
                                                            Button(action: {
                                                                isMoreSheetvisible.toggle()
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
                                                            }) {
                                                                Image("dots")
                                                                    .resizable()
                                                                    .renderingMode(.template)
                                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                    .frame(width: 30, height: 30)
                                                                    .padding(.top, 1)
                                                                    .padding(.trailing, 1)
                                                                    
                                                            }
                                                        }
                                                        .padding()
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(themesviewModel.currentTheme.allBlack.opacity(0.1), lineWidth: 1)
                                                        )
                                                        .background(themesviewModel.currentTheme.windowBackground)
                                                        .cornerRadius(12)
                                                        .shadow(color: themesviewModel.currentTheme.colorControlNormal.opacity(0.3), radius: 4, x: 0, y: 2)
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
                                        .listStyle(PlainListStyle())
                                        .scrollContentBackground(.hidden)
                                        .background(themesviewModel.currentTheme.windowBackground)
                                        
                                    }
//                                    .padding(.leading, 16)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                        }
                        
                        if ismailsView {
                            if homeRecordsViewModel.emailsData.count != 0 {
                                VStack {
                                    HStack{
                                        Text("Mails")
                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        Spacer()
                                    }
                                    
                                    ScrollView(.vertical, showsIndicators: false) {
                                        ForEach(homeRecordsViewModel.emailsData.indices, id: \.self) { index in
                                            let folder = homeRecordsViewModel.emailsData[index]
                                            VStack {
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
                                                            
                                                            
                                                            Spacer()
                                                            if let unixTimestamp = folder.sentAt,
                                                               let istDateStringFromISO = convertToTime(dateInput: unixTimestamp) {
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
                                                        }
                                                    }
                                                }
                                                .padding(.top , 10)
                                                
                                                Divider()
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 1)
                                                    .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                    .onTapGesture {
                                                        homeRecordsViewModel.selectedId = folder.threadId
                                                        homeRecordsViewModel.isEmailScreen = true
                                                    }
                                            }
                                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                            .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                        }
                                        .listStyle(PlainListStyle())
                                        .scrollContentBackground(.hidden)
                                        
                                    }
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
                                                Image("trashFolder")
                                                    .resizable()
                                                    .frame(width: 50, height: 40)
                                                    .foregroundColor(.yellow)
                                                Spacer()
                                            }
                                            
                                            Text(folder.folderName)
                                                .foregroundColor(.black)
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
                            }
                            
                            
                        }
                    }
                    Spacer()


                }
                .padding(.bottom , 50)
                .toast(message: $homeRecordsViewModel.error)
                .toast(message: $consoleViewModel.error)
                .toast(message: $toastMessage)

                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear{
                        homeRecordsViewModel.getMainRecordsData()
                    homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                    
                    homeRecordsViewModel.setPin = sessionManager.pin
                    homeRecordsViewModel.password = sessionManager.password
                    password = sessionManager.password
                }
                .onChange(of: homeRecordsViewModel.mainRecordsData) { newValue in
                    if !newValue.isEmpty {
                        MainselectedTabID = newValue.map { $0.id }

                        if MainselectedTabID.indices.contains(0) {
                            selectedTabID = MainselectedTabID[0]
                            Foldertype = "work"
                            subFoldertype = "files"

                            homeRecordsViewModel.getRecordsData(
                                selectedTabID: selectedTabID,
                                Type: Foldertype,
                                SubFoldersType: subFoldertype
                            )
                        }
                    }
                }
                
                .onChange(of: isMoreSheetvisible) { newValue in
                    if newValue == false {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            homeRecordsViewModel.getRecordsData(selectedTabID: homeRecordsViewModel.folderID, Type: homeRecordsViewModel.fileType,  SubFoldersType: homeRecordsViewModel.subfoldertype)
                        }
                    }
                }


                
                if BottomBars {
                    VStack {
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action: {
                                plusmark = true
                            }) {
                                Image("plus")
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .frame(width: 20, height: 20) // You can adjust size here
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
                            VStack {
                                Button(action: {
                                    if selectedTAB == "work" {
                                        selectedTabID = MainselectedTabID[0]+1 ; Foldertype = "work"; subFoldertype = "files"
                                        
                                        homeRecordsViewModel.folderID = MainselectedTabID[0]+1 ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "files"
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
                                        
                                        workspace = false
                                        ismailsView = false
                                        subFolderView = false
                                        subFolderViewFiles = false
                                        typeview = true
                                        isfilesView = true
                                        homeRecordsViewModel.getMainRecordsData()

                                    }
                                    else if selectedTAB == "archive" {
                                        selectedTabID = MainselectedTabID[1]+1 ;Foldertype = "archive"; subFoldertype = "files"
                                        homeRecordsViewModel.folderID = MainselectedTabID[1]+1 ; homeRecordsViewModel.fileType = "archive" ; homeRecordsViewModel.subfoldertype = "files"
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
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
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getLockerData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
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
                                        .frame(width: 24 , height: 24)
                                }
                                
                                
                                Text("Files")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 10))
                            }
                            .contentShape(Rectangle())
                            Spacer()
                            VStack {
                                Button(action: {
                                    if selectedTAB == "work" {
                                        selectedTabID = MainselectedTabID[0]+2 ; Foldertype = "work"; subFoldertype = "mails"
                                        homeRecordsViewModel.folderID = MainselectedTabID[0]+2 ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "mails"
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
                                        
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
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
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
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getLockerData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
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
                                        .frame(width: 24 , height: 24)
                                }
                                Text("Mails")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 10))
                            }
                            .contentShape(Rectangle())
                            Spacer()
                            
                            VStack {
                                Button(action: {
                                    if selectedTAB == "work" {
                                        selectedTabID = MainselectedTabID[0]+3 ;Foldertype = "work"; subFoldertype = "pictures"
                                        homeRecordsViewModel.folderID = MainselectedTabID[0]+3 ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "pictures"
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
                                        workspace = false
                                        ismailsView = false
                                        subFolderView = false
                                        subFolderViewFiles = false
                                        typeview = true
                                        isfilesView = true
                                        
                                        homeRecordsViewModel.getMainRecordsData()

                                    }
                                    else if selectedTAB == "archive" {
                                        selectedTabID = MainselectedTabID[1]+3 ;Foldertype = "archive"; subFoldertype = "pictures"
                                        homeRecordsViewModel.folderID = MainselectedTabID[1]+3 ; homeRecordsViewModel.fileType = "archive" ; homeRecordsViewModel.subfoldertype = "pictures"
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
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
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getLockerData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
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
                                        .frame(width: 24 , height: 24)
                                }
                                
                                Text("Pictures")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 10))
                            }
                            .contentShape(Rectangle())
                            Spacer()
                            
                            VStack {
                                Button(action: {
                                    if selectedTAB == "work" {
                                        selectedTabID = MainselectedTabID[0]+4 ;Foldertype = "work"; subFoldertype = "videos"
                                        
                                        homeRecordsViewModel.folderID = MainselectedTabID[0]+4 ; homeRecordsViewModel.fileType = "work" ; homeRecordsViewModel.subfoldertype = "videos"
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
                                        workspace = false
                                        ismailsView = false
                                        subFolderView = false
                                        subFolderViewFiles = false
                                        typeview = true
                                        isfilesView = true
                                    }
                                    else if selectedTAB == "archive" {
                                        selectedTabID = MainselectedTabID[1]+4 ; Foldertype = "archive"; subFoldertype = "videos"
                                        homeRecordsViewModel.folderID = MainselectedTabID[1]+4 ; homeRecordsViewModel.fileType = "archive" ; homeRecordsViewModel.subfoldertype = "videos"
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
                                        workspace = false
                                        ismailsView = false
                                        subFolderView = false
                                        subFolderViewFiles = false
                                        typeview = true
                                        isfilesView = true
                                    }
                                    else if selectedTAB == "Locker" {
                                        selectedTabID = MainselectedTabID[2]+4 ; Foldertype = "locker"; subFoldertype = "videos"
                                        homeRecordsViewModel.folderID = MainselectedTabID[2]+4 ; homeRecordsViewModel.fileType = "locker" ; homeRecordsViewModel.subfoldertype = "videos"
                                        DispatchQueue.main.async {
                                            homeRecordsViewModel.getLockerData(selectedTabID: selectedTabID, Type: Foldertype, SubFoldersType: subFoldertype)
                                        }
                                        workspace = false
                                        ismailsView = false
                                        subFolderView = false
                                        subFolderViewFiles = false
                                        typeview = true
                                        isfilesView = true
                                    }
                                }) {
                                    Image(systemName: "video")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 24 , height: 24)
                                }
                                
                                Text("Videos")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 10))
                            }
                            .contentShape(Rectangle())
                        }
                        .padding([.bottom , .top] , 10)
                        .padding([.leading , .trailing], 30)
                        .frame(maxWidth: .infinity)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .zIndex(1000)
                    }
                    
                }
                
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }

                



                    // GRID VIEW

                    
                if subFolderViewFiles {
                        if homeRecordsViewModel.filesData.count != 0 {
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
                                    ForEach(homeRecordsViewModel.filesData.indices, id: \.self) { index in
                                        let file = homeRecordsViewModel.filesData[index]
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
                                                                if let safeURL = fileURL {
                                                                    confirmedURL = safeURL
                                                                    isVideo = true
                                                                    
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                                        showViewer = true
                                                                    }
                                                                    
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
                                                                        if let safeURL = fileURL {
                                                                            confirmedURL = safeURL
                                                                            isVideo = false
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
                                    isMoreSheetvisible = false
                                }
                            }
                                
                                VStack {
                                    Spacer() // Pushes the sheet to the bottom
                                    RecordsThreeDotsView(selectedTabID: $selectedTabID, folderName: $Foldertype, subFolderName: $subFoldertype, emailIds: $emailID, recordIDs: $recordID, fieldIDs: $fieldID, azureName: $FileAzureName, FileName: $foldername, createdTime: $createdAt, UpdatedTime: $UpdatedAt, Foldersize: $filesize, azureLink: $AzureLink , filetype: $fileType , formatFile: $fileFormat, fileClicked: $fileclicks , isPresented: $isMoreSheetvisible)
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
                                                workspace = true
                                                typeview = true
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
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView , emailId: homeRecordsViewModel.selectedId ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars, markAs: $markAs).toolbar(.hidden)
                
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
