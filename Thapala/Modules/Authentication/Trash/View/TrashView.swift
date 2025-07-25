//
//  TrashView.swift
//  Thapala
//
//  Created by Ahex-Guest on 09/10/24.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI
struct TrashView: View {
    @StateObject var TrashedViewModel = TrashViewModel()
    @StateObject var themesviewModel = themesViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @State private var selectedTab = "Mails"
    @State private var selectedFiles: Set<Int> = []
    @State private var selectAll: Bool = false
    @State private var selectedItems: Set<Int> = []
    @State var doitTitle: String = ""
    @State var doitCreatedDate: String = ""
    @State var doitDeleteDate: String = ""
    @State var NoteTitle: String = ""
    @State var NoteCreatedDate: String = ""
    @State var NoteDeleteDate: String = ""
    @State private var doitItems: [PlannerTrashItem] = []
    @State private var NoteItems: [PlannerTrashItem] = []
    @State private var selectedPlannerTab: String = ""
    @State private var bottomIcons = false
    @State private var selectedID: [Int] = []
    @State private var showingDeleteAlert = false
    @State private var showingRestoreAlert = false
    @Binding var isTrashViewVisible: Bool
    @State private var isMenuVisible = false
    @State private var isfilesView: Bool = false
    @State private var isfoldersView: Bool = false
    @State private var selectedIndices: Set<Int> = []
    @State private var isSelectAll = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var conveyedView: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var recordIDs: [Int]? = nil
    @State private var feildIDs: [Int]? = nil
    @State private var selectedFileTab: String = ""
    @State private var azureFileName: String = ""
    @State private var fileSize: String = ""
    @State private var selectedFieldID: Int = 0
    @State private var AwaitingView: Bool = false
    @State private var markAs : Int = 0
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    Button {
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                    Text("Trash")
                        .font(.custom(.poppinsRegular, size: 16))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.top , 10)
                .padding(.leading,20)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
                
                HStack {
                    Button(action: {
                        selectedTab = "Mails"
                        selectedFileTab = ""
                        selectedPlannerTab = ""
                        isfilesView = false
                        isfoldersView = false
                        TrashedViewModel.GetTrashData()
                    }) {
                        Text("Mails")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 10)
                            .padding()
                            .background(selectedTab == "Mails" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        selectedTab = "files"
                        selectedFileTab = "Allfiles"
                        selectedPlannerTab = ""
                        isfilesView = true
                        isfoldersView = false
                        TrashedViewModel.GetFileTrashData()
                        
                    }) {
                        Text("Files")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 10)
                            .padding()
                            .background(selectedTab == "files" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        selectedTab = "Planner"
                        selectedFileTab = ""
                        selectedPlannerTab = "tDo"
                        isfilesView = false
                        isfoldersView = false
                        TrashedViewModel.GetPlannerTrashData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            doitItems = TrashedViewModel.PlanData.filter { $0.type == "doit" }
                        }
                    }) {
                        Text("Planner")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 10)
                            .padding()
                            .background(selectedTab == "Planner" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                if selectedTab == "Mails" {
                    if TrashedViewModel.trashData.count == 0 {
                        VStack(alignment: .center) {
                            Text("No mails Found")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsBold, size: 24))
                        }
                        .background(themesviewModel.currentTheme.windowBackground)
                    }
                    else {
                        VStack{
                            HStack {
                                Text("Select All")
                                    .font(.custom(.poppinsBold, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .fontWeight(.bold)
                                    .padding(.leading, 16)

                                Button(action: {
                                    if selectedIndices.count == TrashedViewModel.trashData.count {
                                        selectedIndices.removeAll()
                                        isSelectAll = false
                                    } else {
                                        selectedIndices = Set(TrashedViewModel.trashData.map { $0.id })
                                        isSelectAll = true
                                    }
                                    feildIDs = Array(selectedIndices)
                                    bottomIcons = !selectedIndices.isEmpty
                                }) {
                                    Image(systemName: isSelectAll ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.top, 1)
                                        .padding(.trailing, 5)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                }

                                Spacer()
                            }
                            .padding(.top , 10)
                            List(TrashedViewModel.trashData, id: \.id) { item in
                                HStack {
                                    Button(action: {
                                        if selectedIndices.contains(item.id) {
                                            selectedIndices.remove(item.id)
                                        } else {
                                            selectedIndices.insert(item.id)
                                        }

                                        feildIDs = Array(selectedIndices)
                                        isSelectAll = selectedIndices.count == TrashedViewModel.trashData.count
                                        

                                        bottomIcons = !selectedIndices.isEmpty
                                    }) {
                                        Image(systemName: selectedIndices.contains(item.id) ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.top, 1)
                                            .padding(.trailing, 5)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        
                                    }

                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(item.firstname ?? "")
                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.leading, 10)

                                            Text(item.subject ?? "")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                .padding(.leading, 10)
                                                .lineLimit(1)
                                        }

                                        Spacer()

                                        if let timestamp = item.timeOfRead,
                                           let istDateString = convertToIST(dateInput: timestamp) {
                                            Text(istDateString)
                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.top, 0)
                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                        }
                                    }
                                    .onTapGesture {
                                        if TrashedViewModel.beforeLongPress {
                                            TrashedViewModel.selectedID = item.threadId
                                            TrashedViewModel.passwordHint = item.passwordHint
                                            TrashedViewModel.isEmailScreen = true
                                        }
                                    }
                                    .gesture(
                                        LongPressGesture(minimumDuration: 1.0)
                                            .onEnded { _ in
                                                withAnimation {
                                                    TrashedViewModel.beforeLongPress = false
                                                }
                                            }
                                    )
                                }
                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                            }
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)

                        }
                    }
                }
                 if selectedTab == "files"{
                        // All Files and Folders toggle buttons
                        HStack {
                            Button(action: {
                                TrashedViewModel.GetFileTrashData()
                                isfilesView = true
                                isfoldersView = false
                                selectedFileTab = "Allfiles"
                            }) {
                                Text("All files")
                                    .fontWeight(.medium)
                                    .frame(width: 100 , height:10)
                                    .padding()
                                    .background(isfilesView ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            Button(action: {
                                isfilesView = false
                                TrashedViewModel.GetFolderTrashData()
                                isfoldersView = true
                                selectedFileTab = "folders"
                            }) {
                                Text("Folders")
                                    .fontWeight(.medium)
                                    .frame(width: 100 , height:10)
                                    .padding()
                                    .background(!isfilesView ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                        
                    }
                    
                    if selectedTab == "Planner"{
                        HStack {
                            Button(action: {
                                selectedPlannerTab = "tDo"
                                isfilesView = false
                                isfoldersView = false
                                TrashedViewModel.GetPlannerTrashData()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    doitItems = TrashedViewModel.PlanData.filter { $0.type == "doit" }
                                }
                            }) {
                                Text("tDo")
                                    .fontWeight(.medium)
                                    .frame(width: 100 , height:10)
                                    .padding()
                                    .background(selectedPlannerTab == "tDo" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            Button(action: {
                                selectedPlannerTab = "tNote"
                                isfilesView = false
                                isfoldersView = false
                                TrashedViewModel.GetPlannerTrashData()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    NoteItems = TrashedViewModel.PlanData.filter { $0.type == "note" }
                                }
                            }) {
                                Text("tNote")
                                    .fontWeight(.medium)
                                    .frame(width: 100 , height:10)
                                    .padding()
                                    .background(selectedPlannerTab == "tNote" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                        HStack {
                            Toggle(isOn: $selectAll) {
                                Text("Select All")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                            }
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .onChange(of: selectAll) { newValue in
                                // When Select All is toggled, update all items
                                if selectedPlannerTab == "tDo" {
                                    selectedID.removeAll()  // Clear previous selection before adding new items
                                    for index in doitItems.indices {
                                        doitItems[index].isChecked = newValue ? 1 : 0
                                        bottomIcons = (doitItems[index].isChecked == 1)
                                        if (doitItems[index].isChecked == 1) {
                                            let id = doitItems[index].id
                                            if !selectedID.contains(id) {  // Avoid duplicates
                                                selectedID.append(id)
                                            }
                                        }
                                    }
                                    
                                }
                                if selectedPlannerTab == "tNote" {
                                    selectedID.removeAll()
                                    for index in NoteItems.indices {
                                        NoteItems[index].isChecked = newValue ? 1 : 0
                                        bottomIcons = (NoteItems[index].isChecked == 1);
                                        if (NoteItems[index].isChecked == 1) {
                                            let id = NoteItems[index].id
                                            if !selectedID.contains(id) {  // Avoid duplicates
                                                selectedID.append(id)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            .padding()
                            
                            Spacer()
                        }
                        
                        if selectedPlannerTab == "tDo" {
                            if TrashedViewModel.isLoading {
                                CustomProgressView()
                            }
                            
                            else if doitItems.count != 0{
                                List {
                                    ForEach(doitItems.indices, id: \.self) { index in
                                        HStack {
                                            Button(action: {
                                                doitItems[index].isChecked = (doitItems[index].isChecked == 0) ? 1 : 0;
                                                bottomIcons = (doitItems[index].isChecked == 1);
                                                if (doitItems[index].isChecked == 1) {
                                                    selectedID = [doitItems[index].id]
                                                }
                                            }) {
                                                Image(systemName: (doitItems[index].isChecked != 0) ? "checkmark.square.fill" : "square")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.top, 1)
                                                    .padding(.trailing, 5)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            }
                                            VStack(alignment: .leading) {
                                                
                                                Text(doitItems[index].title)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsBold, size: 14))
                                                
                                                Text("Created date:  \(formatDateTime(Date(timeIntervalSince1970: TimeInterval(doitItems[index].createdTimeStamp ?? 0))))")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsSemiBold, size: 14))
                                                Text("Deleted date:  \(formatDateTime(Date(timeIntervalSince1970: TimeInterval(doitItems[index].deletedAt ?? "") ?? 0)))")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsSemiBold, size: 14))
                                                
                                            }
                                            .padding(.vertical, 15)
                                        }
                                        .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                    }
                                }
                                .listStyle(PlainListStyle())
                                .scrollContentBackground(.hidden)
                            }
                            else  {
                                VStack(alignment: .center) {
                                    Text("No TDo Found")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsBold, size: 24))
                                }
                            }
                        }
                        if selectedPlannerTab == "tNote" {
                            if TrashedViewModel.isLoading {
                                CustomProgressView()
                            }
                            
                            if NoteItems.count != 0 {
                                List {
                                    ForEach(NoteItems.indices, id: \.self) { index in
                                        HStack {
                                            Button(action: {
                                                NoteItems[index].isChecked = (NoteItems[index].isChecked == 0) ? 1 : 0;
                                                bottomIcons = (NoteItems[index].isChecked == 1);
                                                if (NoteItems[index].isChecked == 1) {
                                                    selectedID = [NoteItems[index].id]
                                                }
                                                
                                            }) {
                                                Image(systemName: (NoteItems[index].isChecked != 0) ? "checkmark.square.fill" : "square")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.top, 1)
                                                    .padding(.trailing, 5)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text(NoteItems[index].title)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsBold, size: 14))
                                                Text("Created date :  \(formatDateTime(Date(timeIntervalSince1970: TimeInterval(NoteItems[index].createdTimeStamp ?? 0))))")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsSemiBold, size: 14))
                                                Text("Deleted date :  \(formatDateTime(Date(timeIntervalSince1970: TimeInterval(NoteItems[index].deletedAt ?? "") ?? 0)))")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsSemiBold, size: 14))
                                                
                                            }
                                            .padding(.vertical, 15)
                                        }
                                        .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                    }
                                }
                                .listStyle(PlainListStyle())
                                .scrollContentBackground(.hidden)
                            }
                            else {
                                VStack(alignment: .center) {
                                    Text("Note items Not Found")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsBold, size: 24))
                                }
                                .background(themesviewModel.currentTheme.windowBackground)
                            }
                        }
                        
                        
                    }
                
                
                if isfilesView {
                    if TrashedViewModel.fileData.count != 0 {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Select All")
                                        .font(.custom(.poppinsBold, size: 16))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .fontWeight(.bold)
                                        .padding(.leading, 16)
                                    
                                    Button(action: {
                                        isSelectAll.toggle()
                                        if isSelectAll {
                                            selectedIndices = Set(TrashedViewModel.fileData.indices)
                                            recordIDs = []
                                            feildIDs = selectedIndices.map { TrashedViewModel.fileData[$0].id }
                                            selectedID = feildIDs ?? []
                                        } else {
                                            selectedIndices.removeAll()
                                        }
                                        bottomIcons = !selectedIndices.isEmpty
                                    }) {
                                        Image(systemName: isSelectAll ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.top, 1)
                                            .padding(.trailing, 5)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.top , 10)
                                
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 10) {
                                        let columns = [
                                            GridItem(.flexible(minimum: 100), spacing: 20),
                                            GridItem(.flexible(minimum: 100), spacing: 20),
                                            GridItem(.flexible(minimum: 100), spacing: 0)
                                        ]
                                        LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
                                            ForEach(TrashedViewModel.fileData.indices, id: \.self) { index in
                                                let file = TrashedViewModel.fileData[index]
                                                VStack(alignment: .leading, spacing: 8) {
                                                    Spacer()
                                                    HStack {
                                                        Spacer()
                                                        Button(action: {
                                                            if selectedIndices.contains(index) {
                                                                selectedIndices.remove(index)
                                                            } else {
                                                                selectedIndices.insert(index)
                                                                recordIDs = []
                                                                feildIDs = selectedIndices.map { TrashedViewModel.fileData[$0].id }
                                                            }
                                                            
                                                            azureFileName = file.azureFileName
                                                            fileSize = file.fileSize
                                                            selectedFieldID = file.id
                                                            // Optional: update selectAll state based on selection count
                                                            isSelectAll = selectedIndices.count == TrashedViewModel.fileData.count
                                                            bottomIcons = !selectedIndices.isEmpty
                                                        }) {
                                                            Image(systemName: selectedIndices.contains(index) ? "checkmark.square.fill" : "square")
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                                .padding(.top, 1)
                                                                .padding(.trailing, 5)
                                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        }
                                                    }
                                                    
                                                    HStack(alignment: .top, spacing: 10) {
                                                        let fileURL = URL(string: file.fileLink)
                                                        
                                                        Group {
                                                            if file.fileLink.lowercased().hasSuffix(".mp4") || file.fileLink.lowercased().hasSuffix(".mov") || file.fileLink.lowercased().hasSuffix(".3gp") || file.fileLink.lowercased().hasSuffix(".asf") || file.fileLink.lowercased().hasSuffix(".avi") || file.fileLink.lowercased().hasSuffix(".f4v") || file.fileLink.lowercased().hasSuffix(".flv") || file.fileLink.lowercased().hasSuffix(".hevc") ||
                                                                file.fileLink.lowercased().hasSuffix(".m2ts") || file.fileLink.lowercased().hasSuffix(".m2v") || file.fileLink.lowercased().hasSuffix(".m4v") || file.fileLink.lowercased().hasSuffix(".mjpeg") || file.fileLink.lowercased().hasSuffix(".mpg") || file.fileLink.lowercased().hasSuffix(".mts") ||
                                                                file.fileLink.lowercased().hasSuffix(".mxf") || file.fileLink.lowercased().hasSuffix(".ogv") || file.fileLink.lowercased().hasSuffix(".rm") || file.fileLink.lowercased().hasSuffix(".swf") || file.fileLink.lowercased().hasSuffix(".ts") || file.fileLink.lowercased().hasSuffix(".vob") || file.fileLink.lowercased().hasSuffix(".webm") || file.fileLink.lowercased().hasSuffix(".wmv") ||
                                                                file.fileLink.lowercased().hasSuffix(".wtv") {
                                                                if let url = fileURL {
                                                                    ZStack {
                                                                        Image("videomp4")
                                                                            .resizable()
                                                                            .frame(width: 60, height: 100)
                                                                            .foregroundColor(.black)
                                                                    }
        
                                                                    
                                                                    
                                                                }
                                                            }
                                                            else if isDocumentOrAudioOrArchive(file.fileLink) {
                                                                ZStack {
                                                                    RoundedRectangle(cornerRadius: 8)
                                                                        .fill(Color.gray.opacity(0.2))
                                                                        .frame(width: 60, height: 100)
                                                                    Image(systemName: "doc.fill")
                                                                        .resizable()
                                                                        .frame(width:55, height: 90)
                                                                        .foregroundColor(.blue)
                                                                }
                                                                
                                                            }
                                                            
                                                            else {
                                                                AsyncImage(url: fileURL) { phase in
                                                                    if let image = phase.image {
                                                                        image
                                                                            .resizable()
                                                                            .scaledToFill()
                                                                            .frame(width: 100, height: 100)
                                                                            .clipped()
                                                                            .cornerRadius(8)
                                                                        
                                                                        
                                                                    }
                                                                    //                                                            else if phase.error != nil {
                                                                    //                                                                Image(systemName: "xmark.octagon")
                                                                    //                                                                    .resizable()
                                                                    //                                                                    .frame(width: 60, height: 100)
                                                                    //                                                                    .foregroundColor(.red)
                                                                    //                                                            }
                                                                    else {
                                                                        CustomProgressView()
                                                                            .frame(width: 60, height: 100)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    Text(file.fileName)
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                .background(themesviewModel.currentTheme.windowBackground)
                                                .cornerRadius(12)
                                                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                            }
                                        }
                                    }
                                    .padding(.top , 10)
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                }
                            }
                        
                    }
                }
                
                if isfoldersView {
                    if TrashedViewModel.folderData.count != 0 {
                        
                        VStack(alignment: .leading, spacing: 15) {
                            
                            HStack {
                                Text("Select All")
                                    .font(.custom(.poppinsBold, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .fontWeight(.bold)
                                    .padding(.leading, 16)
                                
                                Button(action: {
                                    isSelectAll.toggle()
                                    if isSelectAll {
                                        selectedIndices = Set(TrashedViewModel.folderData.indices)
                                        feildIDs = []
                                        recordIDs = selectedIndices.map { TrashedViewModel.folderData[$0].id }
                                        selectedID = recordIDs ?? []
                                    } else {
                                        selectedIndices.removeAll()
                                        
                                    }
                                    bottomIcons = !selectedIndices.isEmpty
                                }) {
                                    Image(systemName: isSelectAll ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.top, 1)
                                        .padding(.trailing, 5)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                }
                                
                                Spacer()
                            }
                            .padding(.top , 10)
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 15) {
                                    let columns = [
                                        GridItem(.flexible(minimum: 100), spacing: 10),
                                        GridItem(.flexible(minimum: 100), spacing: 10),
                                        GridItem(.flexible(minimum: 100), spacing: 10)
                                    ]
                                    
                                    LazyVGrid(columns: columns, alignment: .leading, spacing: 5) {
                                        ForEach(TrashedViewModel.folderData.indices, id: \.self) { index in
                                            let Folders = TrashedViewModel.folderData[index]
                                            
                                            VStack(alignment: .center) {
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    Button(action: {
                                                        if selectedIndices.contains(index) {
                                                            selectedIndices.remove(index)
                                                        } else {
                                                            selectedIndices.insert(index)
                                                            feildIDs = []
                                                            recordIDs = selectedIndices.map { TrashedViewModel.folderData[$0].id }
                                                        }
                                                        
                                                        // Optional: update selectAll state based on selection count
                                                        isSelectAll = selectedIndices.count == TrashedViewModel.folderData.count
                                                        bottomIcons = !selectedIndices.isEmpty
                                                    }) {
                                                        Image(systemName: selectedIndices.contains(index) ? "checkmark.square.fill" : "square")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                            .padding(.top, 1)
                                                            .padding(.trailing, 5)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    }
                                                }
                                                
                                                Image("trashFolder")
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                    .foregroundColor(.yellow)
                                                
                                                Divider()
                                                    .frame(height: 1)
                                                    .background(themesviewModel.currentTheme.attachmentBGColor)
                                                    .padding([.leading, .trailing], 2)
                                                
                                                
                                                Text(Folders.folderName)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14))
                                                    .lineLimit(1)
                                            }
                                            .padding(5)
                                            .padding(.trailing, (index % 3 == 2) ? 16 : 0)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                            .background(themesviewModel.currentTheme.windowBackground)
                                            .cornerRadius(12)
                                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                                        }
                                    }
                                }
                                .padding(.top , 10)
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                        }
                        
                    }
                }

                Spacer()
                if bottomIcons {
                    HStack {
                        Button(action: {
                           showingRestoreAlert = true
                        }) {
                            Image("Restore")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 30, height:30)
                                .padding(.leading,20)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                        }) {
                            Image("deleteIcon")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 30, height: 30)
                                .padding(.leading,20)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(themesviewModel.currentTheme.windowBackground.opacity(0.1))
                }                
            }
            .background(themesviewModel.currentTheme.windowBackground)
            if isMenuVisible{
                HomeMenuView(isSidebarVisible: $isMenuVisible)
            }
            if showingDeleteAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingDeleteAlert = false
                    }
                
                DeleteAlert(isPresented: $showingDeleteAlert) {
                    // Delete action
                    if selectedPlannerTab == "tDo" || selectedPlannerTab == "tNote" {
                        TrashedViewModel.deleteplanner(selectedID: selectedID)
                    }
                    else if selectedFileTab == "Allfiles" {
                            TrashedViewModel.deleteFiles(RecordIds: recordIDs ?? [] , selectedFieldID: selectedFieldID, AzureFileName: azureFileName, FileSize: fileSize)
                        }
                    
                    else if selectedFileTab == "folders" {
                        TrashedViewModel.deleteFolders(RecordIds: recordIDs ?? [], FileIds: feildIDs ?? [])
                        }
                    
                    else if selectedTab == "Mails" {
                        TrashedViewModel.deleteEmail(selectedEmailIDs: feildIDs ?? [])
                    }

                    // Remove the deleted items from the respective list
                    if selectedPlannerTab == "tDo" {
                        doitItems.removeAll { item in
                            selectedID.contains(item.id)
                        }
                    } else if selectedPlannerTab == "tNote" {
                        NoteItems.removeAll { item in
                            selectedID.contains(item.id)
                        }
                    }
                    else if selectedFileTab == "Allfiles" {
                        TrashedViewModel.fileData.removeAll { file in
                            feildIDs?.contains(file.id) == true
                        }
                    }
                    
                    else if selectedFileTab == "folders" {
                        TrashedViewModel.folderData.removeAll { folder in
                            recordIDs?.contains(folder.id) == true
                        }
                    }
                    else if selectedTab == "Mails" {
                        TrashedViewModel.trashData.removeAll { mail in
                            feildIDs?.contains(mail.id) == true
                        }
                    }
                    
                    // Reset selection and bottom icons
                    selectedIndices.removeAll()
                    recordIDs = []
                    feildIDs = []
                    selectedID = []
                    selectedID.removeAll()
                    bottomIcons = false
                    selectAll = false
                    
                    // Optionally dismiss the trash view if needed
                    isTrashViewVisible = false
                }
                .transition(.scale)
                .animation(.easeInOut, value: showingDeleteAlert)
            }
            
            
            if showingRestoreAlert {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingRestoreAlert = false
                    }
                
                RestoreAlert(isPresented: $showingRestoreAlert) {
                    // Delete action
                    if selectedPlannerTab == "tDo" || selectedPlannerTab == "tNote" {
                        TrashedViewModel.restorePlanner(selectedID: selectedID)
                    }
                    else if selectedTab == "Mails" {
                        TrashedViewModel.restoreMails(threadID: feildIDs ?? [])
                    }
                    
                    else if selectedTab == "files" {
                        TrashedViewModel.restoreFiles(RecordIds: recordIDs ?? [], FieldIDs: feildIDs ?? [])
                    }
                    
                    // Remove the deleted items from the respective list
                    if selectedPlannerTab == "tDo" {
                        doitItems.removeAll { item in
                            selectedID.contains(item.id)
                        }
                    } else if selectedPlannerTab == "tNote" {
                        NoteItems.removeAll { item in
                            selectedID.contains(item.id)
                        }
                    }
                  
                    
                    else if selectedFileTab == "Allfiles" {
                        TrashedViewModel.fileData.removeAll { file in
                            feildIDs?.contains(file.id) == true
                        }
                    }
                    
                    else if selectedFileTab == "folders" {
                        TrashedViewModel.folderData.removeAll { folder in
                            recordIDs?.contains(folder.id) == true
                        }
                    }
                    else if selectedTab == "Mails" {
                        TrashedViewModel.trashData.removeAll { mail in
                            feildIDs?.contains(mail.id) == true
                        }
                    }
                    // Reset selection and bottom icons
                    selectedIndices.removeAll()
                    recordIDs = []
                    feildIDs = []
                    selectedID = []
                    selectedID.removeAll()
                    bottomIcons = false
                    selectAll = false
                    isSelectAll = false
                    
//                    selectedFileTab
                    // Optionally dismiss the trash view if needed
                    isTrashViewVisible = false
                }
                .transition(.scale)
                .animation(.easeInOut, value: showingRestoreAlert)
            }
            
            

        }
        .onAppear {
            TrashedViewModel.GetTrashData()
            TrashedViewModel.GetPlannerTrashData()
//            if TrashedViewModel.PlanData.isEmpty {
//                TrashedViewModel.GetPlannerTrashData()
//            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if selectedPlannerTab == "tDo" {
                    doitItems = TrashedViewModel.PlanData.filter { $0.type == "doit" }
                }
            }
        }
        .fullScreenCover(isPresented: $TrashedViewModel.isEmailScreen) {
            MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView,  awaitingView: $AwaitingView , emailId: TrashedViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars ,markAs: $markAs).toolbar(.hidden)
            }
    }
    
    func isDocumentOrAudioOrArchive(_ path: String) -> Bool {
        let supportedExtensions = ["pdf", "doc", "docx", "odt", "rtf", "txt", "xls", "xlsx", "ods", "ppt", "pptx", "odp", "mp3", "wav", "zip", "rar"]
        return supportedExtensions.contains(where: { path.lowercased().hasSuffix(".\($0)") })
    }
    
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy, hh:mma"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current // Or specify a timezone if needed

        let dateString = formatter.string(from: date)
        
        // Get the timezone offset
        let seconds = TimeZone.current.secondsFromGMT(for: date)
        let hours = seconds / 3600
        let minutes = abs(seconds / 60) % 60
        let sign = hours >= 0 ? "+" : "-"
        
        let timeZoneString = String(format: "%@%02d:%02d", sign, abs(hours), minutes)
        
        return "\(dateString)(\(timeZoneString))"
    }

 }

 struct CheckboxToggleStyle: ToggleStyle {
     func makeBody(configuration: Configuration) -> some View {
         HStack {
             Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                 .onTapGesture { configuration.isOn.toggle() }
             configuration.label
         }
     }
 }




struct DeleteAlert: View {
    @Binding var isPresented: Bool
    var onDelete: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // Alert card
            VStack(spacing: 24) {
                // Warning icon
                Circle()
                    .fill(Color(UIColor.systemPink).opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.black)
                    )
                
                // Title
                Text("Confirmation")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Message
                Text("Are you sure you want to delete this Data ?")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                // Buttons
                HStack(spacing: 20) {
                    // No button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("No")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    
                    // Yes button
                    Button(action: {
                        onDelete()
                        isPresented = false
                    }) {
                        Text("Yes")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
         .background(Color.black.opacity(0.4))
         .edgesIgnoringSafeArea(.all)
    }
}


struct RestoreAlert: View {
    @Binding var isPresented: Bool
    var onDelete: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // Alert card
            VStack(spacing: 24) {
                // Warning icon
                Circle()
                    .fill(Color(UIColor.systemPink).opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.black)
                    )
                
                // Title
                Text("Confirmation")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Message
                Text("Are you sure you want to delete this Restore ?")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                // Buttons
                HStack(spacing: 20) {
                    // No button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("No")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    
                    // Yes button
                    Button(action: {
                        onDelete()
                        isPresented = false
                    }) {
                        Text("Yes")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .refreshable {
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
         .background(Color.black.opacity(0.4))
         .edgesIgnoringSafeArea(.all)
    }
}


// struct TrashFilesView_Previews: PreviewProvider {
//     static var previews: some View {
//         TrashView(, isTrashViewVisible: <#Binding<Bool>#>)
//     }
// }



