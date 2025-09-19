//
//  HomePlannerView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import SwiftUI
import ClockTimePicker
import WaterfallGrid

struct HomePlannerView: View {
    @State private var isMenuVisible = false
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject var homeConveyedViewModel = HomeConveyedViewModel()
    @StateObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var selectedOption: TabOption = .DoIt
    @State private var image : String = ""
    @State private var searchText: String = ""
    @State var index: Int?
    @State var id:Int = 0
    @State var selectedID : Int?
    @State private var selectedDate: Date = Date()
    @State private var selectedNewDate: Int = 0
    @State private var isEvent: Bool = false
    @State private var eventSelected: Int = 0
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
    @State private var dolistData: Doit?
    @State private var isCheckedLabelID: [Int] = []
    @State private var notificationTime: Int? = nil
    @State private var Dairyactivetag: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var formattedMapDates: [String] = []
    @State private var eventDatesArray: [Int] = []
    @State private var eventTitle: String = ""
    @State private var eventNote: String = ""
    @State private var eventStartDate: Int = 0
    @State private var eventEndDate: Int = 0
    @State private var eventID: [Int] = []
    @State private var eventDurationOption: String = ""
    @State private var eventUpdateId: Int?
    @State private var newTitleEvent: String = ""
    @State private var newNoteEvent: String = ""
    @State private var newEndTimeEvent: String = ""
    @State private var newEndDateEvent: String = ""
    @State private var newDurationOptionEvent: String = ""
    @State private var isUpdateEventVisible: Bool = false
    @State private var newEventID: Int? = nil
    @State private var newStartUpdatedDate: Int? = nil
    @State private var newEndUpdatedDate: Int? = nil
    @State private var startUpdatedDate: Int? = nil
    @State private var endUpdatedDate: Int? = nil
    @State private var isTagViewVisible: Bool = false
    @State private var isFilterNotification: Bool = false
    @State private var selectedType: String = ""    
    @State private var search: String = ""
    @State private var startDate: String = ""
    @State private var EndDate: String = ""
    @State private var selectState: String = ""
    @State private var searchPlannerText = ""
    @State private var reminderText: String = ""
    @State private var StartDateTimeInterval: Int = 0
    @State private var EndDateTimeInterval: Int = 0
    
    
    var filteredDoitData: [Doit] {
        homePlannerViewModel.doitlistData.filter { $0.reminder != nil }
    }

    enum TabOption {
            case DoIt, Diary, Note, Date
        }
    
    let calendar = Calendar.current
    let daysInMonth: [Date]
    
    init() {
        let today = Date()
        let range = Calendar.current.range(of: .day, in: .month, for: today)!
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: today))!
        
        daysInMonth = range.compactMap { day -> Date? in
            Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                themesviewModel.currentTheme.windowBackground
                    .ignoresSafeArea(edges: .bottom)
                
                VStack{
                    VStack {
                        HStack(spacing: 20) {
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
                            
                            Text("Planner")
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
                        .padding(.top ,15)
                        
                        
                        HStack {
                            HStack {
                                Image("search")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.allBlack.opacity(0.1))
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 12)
                                    .onTapGesture {
                                        homePlannerViewModel.addtask = true  // Set addtask to true when TextField is tapped
                                    }

                                TextField("Search", text: $searchText)  // Bind the TextField to the searchText state variable
                                    .foregroundColor(themesviewModel.currentTheme.allBlack)
                                    .font(.custom(.poppinsMedium, size: 16))  // Correct font name
                                    .padding(.leading, 13)
                                    .onTapGesture {
                                        homePlannerViewModel.addtask = true  // Set addtask to true when TextField is tapped
                                    }
                            }
                            .padding()
                            .background(themesviewModel.currentTheme.attachmentBGColor)
                           
                            .cornerRadius(25)
                            
                            
                                Button(action: {
                                    isFilterNotification.toggle()
                                 }) {
                                Image("notification1")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .padding([.leading , .trailing] , 16)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .padding(10) // Add padding to make the circle bigger than icon
                                    .background(isFilterNotification ? Color.gray : Color.clear)
                                    .clipShape(Circle())
                                }
                                
                                Button(action: {
                                    isTagViewVisible = true
                                }) {
                                    Image("tagbtn")
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .frame(width: 18, height: 18)
                                        .padding(.trailing , 20)
                                }
                            }
                            .padding(.bottom , 10)
                            .padding(.horizontal)
                        
                    }
                    .frame(height: reader.size.height * 0.17)
                    .background(themesviewModel.currentTheme.colorPrimary)
                    .padding(.top , 5)
                    
                        HStack(spacing: 5) { // Adjust spacing as needed
                            RoundedRectangle(cornerRadius: 25)
                                .fill(selectedOption == .DoIt ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                .frame(width: 80, height: 50) // Add fixed width for consistent layout
                                .onTapGesture {
                                    selectedOption = .DoIt
                                    selectedType = "doit"
                                    self.homePlannerViewModel.selectedOption = .DoIt
                                    homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                    self.homePlannerViewModel.isDoItSelected = true
                                    self.homePlannerViewModel.isDairySelected = false
                                    self.homePlannerViewModel.isNoteSelected = false
                                    self.homePlannerViewModel.isDateSelected = false
                                    self.eventDatesArray = []
                                }
                                .overlay(
                                    Text("tDo")
                                        .font(.custom(.poppinsMedium, size: 14))
                                        .foregroundColor(selectedOption == .DoIt ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.inverseTextColor)
                                )
                            
                            RoundedRectangle(cornerRadius: 25)
                                .fill(selectedOption == .Diary ?  themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                .frame(width: 80, height: 50) // Add fixed width for consistent layout
                                .onTapGesture {
                                    selectedOption = .Diary
                                    selectedType = "diary"
                                    self.homePlannerViewModel.selectedOption = .Diary
                                    homePlannerViewModel.GetDiaryDataList(query: "", type: "diary", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                    self.homePlannerViewModel.isDoItSelected = false
                                    self.homePlannerViewModel.isDairySelected = true
                                    self.homePlannerViewModel.isNoteSelected = false
                                    self.homePlannerViewModel.isDateSelected = false
                                    self.eventDatesArray = []
                                }
                                .overlay(
                                    Text("tDiary")
                                        .font(.custom(.poppinsMedium, size: 14))
                                        .foregroundColor(selectedOption == .Diary ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.inverseTextColor)
                                )
                            
                            
                            RoundedRectangle(cornerRadius: 25)
                                .fill(selectedOption == .Note ?  themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                .frame(width: 80, height: 50) // Add fixed width for consistent layout
                                .onTapGesture {
                                    selectedOption = .Note
                                    selectedType = "note"
                                    self.homePlannerViewModel.selectedOption = .Note
                                    homePlannerViewModel.GetNoteDataList(query: "", type: "note", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                    self.homePlannerViewModel.isDairySelected = false
                                    self.homePlannerViewModel.isDoItSelected = false
                                    self.homePlannerViewModel.isNoteSelected = true
                                    self.homePlannerViewModel.isDateSelected = false
                                    self.eventDatesArray = []
                                }
                                .overlay(
                                    Text("tNote")
                                        .font(.custom(.poppinsMedium, size: 14))
                                        .foregroundColor(selectedOption == .Note ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.inverseTextColor)
                                )
                            
                            RoundedRectangle(cornerRadius: 25)
                                .fill(selectedOption == .Date ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                .frame(width: 80, height: 50) // Add fixed width for consistent layout
                                .onTapGesture {
                                    print("selectedOption Date")
                                    selectedOption = .Date
                                    selectedType = "diary"
                                    self.homePlannerViewModel.selectedOption = .Date
                                    homePlannerViewModel.GetDateBookList()
                                    self.homePlannerViewModel.isDairySelected = false
                                    self.homePlannerViewModel.isDoItSelected = false
                                    self.homePlannerViewModel.isNoteSelected = false
                                    self.homePlannerViewModel.isDateSelected = true
                                }
                                .overlay(
                                    Text("tDate")
                                        .font(.custom(.poppinsMedium, size: 14))
                                        .foregroundColor(selectedOption == .Date ?themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.inverseTextColor)
                                )
                        }
                        .background(themesviewModel.currentTheme.tabBackground)
                        .cornerRadius(25)
                    
                    


                    if let selectedOption = homePlannerViewModel.selectedOption {
                        switch selectedOption {
                        case .DoIt:
                            HStack{

                            }
                        case .Diary:
                            HStack {
                                
                                if let firstItem = homePlannerViewModel.listData.first {
                                    
                                    let senderDate: TimeInterval = TimeInterval(firstItem.createdTimeStamp)
                                    let finalDate = convertToTime(timestamp: senderDate)

                                    // compare reminder date with today's date
                                    if finalDate != getCurrentDateWithDayMonthYear() {
                                        HStack {
                                            Image("addnote")
                                                .renderingMode(.template)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .padding(.leading, 18)
                                                .onTapGesture {
                                                    print("finalDate: \(finalDate)")
                                                }

                                            Text(getCurrentDateWithDayMonthYear())
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom("Poppins-Regular", size: 14, relativeTo: .subheadline))
                                                .padding(.leading, 9)

                                            Spacer()
                                        }
                                        .onTapGesture{
                                            homePlannerViewModel.diaryTask  = true
                                        }
                                    }
                                }
                            }

                            
                            
                        case .Note:
                            HStack {
                                Image("addnote")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .padding(.leading , 18)

                                
                                Text("Add Note")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsMedium, size: 16))
                                    .padding(.leading , 9)
                                    
                                
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
                        case .DoIt:
                            doItView
                        case .Diary:
                            diaryView
                        case .Note:
                            dateBookView
                        case .Date:
                            dateView
                            
                        }
                    }

                    TabViewNavigator()
                        .frame(height: 40)
                        .padding(.bottom, 30)
                }
                .onAppear {
                    image = homeNavigatorViewModel.navigatorBioData?.bio?.profile ?? "person"
                    homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                }
                
                .onChange(of: homePlannerViewModel.diaryTask) { newValue in
                    if newValue {
                        dragOffset = 0 // Reset every time it's shown
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            homePlannerViewModel.GetDiaryDataList(query: "", type: "diary", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                            dragOffset = 0
                        }
                    }
                }
                .onChange(of: homePlannerViewModel.addtask) { newValue in
                    if newValue {
                        dragOffset = 0 // Reset every time it's shown
                        search = ""; reminderText = "" ; selectState = "" ; searchPlannerText = "" ; StartDateTimeInterval = 0 ; EndDateTimeInterval = 0
                    }
                    else {
                        if selectedType == "doit" {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                homePlannerViewModel.GetDoitList(query: search, type: selectedType, page: 1, pageSize: 30, searchType: reminderText, status: selectState, labelname: searchPlannerText, startdate: StartDateTimeInterval, enddate: EndDateTimeInterval)
                            }
                        }
                        
                        else if selectedType == "diary" {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                homePlannerViewModel.GetDiaryDataList(query: search, type: selectedType, page: 1, pageSize: 30, searchType: reminderText, status: selectState, labelname: searchPlannerText, startdate: StartDateTimeInterval, enddate: EndDateTimeInterval)
                            }
                        }
                        
                        else if selectedType == "note" {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                homePlannerViewModel.GetNoteDataList(query: search, type: selectedType, page: 1, pageSize: 30, searchType: reminderText, status: selectState, labelname: searchPlannerText, startdate: StartDateTimeInterval, enddate: EndDateTimeInterval)
                            }
                        }
                    }
                }
                
                

                
                
                .navigationBarBackButtonHidden(true)

                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                
                if homePlannerViewModel.addtask {
                    ZStack {
                        Color.gray.opacity(0.1)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    homePlannerViewModel.addtask = false
                                    print("homePlannerViewModel.addtask  \(homePlannerViewModel.addtask)")
                                }
                            }
                        
                        VStack {
                            PlannerAddTaskView(isAddTaskVisible: $homePlannerViewModel.addtask, type: $selectedType, search: $search, selectState: $selectState, searchText: $searchPlannerText, reminderText: $reminderText, StartDateTimeInterval: $StartDateTimeInterval, EndDateTimeInterval: $EndDateTimeInterval)
                                .padding(.top , 80)
                            Spacer()
                        }
                    }
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
                        ListitemView(isListItemVisible: $homePlannerViewModel.selectedtodo, selectedID: selectedData.id ?? 0 , isCheckedLabelID: $isCheckedLabelID)
                    } else {
                        Text("Error: Could not find data for the selected ID")
                            .foregroundColor(.red)
                    }
                }
                if homePlannerViewModel.isPlusBtn {
                    VStack {
                        tDoView(isCreateVisible: $homePlannerViewModel.isPlusBtn)
                            .transition(.move(edge: .bottom))
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
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isEventVisible = false
                                }
                            }

                        VStack {
                            Spacer()
                            EventView(isEventVisible: $isEventVisible, clickedDate: $clickedDate, clickedTime: $clickedTime, text: $newTitleEvent ,EndDate: $newEndDateEvent, Note: $newNoteEvent, time: $newEndTimeEvent, durationOption: $newDurationOptionEvent, UpdateEventView: $isUpdateEventVisible, eventID: $newEventID, startUpdatedDate:  $newStartUpdatedDate, endUpdatedDate: $newEndUpdatedDate)
                                .offset(y: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if value.translation.height > 0 {
                                                dragOffset = value.translation.height
                                            }
                                        }
                                        .onEnded { value in
                                            let dragHeight = value.translation.height
                                            let dismissThreshold: CGFloat = 50

                                            if dragHeight > dismissThreshold {
                                                withAnimation {
                                                    isEventVisible = false
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                )
                                .onAppear {
                                    dragOffset = 0 // ← THIS fixes the “halfway open” issue
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isEventVisible)
                        }
                        
                        
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
                
                
                if isTagViewVisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isTagViewVisible = false
                                }
                            }
                        VStack {
                            Spacer() // Pushes the sheet to the bottom
                            PlannerTagView(isTagViewVisible: $isTagViewVisible)
                            
                                .offset(y: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if value.translation.height > 0 {
                                                dragOffset = value.translation.height
                                            }
                                        }
                                        .onEnded { value in
                                            let dragHeight = value.translation.height
                                            let dismissThreshold: CGFloat = 50

                                            if dragHeight > dismissThreshold {
                                                withAnimation {
                                                    isTagViewVisible = false
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                )
                                .onAppear {
                                    dragOffset = 0 // ← THIS fixes the “halfway open” issue
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isTagViewVisible)
                        }
                    }
                }
                
            }
        }
        .background(themesviewModel.currentTheme.windowBackground)
        .fullScreenCover(isPresented: $appBarElementsViewModel.isSearch) {
            SearchView(appBarElementsViewModel: appBarElementsViewModel)
                .toolbar(.hidden)
        }
        .fullScreenCover(isPresented: $appBarElementsViewModel.isSearch) {
            SearchView(appBarElementsViewModel: appBarElementsViewModel)
                .toolbar(.hidden)
        }
        .navigationDestination(isPresented: $homePlannerViewModel.isComposeEmail) {
                    }
        .toast(message: $homePlannerViewModel.error)

    }
    
    private func formatDateAndTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // Stable for fixed formats
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd-MMM-yyyy, h:mm a" // "29-Aug-2025, 10:15 AM"
        // Convert AM/PM to lowercase
        let formatted = formatter.string(from: date)
        return formatted.replacingOccurrences(of: "AM", with: "am")
                       .replacingOccurrences(of: "PM", with: "pm")
    }
    
    func getCurrentDateWithDayMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"   // "01-09-2025"
        return formatter.string(from: Date())
    }

    func formatDateToDayMonthYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }

    func isNotToday(_ timestamp: Int) -> Bool {
        var timeInterval = TimeInterval(timestamp)

        // handle milliseconds just in case
        if timestamp > 9999999999 {
            timeInterval /= 1000
        }

        let date = Date(timeIntervalSince1970: timeInterval)
        return !Calendar.current.isDate(date, equalTo: Date(), toGranularity: .day)
    }




    
    var doItView: some View {
        ZStack(alignment: .bottomTrailing) {
            if homePlannerViewModel.doitlistData.isEmpty {
                VStack {
                    Spacer()
                    
                    Text("No planner items found")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            homePlannerViewModel.isPlusBtn = true
                        }) {
                            Image("plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(10)
                                .background(themesviewModel.currentTheme.tabBackground)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 15)
                        .padding(.bottom, 15)
                    }
                }
                
                .onChange(of: homePlannerViewModel.isPlusBtn) { newValue in
                    if newValue {
                        print("on change works")
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                        }
                    }
                }
            }
            
            else if isFilterNotification {
                VStack {
                    ScrollView {
                        WaterfallGrid(filteredDoitData, id: \.id) { data in
                            ZStack {
                                if let theme = data.theme {
                                    let themeName = theme.components(separatedBy: "/").last?.replacingOccurrences(of: ".png", with: "") ?? ""
                                    
                                    if themeName.hasPrefix("#") {
                                        // Hex color case
                                        Color(hex: themeName)
                                            .frame(
                                                width: (UIScreen.main.bounds.width / 2) - 20,
                                                height: calculateThemeHeight(for: data)
                                            )
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    } else {
                                        // Image case
                                        Image(themeName)
                                            .resizable()
                                            .scaledToFill()
                                            .clipped()
                                            .frame(
                                                width: (UIScreen.main.bounds.width / 2) - 20,
                                                height: calculateThemeHeight(for: data)
                                            )
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    }
                                }
                                
                                else {
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            themesviewModel.currentTheme.colorControlNormal.opacity(0.2),
                                            themesviewModel.currentTheme.windowBackground
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .frame(
                                        width: (UIScreen.main.bounds.width / 2) - 20,
                                        height: calculateThemeHeight(for: data)
                                    )
                                    .cornerRadius(12)
                                    .shadow(
                                        color: themesviewModel.currentTheme.colorControlNormal.opacity(0.4),
                                        radius: 6,
                                        x: 0,
                                        y: 4
                                    )
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(data.title)
                                            .font(.custom(.poppinsMedium, size: 18))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        
                                        Image(data.status)
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .padding(.trailing, 5)
                                            .onTapGesture {
                                                // Toggle only for this item
                                                TaskCommentId = (TaskCommentId == data.id) ? nil : data.id
                                                isStatusVisible.toggle()
                                            }
                                    }
                                    
                                    Text(data.note)
                                        .font(.custom(.poppinsMedium, size: 16))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .lineLimit(1)
                                    
                                    if let comments = data.comments, !comments.isEmpty {
                                        ForEach(comments, id: \.commentId) { comment in
                                            ZStack(alignment: .topLeading) {
                                                HStack {
                                                    Image(comment.status)
                                                        .resizable()
                                                        .frame(width: 15, height: 15)
                                                        .onTapGesture {
                                                            selectedCommentId = comment.commentId
                                                        }
                                                    
                                                    Text(comment.comment)
                                                        .font(.custom(.poppinsRegular, size: 14))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        .lineLimit(1)
                                                    
                                                    Spacer()
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    
                                    if let reminder = data.reminder {
                                        let reminderDate = Date(timeIntervalSince1970: TimeInterval(reminder))
                                        let formattedDateTime = formatDateAndTime(reminderDate)
                                        
                                        HStack {
                                            Image("notification1")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(themesviewModel.currentTheme.allBlack)
                                            
                                            Text(formattedDateTime)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 12))
                                                .lineLimit(1)
                                        }
                                        .padding(.all , 2)
                                        .background(Color.blueAccent)
                                        .cornerRadius(10)
                                    }
                                    
                                    
                                    if let labels = data.labels, !labels.isEmpty {
                                        HStack {
                                            
                                            Text(labels.first?.labelName ?? "")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 12))
                                                .padding(.all , 2)
                                                .background(Color.blueAccent)
                                                .cornerRadius(10)
                                                .lineLimit(1)
                                            
                                            
                                            if labels.count > 1 {
                                                Text("+ \(labels.count - 1)")
                                                    .font(.custom(.poppinsRegular, size: 8))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .frame(width: 15, height: 15) // Make it a circle
                                                    .padding(.all ,1)
                                                    .background(Circle().fill(Color.clear)) // Transparent fill
                                                    .overlay(
                                                        Circle()
                                                            .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1) // White border
                                                    )
                                            }
                                            
                                        }
                                        //                                    .padding(.bottom , 10)
                                    }
                                }
                                .overlay(
                                    Group {
                                        if TaskCommentId == data.id {
                                            GeometryReader { geo in
                                                let itemWidth = UIScreen.main.bounds.width / 2 - 20
                                                let isRightColumn = geo.frame(in: .global).midX > UIScreen.main.bounds.width / 2
                                                
                                                ZStack {
                                                    VStack {
                                                        HStack {
                                                            Image("todo")
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                            Text("todo")
                                                                .font(.custom(.poppinsMedium, size: 12))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            selectedStatus = "todo"
                                                            homePlannerViewModel.changeStatus(selectedID: data.id, status: selectedStatus)
                                                            TaskCommentId = nil
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                            }
                                                        }
                                                        
                                                        HStack {
                                                            Image("inprogress")
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                            Text("inprogress")
                                                                .font(.custom(.poppinsMedium, size: 12))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            selectedStatus = "inprogress"
                                                            homePlannerViewModel.changeStatus(selectedID: data.id, status: selectedStatus)
                                                            TaskCommentId = nil
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                            }
                                                        }
                                                        
                                                        HStack {
                                                            Image("completed")
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                            Text("completed")
                                                                .font(.custom(.poppinsMedium, size: 12))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            selectedStatus = "completed"
                                                            homePlannerViewModel.changeStatus(selectedID: data.id, status: selectedStatus)
                                                            TaskCommentId = nil
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                            }
                                                        }
                                                    }
                                                    .frame(width: 120, height: 100)
                                                    .padding()
                                                    .background(themesviewModel.currentTheme.windowBackground)
                                                    .cornerRadius(10)
                                                    .shadow(radius: 10)
                                                    .position(
                                                        x: isRightColumn ? geo.size.width - 100 : 60, // shift left for right column
                                                        y: 50 // position above the icon
                                                    )
                                                }
                                                .zIndex(999)
                                            }
                                        }
                                    }
                                )
                                
                                
                                
                                
                                
                                .overlay(
                                    Group {
                                        if let comments = data.comments, !comments.isEmpty {
                                            ForEach(comments, id: \.commentId) { comment in
                                                if selectedCommentId == comment.commentId {
                                                    GeometryReader { geo in
                                                        let itemWidth = UIScreen.main.bounds.width / 2 - 20
                                                        let isRightColumn = geo.frame(in: .global).midX > UIScreen.main.bounds.width / 2
                                                        
                                                        ZStack {
                                                            VStack {
                                                                HStack {
                                                                    Image("todo")
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    Text("todo")
                                                                        .font(.custom(.poppinsMedium, size: 12))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    Spacer()
                                                                }
                                                                .onTapGesture {
                                                                    selectedStatus = "todo"
                                                                    
                                                                    homePlannerViewModel.updateComment(
                                                                        selectedId: data.id,
                                                                        commenttid: selectedCommentId!,
                                                                        comment: comment.comment,
                                                                        selectedStatus: selectedStatus
                                                                    )
                                                                    selectedCommentId = nil
                                                                    
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                        homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                                    }
                                                                }
                                                                
                                                                HStack {
                                                                    Image("inprogress")
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    Text("inprogress")
                                                                        .font(.custom(.poppinsMedium, size: 12))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    
                                                                    Spacer()
                                                                }
                                                                .onTapGesture {
                                                                    selectedStatus = "inprogress"
                                                                    homePlannerViewModel.updateComment(
                                                                        selectedId: data.id,
                                                                        commenttid: selectedCommentId!,
                                                                        comment: comment.comment,
                                                                        selectedStatus: selectedStatus
                                                                    )
                                                                    selectedCommentId = nil
                                                                    
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                        homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                                    }
                                                                }
                                                                
                                                                HStack {
                                                                    Image("completed")
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    Text("completed")
                                                                        .font(.custom(.poppinsMedium, size: 12))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    
                                                                    Spacer()
                                                                }
                                                                .onTapGesture {
                                                                    selectedStatus = "completed"
                                                                    homePlannerViewModel.updateComment(
                                                                        selectedId: data.id,
                                                                        commenttid: selectedCommentId!,
                                                                        comment: comment.comment,
                                                                        selectedStatus: selectedStatus
                                                                    )
                                                                    selectedCommentId = nil
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                        homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                                    }
                                                                }
                                                            }
                                                            .frame(width: 120, height: 100)
                                                            .padding()
                                                            .background(themesviewModel.currentTheme.windowBackground)
                                                            .cornerRadius(10)
                                                            .shadow(radius: 10)
                                                            .position(
                                                                x: isRightColumn ? geo.size.width - 100 : 60, // shift left for right column
                                                                y: 50 // position above the icon
                                                            )
                                                        }
                                                        .zIndex(999)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                )
                                
                                .padding(.bottom , 10)
                                .onAppear{
                                    
                                    print("vamshi it appears ")
                                }
                                .padding(10)
                                .frame(width: UIScreen.main.bounds.width / 2 - 25)
                                .onTapGesture {
                                    homePlannerViewModel.selectedItem = data.id ?? 0
                                    homePlannerViewModel.selectedtodo = true
                                    selectedCommentId = nil
                                    let labelIDs = data.labels?.compactMap { $0.labelId } ?? []
                                    isCheckedLabelID = labelIDs
                                }
                            }
                            
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            
                            
                        }
                        .gridStyle(
                            columnsInPortrait: 2,
                            columnsInLandscape: 3,
                            spacing: 10,
                            animation: .easeInOut(duration: 0.3)
                        )
                        .padding(.horizontal, 10)
                        .padding(.top, 30)
                        
                        
                    }
                    
                    Spacer()
                }
                .onTapGesture {
                    selectedCommentId = nil
                    TaskCommentId = nil
                }
                .onAppear{
                    print("vstack appears")
                }
                
                .onChange(of: isStatusVisible || homePlannerViewModel.selectedtodo || homePlannerViewModel.isPlusBtn) { newValue in
                    if newValue {
                        print("on change works")
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                        }
                    }
                }
                
                
                Button(action: {
                    homePlannerViewModel.isPlusBtn = true
                }) {
                    Image("plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(10)
                        .background(themesviewModel.currentTheme.tabBackground)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.trailing, 15)
                .padding(.bottom, 15)
            }
            
            
            else {
                VStack {
                    ScrollView {
                        WaterfallGrid($homePlannerViewModel.doitlistData, id: \.id) { $data in
                            ZStack {
                                if let theme = data.theme {
                                    let themeName = theme.components(separatedBy: "/").last?.replacingOccurrences(of: ".png", with: "") ?? ""
                                    
                                    if themeName.hasPrefix("#") {
                                        // Hex color case
                                        Color(hex: themeName)
                                            .frame(
                                                width: (UIScreen.main.bounds.width / 2) - 20,
                                                height: calculateThemeHeight(for: data)
                                            )
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    } else {
                                        // Image case
                                        Image(themeName)
                                            .resizable()
                                            .scaledToFill()
                                            .clipped()
                                            .frame(
                                                width: (UIScreen.main.bounds.width / 2) - 20,
                                                height: calculateThemeHeight(for: data)
                                            )
                                            .cornerRadius(12)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    }
                                }
                                
                                else {
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            themesviewModel.currentTheme.colorControlNormal.opacity(0.2),
                                            themesviewModel.currentTheme.windowBackground
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    .frame(
                                        width: (UIScreen.main.bounds.width / 2) - 20,
                                        height: calculateThemeHeight(for: data)
                                    )
                                    .cornerRadius(12)
                                    .shadow(
                                        color: themesviewModel.currentTheme.colorControlNormal.opacity(0.4),
                                        radius: 6,
                                        x: 0,
                                        y: 4
                                    )
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(data.title)
                                            .font(.custom(.poppinsMedium, size: 18))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        
                                        Image(data.status)
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .padding(.trailing, 5)
                                            .onTapGesture {
                                                // Toggle only for this item
                                                TaskCommentId = (TaskCommentId == data.id) ? nil : data.id
                                                isStatusVisible.toggle()
                                            }
                                    }
                                    
                                    Text(data.note)
                                        .font(.custom(.poppinsMedium, size: 16))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .lineLimit(1)
                                    
                                    if let comments = data.comments, !comments.isEmpty {
                                        ForEach(comments, id: \.commentId) { comment in
                                            ZStack(alignment: .topLeading) {
                                                HStack {
                                                    Image(comment.status)
                                                        .resizable()
                                                        .frame(width: 15, height: 15)
                                                        .onTapGesture {
                                                            selectedCommentId = comment.commentId
                                                        }
                                                    
                                                    Text(comment.comment)
                                                        .font(.custom(.poppinsRegular, size: 14))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        .lineLimit(1)
                                                    
                                                    Spacer()
                                                }
                                                
                                            }
                                        }
                                    }
                                    
                                    
                                    if let reminder = data.reminder {
                                        let reminderDate = Date(timeIntervalSince1970: TimeInterval(reminder))
                                        let formattedDateTime = formatDateAndTime(reminderDate)
                                        
                                        HStack {
                                            Image("notification1")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(themesviewModel.currentTheme.allBlack)
                                            
                                            Text(formattedDateTime)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 12))
                                                .lineLimit(1)
                                        }
                                        .padding(.all , 2)
                                        .background(Color.blueAccent)
                                        .cornerRadius(10)
                                    }
                                    
                                    
                                    if let labels = data.labels, !labels.isEmpty {
                                        HStack {
                                            
                                            Text(labels.first?.labelName ?? "")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 12))
                                                .padding(.all , 2)
                                                .background(Color.blueAccent)
                                                .cornerRadius(10)
                                                .lineLimit(1)
                                            
                                            
                                            if labels.count > 1 {
                                                Text("+ \(labels.count - 1)")
                                                    .font(.custom(.poppinsRegular, size: 8))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .frame(width: 15, height: 15) // Make it a circle
                                                    .padding(.all ,1)
                                                    .background(Circle().fill(Color.clear)) // Transparent fill
                                                    .overlay(
                                                        Circle()
                                                            .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1) // White border
                                                    )
                                            }
                                            
                                        }
                                        //                                    .padding(.bottom , 10)
                                    }
                                }
                                .overlay(
                                    Group {
                                        if TaskCommentId == data.id {
                                            GeometryReader { geo in
                                                let itemWidth = UIScreen.main.bounds.width / 2 - 20
                                                let isRightColumn = geo.frame(in: .global).midX > UIScreen.main.bounds.width / 2
                                                
                                                ZStack {
                                                    VStack {
                                                        HStack {
                                                            Image("todo")
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                            Text("todo")
                                                                .font(.custom(.poppinsMedium, size: 12))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            selectedStatus = "todo"
                                                            homePlannerViewModel.changeStatus(selectedID: data.id, status: selectedStatus)
                                                            TaskCommentId = nil
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                            }
                                                        }
                                                        
                                                        HStack {
                                                            Image("inprogress")
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                            Text("inprogress")
                                                                .font(.custom(.poppinsMedium, size: 12))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            selectedStatus = "inprogress"
                                                            homePlannerViewModel.changeStatus(selectedID: data.id, status: selectedStatus)
                                                            TaskCommentId = nil
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                            }
                                                        }
                                                        
                                                        HStack {
                                                            Image("completed")
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                            Text("completed")
                                                                .font(.custom(.poppinsMedium, size: 12))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            
                                                            Spacer()
                                                        }
                                                        .onTapGesture {
                                                            selectedStatus = "completed"
                                                            homePlannerViewModel.changeStatus(selectedID: data.id, status: selectedStatus)
                                                            TaskCommentId = nil
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                            }
                                                        }
                                                    }
                                                    .frame(width: 120, height: 100)
                                                    .padding()
                                                    .background(themesviewModel.currentTheme.windowBackground)
                                                    .cornerRadius(10)
                                                    .shadow(radius: 10)
                                                    .position(
                                                        x: isRightColumn ? geo.size.width - 100 : 60, // shift left for right column
                                                        y: 50 // position above the icon
                                                    )
                                                }
                                                .zIndex(999)
                                            }
                                        }
                                    }
                                )
                                
                                
                                
                                
                                
                                .overlay(
                                    Group {
                                        if let comments = data.comments, !comments.isEmpty {
                                            ForEach(comments, id: \.commentId) { comment in
                                                if selectedCommentId == comment.commentId {
                                                    GeometryReader { geo in
                                                        let itemWidth = UIScreen.main.bounds.width / 2 - 20
                                                        let isRightColumn = geo.frame(in: .global).midX > UIScreen.main.bounds.width / 2
                                                        
                                                        ZStack {
                                                            VStack {
                                                                HStack {
                                                                    Image("todo")
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    Text("todo")
                                                                        .font(.custom(.poppinsMedium, size: 12))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    Spacer()
                                                                }
                                                                .onTapGesture {
                                                                    selectedStatus = "todo"
                                                                    
                                                                    homePlannerViewModel.updateComment(
                                                                        selectedId: data.id,
                                                                        commenttid: selectedCommentId!,
                                                                        comment: comment.comment,
                                                                        selectedStatus: selectedStatus
                                                                    )
                                                                    selectedCommentId = nil
                                                                    
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                        homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                                    }
                                                                }
                                                                
                                                                HStack {
                                                                    Image("inprogress")
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    Text("inprogress")
                                                                        .font(.custom(.poppinsMedium, size: 12))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    
                                                                    Spacer()
                                                                }
                                                                .onTapGesture {
                                                                    selectedStatus = "inprogress"
                                                                    homePlannerViewModel.updateComment(
                                                                        selectedId: data.id,
                                                                        commenttid: selectedCommentId!,
                                                                        comment: comment.comment,
                                                                        selectedStatus: selectedStatus
                                                                    )
                                                                    selectedCommentId = nil
                                                                    
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                        homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                                    }
                                                                }
                                                                
                                                                HStack {
                                                                    Image("completed")
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    Text("completed")
                                                                        .font(.custom(.poppinsMedium, size: 12))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    
                                                                    Spacer()
                                                                }
                                                                .onTapGesture {
                                                                    selectedStatus = "completed"
                                                                    homePlannerViewModel.updateComment(
                                                                        selectedId: data.id,
                                                                        commenttid: selectedCommentId!,
                                                                        comment: comment.comment,
                                                                        selectedStatus: selectedStatus
                                                                    )
                                                                    selectedCommentId = nil
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                                                        homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                                                                    }
                                                                }
                                                            }
                                                            .frame(width: 120, height: 100)
                                                            .padding()
                                                            .background(themesviewModel.currentTheme.windowBackground)
                                                            .cornerRadius(10)
                                                            .shadow(radius: 10)
                                                            .position(
                                                                x: isRightColumn ? geo.size.width - 100 : 60, // shift left for right column
                                                                y: 50 // position above the icon
                                                            )
                                                        }
                                                        .zIndex(999)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                )
                                
                                .padding(.bottom , 10)
                                .onAppear{
                                    
                                    print("vamshi it appears ")
                                }
                                .padding(10)
                                .frame(width: UIScreen.main.bounds.width / 2 - 25)
                                .onTapGesture {
                                    homePlannerViewModel.selectedItem = data.id ?? 0
                                    homePlannerViewModel.selectedtodo = true
                                    selectedCommentId = nil
                                    let labelIDs = data.labels?.compactMap { $0.labelId } ?? []
                                    isCheckedLabelID = labelIDs
                                }
                            }
                            
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                            
                            
                        }
                        .gridStyle(
                            columnsInPortrait: 2,
                            columnsInLandscape: 3,
                            spacing: 10,
                            animation: .easeInOut(duration: 0.3)
                        )
                        .padding(.horizontal, 10)
                        .padding(.top, 30)
                        
                        
                    }
                    
                    Spacer()
                }
                .onTapGesture {
                    selectedCommentId = nil
                    TaskCommentId = nil
                }
                .onAppear{
                    print("vstack appears")
                }
                
                .onChange(of: isStatusVisible || homePlannerViewModel.selectedtodo || homePlannerViewModel.isPlusBtn) { newValue in
                    if newValue {
                        print("on change works")
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                        }
                    }
                }
                
                
                Button(action: {
                    homePlannerViewModel.isPlusBtn = true
                }) {
                    Image("plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(10)
                        .background(themesviewModel.currentTheme.tabBackground)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.trailing, 15)
                .padding(.bottom, 15)
                
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
                        if finalDate == getCurrentDateWithDayMonthYear() {
                            Image("addnote")
                                .renderingMode(.template)
                                .frame(width: 15, height: 15)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                               
                        }
                        
                        Spacer()
                            .frame(width: 1)
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
                                    .font(.custom(.poppinsMedium, size: 14))
                                    .padding(.leading, 20)
                                    .lineLimit(1)
                                    .truncationMode(.tail)  // Optional: Adds ellipsis for overflowing text
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(finalDate)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsMedium, size: 14))
                                    .padding(.trailing, 20)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            Text(data.note)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsMedium, size: 14))
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
            .onChange(of: homePlannerViewModel.noteUpdate || homePlannerViewModel.noteTask) { newValue in
                if newValue {
                    print("on change works")
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        homePlannerViewModel.GetNoteDataList(query: "", type: "note", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
    }
    
    var dateView:some View{
        ZStack(alignment: .bottomTrailing) {
            VStack {
                // Custom Calendar View
                CustomCalendarView(
                    selectedDate: $selectedDate,
                    eventDates: $formattedMapDates,
                    eventDatesArray: $eventDatesArray,
                    isEvent: $isEvent,
                    eventSelected: $eventSelected,
                    themeViewModel: themesviewModel,
                    onDateSelected: { newDate in
                        selectedDate = newDate
                        clickedDate = formatDate(newDate)
                        clickedTime = formatTime(newDate)
                    }
                )
                .padding()
                
                Spacer()
//                let selectedPrefix = String(eventSelected).prefix(5)
                if isEvent {
                    let calendar = Calendar.current
                    let selectedDay = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(eventSelected)))

                    let matchedItems = homePlannerViewModel.dateBookListData.filter { item in
                        if let start = item.startDateTime {
                            let eventDay = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(start)))
                            return eventDay == selectedDay
                        }
                        return false
                    }


                    ForEach(matchedItems, id: \.id) { matchedItem in
                        HStack {
                            Divider()
                                .frame(width: 5)
                                .frame(height: 30)
                                .padding(.leading , 5)
                                .background(Color.blue)
                            
                            Spacer()
                            VStack {
                                HStack {
                                    Text(matchedItem.title)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsSemiBold, size: 18))
                                        .onTapGesture {
                                            homePlannerViewModel.eventInfo = true
                                            eventTitle = matchedItem.title
                                            eventNote = matchedItem.note
                                            eventStartDate = matchedItem.startDateTime ?? 0
                                            eventEndDate = matchedItem.endDateTime ?? 0
                                            eventID.append(matchedItem.id)
                                            eventDurationOption = matchedItem.repeat
                                            eventUpdateId = matchedItem.id
                                            startUpdatedDate = matchedItem.startDateTime ?? 0
                                            endUpdatedDate = matchedItem.endDateTime ?? 0
                                        }
                                    
                                    Spacer()
                                }
                                
                                Divider()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 2)
                                    .padding(.horizontal , 16)
                                    .background(themesviewModel.currentTheme.strokeColor.opacity(0.5))
                            }
                        }
                    }
                }

                
                
                Spacer()
                
            }
            .padding()
            .onAppear {
                print("onAppear")
                homePlannerViewModel.eventInfo = false
                isUpdateEventVisible = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let finalDates = homePlannerViewModel.dateBookListData.compactMap { item -> Date? in
                        if let startDateTime = item.startDateTime, startDateTime > 0 { // Filter out 0 values
                            let senderDate = TimeInterval(startDateTime)
                            print("senderDate  \(senderDate)")
                            eventDatesArray.append(Int(senderDate))
                            return convertToDateTime(timestamp: senderDate)
                        }
                        return nil
                    }
                    //                    .sorted()
                    
                    formattedMapDates = finalDates.map { formatDate($0) }
                    print("formattedMapDates finalDates: \(formattedMapDates)")
                    print("event dates \(eventDatesArray)")
                }
            }
            
            
            .onChange(of: homePlannerViewModel.eventInfo) { newValue in
                if newValue {
                    print("newvalue")
                }
                
                else {
                    print("it working")
                    homePlannerViewModel.GetDateBookList()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let finalDates = homePlannerViewModel.dateBookListData.compactMap { item -> Date? in
                            if let startDateTime = item.startDateTime, startDateTime > 0 { // Filter out 0 values
                                let senderDate = TimeInterval(startDateTime)
                                print("senderDate  \(senderDate)")
                                eventDatesArray.append(Int(senderDate))
                                return convertToDateTime(timestamp: senderDate)
                            }
                            return nil
                        }
                        //                    .sorted()
                        
                        formattedMapDates = finalDates.map { formatDate($0) }
                        print("formattedMapDates finalDates: \(formattedMapDates)")
                        print("event dates \(eventDatesArray)")
                    }

                    
                }
                
            }
            
            .onChange(of: isEventVisible) { newValue in
                if newValue {
                    print("newvalue")
                }
                
                else {
                    print("it working")
                    homePlannerViewModel.GetDateBookList()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let finalDates = homePlannerViewModel.dateBookListData.compactMap { item -> Date? in
                            if let startDateTime = item.startDateTime, startDateTime > 0 { // Filter out 0 values
                                let senderDate = TimeInterval(startDateTime)
                                print("senderDate  \(senderDate)")
                                eventDatesArray.append(Int(senderDate))
                                return convertToDateTime(timestamp: senderDate)
                            }
                            return nil
                        }
                        //                    .sorted()
                        
                        formattedMapDates = finalDates.map { formatDate($0) }
                        print("formattedMapDates finalDates: \(formattedMapDates)")
                        print("event dates \(eventDatesArray)")
                    }

                    
                }
                
            }
            
            
            HStack {
                Spacer()
                Button(action: {
                    isEventVisible.toggle()
                }) {
                    Image("plus")
                        .resizable()
                        .frame(width: 30, height: 30) // size of the plus icon
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .padding(15) // padding inside the circle
                }
                .background(Color.purple.opacity(0.1))
                .clipShape(Circle()) // makes it circular
                .shadow(radius: 5) // optional: adds a soft shadow
                .padding(.trailing, 15)
                .padding(.bottom, 50)
            }
            
            if homePlannerViewModel.eventInfo {
                ZStack {
                    Color.gray?.opacity(0.1)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            homePlannerViewModel.eventInfo = false
                            print(" ZStack homePlannerViewModel.eventInfo  \(homePlannerViewModel.eventInfo)")
                        }

                    // Centered DeleteNoteAlert
                    eventInfoView(eventTitle: $eventTitle, eventNote: $eventNote, eventStartDate: $eventStartDate, eventEndDate: $eventEndDate, isEventInfoView: $homePlannerViewModel.eventInfo, eventID: $eventID, eventDurationOption: $eventDurationOption, eventUpdateId: $eventUpdateId, startUpdatedDate: $startUpdatedDate , endUpdatedDate: $endUpdatedDate)
                  }
                    .transition(.scale)
                }
        }

    }

    func convertToDateTime(timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
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
    
    func calculateThemeHeight(for item: Doit) -> CGFloat {
        let baseHeight: CGFloat = 100
        let rowHeight: CGFloat = 30 // or dynamic if text wraps
        let spacing: CGFloat = 2
        let reminderTimeHeight: CGFloat = 20
        
        let commentCount = item.comments?.count ?? 0
        
        if item.reminder != nil {
            let listHeight = CGFloat(commentCount ) * (rowHeight + spacing) + (reminderTimeHeight)
            let totalHeight = baseHeight + listHeight
            let maxHeight = UIScreen.main.bounds.height * 0.65

            return min(totalHeight, maxHeight)
        }
        else {
            let listHeight = CGFloat(commentCount) * (rowHeight + spacing)
            let totalHeight = baseHeight + listHeight
            let maxHeight = UIScreen.main.bounds.height * 0.65

            return min(totalHeight, maxHeight)
        }


    }
}



struct EventView: View {
    @StateObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @Binding var isEventVisible: Bool
    @Binding var clickedDate: String
    @Binding var clickedTime: String
    @State private var isEditing = false
    @Binding var text: String
    @Binding var EndDate: String
    @Binding var Note: String
    @Binding var time: String
    @Binding var durationOption: String
    @Binding var UpdateEventView: Bool
    @Binding var eventID: Int?
    @Binding var startUpdatedDate: Int?
    @Binding var endUpdatedDate: Int?
    @State private var repeatOption: String = "norepeat"
    @State private var isDatePickerVisible = false
    @State private var isEndDatePickerVisible = false
    @State private var isTimePickerVisible = false
    @State private var isEndTimePickerVisible = false
    @State private var selectedDate = Date()
    @State private var selectedEndDate = Date()
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
                    .font(.custom(.poppinsMedium, size: 14))
                    .foregroundColor(themesviewModel.currentTheme.allBlack)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.leading, 16)
                Button(action: {
                    withAnimation {
                        isEventVisible = false
                        if UpdateEventView {
                            homePlannerViewModel.updateEvent(selectedID: eventID ?? 0, endTime: Int(homePlannerViewModel.selectedEndDateTime?.timeIntervalSince1970 ?? 0), Note: Note, Repeat: durationOption, startTime: Int(homePlannerViewModel.selectedDateTime?.timeIntervalSince1970 ?? 0), Title: text)
                        }
                        else {
                            homePlannerViewModel.AddEvent(endDateTime: Int(homePlannerViewModel.selectedEndDateTime?.timeIntervalSince1970 ?? 0), note: Note, repeat: repeatOption, startDateTime: Int(homePlannerViewModel.selectedDateTime?.timeIntervalSince1970 ?? 0), title: text)
                            text = ""
                            Note = ""
                            repeatOption = ""
                            EndDate = ""
                            time = ""
                        }

                    }
                }) {
                    Text("Done")
                        .font(.custom(.poppinsMedium, size: 14))
                        .foregroundColor(Color(red: 69 / 255, green: 86 / 255, blue: 225 / 255))
                }
                .padding(.top, 20)
                .padding(.trailing, 16)
            }
            
                EventfloatingTextField(placeHolder: "Title", text: $text)
                    .padding(.horizontal , 10)
            
            
            
            HStack {
                EventfloatingTextField(
                    placeHolder: clickedDate.isEmpty ? getCurrentDateDayMonthYear() : "Start Date", text: $clickedDate)
                    .onTapGesture {
                        isDatePickerVisible = true
                    }
                
                Spacer()
                    .frame(width: 10)
                // Time TextField
                
                EventfloatingTextField(placeHolder: clickedTime.isEmpty ? formatTime(Date()) : "Time", text: $clickedTime)

                    .onTapGesture {
                        isTimePickerVisible = true
                        print("formatTime(Date())    \(formatTime(Date()))")
                    }
            }
            .padding(.horizontal,10)
                
                HStack {
                    
                    EventfloatingTextField(placeHolder: "End Date", text: $EndDate)
                        .onTapGesture {
                            isEndDatePickerVisible = true
                        }
                    
                    
                    Spacer()
                        .frame(width: 10)

                    
                    EventfloatingTextField(placeHolder: "Time", text: $time)
                        .onTapGesture {
                            isEndTimePickerVisible = true
                            print("formatTime(Date())    \(formatTime(Date()))")
                        }
                }
                .padding(.horizontal,10)
            
            
            Menu {
                Button("Daily") {repeatOption = "everyday"; durationOption = repeatOption}
                Button("Weekly") { repeatOption = "everyweek" ; durationOption = repeatOption}
                Button("Monthly") { repeatOption = "everymonth" ; durationOption = repeatOption}
                Button("Yearly") { repeatOption = "everyyear" ; durationOption = repeatOption}
                Button("No repeat") { repeatOption = "norepeat" ; durationOption = repeatOption}
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
            
            EventfloatingTextField(placeHolder: "Note", text: $Note)
                .padding(.horizontal , 10)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: calculateHeight())
            .background(Color(red: 231 / 255, green: 228 / 255, blue: 234 / 255))
            .cornerRadius(16)
            .shadow(radius: 10)
            .onAppear{
                if UpdateEventView {
                    repeatOption = durationOption
                    
                    if let startUpdatedDate = startUpdatedDate {
                        homePlannerViewModel.selectedDateTime = Date(timeIntervalSince1970: TimeInterval(startUpdatedDate))
                    }
                    
                    if let endUpdatedDate = endUpdatedDate {
                        homePlannerViewModel.selectedEndDateTime = Date(timeIntervalSince1970: TimeInterval(endUpdatedDate))
                    }

                }
                else {
                    homePlannerViewModel.selectedDateTime = getCurrentDateWithDayMonthYear()
                }
            }
            .onChange(of: isEventVisible) { newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        print("if condition")
                        homePlannerViewModel.GetDateBookList()
                    }
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        print("else condition")
                        homePlannerViewModel.GetDateBookList()
                    }
                }
            }
        
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
                                // Convert selectedDate to string and assign to clickedDate
                                homePlannerViewModel.selectedDateTime = selectedDate
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd-MMM-yyyy"
                                clickedDate = formatter.string(from: selectedDate)
                                isDatePickerVisible = false
                            }
                        )
                        .offset(y: -220)
                    }
                    
                    else if isEndDatePickerVisible {
                        DialogView(
                            title: "Select a Date",
                            content: {
                                DatePicker("", selection: $selectedEndDate, displayedComponents: .date)
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                            },
                            onCancel: {
                                isEndDatePickerVisible = false
                            },
                            onConfirm: {
                                // Convert selectedDate to string and assign to clickedDate
                                homePlannerViewModel.selectedEndDateTime = selectedEndDate
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd-MMM-yyyy"
                                EndDate = formatter.string(from: selectedEndDate)
                                isEndDatePickerVisible = false
                                      print("EndDate  \(EndDate)")
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
                                homePlannerViewModel.selectedDateTime = selectedDate
                                clickedTime = formatTime(selectedDate)
                                isTimePickerVisible = false
                            }
                        )
                        .offset(y: -120)
                    }
                    
                    else if isEndTimePickerVisible {
                        DialogView(
                            title: "Select a Time",
                            content: {
                                ClockPickerView(date: $selectedEndDate)
                                    .frame(width: 250, height: 250)
                            },
                            onCancel: {
                                isEndTimePickerVisible = false
                            },
                            onConfirm: {
                                homePlannerViewModel.selectedEndDateTime = selectedEndDate
                                time = formatTime(selectedEndDate)
                                isEndTimePickerVisible = false
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
    
    func getCurrentDateDayMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter.string(from: Date())
    }

    
    func getCurrentDateWithDayMonthYear() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm"
        let dateString = formatter.string(from: Date())
        return formatter.date(from: dateString)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date).lowercased()
    }
}
    
    

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    @Binding var eventDates: [String]
    @Binding var eventDatesArray: [Int]
    @Binding var isEvent: Bool
    @Binding var eventSelected: Int
    let themeViewModel: ThemesViewModel // Adjust type as needed
    let onDateSelected: (Date) -> Void
    
    @State private var currentMonth = Date()
    
    private let calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: "UTC")!
        return cal
    }()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.timeZone = TimeZone(abbreviation: "UTC") // Set to UTC
        return formatter
    }()

    
    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Month/Year header with navigation
            HStack {
                Button(action: { changeMonth(-1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(themeViewModel.currentTheme.allBlack)
                }
                
                Spacer()
                
                Text(monthYearFormatter.string(from: currentMonth))
                    .font(.custom(.poppinsSemiBold, size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(themeViewModel.currentTheme.allBlack)
                
                Spacer()
                
                Button(action: { changeMonth(1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(themeViewModel.currentTheme.allBlack)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            
            // Days of week header
            HStack {
                ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeViewModel.currentTheme.textColor.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
            
            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    DayView(
                        formatedSelectedDates: $eventDates,
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        hasEvent: hasEvent(for: date),
                        isInCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        themeViewModel: themeViewModel,
                        onTap: {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                            formatter.timeZone = TimeZone(identifier: "Asia/Kolkata") // IST
                            
                            let istDateString = formatter.string(from: date)
                            selectedDate = date
                            onDateSelected(date)
                            print("customize calender selectedDate  \(selectedDate)")
                            
                            let calendar = Calendar.current

                            // Normalize eventDates to just year/month/day
                            let eventDatesSet: Set<Date> = Set(eventDatesArray.compactMap { timestamp in
                                let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                                return calendar.startOfDay(for: date)
                            })

                            // Normalize selectedDate to start of day
                            let selectedDay = calendar.startOfDay(for: selectedDate)

                            // Check if the selected date has an event
                            if eventDatesSet.contains(selectedDay) {
                                print("This day has an event!")
                                isEvent = true
                            }
                            let senderDate = Int(selectedDate.timeIntervalSince1970)
                            print("senderDate  \(senderDate)")
                            eventSelected = senderDate
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
        .background(themeViewModel.currentTheme.attachmentBGColor)
        .cornerRadius(12)
        .onAppear {
            currentMonth = selectedDate
        }
    }
    
    private func changeMonth(_ direction: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: direction, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func getDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let firstOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start else {
            return []
        }
        
        let firstDayWeekday = calendar.component(.weekday, from: firstOfMonth)
        let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        
        var days: [Date] = []
        
        // Add previous month's trailing days
        for i in 1..<firstDayWeekday {
            if let date = calendar.date(byAdding: .day, value: -i, to: firstOfMonth) {
                days.insert(date, at: 0)
            }
        }
        
        // Add current month's days
        for day in 0..<numberOfDaysInMonth {
            if let date = calendar.date(byAdding: .day, value: day, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        // Add next month's leading days to fill the grid
        let remainingDays = 42 - days.count // 6 weeks * 7 days
        for day in 0..<remainingDays {
            if let lastDay = days.last,
               let date = calendar.date(byAdding: .day, value: day + 1, to: lastDay) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func hasEvent(for date: Date) -> Bool {
        let dateString = formatDate(date)
        return eventDates.contains(dateString)
    }
    
    private func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

// Individual Day View
struct DayView: View {
    @Binding var formatedSelectedDates: [String]
    let date: Date
    let isSelected: Bool
    let hasEvent: Bool
    let isInCurrentMonth: Bool
    let themeViewModel: ThemesViewModel
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 2) {
            Button(action: onTap) {
                VStack(spacing: 2) {
                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(textColor)
                        .frame(width: 32, height: 32)
                        .background(backgroundColor)
                        .clipShape(Circle())
                    
                    // Green dot for events
                    Circle()
                        .fill(hasEvent ? Color.green : Color.clear)
                        .frame(width: 6, height: 6)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .opacity(isInCurrentMonth ? 1.0 : 0.3)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.green
        } else {
            return Color.clear
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return Color.black
        } else {
            return themeViewModel.currentTheme.allBlack
        }
    }
}

    

struct eventInfoView: View {
    @StateObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @Binding var eventTitle: String
    @Binding var eventNote: String
    @Binding var eventStartDate: Int
    @Binding var eventEndDate: Int
    @Binding var isEventInfoView: Bool
    @Binding var eventID: [Int]
    @Binding var eventDurationOption: String
    @Binding var eventUpdateId: Int?
    @Binding var startUpdatedDate: Int?
    @Binding var endUpdatedDate: Int?
    @State private var startsDate: String = ""
    @State private var startsTime:  String = ""
    @State private var endsDate:  String = ""
    @State private var endsTime: String = ""
    @State private var showingDeleteAlert = false
    @State private var isEventVisible: Bool = false
    @State private var isUpdateEventVisible: Bool = false
    @State private var dragOffset: CGFloat = 0
    var body: some View {
        
            VStack(alignment: .leading, spacing: 15){
                HStack {
                    Spacer()
                    Text("Details")
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .font(.custom(.poppinsMedium, size: 15))
                    
                    Spacer()
                    
                    Button(action: {
                        self.isEventInfoView = false
                        print("isEventInfoView  \(isEventInfoView)")
                    }) {
                        Image("cross")
                            .resizable()
                            .frame(width: 20 , height: 20)
                    }
                    
                }
                Text("Title")
                    .foregroundColor(themesviewModel.currentTheme.allBlack)
                    .font(.custom(.poppinsMedium, size: 15))
                
                Text(eventTitle)
                    .foregroundColor(themesviewModel.currentTheme.allBlack.opacity(0.5))
                    .font(.custom(.poppinsMedium, size: 15))
                
                Text("Note")
                    .foregroundColor(themesviewModel.currentTheme.allBlack)
                    .font(.custom(.poppinsMedium, size: 15))
                
                Text(eventNote)
                    .foregroundColor(themesviewModel.currentTheme.allBlack.opacity(0.5))
                    .font(.custom(.poppinsMedium, size: 15))
                
                HStack {
                    VStack(alignment: .leading, spacing: 15){
                        Text("Start Date")
                            .foregroundColor(themesviewModel.currentTheme.allBlack)
                            .font(.custom(.poppinsMedium, size: 15))
                        
                        Text(startsDate)
                            .foregroundColor(themesviewModel.currentTheme.allBlack.opacity(0.5))
                            .font(.custom(.poppinsMedium, size: 15))
                        
                        Text("Start Time")
                            .foregroundColor(themesviewModel.currentTheme.allBlack)
                            .font(.custom(.poppinsMedium, size: 14))
                        
                        Text(startsTime)
                            .foregroundColor(themesviewModel.currentTheme.allBlack.opacity(0.5))
                            .font(.custom(.poppinsMedium, size: 15))
                    }

                    VStack(alignment: .leading, spacing: 15) {
                        Text("End Date")
                            .foregroundColor(themesviewModel.currentTheme.allBlack)
                            .font(.custom(.poppinsMedium, size: 15))
                        
                        Text(endsDate)
                            .foregroundColor(themesviewModel.currentTheme.allBlack.opacity(0.5))
                            .font(.custom(.poppinsMedium, size: 15))
                        
                        Text("End Time")
                            .foregroundColor(themesviewModel.currentTheme.allBlack)
                            .font(.custom(.poppinsMedium, size: 15))
                        
                        Text(endsTime)
                            .foregroundColor(themesviewModel.currentTheme.allBlack.opacity(0.5))
                            .font(.custom(.poppinsMedium, size: 15))
                    }
                    .padding(.leading , 16)
                }
                                
                
                HStack {
                    Spacer()
                    
                    
                    Text("Delete")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .padding()
                        .frame(width: 80, height: 40)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.trailing, 5)
                        .onTapGesture{
                            showingDeleteAlert = true
                        }
                    
                    Text("Edit")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width: 80, height: 40)
                        .background(Color.black)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.trailing, 16)
                        .onTapGesture{
                            isEventVisible = true
                            isUpdateEventVisible = true
                        }
                    
                }
            }
            .padding(16)
            .background(Color.white)               // Background comes first
            .cornerRadius(10)                      // Then corner radius
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Then shadow
            .padding(.horizontal, 40)
        
        .onAppear{
            print("eventDurationOption  \(eventDurationOption)")
            print("on Appear \(isEventInfoView)")
            print("eventStartDate  \(eventStartDate)")
            print("eventEndDate  \(eventEndDate)")
            let (startDate, startTime) = formatDateAndTime(from: eventStartDate)
            let (endDate, endTime) = formatDateAndTime(from: eventEndDate)
            print("eventStartDate  \(startDate), \(startTime)") // 02 Sep 2025, 12:32 PM
            print("eventEndDate    \(endDate), \(endTime)")
            startsDate = startDate
            startsTime = startTime
            endsDate = endDate
            endsTime = endTime
        }
        
        if showingDeleteAlert {
            ZStack {
                Color.gray.opacity(0.5) // Dimmed background
                    .ignoresSafeArea()
                    .transition(.opacity)

                // Centered DeleteNoteAlert
                DeleteEventAlert(isPresented: $showingDeleteAlert) {
                    homePlannerViewModel.deleteEvent(selectedID: eventID)
                    self.isEventInfoView = false
                }
                .transition(.scale)
            }
        }
        
        if isEventVisible {
            ZStack {
                // Tappable background
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isEventVisible = false
                        }
                    }

                VStack {
                    Spacer()
                    EventView(isEventVisible: $isEventVisible, clickedDate: $startsDate, clickedTime: $startsTime, text: $eventTitle ,EndDate: $endsTime ,Note: $eventNote , time: $endsDate, durationOption: $eventDurationOption, UpdateEventView: $isUpdateEventVisible, eventID: $eventUpdateId, startUpdatedDate: $startUpdatedDate, endUpdatedDate: $endUpdatedDate)
//                        self.isEventInfoView = false
                        .offset(y: dragOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.height > 0 {
                                        dragOffset = value.translation.height
                                    }
                                }
                                .onEnded { value in
                                    let dragHeight = value.translation.height
                                    let dismissThreshold: CGFloat = 50

                                    if dragHeight > dismissThreshold {
                                        withAnimation {
                                            isEventVisible = false
                                        }
                                    } else {
                                        withAnimation {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                        .onAppear {
                            dragOffset = 0 // ← THIS fixes the “halfway open” issue
                        }
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isEventVisible)
                }
                
                
            }
        }
        

    }

    
    func formatDateAndTime(from timestamp: Int?) -> (date: String, time: String) {
        guard let timestamp = timestamp else { return ("Invalid date", "") }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Separate formats
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let dateString = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "hh:mm a"
        let timeString = dateFormatter.string(from: date).lowercased()
        
        return (dateString, timeString)
    }


    
}



struct DeleteEventAlert: View {
    @StateObject var themesviewModel = ThemesViewModel()
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
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Message
                Text("Are you sure you want to delete this note ?")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
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
            .background(themesviewModel.currentTheme.windowBackground)
            .cornerRadius(16)
            .padding(.horizontal, 16)
        }
    }
}



struct PlannerTagView: View {
    @StateObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @Binding var isTagViewVisible: Bool
    @State var comment: String = ""
//    var selectedID: Int
    @State private var searchText: String = ""
    @State private var isCreateLabelVisible: Bool = false // Tracks visibility of createLabelView
    @State private var Textfill: String = ""
    @State private var isChecked: Bool = false
//    @Binding var isclicked: Bool
    @State var selectedLabelDoitID: [Int] = []
    @State var id:Int = 0
    @State private var deleteBoolean: Bool = false
    var body: some View {
        ZStack {
            // Main BottomTagSheetView content
            if !isCreateLabelVisible {
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundColor(themesviewModel.currentTheme.strokeColor)
                            .padding(.horizontal, 16)
                            .padding(.top , 30)

                        // Search Field
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .frame(width: 24, height: 24)
                                .padding(.leading, 12)
                            
                            TextField("", text: $searchText, prompt: Text("Filter label").foregroundColor(themesviewModel.currentTheme.textColor))
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom("Poppins-Regular", size: 12))
                                .padding(.leading, 13)
                            
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal, 20)

                        // Create Label Button
                        HStack {
                            Image("plusmark")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .frame(width: 24, height: 24)
                                .padding(.leading, 25)
                                .onTapGesture {
                                    isCreateLabelVisible = true
                                }
                        
                            Button(action: {
                                withAnimation {
                                    isCreateLabelVisible = true
                                }
                            }, label: {
                                Text("Create Label")
                                    .foregroundColor(themesviewModel.currentTheme.colorAccent)
                                    .fontWeight(.bold)
                            })
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 10)

                        // Scrollable list with filtered data
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                let filteredIndices = homePlannerViewModel.tagLabelDoItData.indices.filter { index in
                                    searchText.isEmpty ||
                                    homePlannerViewModel.tagLabelDoItData[index].labelName.lowercased().contains(searchText.lowercased())
                                }

                                ForEach(filteredIndices, id: \.self) { index in
                                    HStack {
                                        if homePlannerViewModel.tagLabelDoItData[index].isEditing {
                                            TextField("Enter label", text: $homePlannerViewModel.tagLabelDoItData[index].labelName)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .background(themesviewModel.currentTheme.windowBackground)
                                                .font(.custom(.poppinsRegular, size: 16))
                                                .onSubmit {
                                                    homePlannerViewModel.tagLabelDoItData[index].isEditing = false
                                                    homePlannerViewModel.editPlannerTagLabel(
                                                        selectedID: homePlannerViewModel.tagLabelDoItData[index].id,
                                                        labelName: homePlannerViewModel.tagLabelDoItData[index].labelName
                                                    )
                                                }
                                        } else {
                                            Text(homePlannerViewModel.tagLabelDoItData[index].labelName)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 16))
                                        }

                                        Spacer()

                                        Button(action: {
                                            homePlannerViewModel.tagLabelDoItData[index].isEditing = true
                                        }) {
                                            Image("edits")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        }
                                        .padding(.trailing, 10)

                                        Button(action: {
                                            homePlannerViewModel.DeleteTagResponse(selectedIDs: homePlannerViewModel.tagLabelDoItData[index].id)
                                            print("delete clicked")
                                            deleteBoolean = true
                                        }) {
                                            Image("del")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        }
                                        .padding(.trailing, 30)
                                    }
                                    .padding(.top, 10)
                                    .padding(.leading, 20)
                                }

                            }
                            .padding(.leading , 20)
                        }
                    }
                    .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: calculateHeight())
                .background(themesviewModel.currentTheme.windowBackground)
                .cornerRadius(16)
                .shadow(radius: 10)
                .toast(message: $homePlannerViewModel.error)
                .onAppear{
                    homePlannerViewModel.GetTagDoitLabelList()
                    homePlannerViewModel.GetDoitList(query: "", type: "doit", page: 1, pageSize: 30, searchType: "", status: "", labelname: "", startdate: 0, enddate: 0)
                }
                .onChange(of: deleteBoolean) {newValue in
                    if newValue {
                        print("if works")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            homePlannerViewModel.GetTagDoitLabelList()
                            deleteBoolean = false
                        }
                    }
                }
            }

            if isCreateLabelVisible {
                createTagView(iscreatelabelvisible: $isCreateLabelVisible, Textfill: $Textfill)
                    .transition(.move(edge: .bottom)) // Smooth transition
                    .animation(.easeInOut)
            }
        }
        .background(
            Color.black.opacity(isCreateLabelVisible ? 0.4 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isTagViewVisible = false // Dismiss the sheet
                    }
                }
        )
    }
        
    func calculateHeight() -> CGFloat {
        let filteredCount = homePlannerViewModel.tagLabelDoItData.filter { label in
            searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
        }.count

        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44 // Estimated height for each row in the list
        let maxHeight: CGFloat = 800 // Maximum height for the entire view

        // Use filteredCount if searchText is not empty, otherwise use total count
        let count = searchText.isEmpty ? homePlannerViewModel.tagLabelDoItData.count : filteredCount
        let totalHeight = baseHeight + (CGFloat(count) * rowHeight)

        return min(totalHeight, maxHeight) // Ensure it doesn't exceed maxHeight
    }
}


    


#Preview {
    HomePlannerView()
}
