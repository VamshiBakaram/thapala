//
//  TrashView.swift
//  Thapala
//
//  Created by Ahex-Guest on 09/10/24.
//

import SwiftUI
struct TrashView: View {
    @ObservedObject var themesviewModel = themesViewModel()
     @State private var selectedTab = "Mails"
     @State private var isAllFilesMode = true
     @State private var selectedFiles: Set<Int> = []
    @ObservedObject var TrashedViewModel = TrashViewModel()
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
    @State private var selectedPlannerTab: String = "tDo"
    @State private var bottomIcons = false
    @State private var selectedID: [Int] = []  // Use @State to make it mutable
    @State private var showingDeleteAlert = false
    @State private var showingRestoreAlert = false
    @Binding var isTrashViewVisible: Bool
    @State private var isMenuVisible = false
   
    
    @Environment(\.presentationMode) var presentationMode

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
                        .font(.custom(.poppinsRegular, size: 12))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading,20)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
                
                HStack {
                    Button(action: {
                        selectedTab = "Mails"
                        //                    TrashedViewModel.GetTrashData()
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
                        selectedTab = "Files"
                        //                    TrashedViewModel.GetTrashData()
                    }) {
                        Text("Files")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 10)
                            .padding()
                            .background(selectedTab == "Files" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    Button(action: {
                        selectedTab = "Planner"
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
//                    TrashMailsView()
                }else{
                    if selectedTab == "Files"{
                        // All Files and Folders toggle buttons
                        HStack {
                            let onSelectedTab:String = "files"
                            Button(action: {
                                isAllFilesMode = true
                                TrashedViewModel.GetFileTrashData(selectedTab: onSelectedTab)
                            }) {
                                Text("All files")
                                    .fontWeight(.medium)
                                    .frame(width: 100 , height:10)
                                    .padding()
                                    .background(isAllFilesMode ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            let SelectedTab:String = "folders"
                            Button(action: {
                                isAllFilesMode = false
                                TrashedViewModel.GetFileTrashData(selectedTab: SelectedTab)
                            }) {
                                Text("Folders")
                                    .fontWeight(.medium)
                                    .frame(width: 100 , height:10)
                                    .padding()
                                    .background(!isAllFilesMode ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
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
                        
                        // Select All checkbox
                        // Main content based on the selected mode
                        if isAllFilesMode {
                            AllFilesView(selectedFiles: $selectedFiles)
                        } else {
                            FoldersView()
                        }
                    }
                    
                    if selectedTab == "Planner"{
                        HStack {
                            Button(action: {
                                selectedPlannerTab = "tDo"
                                print("selectedPlannerTab\(selectedPlannerTab)")
                                isAllFilesMode = true
                                TrashedViewModel.GetPlannerTrashData()
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
                                print("selectedPlannerTab: \(selectedPlannerTab)")
                                isAllFilesMode = false
                                TrashedViewModel.GetPlannerTrashData()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    NoteItems = TrashedViewModel.PlanData.filter { $0.type == "note" }
                                    print("Updated NoteItems: \(NoteItems)")
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
                                                print("Select all do it: \(selectedID)")  // Corrected print statement
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
                                                print("Select all Note: \(selectedID)")  // Corrected print statement
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
                            List {
                                ForEach(doitItems.indices, id: \.self) { index in
                                    HStack {
                                        Button(action: {
                                            doitItems[index].isChecked = (doitItems[index].isChecked == 0) ? 1 : 0;
                                            bottomIcons = (doitItems[index].isChecked == 1);
                                            if (doitItems[index].isChecked == 1) {
                                                selectedID = [doitItems[index].id]
                                                print("selected do it \(selectedID) ")
                                            }
                                        }) {
                                            Image(systemName: (doitItems[index].isChecked != 0) ? "checkmark.square.fill" : "square")
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .font(.system(size: 24))
                                        }
                                        VStack(alignment: .leading) {
                                            
                                            Text("Title: \(doitItems[index].title)")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.headline)
                                            Text("Created At: \(formatDateTime(Date(timeIntervalSince1970: TimeInterval(doitItems[index].createdAt) ?? 0)))")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.subheadline)
                                            Text("Deleted At: \(formatDateTime(Date(timeIntervalSince1970: TimeInterval(doitItems[index].updatedAt) ?? 0)))")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.subheadline)
                                            
                                        }
                                        .padding(.vertical, 8)
                                    }
                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                }
                            }
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)
                        }
                        if selectedPlannerTab == "tNote" {
                            List {
                                ForEach(NoteItems.indices, id: \.self) { index in
                                    HStack {
                                        Button(action: {
                                            NoteItems[index].isChecked = (NoteItems[index].isChecked == 0) ? 1 : 0;
                                            bottomIcons = (NoteItems[index].isChecked == 1);
                                            if (NoteItems[index].isChecked == 1) {
                                                selectedID = [NoteItems[index].id]
                                                print("selected Note \(selectedID) ")
                                            }
                                            
                                        }) {
                                            Image(systemName: (NoteItems[index].isChecked != 0) ? "checkmark.square.fill" : "square")
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .font(.system(size: 24))
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Title: \(NoteItems[index].title)")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.headline)
                                            Text("Created At: \(formatDateTime(Date(timeIntervalSince1970: TimeInterval(NoteItems[index].createdAt) ?? 0)))")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.subheadline)
                                            Text("Deleted At: \(formatDateTime(Date(timeIntervalSince1970: TimeInterval(NoteItems[index].updatedAt) ?? 0)))")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.subheadline)
                                            
                                        }
                                        .padding(.vertical, 8)
                                    }
                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                }
                            }
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)
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
                                .padding(.leading,20)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        
                        Button(action: {
                            showingDeleteAlert = true
                            print("delete button tapped")
                        }) {
                            Image("deleteIcon")
                                .padding(.leading, 20)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        Spacer()
                    }
                    .padding(.leading , 10)
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
                    TrashedViewModel.deleteplanner(selectedID: selectedID)
                    
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
                    
                    // Reset selection and bottom icons
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
                    TrashedViewModel.restorePlanner(selectedID: selectedID)
                    
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
                    
                    // Reset selection and bottom icons
                    selectedID.removeAll()
                    bottomIcons = false
                    selectAll = false
                    
                    // Optionally dismiss the trash view if needed
                    isTrashViewVisible = false
                }
                .transition(.scale)
                .animation(.easeInOut, value: showingRestoreAlert)
            }
        }
        .onAppear {
            TrashedViewModel.GetTrashData()
            if TrashedViewModel.PlanData.isEmpty {
                TrashedViewModel.GetPlannerTrashData()
                print("API is running")
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if selectedPlannerTab == "tDo" {
                    doitItems = TrashedViewModel.PlanData.filter { $0.type == "doit" }
                }
                print("Fetched \(selectedPlannerTab) items count: \(doitItems.count)")
                
            }

        }

        
    }
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
 }

 // Custom CheckboxToggleStyle
 struct CheckboxToggleStyle: ToggleStyle {
     func makeBody(configuration: Configuration) -> some View {
         HStack {
             Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                 .onTapGesture { configuration.isOn.toggle() }
             configuration.label
         }
     }
 }

 // View for All Files Mode
 struct AllFilesView: View {
     @Binding var selectedFiles: Set<Int>
     
     var body: some View {
         ScrollView(.horizontal) {
             HStack {

             }
             .padding()
         }
     }
 }

 // View for Folders Mode (Placeholder)
 struct FoldersView: View {
     var body: some View {
         Text("Folders content here")
             .padding()
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



