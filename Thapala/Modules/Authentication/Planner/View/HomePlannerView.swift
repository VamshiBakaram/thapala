//
//  HomePlannerView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import SwiftUI
import ClockTimePicker
struct HomePlannerView: View {
    @State private var isMenuVisible = false
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject var homeConveyedViewModel = HomeConveyedViewModel()
    @StateObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var selectedOption: TabOption = .doit
    @State private var image : String = ""
    @State private var searchText: String = ""
    @State var index: Int?
    @State var id:Int = 0
    @State var selectedID : Int?
    @State private var selectedDate: Date = Date()
    @State private var futureDate: Date = Date()
    @State private var formattedDate: String = ""
    @State private var selectedCommentId: Int?
    @State private var TaskCommentId: Int?
    @State private var selectedStatus: String = ""
    @State private var isEventVisible: Bool = false
    @State private var title: String = ""
    @State private var isStatusVisible: Bool = false
    @State var themeArray: [String] = []
    @State private var selectedNames: [String] = []
    @State private var clickedDate: String = "" // Store the formatted date
    @State private var clickedTime: String = ""
    @State private var iNotificationAppBarView = false
    enum TabOption {
            case doit, diary, Note, date
        }
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                VStack{
                    VStack {
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: image)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                case .failure:
                                    Image("person")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(.leading, 20) // Padding for consistent spacing
                            
                            
                            Text("Planner")
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            Spacer()
                            
                            Button(action: {
                            }) {
                                Image("magnifyingglass")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            Button(action: {
                                iNotificationAppBarView = true
                            }) {
                                Image("notification")
                                    .resizable()
                                    .frame(width: 20, height: 22)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                            }
                            .padding(.trailing, 15)
                            
                            
                            Button(action: {
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .font(Font.title.weight(.medium))
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .frame(width: 18, height: 18)
                            }
                            .padding(.trailing, 15)
                           
                        }
                        .padding(.top , -reader.size.height * 0.01)
                        HStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(themesviewModel.currentTheme.allGray)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 12)
                                    .onTapGesture {
                                        homePlannerViewModel.addtask = true  // Set addtask to true when TextField is tapped
                                    }

                                TextField("Search", text: $searchText)  // Bind the TextField to the searchText state variable
                                    .foregroundColor(themesviewModel.currentTheme.allGray)
                                    .font(.custom("Poppins-Regular", size: 12))  // Correct font name
                                    .padding(.leading, 13)
                                    .onTapGesture {
                                        homePlannerViewModel.addtask = true  // Set addtask to true when TextField is tapped
                                    }
                            }
                            .padding()
                            .background(themesviewModel.currentTheme.attachmentBGColor)
                            .cornerRadius(10)
                                        Button(action: {
                                                    }) {
                                        Image("notification1")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .padding(.trailing , 16)
                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        }
                                        
                                        Button(action: {}) {
                                            Image("tagbtn")
                                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                .frame(width: 18, height: 18)
                                                .padding(.trailing , 20)
                                        }
                                    }
                                    .padding(.horizontal)
                    }
                    .frame(height: reader.size.height * 0.16)
                    .background(themesviewModel.currentTheme.tabBackground)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack {
                            // Background
                            Rectangle()
                                .fill(themesviewModel.currentTheme.tabBackground)
                                .frame(height: 60) // Set desired height for the background
                                .cornerRadius(20)

                            HStack(spacing: 10) {
                                Button("tDo") {
                                    selectedOption = .doit
                                    self.homePlannerViewModel.selectedOption = .doit
                                    homePlannerViewModel.GetDoitList()
                                    self.homePlannerViewModel.isDoItSelected = true
                                    self.homePlannerViewModel.isDairySelected = false
                                    self.homePlannerViewModel.isNoteSelected = false
                                    self.homePlannerViewModel.isDateSelected = false
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding([.leading, .trailing], 20)
                                .frame(height: 60) // Adjust button height
                                .background(selectedOption == .doit ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .cornerRadius(20)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                Button("tDiary") {
                                    selectedOption = .diary
                                    self.homePlannerViewModel.selectedOption = .diary
                                    homePlannerViewModel.GetDiaryDataList()
                                    self.homePlannerViewModel.isDoItSelected = false
                                    self.homePlannerViewModel.isDairySelected = true
                                    self.homePlannerViewModel.isNoteSelected = false
                                    self.homePlannerViewModel.isDateSelected = false
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding([.leading, .trailing], 20)
                                .frame(height: 60) // Adjust button height
                                .background(selectedOption == .diary ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .cornerRadius(20)
                                .foregroundColor(themesviewModel.currentTheme.textColor)

                                Button("tNote") {
                                    selectedOption = .Note
                                    self.homePlannerViewModel.selectedOption = .Note
                                    homePlannerViewModel.GetNoteDataList()
                                    self.homePlannerViewModel.isDairySelected = false
                                    self.homePlannerViewModel.isDoItSelected = false
                                    self.homePlannerViewModel.isNoteSelected = true
                                    self.homePlannerViewModel.isDateSelected = false
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding([.leading, .trailing], 20)
                                .frame(height: 60) // Adjust button height
                                .background(selectedOption == .Note ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .cornerRadius(20)
                                .foregroundColor(themesviewModel.currentTheme.textColor)

                                Button("tDate") {
                                    selectedOption = .date
                                    self.homePlannerViewModel.selectedOption = .Date
                                    homePlannerViewModel.GetDateBookList()
                                    self.homePlannerViewModel.isDairySelected = false
                                    self.homePlannerViewModel.isDoItSelected = false
                                    self.homePlannerViewModel.isNoteSelected = false
                                    self.homePlannerViewModel.isDateSelected = true
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding([.leading, .trailing], 20)
                                .frame(height: 60) // Adjust button height
                                .background(selectedOption == .date ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .cornerRadius(20)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            }
                        }
                        .padding(.leading, 30)
                    }


                    if let selectedOption = homePlannerViewModel.selectedOption {
                        switch selectedOption {
                        case .doit:
                            HStack{

                            }
                        case .diary:
                            if var diary = homePlannerViewModel.listData.first{
                                if diary.reminder != Int(getCurrentDateWithMonthYear()) {
                                    HStack {
                                        Image("addnote")
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .padding(.leading , 18)
                                        Text(getCurrentDateWithMonthYear()) // Display both date and month-year
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom("Poppins-Regular", size: 14, relativeTo: .subheadline))
                                            .padding(.leading , 9)
                                        Spacer()
                                        
                                    }
                                    .padding(.top , 10)
                                    .onTapGesture {
                                        homePlannerViewModel.diaryTask = true  // Set addtask to true when TextField is tapped
                                    }
                                }
                            }
                            else {
                               
                            }

                        case .Note:
                            HStack {
                                Image("addnote")
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .padding(.leading , 18)

                                
                                Text("Add Note")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 9)
                                    .font(.custom("Poppins-Regular", size: 14, relativeTo: .subheadline)) // Make sure the font name is correct
                                
                                Spacer()
                                            
                            }
                            .padding(.top , 10)
                            .onTapGesture {
                                homePlannerViewModel.noteTask = true  // Set addtask to true when TextField is tapped
                            }
                        case .Date:
                            HStack{

                            }
                        }
                    }
                    
                    if let selectedOption = homePlannerViewModel.selectedOption {
                        switch selectedOption {
                        case .doit:
                            doItView
                        case .diary:
                            diaryView
                        case .Note:
                            dateBookView
                        case .Date:
                            dateView
                            
                        }
                    }

                    TabViewNavigator()
                        .frame(height: 40)
                        .padding(.bottom, 10)
                }
                .onAppear {
                    image = homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"
                    homePlannerViewModel.GetDoitList()
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 300 / 1000.0) {
                        themeArray = homePlannerViewModel.doitlistData.compactMap { $0.theme }
                        
                        if !themeArray.isEmpty {
                            // Extract themes from doitlistData
                            let themes = homePlannerViewModel.doitlistData.compactMap { $0.theme }
                            
                            // Process each theme in the array
                            themeArray = themes.compactMap { theme in
                                theme.components(separatedBy: "/").last?.replacingOccurrences(of: ".png", with: "")
                            }
                            
                            for (index, theme) in themeArray.enumerated() {
                                print("Theme Image \(index + 1): \(theme)")
                            }
                        } else {
                            themeArray = [] // Default value if themeArray is empty
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)

                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                if homePlannerViewModel.addtask {
                    Color.black
                     .opacity(0.4)
                     .edgesIgnoringSafeArea(.all)
                     PlannerAddTaskView(isAddTaskVisible: $homePlannerViewModel.addtask)
                     .padding(.bottom,330 )
                }
                if homePlannerViewModel.diaryTask {
                    Color.black
                     .opacity(0.4)
                     .edgesIgnoringSafeArea(.all)
                    DiaryView(isDiaryVisible: $homePlannerViewModel.diaryTask, DiarynotificationTime: $homePlannerViewModel.diaryNotificationNotetime, isDiaryTagActive: $homePlannerViewModel.isDiaryTagActive, selectedNames: selectedNames)
                     .transition(.opacity)
                }
                if homePlannerViewModel.noteTask {
                    Color.black
                     .opacity(0.4)
                     .edgesIgnoringSafeArea(.all)
                    NoteView(isNoteVisible: $homePlannerViewModel.noteTask, notificationTime: $homePlannerViewModel.notificationNotetime, isTagActive: $homePlannerViewModel.isTagActive)
                     .transition(.opacity)
                }
                if homePlannerViewModel.diaryUpdate {
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)

                    if let selectedData = homePlannerViewModel.listData.first(where: { $0.id == homePlannerViewModel.selectedID }) {
                        DiaryUpdateView(isDiaryupdateVisible: $homePlannerViewModel.diaryUpdate, DiarynotificationTime: $homePlannerViewModel.diaryNotificationNotetime, selectedID: selectedData.id ?? 0, selectedNames: $selectedNames)
                    } else {
                        Text("Error: Could not find data for the selected ID")
                            .foregroundColor(.red)
                    }
                }
                
                if homePlannerViewModel.noteUpdate {
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                    if let selectedData = homePlannerViewModel.noteListData.first(where: { $0.id == homePlannerViewModel.selectedID }) {
                        NoteUpdateView(isNoteupdateVisible: $homePlannerViewModel.noteUpdate, notificationTime: $homePlannerViewModel.notificationNotetime, selectedID: selectedData.id ?? 0)
                    } else {
                        Text("Error: Could not find data for the selected ID")
                            .foregroundColor(.red)
                    }
                }
                if homePlannerViewModel.selectedtodo {
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)

                    if let selectedData = homePlannerViewModel.doitlistData.first(where: { $0.id == homePlannerViewModel.selectedItem }) {
                        ListitemView(isListItemVisible: $homePlannerViewModel.selectedtodo, selectedID: selectedData.id ?? 0)
                    } else {
                        Text("Error: Could not find data for the selected ID")
                            .foregroundColor(.red)
                    }
                }


                
                if homePlannerViewModel.addNote {
                                Color.black
                                    .opacity(0.4)
                                    .edgesIgnoringSafeArea(.all)
                                PlannerAddTaskView(isAddTaskVisible: $homePlannerViewModel.addNote)
                                    .transition(.opacity)
                }
                if homePlannerViewModel.isPlusBtn {
                    VStack {
                        tDoView(isCreateVisible: $homePlannerViewModel.isPlusBtn)
                            .transition(.move(edge: .bottom)) // Smooth transition
                            .animation(.easeInOut)
                    }
                    .background(
                        themesviewModel.currentTheme.windowBackground
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                    isEventVisible = false // Dismiss the sheet
                                
                            }
                    )
                }
                if isEventVisible {
                    VStack {
                        Spacer() // Pushes the sheet to the bottom
    //                    EventView(isEventVisible: $isEventVisible,text: $title)
                        EventView(isEventVisible: $isEventVisible, clickedDate: $clickedDate, clickedTime: $clickedTime, text: $title)
                            .transition(.move(edge: .bottom)) // Smooth transition
                            .animation(.easeInOut)
                    }
                    .background(
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                    isEventVisible = false // Dismiss the sheet
                                
                            }
                    )
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
        }
        .background(themesviewModel.currentTheme.windowBackground)
        .fullScreenCover(isPresented: $appBarElementsViewModel.isSearch) {
            SearchView(appBarElementsViewModel: appBarElementsViewModel)
                .toolbar(.hidden)
        }
        .navigationDestination(isPresented: $homePlannerViewModel.isComposeEmail) {
                    }
        .toast(message: $homePlannerViewModel.error)

    }
    func getCurrentDateWithMonthYear() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // "21 November, 2024"
            return dateFormatter.string(from: Date())
        }
    
    var doItView: some View {
        ZStack(alignment: .top) {
            VStack {

                ScrollView {

                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                    
                    
                    LazyVGrid(columns: columns, spacing: 10) { // Row spacing


                        
                        ForEach($homePlannerViewModel.doitlistData, id: \.id) { $data in
                            ZStack {
                                if !themeArray.isEmpty {
                                    ForEach(themeArray.indices, id: \.self) { index in
                                        ZStack {
                                            Image(themeArray[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 200)
                                                .clipped()
                                        }
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    }
                                }

                                    else {
                                    Color.white
                                        .frame(height: 200) // Ensure consistency with grid cell height
                                        .cornerRadius(12)
                                }

                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text(data.title)
                                        .font(.headline)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .fontWeight(.bold)
                                    
                                    Image(data.status)
                                        .resizable()
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20, alignment: .leading)
                                        .padding(.trailing , 1)
                                        .onTapGesture {
                                            // Set the selected comment's id
                                            TaskCommentId = data.id
                                            isStatusVisible.toggle()
                                        }
                                }
                                
                                Text(data.note)
                                    .font(.headline)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                
                                if let comments = data.comments, !comments.isEmpty {
                                    ForEach(comments, id: \.commentId) { comment in
                                        ZStack(alignment: .topLeading) { // Use ZStack to layer views on top of each other
                                            HStack {
                                                Image(comment.status)
                                                    .resizable()
                                                    .frame(width: 20, height: 20, alignment: .leading)
                                                    .onTapGesture {
                                                        // Set the selected comment's id
                                                        selectedCommentId = comment.commentId
                                                    }
                                                
                                                Text(comment.comment)
                                                    .font(.subheadline)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                            }
                                            
                                            // Overlay for selected comment
                                            if selectedCommentId == comment.commentId {
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Image("todo")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                        Text("todo")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                    }
                                                    .onTapGesture {
                                                        selectedStatus = "todo"
                                                        homePlannerViewModel.updateComment(selectedId: data.id, commenttid: selectedCommentId!, comment: comment.comment, selectedStatus: selectedStatus)
                                                        selectedCommentId = nil
                                                    }
                                                    
                                                    HStack {
                                                        Image("inprogress")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                        Text("inprogress")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                    }
                                                    .onTapGesture {
                                                        selectedStatus = "inprogress"
                                                        homePlannerViewModel.updateComment(selectedId: data.id, commenttid: selectedCommentId!, comment: comment.comment, selectedStatus: selectedStatus)
                                                        selectedCommentId = nil
                                                    }
                                                    
                                                    HStack {
                                                        Image("completed")
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                        Text("completed")
                                                            .font(.subheadline)
                                                            .foregroundColor(.secondary)
                                                    }
                                                    .onTapGesture {
                                                        selectedStatus = "completed"
                                                        homePlannerViewModel.updateComment(selectedId: data.id, commenttid: selectedCommentId!, comment: comment.comment, selectedStatus: selectedStatus)
                                                        selectedCommentId = nil
                                                    }
                                                }
                                                .frame(width: 120, height: 100) // Overlay size
                                                .padding()
                                                .cornerRadius(10)
                                                .shadow(radius: 10)
                                                .zIndex(2) // Ensure overlay is above all other views
                                            }
                                        }
                                    }
                                }
                                
                            }
                            .padding(10)
                            .frame(width: UIScreen.main.bounds.width / 2 - 25)
                            .cornerRadius(12)
                            .onTapGesture {
                                homePlannerViewModel.selectedItem = data.id ?? 0
                                homePlannerViewModel.selectedtodo = true
                                selectedCommentId = nil
                            }
                            }
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        }
                    }
                    .padding(.horizontal, 10) // Adjust padding for alignment
                    .padding(.top, 10) // Optional padding at the top
                }
                
                Spacer() // Pushes content to the bottom
                HStack {
                    Spacer() // Pushes the button to the right
                    Button(action: {
                        homePlannerViewModel.isPlusBtn = true
                    }) {
                        Image("plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24) // Size of the image itself
                            .padding(8) // Optional: add padding inside the button
                            .background(themesviewModel.currentTheme.tabBackground)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .clipShape(Circle())
                    }
                    .frame(width: 40, height: 40) // Total button frame
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                }
                
            }
            .onTapGesture {
                selectedCommentId = nil
                TaskCommentId = nil
            }
            
            // Overlay appears above the LazyVGrid
            if isStatusVisible, let taskCommentId = TaskCommentId, let selectedItem = homePlannerViewModel.doitlistData.first(where: { $0.id == taskCommentId }) {
                VStack {
                    HStack {
                        Image("todo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("todo")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        selectedStatus = "todo"
                        homePlannerViewModel.changeStatus(selectedID: taskCommentId, status: selectedStatus)
                        TaskCommentId = nil
                    }
                    
                    HStack {
                        Image("inprogress")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("inprogress")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        selectedStatus = "inprogress"
                        homePlannerViewModel.changeStatus(selectedID: taskCommentId, status: selectedStatus)
                        TaskCommentId = nil
                    }
                    
                    HStack {
                        Image("completed")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("completed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        selectedStatus = "completed"
                        homePlannerViewModel.changeStatus(selectedID: taskCommentId, status: selectedStatus)
                        TaskCommentId = nil
                    }
                }
                .frame(width: 120, height: 100) // Overlay size
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .zIndex(2) // Ensure overlay is above all other views
            }
        }
    }



    var diaryView:some View{
        
        VStack{
            if homePlannerViewModel.listData.count == 0 {
                VStack {
                    Text("No Data found")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsRegular, size: 16))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(themesviewModel.currentTheme.windowBackground)
            }
            else {
                List ($homePlannerViewModel.listData, id: \.id) {  $data in
                    HStack{
                        let senderDate: TimeInterval = TimeInterval(data.createdTimeStamp)
                        let finalDate = convertToTime(timestamp: senderDate)
                        if homePlannerViewModel.listData.firstIndex(where: { $0.id == data.id }) == 0 {
                            VStack(alignment: .leading){
                                Text(finalDate)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                    .lineLimit(1)
                                
                                Text(data.title)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                            }
                            .padding(.leading , 16)
                        }
                        else {
                            VStack(alignment: .leading) {
                                Text(finalDate)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                    .lineLimit(1)
                                
                                Text(data.title)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                            }
                            .padding(.leading , 16)
                                                        
                        }
                        Spacer()
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        homePlannerViewModel.selectedID = data.id ?? 0
                        homePlannerViewModel.diaryUpdate = true
                    }
                    
                    .tint(Color(red: 1.0, green: 0.5, blue: 0.5))
                }
             }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
    
    var dateBookView:some View{
        
        VStack{
            if homePlannerViewModel.noteListData.count == 0 {
                VStack {
                    Text("No Data found")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsRegular, size: 16))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(themesviewModel.currentTheme.windowBackground)
            }
            else {
                List ($homePlannerViewModel.noteListData, id: \.id) {  $data in
                    HStack{
                        let senderDate: TimeInterval = TimeInterval(data.createdTimeStamp) ?? 0
                        let finalDate = convertTime(timestamp: senderDate)
                        VStack {
                            HStack {
                                Text(data.title)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                    .padding(.leading, 20)
                                    .lineLimit(1)
                                    .truncationMode(.tail)  // Optional: Adds ellipsis for overflowing text
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(finalDate)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title2))
                                    .padding(.trailing, 20)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            Text(data.note)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title2))
                                .padding(.leading, 20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Spacer()
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        homePlannerViewModel.selectedID = data.id ?? 0
                        homePlannerViewModel.noteUpdate = true
                    }
                    
                    .tint(Color(red: 1.0, green: 0.5, blue: 0.5))
                }
            }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
    }
    
    var dateView:some View{
        VStack {
             DatePicker(
                 "Select a Date:",
                 selection: $selectedDate,
                 displayedComponents: [.date]
             )
             .datePickerStyle(GraphicalDatePickerStyle())
             .padding()
             .foregroundColor(themesviewModel.currentTheme.textColor)
             .background(themesviewModel.currentTheme.attachmentBGColor)
             .onChange(of: selectedDate) { newDate in
                 isEventVisible = true
                 clickedDate = formatDate(newDate) // Format the date
                 clickedTime = formatTime(newDate) // Format the time
             }
             
             Spacer()
            Spacer() // Pushes content to the bottom
            HStack {
                Spacer() // Pushes the button to the right
                Button(action: {
                    isEventVisible.toggle()
                }) {
                    Image("plus")
                        .font(Font.title.weight(.medium))
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                }
                .padding(.trailing, 15)
                .padding(.bottom, 15) // Add padding from the bottom
            }
            
            
        }
        .padding()
    }

    func convertToTime(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Custom date format
        return dateFormatter.string(from: date)
    }
    func convertTime(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy" // Custom date format
        return dateFormatter.string(from: date)
    }
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" // Format for the date (e.g., 13 Jan 2025)
        formatter.timeZone = TimeZone.current // Use the user's local time zone
        return formatter.string(from: date)
    }

    // Function to format the time
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // Format for the time (e.g., 03:36 PM)
        formatter.timeZone = TimeZone.current // Use the user's local time zone
        return formatter.string(from: date)
    }

    

    
    }







struct EventView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @Binding var isEventVisible: Bool
    @Binding var clickedDate: String
    @Binding var clickedTime: String
    @State private var title: String = ""
    @State private var Note: String = ""
    @State private var time: String = ""
    @State private var isEditing = false
    @Binding var text: String
    @State private var repeatOption: String = "No repeat"
    @State private var isDatePickerVisible = false
    @State private var isTimePickerVisible = false
    @State private var selectedDate = Date()
    @State private var isFocused: Bool = false
    @State private var istitleFocused: Bool = false
    @State private var isEndDateFocused:Bool = false
    @State private var isEndTimeFocused:Bool = false
//    @State private var username: String = ""
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Add Event")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.leading, 16)
                Button(action: {
                    withAnimation {
                        isEventVisible = false
                        homePlannerViewModel.AddEvent(endDateTime: Int(title) ?? 0, note: Note, repeat: repeatOption, startDateTime: Int(clickedDate) ?? 0, title: text)
                       
                    }
                }) {
                    Text("Done")
                        .foregroundColor(Color(red: 69 / 255, green: 86 / 255, blue: 225 / 255))
                }
                .padding(.top, 20)
                .padding(.trailing, 16)
            }
            

            
            VStack {
                ZStack(alignment: .leading) {
                    // Border
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(height: 50)

                    // TextField
                    TextField("", text: $text, onEditingChanged: { focused in
                        withAnimation {
                            istitleFocused = focused || !Note.isEmpty
                        }
                    })
                    .padding(.leading, 10)

                    // Label
                    Text("Title")
                        .foregroundColor(.gray)
                        .font(istitleFocused ? .caption : .body) // Smaller font when focused
                        .background(Color(red: 231 / 255, green: 228 / 255, blue: 234 / 255))
                        .padding(.leading, istitleFocused ? 5 : 10) // Adjust horizontal padding
                        .padding(.bottom, istitleFocused ? 45 : 10) // Move label above or inside the field
                        .scaleEffect(istitleFocused ? 1.0 : 1.2, anchor: .leading) // Scale label for effect
                }
                .padding(.horizontal)
            }


            HStack {
                TextField("Start Date", text: $clickedDate)
                    .foregroundColor(.black)
                    .font(.custom("Poppins-Regular", size: 16))
                    .padding()
                    .background(Color.clear)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.leading, 10)
                
                Spacer()
                    .frame(width: 10)
                // Time TextField
                TextField("Time", text: $clickedTime)
                    .foregroundColor(.black)
                    .font(.custom("Poppins-Regular", size: 16))
                    .padding()
                    .background(Color.clear)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding(.trailing, 10)
            }
            .padding(.horizontal,10)
                
                HStack {
                    VStack {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(height: 55)
                                .onTapGesture {
                                    isDatePickerVisible = true
                                }
                            
                            TextField("", text: $title, onEditingChanged: { focused in
                                withAnimation {
                                    isEndDateFocused = focused || !Note.isEmpty
                                }
                            })
                            .padding(.leading, 10)

                            
                            Text("End Date")
                                .foregroundColor(.gray)
                                .font(isEndDateFocused ? .caption : .body) // Smaller font when focused
                                .background(Color(red: 231 / 255, green: 228 / 255, blue: 234 / 255))
                                .padding(.leading, isEndDateFocused ? 5 : 10) // Adjust horizontal padding
                                .padding(.bottom, isEndDateFocused ? 45 : 10) // Move label above or inside the field
                                .scaleEffect(isEndDateFocused ? 1.0 : 1.2, anchor: .leading) // Scale label for effect
                      
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(width: 10)
                    // Time TextField

                    VStack {
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(height: 55)
                                .onTapGesture {
                                    isTimePickerVisible = true
                                }
                            
                            TextField("", text: $time, onEditingChanged: { focused in
                                withAnimation {
                                    isEndTimeFocused = focused || !Note.isEmpty
                                }
                            })
                            .padding(.leading, 10)
                            
                            Text("Time")
                                .foregroundColor(.gray)
                                .font(isEndTimeFocused ? .caption : .body) // Smaller font when focused
                                .background(Color(red: 231 / 255, green: 228 / 255, blue: 234 / 255))
                                .padding(.leading, isEndTimeFocused ? 5 : 10) // Adjust horizontal padding
                                .padding(.bottom, isEndTimeFocused ? 45 : 10) // Move label above or inside the field
                                .scaleEffect(isEndTimeFocused ? 1.0 : 1.2, anchor: .leading) // Scale label for effect

                        }
                        .padding(.horizontal)
                    }
                    
                    
                }
            Menu {
                Button("Daily") { repeatOption = "everyday" }
                Button("Weekly") { repeatOption = "everyweek" }
                Button("Monthly") { repeatOption = "everymonth" }
                Button("Yearly") { repeatOption = "everyyear" }
                Button("No repeat") { repeatOption = "norepeat" }
            } label: {
                HStack {
                    Text(repeatOption)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .foregroundColor(.black)
                .font(.custom("Poppins-Regular", size: 16))
                .padding()
                .background(Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.horizontal, 16)
            }
            VStack {
                ZStack(alignment: .leading) {
                    // Border
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(height: 55)

                    // TextField
                    TextField("", text: $Note, onEditingChanged: { focused in
                        withAnimation {
                            isFocused = focused || !Note.isEmpty
                        }
                    })
                    .padding(.leading, 10)

                    // Label
                    Text("Note")
                        .foregroundColor(.gray)
                        .font(isFocused ? .caption : .body) // Smaller font when focused
                        .background(Color(red: 231 / 255, green: 228 / 255, blue: 234 / 255))
                        .padding(.leading, isFocused ? 5 : 10) // Adjust horizontal padding
                        .padding(.bottom, isFocused ? 45 : 10) // Move label above or inside the field
                        .scaleEffect(isFocused ? 1.0 : 1.2, anchor: .leading) // Scale label for effect
                }
                .padding(.horizontal)
            }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: calculateHeight())
            .background(Color(red: 231 / 255, green: 228 / 255, blue: 234 / 255))
            .cornerRadius(16)
            .shadow(radius: 10)
            .overlay(
                Group {
                    if isDatePickerVisible {
                        DialogView(
                            title: "Select a Date",
                            content: {
                                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                            },
                            onCancel: {
                                isDatePickerVisible = false
                            },
                            onConfirm: {
                                isDatePickerVisible = false
                            }
                        )
                        .offset(y: -220)
                    }
                }
            )
        
            .overlay(
                Group {
                    if isTimePickerVisible {
                        DialogView(
                            title: "Select a Time",
                            content: {
                                ClockPickerView(date: $selectedDate)
                                    .frame(width: 250, height: 250)
                            },
                            onCancel: {
                                isTimePickerVisible = false
                            },
                            onConfirm: {
                                isTimePickerVisible = false
                                homePlannerViewModel.selectedDateTime = selectedDate
                            }
                        )
                        .offset(y: -120)
                    }
                }
            )
        }
        
        // Dynamically calculate the height of the view
        func calculateHeight() -> CGFloat {
            let baseHeight: CGFloat = 500 // Base height for fixed elements
            let maxHeight: CGFloat = 800 // Maximum height for the entire view
            return min(baseHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
        }
    }
    
    

    

    


#Preview {
    HomePlannerView()
}
