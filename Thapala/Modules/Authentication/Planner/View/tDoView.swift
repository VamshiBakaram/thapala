//
//  tDateView.swift
//  Thapala
//
//  Created by Ahex-Guest on 19/12/24.
//
//import SwiftUI

import SwiftUI
import ClockTimePicker

struct tDoView: View {
    @Binding var isCreateVisible: Bool
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @State private var text: String = "let's Start"
    @State private var tasktext: String = "write the task"
    @State private var isSubTaskVisible: Bool = false
    @State private var subtasks: [String] = [] // Array to store subtask texts
    @State private var newSubTaskText: String = ""
    @State private var isSubTaskCommitted = false

    var body: some View {
        ZStack {
            themesviewModel.currentTheme.windowBackground
                .ignoresSafeArea()
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button(action: {
                    self.isCreateVisible = false
                }) {
                    Image("backButton")
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .padding(.leading, 10)
                }
                Spacer() // This will push the text to the center
                Text("Add Task")
                    .frame(maxWidth: .infinity, alignment: .center) // Ensures the text is centered
                    .foregroundColor(themesviewModel.currentTheme.textColor)
            }
            HStack {
                TextField("", text: $text)
                    .font(.headline)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .padding(.leading, 16) // Adds 10-point padding to the leading edge
                    .padding(.trailing, 15) // Adds 15-point padding to the trailing edge
                    .fontWeight(.bold)
                
                Button(action: {
                    if !newSubTaskText.isEmpty {
                        subtasks.append(newSubTaskText) // Add the new subtask to the array
                        newSubTaskText = "" // Reset the new subtask text field
                        isSubTaskCommitted = false // Set committed state to false
                    }
                    isSubTaskVisible = true
                }) {
                    Image("plusmark")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.colorAccent)
                        .fontWeight(.bold)
                        .frame(width: 24, height: 24) // Set appropriate size for the icon
                        .padding(.trailing, 16) // Adds 10-point padding to the trailing edge of the button
                        
                }
            }

            TextField("", text: $tasktext)
                .font(.headline)
                .foregroundColor(themesviewModel.currentTheme.textColor)
                .padding(.leading, 16) // Adds 10-point padding to the leading edge
                .padding(.trailing, 16) // Adds 15-point padding to the trailing edge


            ForEach(subtasks.indices, id: \.self) { index in
                HStack {
                    if !subtasks[index].isEmpty {
                        Image("plusmark")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .padding(.leading,16)
                    }
                    TextField("+ SubTask", text: Binding(
                        get: { subtasks[index] },
                        set: { subtasks[index] = $0 }
                    ))
                    .font(.headline)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .padding(.horizontal, 16)
                    if !subtasks[index].isEmpty {
                        Image("del")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .padding(.trailing,16)
                            .onTapGesture {
                                subtasks.remove(at: index) // Remove the subtask at the given index
                            }
                    }
                }
            }
            
            ZStack(alignment: .leading) {
                if newSubTaskText.isEmpty {
                    Text("+ SubTask")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.leading, 20)
                }

                TextField("", text: $newSubTaskText, onCommit: {
                    if !newSubTaskText.isEmpty {
                        subtasks.append(newSubTaskText)
                        isSubTaskCommitted = false
                        newSubTaskText = ""
                    }
                    isSubTaskVisible = true
                })
                .foregroundColor(themesviewModel.currentTheme.textColor)
                .padding(.leading, 16)
                .padding(.trailing, 16)
            }
            
            Spacer()
            
            Button(action: {
                homePlannerViewModel.AddTask(title: text, tasks: subtasks, notes: tasktext)
                self.isCreateVisible = false
                // Handle button action here
            }) {
                Text("Add Task")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themesviewModel.currentTheme.colorPrimary)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
            
    }
 }

}


struct ListitemView: View {
    @Binding var isListItemVisible: Bool
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @State private var text: String = "let's Start"
    @State private var tasktext: String = "write the task"
    @State private var isSubTaskVisible: Bool = false
    @State private var subtasks: [SubTask] = []
    @State private var newSubTaskText: String = ""
    @State private var isSubTaskCommitted = false
    @State var title: String = ""
    @State var note: String = ""
    @State var editedAt = Date()
    @State var taskID: Int?
    var selectedID: Int
    @State private var isNotificationVisible: Bool = false
    @State private var isTagViewVisible: Bool = false
    @State private var isclicked: Bool = false
    @State private var isHistoryVisible: Bool = false
    @State private var BottomDeleteAlert: Bool = false
    @State private var isTextFieldVisible = true
    @State private var tagsLabelList: [TagLabelList] = []
    @State var lastEditTime: String = ""
    @State private var isBackgroundViewVisible: Bool = false
    @State private var BackgroundThemeimage: String?
    @State private var onTapTheme: Bool = false
    @State var themeImage: String = ""
    @State var themeArray: [String] = []

    
    struct SubTask {
        var text: String
        var imageStatus: String
    }

    var body: some View {
        ZStack {
            if themeImage.isEmpty {
                themesviewModel.currentTheme.windowBackground
                    .ignoresSafeArea()
            }
            else {
                if let diary = homePlannerViewModel.doitlistData.first(where: { $0.id == selectedID }) {
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
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        self.isListItemVisible = false
                    }) {
                        Image("backButton")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .padding(.leading, 12)
                    }
                    Spacer()
                    
                    Text("Add Task")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            VStack {
                HStack {
                    TextField("", text: $title)
                        .font(.headline)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.leading, 16)
                        .padding(.trailing, 15)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        if !newSubTaskText.isEmpty {
                            subtasks.append(SubTask(text: newSubTaskText, imageStatus: "todo"))
                            homePlannerViewModel.taskAdding(comment: newSubTaskText, selectedID: selectedID)
                            newSubTaskText = ""
                            isSubTaskCommitted = false
                        }
                        isSubTaskVisible = true
                    }) {
                        Image("plusmark")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.colorAccent)
                            .fontWeight(.bold)
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 16)
                    }
                }
                
                TextField("", text: $note)
                    .font(.headline)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                
                ForEach(subtasks.indices, id: \.self) { index in
                    HStack {
                        if !subtasks[index].text.isEmpty {
                            Image(subtasks[index].imageStatus)
                                .resizable()  // Ensure the image can be resized
                                .frame(width: 20, height: 20)  // Apply frame size here
                                .padding(.leading, 16)
                        }
                        TextField("+ SubTask", text: Binding(
                            get: { subtasks[index].text },
                            set: { subtasks[index].text = $0 }
                        ))
                        .font(.headline)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        
                        if !subtasks[index].text.isEmpty {
                            Image("wrongmark")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .padding(.trailing, 20)
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    subtasks.remove(at: index)
                                    homePlannerViewModel.RemoveTask(selectedIDs: selectedID, commentIDs: taskID ?? 0)
                                }
                        }
                    }
                }
                
                if isSubTaskVisible {
                    HStack {
                        TextField("+ SubTask", text: $newSubTaskText, onCommit: {
                            if !newSubTaskText.isEmpty {
                                subtasks.append(SubTask(text: newSubTaskText, imageStatus: "todo"))
                                homePlannerViewModel.taskAdding(comment: newSubTaskText, selectedID: selectedID)
                                // Reset newSubTaskText after commit
                                DispatchQueue.main.async {
                                    newSubTaskText = ""
                                    isSubTaskCommitted = false
                                }
                            }
                            isSubTaskVisible = true
                        })
                        .font(.headline)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    }
                }
                    VStack(alignment: .leading, spacing: 10) { // Set spacing to 15 between views
                        
                        if let selectedDiary = homePlannerViewModel.doitlistData.first(where: { $0.id == selectedID }),
                           let reminderTimestamp = selectedDiary.reminder {
                            // Convert Int (timestamp) to Date
                            let reminderDate = Date(timeIntervalSince1970: TimeInterval(reminderTimestamp) ?? 0)
                            
                            // Format the date and time
                            var formattedDateTime = formatDateTime(reminderDate)
                            
                            HStack(spacing: 10) {
                                // Notification icon aligned on the left
                                if isTextFieldVisible {
                                    Image("notification1")
                                        .resizable()
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 16, height: 16)
                                        .padding(.leading, 5)
                                
                                
                                // Conditionally render TextField based on isTextFieldVisible
                                    TextField("", text: Binding(
                                        get: { formattedDateTime },
                                        set: { newValue in
                                            if let newDate = parseDateTime(newValue) {
                                                // Update the reminder timestamp
                                                if let index = homePlannerViewModel.doitlistData.firstIndex(where: { $0.id == selectedID }) {
                                                    homePlannerViewModel.doitlistData[index].reminder = Int(newDate.timeIntervalSince1970)
                                                }
                                            }
                                        }
                                    ))
                                    foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.system(size: 12))
                                    .disabled(!canEdit())
                                    .frame(height: 30)
                                
                                
                                // Remove icon aligned on the right
                                    Image("wrongmark")
                                        .renderingMode(.template)
                                        .resizable()
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 16, height: 16)
                                        .padding(.trailing, 5)
                                        .onTapGesture {
                                            formattedDateTime = ""
                                            isTextFieldVisible = false // Hide TextField when tapped
                                        }
                                }
                            }
                            
                            .frame(width: 200, height: 35)
                            .background(Color.red) // Background color conditionally
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isTextFieldVisible ? Color.black : Color.clear, lineWidth: 1) // Border color conditionally
                            )
                        }


                        
                        Spacer().frame(height: 15)
                        // ScrollView for tags
                        let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach($tagsLabelList, id: \.labelId) { $label in
                                if !$label.labelName.wrappedValue.isEmpty {
                                    HStack {
                                        if !label.labelName.isEmpty {
                                            TextField("", text: $label.labelName)
                                                .frame(height: 35)
                                                .padding(.leading, 16)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .disabled(!canEdit())
                                            
                                            Image("wrongmark")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .padding(.trailing, 5)
                                                .onTapGesture {
                                                    label.labelName = ""
                                                    if let selectedDiary = homePlannerViewModel.doitlistData.first(where: { $0.id == selectedID }) {
                                                        homePlannerViewModel.removeTag(selectedID: selectedID, Tagid: label.labelId)
                                                    }
                                                    
                                                }
                                        }
                                        }

//                                        planner/remove-label?plannerId=332&labelId=106
                                    .background(themesviewModel.currentTheme.iconColor)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.black, lineWidth: 1) // Border around the TextField
                                    )
                                }
                            }
                        }

                        Spacer().frame(height: 15)

                    }

                    .padding(.horizontal, 10)
                
                HStack {
                    Spacer() // Push content to the trailing edge
                    
                    Text("Edited")
                        .font(.subheadline)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    
                    Text(lastEditTime)
                        .font(.subheadline)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.leading, 1)
                }
                .padding(.trailing, 16)
                                
                // ScrollView for tags
                
                Spacer()
                HStack {
                    Button(action: {
                        withAnimation {
                            isNotificationVisible.toggle()
                        }
                    }, label: {
                        Image("plannerbell")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    .padding(.bottom, 10)
                    .padding(.leading, 40)
                    
                    Button(action: {
                        isBackgroundViewVisible.toggle()
                    }, label: {
                        Image("backgroundimage")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    .padding(.bottom, 10)
                    .padding(.leading, 40)
                    
                    Button(action: {
                        isTagViewVisible.toggle()
                    }, label: {
                        Image("Tags")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    .padding(.bottom, 10)
                    .padding(.leading, 40)
                    
                    Button(action: {
                        isHistoryVisible.toggle()
                    }, label: {
                        Image("timer")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    .padding(.bottom, 10)
                    .padding(.leading, 40)
                    Button(action: {
                        BottomDeleteAlert.toggle()
                    }, label: {
                        Image("del")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    .padding(.bottom, 10)
                    .padding(.leading, 40)
                    
                    
                    Spacer()
                }
                .padding(.top, 20)
                .background(themesviewModel.currentTheme.windowBackground)
              }
            }
            .onAppear {
                if homePlannerViewModel.doitlistData.isEmpty {
                    homePlannerViewModel.GetDoitList()
                    
                    homePlannerViewModel.GetDoitHistory(selectedID: selectedID)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                    if let diary = homePlannerViewModel.doitlistData.first(where: { $0.id == selectedID }) {
                        title = diary.title
                        note = diary.note
                        tagsLabelList = diary.labels ?? []
                        if let comments = diary.comments, !comments.isEmpty {
                            for comment in comments {
                                taskID = comment.commentId
                                subtasks.append(SubTask(text: comment.comment, imageStatus: comment.status))
                            }
                        }
                        if let theme = diary.theme {
                            themeImage = theme
                            if let fileName = theme.components(separatedBy: "/").last?.replacingOccurrences(of: ".png", with: "") {
                                themeImage = fileName
                            }
                        } else {
                            themeImage = "" // Default value if theme is nil
                        }
                        
                    }
                    
                    // Assuming `doitlistData` is an array of `Doit` objects
                    themeArray = homePlannerViewModel.doitlistData.compactMap { $0.theme }

                    if let lastHistory = homePlannerViewModel.doitHistoryData.last {
                        lastEditTime = convertToTime(timestamp: TimeInterval(lastHistory.modifiedAt))
                        
                    }
                }
            }
            if isNotificationVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    NotificationView(isNotificationVisible: $isNotificationVisible, selectedID: selectedID)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isNotificationVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            if isTagViewVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    TagView(isTagViewVisible: $isTagViewVisible, selectedID: selectedID, isclicked: $isclicked)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isTagViewVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            
            
            if isHistoryVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    HistoryBottomView(isHistoryVisible: $isHistoryVisible, selectedID: selectedID)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isHistoryVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            
            if BottomDeleteAlert {
                Color.gray.opacity(0.5) // Semi-transparent background
                     .ignoresSafeArea() // Extend to the edges of the screen
                     .transition(.opacity) // Add smooth appearance/disappearance
                 
                DeleteAlertView(isPresented: $BottomDeleteAlert) {
                     // Handle delete action here
                     homePlannerViewModel.deleteNote(selectedID: selectedID)
                     self.BottomDeleteAlert = false
                    self.isListItemVisible = false
                 }
                 .transition(.scale) // Add smooth scaling effect
             }
            
            if isBackgroundViewVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    BottomBackgroundView(isBackgroundViewVisible: $isBackgroundViewVisible, themeimage: $BackgroundThemeimage, selectedIconIndex: themeImage,selectedID: selectedID, onTapTheme: $onTapTheme)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isBackgroundViewVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            
        }
        
    }
    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Ensures the correct locale is used
        formatter.timeZone = TimeZone.current // Uses the current time zone

        // Define a custom date and time format
        formatter.dateFormat = "MMM dd, yyyy, h:mm a" // Example format: "Dec 27, 2024, 5:30 PM"
        
        return formatter.string(from: date)
    }
    
    private func parseDateTime(_ dateTimeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.date(from: dateTimeString)
    }
    
    private func canEdit() -> Bool {
        homePlannerViewModel.doitlistData.firstIndex(where: { $0.id == selectedID }) == nil
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

struct NotificationView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var isNotificationVisible: Bool
    @State var comment: String = ""
    var selectedID: Int
    @State private var selectedDate = Date() // Holds the current date or time
    @State private var isDatePickerVisible = false // Controls date picker dialog
    @State private var isTimePickerVisible = false
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
                        if let selectedDateTime = homePlannerViewModel.selectedDateTime {
                            // Convert the Date to an Int (e.g., timestamp)
                            let reminderInt = Int(selectedDateTime.timeIntervalSince1970)
                            homePlannerViewModel.TapOnDone(selectedID: selectedID, reminder: reminderInt)
                            self.isNotificationVisible = false
                        }
                    }, label: {
                        Text("Done")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .fontWeight(.bold)
                    })
                    .font(.headline)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
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
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .frame(width: 24, height: 24)
                        .padding(.leading, 16)

                    Button(action: {
                         isDatePickerVisible = true
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
        .overlay(
            Group {
                if isDatePickerVisible {
                    timeDialogView(
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
                            isTimePickerVisible = true
                        }
                    )
                    .offset(y: -120)
                }
            }
        )
        .overlay(
            Group {
                if isTimePickerVisible {
                    timeDialogView(
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
    
    private var selectedDateTimeFormatted: String {
        guard let dateTime = homePlannerViewModel.selectedDateTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
}
struct timeDialogView<Content: View>: View {
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



struct TagView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var isTagViewVisible: Bool
    @State var comment: String = ""
    var selectedID: Int
    @State private var searchText: String = ""
    @State private var isCreateLabelVisible: Bool = false // Tracks visibility of createLabelView
    @State private var Textfill: String = ""
    @State private var isChecked: Bool = false
    @Binding var isclicked: Bool
    @State var selectedLabelDoitID: [Int] = []


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
                                    if !homePlannerViewModel.selectedLabelDoitID.isEmpty { // Check if the array is not empty
                                        homePlannerViewModel.ApplyTag(listId: selectedID, tagIds: homePlannerViewModel.selectedLabelDoitID) // Pass the array
                                        self.isTagViewVisible = false // Dismiss the sheet
                                        isclicked = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                                            if homePlannerViewModel.doitlistData.isEmpty {
                                                homePlannerViewModel.GetDoitList()
                                            }
                                        }

                                    }
                                }
                            }, label: {
                                Text("Apply")
                                    .foregroundColor(themesviewModel.currentTheme.colorAccent)
                                    .fontWeight(.bold)
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
                                .renderingMode(.template)
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

                        }
                        .padding()
                        .foregroundColor(Color.red)
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
                                    .foregroundColor(themesviewModel.currentTheme.colorAccent)
                                    .fontWeight(.bold)
                            })
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 10)

                        // Scrollable list with filtered data
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(homePlannerViewModel.tagLabelDoItData.filter { label in
                                    searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
                                }) { label in
                                    HStack {
                                        Button(action: {
                                            toggleCheck(for: label.id) // Toggle state based on the label's ID
                                        }) {
                                            Image(label.isChecked ?  "checkbox" : "Check")
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
                    homePlannerViewModel.GetTagDoitLabelList()
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
    
    func toggleCheck(for id: Int) {
        if let index = homePlannerViewModel.tagLabelDoItData.firstIndex(where: { $0.id == id }) {
            homePlannerViewModel.tagLabelDoItData[index].isChecked.toggle()
            if homePlannerViewModel.tagLabelDoItData[index].isChecked {
                homePlannerViewModel.selectedLabelDoitID.append(id)
            } else {
                homePlannerViewModel.selectedLabelDoitID.removeAll { $0 == id }
            }
        }
    }


        
    func calculateHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44 // Estimated height for each row in the list
        let maxHeight: CGFloat = 800 // Maximum height for the entire view
        let totalHeight = baseHeight + (CGFloat(homePlannerViewModel.tagLabelDoItData.count) * rowHeight)
        return min(totalHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
    }
}



struct HistoryBottomView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var isHistoryVisible: Bool
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
                .foregroundColor(themesviewModel.currentTheme.strokeColor)
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
                                    
                                    Text("\(homePlannerViewModel.sessionManager.userName) \("Vamshi") ")
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
                                    .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
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


struct DeleteAlertView : View {
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
                Text("Are you sure you want to delete this Task ?")
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
                            .foregroundColor(.black)
                            .background(Color(UIColor.systemGray6))
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
                            .foregroundColor(.white)
                            .background(Color.red)
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


struct BottomBackgroundView: View {
    @Binding var isBackgroundViewVisible: Bool
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var themeimage: String?
    @State private var selectedColor: Color = .blue
    @State var selectedIconIndex: String
    @State var selectedID: Int
    @Binding var onTapTheme: Bool
    @State var subImage: [String] = []
    @State var selectedToolTip: String?
    
    
    // Array of hex color codes
    let colors: [String] = [
        "#ffffff", "#f9b0a8", "#f39f76", "#fff8b9", "#e2f6d3", "#b5ddd4", "#d5e2e9","#aeccdc", "#d3c0db", "#f6e2dd", "#e9e2d4", "#efeff0"
    ]
    
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
                
                // Image Picker Section (Second Row)
                // Inside the Image Picker Section (Second Row)
                
                // Background Picker Section (Third Row)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(availableBackgrounds) { background in // No need for id: \.value if Background is Identifiable
                            
                            Image(background.value)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36, height: 36)
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
                    .fill(themesviewModel.currentTheme.windowBackground)
                    .shadow(radius: 10)
            )
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if homePlannerViewModel.noteListData.isEmpty {
                homePlannerViewModel.GetDoitList()
            }

            // Safely handle any logic without mutating `selectedID`
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let diary = homePlannerViewModel.doitlistData.first(where: { $0.id == selectedID }) {
                    selectedID = diary.id
//                    selectedIconIndex = diary.theme
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

//
//struct AddTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTaskView()
//    }
//}
