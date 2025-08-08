//
//  NoteView.swift
//  Thapala
//
//  Created by Ahex-Guest on 26/11/24.
//

import SwiftUI
import ClockTimePicker

struct NoteView: View {
    @Binding var isNoteVisible: Bool
    @Binding var notificationTime: Int?
    @Binding var isTagActive: Bool
    @ObservedObject private var plannerAddTaskViewModel = PlannerAddTaskViewModel()
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var selectedID : Int?
    @State var id:Int = 0
    @State private var isNotificationVisible: Bool = false
    @State private var isTagSheetVisible: Bool = false
    @State private var isclicked: Bool = false
    @State private var selectedTag: [Int] = []
    @State private var isScreenActive: Bool = false
    @State private var isViewActive: Bool = false
    @State private var isBackgroundSheetVisible: Bool = false
    @State private var BackgroundThemeimage: String?
    @State private var onTapTheme: Bool = false
    @State private var isPostBoxMailViewActive: Bool = false
    @State var themeImage: String = ""
    
    var body: some View {
        ZStack {
            if onTapTheme {
                Image(BackgroundThemeimage!)
                    .resizable()
                    .ignoresSafeArea()
            }
            else {
                Color.white
                    .ignoresSafeArea()
            }
            
            VStack {
                HStack {
                    Button(action: {
                        self.isNoteVisible = false
                        if let reminderTime = notificationTime {
                            homePlannerViewModel.AddNewNote(title: title,notes: note,reminder: reminderTime)
                        }
                        if isTagActive {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                homePlannerViewModel.ApplyTag(listId: id, tagIds: selectedTag)
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            homePlannerViewModel.ScheduledonclickDone(selectedID: id, reminder: notificationTime)
                            }
                    }, label: {
                        Image("wrongmark")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    .padding(.leading, 16) // Add spacing of 16 from the leading edge
                    .padding(.top, 16) // Add spacing of 16 from the top edge
                    Spacer() // Push the button to the top-left
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure HStack stretches across the screen, aligning left
                
                
                
                ZStack(alignment: .leading) {
                    if title.isEmpty {
                        Text("What's new")
                            .foregroundColor(themesviewModel.currentTheme.textColor) // your custom placeholder color
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                    }

                    TextField("", text: $title)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(8)
                        .padding(.top, 15)
                        .padding(.horizontal, 16)
                        .foregroundColor(themesviewModel.currentTheme.textColor) // actual text color
                }
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                    .padding(.horizontal, 16) // Horizontal padding for the Rectangle

                ZStack(alignment: .leading) {
                    if note.isEmpty {
                        Text("Write about it")
                            .foregroundColor(themesviewModel.currentTheme.textColor) // your custom placeholder color
                            .padding(.horizontal, 20)
                            .padding(.top, 15)
                    }

                    TextField("", text: $note)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(8)
                        .padding(.top, 15)
                        .padding(.horizontal, 16)
                        .foregroundColor(themesviewModel.currentTheme.textColor) // actual text color
                }

                
                Spacer() // Push content upwards
                
                // Align the tags image at the bottom
                HStack {
                    Button(action: {
                        isNotificationVisible.toggle()

                    }, label: {
                        Image("plannerbell")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                    
                    
                    Button(action: {
                        isBackgroundSheetVisible.toggle()
                    }, label: {
                        Image("backgroundimage")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                    
                    Button(action: {
                        isTagSheetVisible.toggle()

                    }, label: {
                        Image("Tags")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                    Spacer()
                }
                .padding(.top, 20)
                .background(Color.gray)
            }
            .background(themesviewModel.currentTheme.windowBackground)
            
            .onAppear {
                isScreenActive = true
                isViewActive = true
                
                if homePlannerViewModel.noteListData.isEmpty {
                    homePlannerViewModel.GetNoteDataList()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let note = homePlannerViewModel.noteListData.first {
                        let incrementedId = note.id // `id` is a non-optional Int
                        id = incrementedId + 1
                    }
                }
            }

            if isNotificationVisible {
                ZStack {
                    // Tappable background
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isNotificationVisible = false
                            }
                        }

                    VStack {
                        Spacer()
                        BottomNotificationView(isNotificationVisible: $isNotificationVisible, notificationTime: $notificationTime, isViewActive: $isViewActive, ispostBoxMailViewActive: $isPostBoxMailViewActive, selectedID: selectedID ?? 0)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isNotificationVisible)
                    }
                }
            }
            
            if isTagSheetVisible {
                ZStack {
                    // Tappable background
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isTagSheetVisible = false
                            }
                        }

                    VStack {
                        Spacer()
                        BottomTagView(isTagVisible: $isTagSheetVisible, selectedID: selectedID ?? 0, isclicked: $isclicked, selectedTag: $selectedTag, isScreenActive: $isScreenActive)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isTagSheetVisible)
                    }
                }
            }
            
            if isBackgroundSheetVisible {
                ZStack {
                    // Tappable background
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isBackgroundSheetVisible = false
                            }
                        }

                    VStack {
                        Spacer()
                        BottomThemeView(themeimage: $BackgroundThemeimage, selectedIconIndex: themeImage, isBackgroundSheetVisible: $isBackgroundSheetVisible, selectedID: id, onTapTheme: $onTapTheme)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isBackgroundSheetVisible)
                    }
                }

            }
        }
    }
}

struct NoteUpdateView: View {
    @Binding var isNoteupdateVisible: Bool
    @Binding var notificationTime: Int?
    @ObservedObject private var plannerAddTaskViewModel = PlannerAddTaskViewModel()
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @State private var textInput: String = ""
    @State private var text: String = ""
    var selectedID: Int
    @State var id: Int = 0
    @State var listsData: [Diary] = []
    @State var NotelistDatas: [Note] = []
    @State var tNotetitle: String = ""
    @State var tNotenote: String = ""
    @State var tNoteType: String = ""
    @State private var isNotificationVisible: Bool = false
    @State private var isTagVisible: Bool = false
    @State private var isHistorySheetVisible: Bool = false
    @State private var isclicked: Bool = false
    @State private var isTextFieldVisible = true
    @State private var showingDeleteAlert = false
    @State private var isEditable = false
    @State private var tagslabels: [TagLabels] = []
    @State private var isScreenActive: Bool = false
    @State private var isViewActive: Bool = false
    @State private var isBackgroundSheetVisible: Bool = false
    @State private var BackgroundThemeimage: String?
    @State private var onTapTheme: Bool = false
    @State private var isPostBoxMailViewActive: Bool = false
    @State var themeImage: String = ""
    
    
    var body: some View {
        ZStack {
            if !themeImage.isEmpty {
                if let diary = homePlannerViewModel.noteListData.first(where: { $0.id == selectedID }) {
                    if let theme = diary.theme {
                        if let hexColor = Color(hex: theme) {
                        // Use the color from the hex code
                        hexColor
                            .ignoresSafeArea() // Make sure the color fills the screen
                    } else {
                        // Attempt to load the image
                        Image(themeImage)
                            .resizable() // Make the image resizable
                            .ignoresSafeArea()
                    }
                   }
                }
                
                if onTapTheme {
                    Image(BackgroundThemeimage!)
                        .resizable()
                        .ignoresSafeArea()
                }

            }


            
            else {
                // Default theme color if `themeImage` is empty
                Color.white
                    .ignoresSafeArea()
            }
            
            VStack {
                HStack {
                    Button(action: {
                        homePlannerViewModel.NoteDiaryData(selectedID: selectedID, notediary: tNotetitle, titlediary: tNotenote)
                        self.isNoteupdateVisible = false
                        
                    }, label: {
                        Image("wrongmark")
                    })
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .leading, spacing: 1) { // Set spacing explicitly between the elements
                    TextField("What's new", text: $tNotetitle)
                        .background(Color.clear)
                        .cornerRadius(8)
                        .padding(.top, 30) // Add top padding to the TextField
                        .padding(.horizontal, 16) // Add horizontal padding
                        .foregroundStyle(Color.black)
                        .disabled(!isEditable)
                        .onSubmit {
                            isEditable = false // Set `isEditable` to false when tick mark is pressed
                        }
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 16) // Horizontal padding for the Rectangle
                }

                VStack(alignment: .leading) {
                    // TextField for the note
                    TextField("Write about it", text: $tNotenote)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(8)
                        .padding(.top, 15)
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.black)
                        .disabled(!isEditable)
                        .onSubmit {
                            isEditable = false // Set `isEditable` to false when tick mark is pressed
                        }
                }
                
                    VStack(alignment: .leading, spacing: 15) { // Updated spacing
                        if let selectedDiaryIndex = homePlannerViewModel.noteListData.firstIndex(where: { $0.id == selectedID }),
                           let reminderTimestamp = homePlannerViewModel.noteListData[selectedDiaryIndex].reminder {
                            // Convert Int (timestamp) to Date
                            let reminderDate = Date(timeIntervalSince1970: TimeInterval(reminderTimestamp))
                            
                            // Format the date and time
                            let formattedDateTime = formatDateTime(reminderDate)
                            
                            HStack(spacing: 10) {
                                // Notification icon aligned on the left
                                if isTextFieldVisible {
                                    Image("notification1")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .padding(.leading, 5)
                                
                                // Conditionally render TextField based on isTextFieldVisible
                                    TextField("", text: Binding(
                                        get: { formattedDateTime },
                                        set: { newValue in
                                            if let newDate = parseDateTime(newValue) {
                                                // Update the reminder timestamp
                                                if let index = homePlannerViewModel.noteListData.firstIndex(where: { $0.id == selectedID }) {
                                                    homePlannerViewModel.noteListData[index].reminder = Int(newDate.timeIntervalSince1970)
                                                }
                                            }
                                        }
                                    ))
                                    .foregroundColor(.black)
                                    .font(.system(size: 12))
                                    .disabled(!canEdit())
                                    .frame(height: 30)
                                
                                
                                // Remove icon aligned on the right
                                    Image("wrongmark")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                        .padding(.trailing, 5)
                                            .onTapGesture {
                                                if let selectedDiary = homePlannerViewModel.noteListData.first(where: { $0.id == selectedID }) {
                                                    homePlannerViewModel.removescheduleNote(selectedID: selectedID) // Pass nil for null
                                                    isTextFieldVisible = false // Hide TextField when tapped
                                                }
                                            }
                                }
                            }
                            .frame(width: 200, height: 35)
                            .background(isTextFieldVisible ? Color(red: 187/255, green: 190/255, blue: 238/255) : Color.clear) // Background color conditionally
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isTextFieldVisible ? Color.black : Color.clear, lineWidth: 1) // Border color conditionally
                            )
                        }
                        let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach($tagslabels, id: \.labelId) { $label in
                                if !$label.labelName.wrappedValue.isEmpty {
                                    HStack {
                                        if !label.labelName.isEmpty {
                                            TextField("", text: $label.labelName)
                                                .frame(height: 35)
                                                .padding(.leading, 10)
                                                .foregroundColor(.black)
                                                .disabled(!canEdit())
                                            
                                            Image("wrongmark")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .padding(.trailing, 5)
                                                .onTapGesture {
                                                    label.labelName = ""
                                                    if let selectedDiary = homePlannerViewModel.noteListData.first(where: { $0.id == selectedID }) {
                                                        homePlannerViewModel.removeTag(selectedID: selectedID, Tagid: label.labelId)
                                                    }

                                                    
                                                }
                                        }
                                    }
                                    .background(Color(red: 187/255, green: 190/255, blue: 238/255)) // Background color
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black, lineWidth: 1) // Border around the TextField
                                    )
                                }
                            }
                        }
                        
                    }
                    .padding(.leading, 10)
                    .padding(.horizontal, 10)
                    
                    Spacer() // Push content upwards
                    
                    // Align the tags image at the bottom
                    HStack {
                        Button(action: {
                            isEditable = true
                        }, label: {
                            Image("edits")
                        })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                        
                        
                        Button(action: {
                            isBackgroundSheetVisible.toggle()
                            
                        }, label: {
                            Image("backgroundimage")
                        })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                        
                        
                        Button(action: {
                            isTagVisible.toggle()
                            
                        }, label: {
                            Image("Tags")
                        })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                        
                        Button(action: {
                            isNotificationVisible.toggle()
                            
                        }, label: {
                            Image("plannerbell")
                        })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                        
                        Button(action: {
                            self.isHistorySheetVisible = true
                        }, label: {
                            Image("timer")
                        })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                        
                        Button(action: {
                            showingDeleteAlert = true
                            
                        }, label: {
                            Image("del")
                        })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                        Spacer()
                    }
                    .padding(.top, 20)
                    .background(Color.gray)
                }
            }
            .onAppear {

                if homePlannerViewModel.noteListData.isEmpty {
                    homePlannerViewModel.GetNoteDataList()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let note = homePlannerViewModel.noteListData.first(where: { $0.id == selectedID }) {
                        tNotetitle = note.title
                        tNotenote = note.note
                        tagslabels = note.labels ?? []
                        tNoteType = note.type
                        if let theme = note.theme {
                            themeImage = theme
                            if let fileName = theme.components(separatedBy: "/").last?.replacingOccurrences(of: ".png", with: "") {
                                themeImage = fileName
                            }
                        } else {
                            themeImage = "" // Default value if theme is nil
                        }
                    }
                }
            }
            
            if isNotificationVisible {
                ZStack {
                    // Tappable background
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isNotificationVisible = false
                            }
                        }

                    VStack {
                        Spacer()
                        BottomNotificationView(isNotificationVisible: $isNotificationVisible, notificationTime: $notificationTime, isViewActive: $isViewActive, ispostBoxMailViewActive: $isPostBoxMailViewActive, selectedID: selectedID)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isTagVisible)
                    }
                }
            }
            
        if isTagVisible {
            ZStack {
                // Tappable background
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isTagVisible = false
                        }
                    }

                VStack {
                    Spacer()
                    BottomTagView(isTagVisible: $isTagVisible,selectedID: selectedID,isclicked: $isclicked,selectedTag: $homePlannerViewModel.selectedLabelNoteID,
                        isScreenActive: $isScreenActive
                    )
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: isTagVisible)
                }
            }
        }


            
        if isHistorySheetVisible {
            ZStack {
                // Tappable background
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isHistorySheetVisible = false
                        }
                    }

                VStack {
                    Spacer()
                    HistoryView(isHistorySheetVisible: $isHistorySheetVisible, selectedID: selectedID)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: isTagVisible)
                }
            }
        }
        
            if showingDeleteAlert {
                ZStack {
                    Color.gray.opacity(0.5) // Dimmed background
                        .ignoresSafeArea()
                        .transition(.opacity)

                    // Centered DeleteNoteAlert
                    DeleteNoteAlert(isPresented: $showingDeleteAlert) {
                        homePlannerViewModel.deleteNote(selectedID: selectedID)
                        self.isNoteupdateVisible = false
                    }
                    .transition(.scale)
                }
            }
        
        if isBackgroundSheetVisible {
            
            ZStack {
                // Tappable background
                Rectangle()
                    .fill(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            isBackgroundSheetVisible = false
                        }
                    }

                VStack {
                    Spacer()
                    BottomThemeView(themeimage: $BackgroundThemeimage, selectedIconIndex: themeImage, isBackgroundSheetVisible: $isBackgroundSheetVisible, selectedID: selectedID, onTapTheme: $onTapTheme)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut, value: isTagVisible)
                }
            }
        }
            
        }

    
    // Helper function to determine editability
    private func canEdit() -> Bool {
        homePlannerViewModel.noteListData.firstIndex(where: { $0.id == selectedID }) == nil
    }
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Function to parse string back to Date
    private func parseDateTime(_ dateTimeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.date(from: dateTimeString)
    }
}


struct BottomNotificationView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @ObservedObject var snoozedMailsViewModel = SnoozedMailsViewModel()
    @Binding var isNotificationVisible: Bool
    @Binding var notificationTime: Int?
    @Binding var isViewActive: Bool
    @Binding var ispostBoxMailViewActive: Bool
    @State var comment: String = ""
    var selectedID: Int
    @State private var selectedDate = Date() // Holds the current date or time
    @State private var isDatePickerVisibled = false // Controls date picker dialog
    @State private var isTimePickerVisiblee = false
    @ObservedObject private var options = ClockLooks()
    @State var id:Int = 0
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Reminder")
                        .font(.headline)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.top, 20)
                        .padding(.leading, 16)
                    
                    Spacer()
                
                    Button(action: {
                        if isViewActive {
                            if let selectedDateTime = homePlannerViewModel.selectedDateTime {
                                notificationTime = Int(selectedDateTime.timeIntervalSince1970)
                                homePlannerViewModel.ScheduledonclickDone(selectedID: id, reminder: notificationTime)
                                isNotificationVisible = false
                            }
                        }
                        else {
                            if let selectedDateTime = homePlannerViewModel.selectedDateTime {
                                // Convert the Date to an Int (e.g., timestamp)
                                let reminderInt = Int(selectedDateTime.timeIntervalSince1970)
                                homePlannerViewModel.ScheduledonclickDone(selectedID: selectedID, reminder: reminderInt)
                                isNotificationVisible = false
                            }
                        }
                    }, label: {
                        Text("Done")
                            .foregroundColor(themesviewModel.currentTheme.colorAccent)
                            .fontWeight(.bold)
                    })
                    .font(.headline)
                    .foregroundColor(themesviewModel.currentTheme.colorAccent)
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                    .padding(.horizontal, 16)
                
                HStack {
                    Button(action: {
                    }, label: {
                        Text("Tomorrow")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: {
                    }, label: {
                        Text("8:00 AM")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.trailing, 16)
                }
                .padding(.top, 10)
                
                HStack {
                    Button(action: {
                    }, label: {
                        Text("Next Week")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: {
                    }, label: {
                        Text("8:00 AM")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.trailing, 16)
                }
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "timer")
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .frame(width: 24, height: 24)
                        .padding(.leading, 16)
                    
                    Button(action: {
                         isDatePickerVisibled = true
                     }) {
                         Text(homePlannerViewModel.selectedDateTime != nil ? selectedDateTimeFormatted : "Select Date and Time")
                             .foregroundColor(themesviewModel.currentTheme.colorAccent)
                             .fontWeight(.bold)
                             .padding()
                     }
                 }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 213) // Adjust height as per design
            .background(themesviewModel.currentTheme.windowBackground)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .onAppear {
            options.withHands = true
            
            if homePlannerViewModel.noteListData.isEmpty {
                homePlannerViewModel.GetNoteDataList()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let note = homePlannerViewModel.noteListData.first {
                    let incrementedId = note.id // `id` is a non-optional Int
                    id = incrementedId + 1
                    
                }
            }
        }
        .overlay(
            Group {
                if isDatePickerVisibled {
                    DialogViews(
                        title: "Select a Date",
                        content: {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                        },
                        onCancel: {
                            isDatePickerVisibled = false
                        },
                        onConfirm: {
                            isDatePickerVisibled = false
                            isTimePickerVisiblee = true
                        }
                    )
                    .offset(y: -120)
                }
            }
        )
        .overlay(
            Group {
                if isTimePickerVisiblee {
                    DialogViews(
                        title: "Select a Time",
                        content: {
                            ClockPickerView(date: $selectedDate)
                                .frame(width: 250, height: 250)
                        },
                        onCancel: {
                            isTimePickerVisiblee = false
                        },
                        onConfirm: {
                            isTimePickerVisiblee = false
                            homePlannerViewModel.selectedDateTime = selectedDate
                        }
                    )
                    .offset(y: -120)
                }
            }
        )
    }
    
    private var selectedDateTimeFormatted: String {
        guard let dateTime = homePlannerViewModel.selectedDateTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
}




struct BottomTagView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var isTagVisible: Bool
    @State var comment: String = ""
    var selectedID: Int
    @State private var searchText: String = ""
    @State private var isCreateLabelVisible: Bool = false // Tracks visibility of createLabelView
    @State private var Textfill: String = ""
    @State private var isChecked: Bool = false
    @Binding var isclicked: Bool
    @Binding var selectedTag: [Int]
    @Binding var isScreenActive: Bool
    @State var id:Int = 0
    @State private var isTagActive: Bool = false

    var body: some View {
        ZStack {
            // Main BottomTagSheetView content
            if !isCreateLabelVisible {
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Label as")
                                .font(.headline)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.top, 20)
                                .padding(.leading, 16)
                            
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    selectedTag = homePlannerViewModel.selectedLabelNoteID
                                    if homePlannerViewModel.selectedLabelNoteID != [0] { // Check if the array is not empty
                                        if isScreenActive {
                                            isTagActive = true
                                            homePlannerViewModel.ApplyTag(listId: id, tagIds: homePlannerViewModel.selectedLabelNoteID) // Pass the array
                                            isTagVisible = false // Dismiss the sheet
                                            isclicked = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                                                if homePlannerViewModel.noteListData.isEmpty {
                                                    homePlannerViewModel.GetNoteDataList()

                                                }
                                            }
                                            
                                        }
                                        else {
                                            homePlannerViewModel.ApplyTag(listId: selectedID, tagIds: homePlannerViewModel.selectedLabelNoteID) // Pass the array
                                            isTagVisible = false // Dismiss the sheet
                                            isclicked = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                                                if homePlannerViewModel.noteListData.isEmpty {
                                                    homePlannerViewModel.GetNoteDataList()
                                                }
                                            }
                                        }


                                    }
                                }
                            }, label: {
                                Text("Apply")
                                    .foregroundColor(themesviewModel.currentTheme.colorAccent)
                            })
                            .padding(.trailing, 16)
                        }
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundColor(themesviewModel.currentTheme.strokeColor)
                            .padding(.horizontal, 16)

                        // Search Field
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .frame(width: 24, height: 24)
                                .padding(.leading, 12)
                            
                            TextField(
                                "",
                                text: $searchText,
                                prompt: Text("Filter label")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom("Poppins-Regular", size: 12))
                            )
                            .padding(.leading, 13)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
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
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .fontWeight(.bold)
                            })
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 10)

                        // Scrollable list with filtered data
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(homePlannerViewModel.tagLabelNoteData.filter { label in
                                    searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
                                }) { label in
                                    HStack {
                                        Button(action: {
                                            toggleCheck(for: label.id) // Toggle state based on the label's ID
                                        }) {
                                            Image(label.isChecked ? "checkbox" : "Check")
                                                .resizable()
                                                .renderingMode(.template)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .frame(width: 24, height: 24)
                                                .padding(.leading, 25)
                                        }

                                        Button(action: {
                                            // Handle label text button action here if needed
                                        }) {
                                            Text(label.labelName)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                        }
                                        .padding(.trailing, 16)
                                    }
                                    .padding(.top, 10)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: calculateHeight())
                .background(themesviewModel.currentTheme.windowBackground)
                .cornerRadius(16)
                .shadow(radius: 10)
                .onAppear{
                    homePlannerViewModel.GetTagNoteLabelList()
                    if homePlannerViewModel.noteListData.isEmpty {
                        homePlannerViewModel.GetNoteDataList()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let note = homePlannerViewModel.noteListData.first {
                            let incrementedId = note.id // `id` is a non-optional Int
                            id = incrementedId + 1
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
                        isTagVisible = false // Dismiss the sheet
                    }
                }
        )
    }
    
    func toggleCheck(for id: Int) {
        if let index = homePlannerViewModel.tagLabelNoteData.firstIndex(where: { $0.id == id }) {
            homePlannerViewModel.tagLabelNoteData[index].isChecked.toggle()
            if homePlannerViewModel.tagLabelNoteData[index].isChecked {
                homePlannerViewModel.selectedLabelNoteID.append(id)
            } else {
                homePlannerViewModel.selectedLabelNoteID.removeAll { $0 == id }
            }
        }
    }
        
    func calculateHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44 // Estimated height for each row in the list
        let maxHeight: CGFloat = 800 // Maximum height for the entire view
        let totalHeight = baseHeight + (CGFloat(homePlannerViewModel.tagLabelNoteData.count) * rowHeight)
        return min(totalHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
    }
        


}




struct DialogViews<Content: View>: View {
    let title: String
    let content: Content
    let onCancel: () -> Void
    let onConfirm: () -> Void

    init(title: String, @ViewBuilder content: () -> Content, onCancel: @escaping () -> Void, onConfirm: @escaping () -> Void) {
        self.title = title
        self.content = content()
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .padding(.top)

            content
                .padding(.horizontal)

            HStack {
                Button("Cancel") {
                    onCancel()
                }
                .padding()
                .foregroundColor(.red)

                Spacer()

                Button("OK") {
                    onConfirm()
                }
                .padding()
                .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: 350)
        .frame(height: 350)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
    }
}

struct createTagView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var iscreatelabelvisible: Bool
    @Binding var Textfill: String

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    // Left-aligned close button
                    Button(action: {
                        Textfill = ""
                        iscreatelabelvisible = false
                    }, label: {
                        Image("wrongmark")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.allBlack)
                    })
                    .padding(.leading, 16)
                    .frame(height: 44) // Ensure consistent height
                    
                    // Centered "Create Label" text
                    Spacer()
                    Text("Create Label")
                        .padding() // Add padding around the text
                        .frame(height: 44) // Ensure consistent height
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                    Spacer()
                    
                    // Conditionally display "Create" text
                    if Textfill.count >= 1 {
                        Text("Create")
                            .padding() // Add padding around the text
                            .frame(height: 44) // Ensure consistent height
                            .foregroundColor(themesviewModel.currentTheme.colorAccent)
                            .padding(.trailing, 16)
                            .fontWeight(.bold)
                            .onTapGesture {
                                iscreatelabelvisible = false
                                Textfill = ""
                            }
                    }
                }
                .frame(maxWidth: .infinity) // Stretch HStack to full width

                VStack(alignment: .leading) {
                    Text("Name")
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .padding() // Add padding around the text
                        .padding(.top, 10) // Add top padding
                        .padding(.leading, 16)
                    
                    TextField("", text: $Textfill)
                        .padding()
                        .background(themesviewModel.currentTheme.allGray)
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .cornerRadius(8) // Rounded corners
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Make the VStack take up full width and align content to the leading

                Spacer() // Push content up to fill space below
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the entire screen
            .background(Color.white)
        }
    }
}

struct HistoryView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var isHistorySheetVisible: Bool
    @State var comment: String = ""
    var selectedID: Int
    @State private var isitVisiblee = false
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Version history")
                .font(.headline)
                .foregroundColor(themesviewModel.currentTheme.textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.horizontal, 16)
            Spacer()
                .frame(height: 8)
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(themesviewModel.currentTheme.textColor)
                .padding(.horizontal, 16)
            Spacer()
                .frame(height: 12)

            // List View
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(homePlannerViewModel.historyScheduleData, id: \.self) { data in
                        VStack(spacing: 0) {
                            HStack(alignment: .center, spacing: 12) {
                                // Calendar Icon
                                Image(systemName: "calendar")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                // Date and Name
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(convertToTime(timestamp: TimeInterval(data.modifiedAt)))
                                        .font(.system(size: 14))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    
                                    Text("\(homePlannerViewModel.sessionManager.userName) \("Bakaram") ")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .padding(.leading ,16)
                            .padding(.trailing,16)
                            .overlay(
                                Rectangle()
                                    .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1)
                                    .padding(.horizontal, 16)
                            )

                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: calculateHeight())
        .background(themesviewModel.currentTheme.windowBackground)
        .cornerRadius(16)
        .shadow(radius: 10)
        .onAppear {
            homePlannerViewModel.GetScheduleHistoryList(selectedID: selectedID)
        }
    }
    func calculateHeight() -> CGFloat {
        let baseHeight: CGFloat = 150 // Base height for fixed elements
        let rowHeight: CGFloat = 50 // Estimated height for each row in the list
        let maxHeight: CGFloat = 800 // Maximum height for the entire view
        let totalHeight = baseHeight + (CGFloat(homePlannerViewModel.historyScheduleData.count) * rowHeight)
        return min(totalHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
    }
    func convertToTime(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday)!
        
        if calendar.isDate(date, inSameDayAs: now) {
            return "Today, \(formatTime(from: date))"
        } else if calendar.isDate(date, inSameDayAs: startOfYesterday) {
            return "Yesterday, \(formatTime(from: date))"
        } else {
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            return "\(dateFormatter.string(from: date)), \(formatTime(from: date))"
        }
    }
    
    func formatTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
struct DeleteNoteAlert: View {
    @ObservedObject var themesviewModel = ThemesViewModel()
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


struct BottomThemeView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @Binding var themeimage: String?
    @State private var selectedColor: Color = .blue
    @State var selectedIconIndex: String
    @Binding var isBackgroundSheetVisible: Bool
    @State var selectedID: Int
    @Binding var onTapTheme: Bool
    @State var subImage: [String] = []
    @State var selectedToolTip: String?
    
    
    // Array of hex color codes
    let colors: [String] = [
        "#ffffff", "#f9b0a8", "#f39f76", "#fff8b9", "#e2f6d3", "#b5ddd4", "#d5e2e9","#aeccdc", "#d3c0db", "#f6e2dd", "#e9e2d4", "#efeff0"
    ]
    
//    let availableBackgrounds: [Background] = [
        let availableBackgrounds: [Background] = [
            Background(type: .image,
                      value: "fruits-7434339_1920",
                      tooltip: "Food",
                      plannerType: .doit,
                      subImages: [
                        SubImage(value: "assets/plannerBackground/food/coffee-4518354_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/food-3226311_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/food-7232678_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/fruit-7129434_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/fruits-7434339_1920.jpg", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/ice-2519682_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/kiwi-7127148_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/orange-4547207_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/spaghetti-7433732_1920.jpg", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/food/summer-4518347_1920.png", tooltip: "")
                      ]),
            
            // Green backgrounds
            Background(type: .image,
                      value: "landscape-409551_1280",
                      tooltip: "Green",
                      plannerType: .common,
                      subImages: [
                        SubImage(value: "assets/plannerBackground/green/abstract-1264071_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/blue-1296253_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/cityscape-303406_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/garden-6097539_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/hills-7135587_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/house-2023958_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/house-2023960_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/nature-5288669_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/resistance-148608_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/green/the-background-352165_1920.png", tooltip: "")
                      ]),
            
            // Love backgrounds
            Background(type: .image,
                      value: "heart-5106075_1920",
                      tooltip: "Love",
                      plannerType: .common,
                      subImages: [
                        SubImage(value: "assets/plannerBackground/love/beach-2245049_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/canines-1296551_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/cat-8239223_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/christmas-1869533_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/landscape-1300109_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/pink-6579855_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/romantic-card-7320309_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/sand-45710_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/sunset-5250356_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/love/wings-732712_1920.png", tooltip: "")
                      ]),
            
            // Miss backgrounds
            Background(type: .image,
                      value: "pattern-6854140_1280",
                      tooltip: "Miss",
                      plannerType: .note,
                      subImages: [
                        SubImage(value: "assets/plannerBackground/miss/ai-generated-8572696_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/feather-1689331_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/lace-2033434_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/leaves-8184621_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/pattern-6854140_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/sea-7920977_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/shape-8401083_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/space-5654794_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/the-great-wave-off-kanagawa-7107112_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/miss/wings-732712_1920.png", tooltip: "")
                      ]),
            
            // Mountain backgrounds
            Background(type: .image,
                      value: "desolate-1300152_1280",
                      tooltip: "Mountain",
                      plannerType: .common,
                      subImages: [
                        SubImage(value: "assets/plannerBackground/mountain/everest-4828404_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/landscape-1300109_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/man-7750139_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/mountain-1848342_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/mountains-5655190_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/mountains-6333930_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/mountains-8314422_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/natural-4821584_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/sky-6668309_128.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/mountain/sky-6668309_11111.png", tooltip: "")
                      ]),
            
            // Nature backgrounds
            Background(type: .image,
                      value: "homes-8194751_1280",
                      tooltip: "Nature",
                      plannerType: .common,
                      subImages: [
                        SubImage(value: "assets/plannerBackground/nature/abstract-1264071_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/autumn-1300297_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/cartoon-2022644_1.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/forest-4246102_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/garden-6097539_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/landscape-1844226_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/landscape-2024099_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/night-7130914_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/palm-4822903_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/nature/resistance-148608_1920.png", tooltip: "")
                      ]),
            
            // Person backgrounds
            Background(type: .image,
                      value: "canines-1296551_1280",
                      tooltip: "Person",
                      plannerType: .common,
                      subImages: [
                        SubImage(value: "assets/plannerBackground/person/girl-7130668_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/girl-8301168_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/hands-8731277_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/moon-8915326_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/saxophone-8846586_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/singer-5694224_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/woman-6585310_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/woman-6731242_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/woman-7074930_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/person/woman-7202209_1280.png", tooltip: "")
                      ]),
            
            // Travel backgrounds
            Background(type: .image,
                      value: "woman-8437509_1920",
                      tooltip: "Travel",
                      plannerType: .common,
                      subImages: [
                        SubImage(value: "assets/plannerBackground/travel/abstract-1262247_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/adventure-5519220_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/camel-1574449.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/cars-5970663_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/cowboys-8005806_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/location-4496459_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/road-trip-4399206_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/skating-4687221_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/ThanitDecember.jpg", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/travel/van-7107690_1280.png", tooltip: "")
                      ]),
            
            // Urban backgrounds
            Background(type: .image,
                      value: "149731",
                      tooltip: "Urban",
                      plannerType: .note,
                       subImages:[
                        SubImage(value: "assets/plannerBackground/urbn/1497.jpg", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/14973.jpg", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/cityscape-303406_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/cityscape-5057263_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/living-room-7939062_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/post-box-4665160_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/seat-7354939_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/sofa-7939061_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/store-4156934_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/urbn/traveling-4323759_1920.png", tooltip: "")
                       ]),
        // water
            Background(type: .image,
                      value: "sea-7920977_1280",
                      tooltip: "Water",
                      plannerType: .doit,
                       subImages:[
                        SubImage(value: "assets/plannerBackground/water/beach-2245049_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/water/city-7356540_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/water/fishing-3635221_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/water/homes-8194751_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/water/house-2023960_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/water/natural-4821550_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/water/natural-4821583_1920.png", tooltip: ""),
                        SubImage( value: "assets/plannerBackground/water/sand-45710_1280.png", tooltip: ""),
                        SubImage( value: "assets/plannerBackground/water/sea-7920977_128.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/water/the-great-wave-off-kanagawa-7107112_1280.png", tooltip: ""),
                                 ]),

    // work
            Background(type: .image,
                      value: "office-meeting-8731813_1920",
                      tooltip: "Work",
                      plannerType: .common,
                       subImages:[
                        SubImage(value: "assets/plannerBackground/work/bank-4859142_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/business-3064400_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/cartoon-8543726_1920.png'", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/cloud-4273197_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/email-4284157_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/gears-5193383_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/geometric-7719159_1920.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/progress-1262245_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/work-4156942_1280.png", tooltip: ""),
                        SubImage(value: "assets/plannerBackground/work/work-4997565_1280.png", tooltip: ""),
                       ]),
        ]


    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                
                // Color Picker Section (First Row)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 3) {
                        ForEach(colors, id: \.self) { hex in
                            if let color = Color(hex: hex) {
                                Circle()
                                    .fill(color)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        let correctedHex = hex.lowercased()
                                        homePlannerViewModel.AddTheme(theme: correctedHex, selectedID: selectedID)
                                    }
                                
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Background Picker Section (Third Row)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(availableBackgrounds) { background in // No need for id: \.value if Background is Identifiable
                            
                            Image(background.value)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
                            //                                .background(Color.red) // Add this line for debugging
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 0.5) // Add a border with your desired color and width
                                )
                                .onTapGesture {
                                    selectedToolTip = background.tooltip
                                    
                                    let subImages = background.subImages
                                    let processedFileNames = subImages.map { image in
                                        image.value
                                            .components(separatedBy: "/")
                                            .last?
                                            .replacingOccurrences(of: ".png", with: "") ?? ""
                                    }
                                    themeimage = background.value
                                    subImage = processedFileNames
                                    onTapTheme = true
                                    homePlannerViewModel.AddTheme(theme: "assets/plannerBackground/\(background.tooltip.lowercased())/\(themeimage!).png", selectedID: selectedID)
                                    
                                }
                        }
                    }
                }
                .frame(height: 60)
                .padding(.horizontal)
                
                if onTapTheme {
                    ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(subImage, id: \.self) { imageName in
//                            let themeimage = background.value
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 0.5) // Add a border with your desired color and width
                                )
                                .onTapGesture {
                                    themeimage = imageName
                                    homePlannerViewModel.AddTheme(theme:"assets/plannerBackground/\(selectedToolTip!.lowercased())/\(themeimage!).png", selectedID: selectedID)
                                    
                                }
                        }
                    }
                }
                
                    .frame(height: 60)
                    .padding(.horizontal)
            }

            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(radius: 10)
            )
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if homePlannerViewModel.noteListData.isEmpty {
                homePlannerViewModel.GetNoteDataList()
            }

            // Safely handle any logic without mutating `selectedID`
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let diary = homePlannerViewModel.noteListData.first(where: { $0.id == selectedID }) {
                    selectedID = diary.id
                    if let theme = diary.theme {
                        selectedIconIndex = theme
                        if let fileName = theme.components(separatedBy: "/").last?.replacingOccurrences(of: ".png", with: "") {
                            selectedIconIndex = fileName
                        }
                    } else {
                        selectedIconIndex = "" // Default value if theme is nil
                    }
                }
            }
           
        }
    }
}



//#Preview {
//    NoteView(isNoteVisible: .constant(true))
//}
