//
//  RecordsThreeDotsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 27/05/25.
//

import SwiftUI

struct RecordsThreeDotsView: View {
    @StateObject var homeRecordsViewModel = HomeRecordsViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var isDotsVisible: Bool = false
    @State private var showingDeleteAlert = false
    @Binding var selectedTabID: Int
    @Binding var folderName: String
    @Binding var subFolderName: String
    @Binding var emailIds: Int
    @Binding var recordIDs: Int
    @Binding var fieldIDs: Int
    @Binding var azureName: String
    @Binding var FileName: String
    @Binding var createdTime: String
    @Binding var UpdatedTime: String
    @Binding var Foldersize: String
    @Binding var azureLink: String
    @Binding var filetype: String
    @Binding var formatFile: String
    @Binding var fileClicked: Bool
    @State private var Files: [FieldID] = []
    @State private var mailIDArray: [Int] = []
    @State private var recordIDArray: [Int] = []
    @State private var isMoveSheetvisible: Bool = false
    @State private var isMoreVisible: Bool = true
    @State private var DetailsViewVisible: Bool = false
    @State private var renameview: Bool = false
    @State private var selectedIndices: Set<Int> = []
    
    var body: some View {
        ZStack {
                if isMoreVisible {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            HStack {
                                Button {
                                    renameview = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isMoreVisible = false
                                    }
                                } label: {
                                    Image("edits")
                                        .renderingMode(.template)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    
                                    Text("Rename")
                                        .fontWeight(.bold)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading, 10)
                                }
                            }
                            
                            HStack {
                                Button {
                                    isMoveSheetvisible = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isMoreVisible = false
                                    }
                                } label: {
                                    Image("Recordsmoveto")
                                        .renderingMode(.template)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    
                                    Text("Move")
                                        .fontWeight(.bold)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading, 10)
                                }
                            }
                            if fileClicked{
                                HStack {
                                    Button {
                                        homeRecordsViewModel.downloadFile(selectedfieldID: fieldIDs,fileLink: azureLink)
                                        homeRecordsViewModel.fileDownloads(selectedfieldID: fieldIDs)
                                    } label: {
                                        Image("download")
                                            .renderingMode(.template)
                                            .frame(width: 35, height: 35)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        
                                        Text("Download")
                                            .fontWeight(.bold)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.leading, 10)
                                    }
                                    
                                }
                            }
                            
                            HStack {
                                Button {
                                    showingDeleteAlert = true
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isMoreVisible = false
                                    }
                                } label: {
                                    Image("delete")
                                        .renderingMode(.template)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    
                                    Text("Delete")
                                        .fontWeight(.bold)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading, 10)
                                }
                            }
                            
                            HStack {
                                Button {
                                    DetailsViewVisible = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        isMoreVisible = false
                                    }
                                } label: {
                                    Image("details")
                                        .renderingMode(.template)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    
                                    Text("Details")
                                        .fontWeight(.bold)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading, 10)
                                }
                            }
                        }
                        
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .onAppear {
                            Files = [FieldID(id: fieldIDs, azureFileName: azureName)]
                            if fieldIDs == 0 && azureName == "" {
                                Files = []
                            }
                            mailIDArray = [emailIds]
                            recordIDArray = [recordIDs]
                        }
                    }
                    .toast(message: $homeRecordsViewModel.error)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: calculateTotalHeight())
                    .background(themesviewModel.currentTheme.windowBackground)
                    .cornerRadius(16)
                    .shadow(radius: 10)
            }

            if isMoveSheetvisible {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isMoveSheetvisible = false
                                isMoreVisible = false
                            }
                        }

                    
                    VStack {
                        Spacer()
                        MoveTo(isMoveToSheetVisible: $isMoveSheetvisible, selectedThreadID: $mailIDArray, selectedIndices: $selectedIndices)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: isMoveSheetvisible)
                        
                    }
                }
            }
            
            // Delete Alert
            if showingDeleteAlert {
                ZStack {
                    Color.gray.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                showingDeleteAlert = false
                                isMoreVisible = false
                            }
                        }

                    
                    DeleteTrashAlert(isPresented: $showingDeleteAlert) {
                        homeRecordsViewModel.deleteBottom(
                            selectedTabType: folderName,
                            RecordIds: recordIDArray,
                            FieldIDs: Files,
                            EmailIDs: mailIDArray
                        )
                        isMoreVisible = false
                    }
                    .transition(.scale)
                    .animation(.easeInOut, value: showingDeleteAlert)
                }
            }
            if DetailsViewVisible {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                DetailsViewVisible = false
                                isMoreVisible = false
                            }
                        }

                    
                    VStack(alignment: .leading, spacing: 10){
                        Spacer()
                        VStack {
                            HStack {
                                Text("Details")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                Spacer()
                            }
                            Divider()
                                .frame(height: 1)
                                .background(themesviewModel.currentTheme.customEditTextColor)
                                .padding([.leading, .trailing], 16)
                            
                            HStack{
                                Text("Folder name:")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                Spacer()
                                Text(FileName)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.trailing , 16)
                                
                            }
                            HStack{
                                Text("Folder type:")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                Spacer()
                                Text(folderName)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.trailing , 16)
                                
                            }
                            
                            HStack{
                                Text("Created At:")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                Spacer()
                                let unixTimestamp = createdTime
                                    Text(convertToTimeDate(dateInput: unixTimestamp) ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.trailing , 16)

   
                            }
                            HStack{
                                Text("Updated At:")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                Spacer()
                                let unixTimestamp = UpdatedTime
                                    Text(convertToTimeDate(dateInput: unixTimestamp) ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.trailing , 16)
                                
                            }
                            HStack{
                                Text("Folder Size:")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                Spacer()
                                Text(Foldersize)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.trailing , 16)
                                
                            }
                        }
                        .background(themesviewModel.currentTheme.windowBackground)
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: DetailsViewVisible)

                }
                .zIndex(4)
            }
            
            if renameview {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                renameview = false
                                isMoreVisible = false
                            }
                        }
                    
                    VStack (alignment: .leading, spacing: 10){
                        
                        Text("Rename Folder")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16))
                            .fontWeight(.bold)
                            .padding(.leading , 16)
                        
                        floatingtextfield(text: $FileName, placeHolder: "Folder name", allowedCharacter: .defaultType)
                            .padding(.horizontal)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        HStack {
                            Spacer()
                            Button{
                                homeRecordsViewModel.rename(fileRecordName: ("\(FileName).\(formatFile)"), subfoldertype: subFolderName, selectedfieldID: fieldIDs , fileType: filetype)
                                homeRecordsViewModel.getRecordsData(selectedTabID: selectedTabID, Type: folderName, SubFoldersType: subFolderName)
                                renameview = false
                            }label: {
                                Text("Rename")
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
                    .animation(.easeInOut, value: renameview)
                }
            }
                
            
        }
        .background(
            Color.black.opacity(isMoreVisible ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isMoreVisible = false // Dismiss the sheet
                    }
                }

        )
        
    }
    
    func calculateTotalHeight() -> CGFloat {
        let totalHeight: CGFloat = 300
        let maxHeight: CGFloat = 800
        return min(totalHeight, maxHeight)
    }
}

//#Preview {
//    RecordsThreeDotsView(selectTabIDs: <#Binding<Int>#>, folderType: <#Binding<String>#>, SubFolderType: <#Binding<String>#>)
//}

