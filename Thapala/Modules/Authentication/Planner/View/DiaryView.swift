//
//  DiaryView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/11/24.
//


import SwiftUI
import ClockTimePicker
struct DiaryView: View {
    @Binding var isDiaryVisible: Bool
    @ObservedObject private var plannerAddTaskViewModel = PlannerAddTaskViewModel()
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var DiarynotificationTime: Int?
    @Binding var isDiaryTagActive: Bool
    @State private var textInput: String = ""
    @State private var text: String = ""
    @State private var selectedID : Int?
    @State var id:Int = 0
    @State private var isNotificationSheetVisible: Bool = false
    @State private var isTagSheetVisible: Bool = false
    @State private var isBackgroundSheetVisible:Bool = false
    @ObservedObject private var options = ClockLooks()
    @State private var isclicked: Bool = false
    @State private var isDiaryViewActive: Bool = false
    @State private var isActive: Bool = false
    @State private var selectedNewDiaryTag: [Int] = []
    @State private var BackgroundThemeimage: String?
    @State private var onTapTheme: Bool = false
    @State var themeImage: String = ""
    @State var selectedNames: [String]
    var body: some View {
        ZStack {
            if onTapTheme {
                Image(BackgroundThemeimage!)
                    .resizable()
                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                    .ignoresSafeArea()
            }
            else {
                Color.white
                    .ignoresSafeArea()
            }
            
            VStack {
                HStack {
                    Button(action: {
                        onTapTheme = false
                        self.isDiaryVisible = false
                        print("Valid DiarynotificationTime: \(DiarynotificationTime)")
                        if let reminderTime = DiarynotificationTime {
                            print("Valid reminderTime: \(reminderTime)")
                            homePlannerViewModel.AddNewDiary(title: textInput, notes: text, reminder: reminderTime)
                            print("if Case")
                        } else {
                            print("DiarynotificationTime is nil. Using default value or handling it differently.")
                            print("else case")
                            homePlannerViewModel.AddNewDiary(title: textInput, notes: text, reminder: DiarynotificationTime ?? nil) // Pass nil if reminder is optional
                        }
//                        homePlannerViewModel.postDiary(selectedID: selectedID ?? 0,text: text, textInput: textInput)
                        print("api calling")
                        print("isDiaryTagActive\(isDiaryTagActive)")
                        if isDiaryTagActive {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                homePlannerViewModel.ApplyTag(listId: id, tagIds: selectedNewDiaryTag)
                                print("ApplyTag API called after 3 seconds")
                            }
                        }
                    }, label: {
                        Image("wrongmark")
                    })
                    .padding(.leading, 16) // Add spacing of 16 from the leading edge
                    .padding(.top, 16) // Add spacing of 16 from the top edge
                    Spacer() // Push the button to the top-left
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure HStack stretches across the screen, aligning left
                
                // Add the first TextField and Rectangle separator
                VStack(alignment: .leading, spacing: 1) { // Set spacing explicitly between the elements
                    TextField("What's new", text: $textInput)
//                                .padding()
                        .background(Color.clear)
                        .cornerRadius(8)
                        .padding(.top, 30) // Add top padding to the TextField
                        .padding(.horizontal, 16) // Add horizontal padding
                        .foregroundStyle(Color.black)
//                        .disabled(!canEdit())

                    // Add a Spacer here to force the correct spacing if needed
//                            Spacer().frame(height: 1) // Add space between TextField and Rectangle

                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 16) // Horizontal padding for the Rectangle
                }

                VStack(alignment: .leading) {
                    // TextField for the note
                    TextField("Write about it", text: $text)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(8)
                        .padding(.top, 15)
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color.black)
//                        .disabled(!canEdit())
                }
                Spacer() // Push content upwards
                // Align the tags image at the bottom
                HStack {
                    Button(action: {
                        isNotificationSheetVisible.toggle()

                    }, label: {
                        Image("plannerbell")
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
                        isTagSheetVisible.toggle()
                    }, label: {
                        Image("Tags")
                    })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                    Spacer()
                }
                .padding(.top, 20)
                .background(Color.gray)

            }
            
            .onAppear{
                isDiaryViewActive = true
                isActive = true
                
                if homePlannerViewModel.NotelistData.isEmpty {
                    homePlannerViewModel.GetDiaryDataList()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let note = homePlannerViewModel.listData.first {
                        let incrementedId = note.id
                        id = incrementedId + 1
                        print("Let's check the first id: \(incrementedId), Incremented id: \(id)")
                    } else {
                        print("No diary found with ID: \((id))")
                    }
                }
            }
            if isNotificationSheetVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    BottomSheetNotificationView(isNotificationSheetVisible: $isNotificationSheetVisible, DiarynotificationTime: $DiarynotificationTime, isDiaryViewActive: $isDiaryViewActive, selectedID: selectedID ?? 0)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isNotificationSheetVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            
            if isTagSheetVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    BottomTagSheetView(isTagSheetVisible: $isTagSheetVisible, isActive: $isActive, selectedNewDiaryTag: $selectedNewDiaryTag, selectedNames: $selectedNames, selectedID: selectedID ?? 0, isclicked: $isclicked)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isTagSheetVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            if isBackgroundSheetVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    BottomBackgroundSheetView(themeimage: $BackgroundThemeimage, selectedIconIndex: themeImage, isBackgroundSheetVisible: $isBackgroundSheetVisible, selectedID: id, onTapTheme: $onTapTheme)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isBackgroundSheetVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
        }
    }
}

struct DiaryUpdateView: View {
    @Binding var isDiaryupdateVisible: Bool
    @Binding var DiarynotificationTime: Int?
    @ObservedObject private var plannerAddTaskViewModel = PlannerAddTaskViewModel()
    @StateObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @State private var textInput: String = ""
    @State private var text: String = ""
    var selectedID: Int
//    var labelID: Int
    @State var id: Int = 0
    @State var listsData: [Diary] = []
    @State var titlediary: String = ""
    @State var notediary: String = ""
    @State var themeImage: String = ""
    @State private var labelcomments: [Comment] = []
    @State private var isLabelSheetVisible: Bool = false
    @State private var isNotificationSheetVisible: Bool = false
    @State private var isTagSheetVisible: Bool = false
    @State private var isBackgroundSheetVisible: Bool = false
    @State private var BackgroundThemeimage: String?
    @State private var onTapTheme: Bool = false
    @State private var tagslabel: [TagLabel] = []
    @State private var scheduletime : Date?
    @State private var reminders = 0
    @State private var comment: String = ""
    @State var isCommentAdded: Bool = false
    @State private var label: [RemoveLabelRequest] = []
    @State private var isTextFieldVisible = true // Add a state to track visibility
//    @State private var selectedLabelIDs: Int?
    @State var selectedLabelID: [Int] = []
    @State private var isclicked: Bool = false
    @State private var isDiaryViewActive: Bool = false
    @State private var isActive: Bool = false
    @Binding var selectedNames: [String]

    var body: some View {
        ZStack {
            if themeImage.isEmpty {
                // Default theme color if `themeImage` is empty
                themesviewModel.currentTheme.windowBackground
                    .ignoresSafeArea()
            }
            else {
                if let diary = homePlannerViewModel.listData.first(where: { $0.id == selectedID }) {
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


            
//            else {
//                // Default theme color if `themeImage` is empty
//                Color.white
//                    .ignoresSafeArea()
//            }

            VStack {
                HStack {
                    Button(action: {
                        print("selected names on click wrong mark \(selectedNames)")
                        print("homePlannerViewModel.selectedLabelNames   \(homePlannerViewModel.selectedLabelNames)")
                        onTapTheme = false
                        print("onTapTheme    \(onTapTheme)")
                        self.isDiaryupdateVisible = false
                        if homePlannerViewModel.listData.firstIndex(where: { $0.id == selectedID }) == 0 {
                            homePlannerViewModel.updateDiaryData(selectedID: selectedID, notediary: notediary, titlediary: titlediary)
                            print("API called with ID: \(selectedID), Title: \(titlediary), Content: \(notediary)")
                        }
                    }, label: {
                        Image("wrongmark")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack {
                    VStack (alignment: .leading) {
                        VStack(alignment: .leading, spacing: 1) { // Set spacing explicitly between the elements
                            TextField("What's new", text: $titlediary)
//                                .padding()
                                .background(Color.clear)
                                .cornerRadius(8)
                                .padding(.top, 30) // Add top padding to the TextField
                                .padding(.horizontal, 16) // Add horizontal padding
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .disabled(!canEdit())

                            // Add a Spacer here to force the correct spacing if needed
//                            Spacer().frame(height: 1) // Add space between TextField and Rectangle

                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                .padding(.horizontal, 16) // Horizontal padding for the Rectangle
                        }

                        VStack(alignment: .leading) {
                            // TextField for the note
                            TextField("Write about it", text: $notediary)
                                .padding()
                                .background(Color.clear)
                                .cornerRadius(8)
                                .padding(.top, 15)
                                .padding(.horizontal, 16)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .disabled(!canEdit())

                            

                        }
//
                        VStack(alignment: .leading, spacing: 10) { // Set spacing to 15 between views
                            
                            if var selectedDiary = homePlannerViewModel.listData.first(where: { $0.id == selectedID }),
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
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .frame(width: 16, height: 16)
                                            .padding(.leading, 5)
                                    }
                                    
                                    // Conditionally render TextField based on isTextFieldVisible
                                    if isTextFieldVisible {
                                        TextField("", text: Binding(
                                            get: { formattedDateTime },
                                            set: { newValue in
                                                if let newDate = parseDateTime(newValue) {
                                                    // Update the reminder timestamp
                                                    if let index = homePlannerViewModel.listData.firstIndex(where: { $0.id == selectedID }) {
                                                        homePlannerViewModel.listData[index].reminder = Int(newDate.timeIntervalSince1970)
                                                    }
                                                }
                                            }
                                        ))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.system(size: 12))
                                        .disabled(!canEdit())
                                        .frame(height: 30)
                                    }
                                    
                                    // Remove icon aligned on the right
                                    if isTextFieldVisible {
                                        Image("wrongmark")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .frame(width: 16, height: 16)
                                            .padding(.trailing, 5)
                                            .onTapGesture {
                                                formattedDateTime = ""
                                                isTextFieldVisible = false // Hide TextField when tapped
                                                //                                                homePlannerViewModel.removescheduleDiary(selectedID: selectedID, reminder: nil)
                                                print("isCommentAdded\(isCommentAdded)")
                                            }
                                    }
                                    
                                }
                                .frame(width: 200, height: 35)
                                .background(themesviewModel.currentTheme.windowBackground) // Background color conditionally
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1) // Border color conditionally
                                )
                            }
                            
                            
                            //                            if isclicked {
                            //                                ForEach(selectedNames, id: \.self) { name in
                            //                                    Text(name)
                            //                                        .padding()
                            //                                        .background(Color.clear)
                            //                                        .cornerRadius(8)
                            //                                        .padding(.top, 15)
                            //                                        .padding(.horizontal, 16)
                            //                                        .foregroundStyle(Color.black)
                            //                                        .disabled(!canEdit())
                            //                                }
                            //                            }
                            Spacer().frame(height: 15)
                            // ScrollView for tags
                            
                            
                            let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
                            LazyVGrid(columns: columns, spacing: 10) {
                                ForEach($tagslabel, id: \.labelId) { $label in
                                    if !$label.labelName.wrappedValue.isEmpty {
                                        HStack {
                                            if !label.labelName.isEmpty {
                                                TextField("", text: $label.labelName)
                                                    .frame(height: 35)
                                                    .padding(.leading, 10)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .disabled(!canEdit())
                                                
                                                Image("wrongmark")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .frame(width: 16, height: 16)
                                                    .padding(.trailing, 5)
                                                    .onTapGesture {
                                                        print("selected names on click wrong mark \(selectedNames)")
                                                        label.labelName = ""
                                                        //                                                        label.isRemoved = true
                                                        print("letcheck \(label.labelId)")
                                                        if let selectedDiary = homePlannerViewModel.listData.first(where: { $0.id == selectedID }) {
                                                            homePlannerViewModel.removeTag(selectedID: selectedID, Tagid: label.labelId)
                                                        }
                                                        else {
                                                            // Handle case where no matching diary was found
                                                            print("No diary found with id: \(selectedID)")
                                                        }
                                                        
                                                    }
                                            }
                                        }
                                        
                                        .background(themesviewModel.currentTheme.windowBackground)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1) // Border around the TextField
                                        )
                                    }
                                }
                            }
                            
                            if isclicked {
                            let columness = [GridItem(.adaptive(minimum: 100), spacing: 10)]
                            LazyVGrid(columns: columness, spacing: 10) {
                                ForEach(selectedNames, id: \.self) { name in
                                        HStack {
                                            Text(name)
                                                    .frame(height: 35)
                                                    .padding(.leading, 10)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .disabled(!canEdit())
                                                
                                                Image("wrongmark")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .frame(width: 16, height: 16)
                                                    .padding(.trailing, 5)
                                                    .onTapGesture {
                                                        print("selected names on click wrong mark \(name)")
//                                                        ForEach($tagslabel, id: \.labelId) { $label in
//                                                            if $label.labelName.wrappedValue == name {
//                                                                let id = $label.labelId.wrappedValue
//                                                                let ide = $label.plannerId.wrappedValue
////                                                                print("Label ID: \(id)")
//                                                                // Do something with `id`
////                                                                print("letcheck \(id)")
//                                                                if let selectedDiary = homePlannerViewModel.listData.first(where: { $0.id == ide }) {
//                                                                    homePlannerViewModel.removeTag(selectedID: ide, Tagid: id)
//                                                                }
//                                                                else {
//                                                                    // Handle case where no matching diary was found
//                                                                    print("No diary found with id: \(selectedID)")
//                                                                }
//                                                            }
//                                                        }

//                                                        //                                                        label.isRemoved = true

                                                        
                                                    }
                                            
                                        }
                                        .background(themesviewModel.currentTheme.windowBackground)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.black, lineWidth: 1) // Border around the TextField
                                        )
                                    
                                }
                            }
                        }
                            
//                            if isclicked {
//                                let columnss = [GridItem(.adaptive(minimum: 100), spacing: 10)]
//                                LazyVGrid(columns: columnss, spacing: 10) {
//                                    ForEach(selectedNames, id: \.self) { name in
//                                        Text(name)
//                                            .frame(height: 35)
//                                            .padding(.leading, 10)
//                                            .foregroundColor(.black)
//                                            .disabled(!canEdit())
//                                    }
//                                }
//                            } else {
//                                // Optionally, display a message or placeholder when isclicked is false
//                                Text("No names to display")
//                            }
                        
                            
//                            let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
//                            LazyVGrid(columns: columns, spacing: 10) {
//                                ForEach(selectedNames, id: \.self) { $name in
//                                        HStack {
//                                            
//                                            if isclicked && !selectedNames.isEmpty {
//                                                TextField("", text: $name)
//                                                    .frame(height: 35)
//                                                    .padding(.leading, 10)
//                                                    .foregroundColor(.black)
//                                                    .disabled(!canEdit())
//                                                
//                                                Image("wrongmark")
//                                                    .resizable()
//                                                    .frame(width: 16, height: 16)
//                                                    .padding(.trailing, 5)
//                                                    .onTapGesture {
//                                                        label.labelName = ""
////                                                        label.isRemoved = true
//                                                        print("letcheck \(label.labelId)")
//                                                        if let selectedDiary = homePlannerViewModel.listData.first(where: { $0.id == selectedID }) {
//                                                            homePlannerViewModel.removeTag(selectedID: selectedID, Tagid: label.labelId)
//                                                        }
//                                                        else {
//                                                            // Handle case where no matching diary was found
//                                                            print("No diary found with id: \(selectedID)")
//                                                        }
//                                                        
//                                                    }
//                                            }
//                                            }
//
////                                        planner/remove-label?plannerId=332&labelId=106
//                                        .background(Color(red: 187/255, green: 190/255, blue: 238/255)) // Background color
//                                        .cornerRadius(8)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 8)
//                                                .stroke(Color.black, lineWidth: 1) // Border around the TextField
//                                        )
//                                    
//                                }
//                            }

                            Spacer().frame(height: 15)


                            // ScrollView for comments
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach($labelcomments, id: \.commentId) { $comment in
                                        ZStack(alignment: .trailing) {
                                            if !comment.comment.isEmpty {
                                                TextField("", text: $comment.comment)
                                                    .frame(height: 45)
                                                    .padding(.leading, 10)
                                                    .background(themesviewModel.currentTheme.windowBackground)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1) // Border around the TextField
                                                    )
                                                    .cornerRadius(8)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .disabled(!comment.isEditable)  // Enable or disable based on isEditable
                                            }
                                            
                                            if !comment.comment.isEmpty {
                                                Button(action: {
                                                    comment.isEditable.toggle() // Toggle isEditable state
                                                    if !comment.isEditable {
                                                        homePlannerViewModel.updateCommentData(selectedId: selectedID, commentide: comment.commentId, comment: comment.comment)
                                                    }
                                                    print("comment.isEditable.toggle()\(comment.isEditable)")
                                                }, label: {
                                                    Image("edits")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .padding(.trailing, 50)
                                                })
                                            }

                                            if !comment.comment.isEmpty {
                                                Button(action: {
                                                    // Handle comment deletion
                                                    comment.comment = "" // Empty the comment text to hide the TextField
                                                    comment.isEditable = false // Ensure the TextField is not editable after deletion

                                                    if let selectedDiary = homePlannerViewModel.listData.first(where: { $0.id == selectedID }) {
                                                        homePlannerViewModel.deletecomments(selectedIDs: selectedID, commentIDs: comment.commentId)
                                                    }
                                                    print("selectedID: \(selectedID)")
                                                }, label: {
                                                    Image("del")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .padding(.trailing, 16)
                                                })
                                            }
                                        }
                                    }


                                    
                                    // Add a new comment input at the end
                                    if !comment.isEmpty && isCommentAdded {
                                            ZStack(alignment: .trailing) {
                                                TextField("", text: $comment) // Bind to a new comment field
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .frame(height: 45)
                                                    .padding(.leading, 10)
                                                    .background(themesviewModel.currentTheme.windowBackground)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1) // Border around the TextField
                                                    )
                                                    .cornerRadius(8)
                                                    .foregroundColor(.black)
                                                    .disabled(!canEdit())
                                                Button(action: {
                                                    print("Edit button pressed")
                                                }, label: {
                                                    Image("edits")
                                                        .padding(.trailing, 50)
                                                })
                                                .disabled(!canbeEdit())
                                                
                                                Button(action: {
                                                    // Handle comment deletion or action here
                                                    print("selectedID: \(selectedID)")
                                                }, label: {
                                                    Image("del")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .padding(.trailing, 16)
                                                })
                                            }
                                        
                                    }

                                }
                                .background(themesviewModel.currentTheme.windowBackground)
                                .padding(.horizontal, 10) // Apply horizontal padding only once to the VStack
                            }

                            



                        }

                        .padding(.horizontal, 10)
                        

                    }
                    
                    Spacer()

                    HStack {
                        Button(action: {
                            withAnimation {
                                isLabelSheetVisible.toggle()
                            }
                        }, label: {
                            Image("label")
                        })
                        .padding(.bottom, 10)
                        .padding(.leading, 40)
                        
                        Button(action: {
                            isNotificationSheetVisible.toggle()
                        }, label: {
                            Image("plannerbell")
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
                            isTagSheetVisible.toggle()
                        }, label: {
                            Image("Tags")
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
                print("homePlannerViewModel.selectedLabelNames: \(homePlannerViewModel.selectedLabelNames)")
                print("onTapTheme   \(onTapTheme)")
                if homePlannerViewModel.listData.isEmpty {
                    homePlannerViewModel.GetDiaryDataList()
                }
                
                // Change 200 milliseconds to 0.2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 500 / 1000.0) {
                    if let diary = homePlannerViewModel.listData.first(where: { $0.id == selectedID }) {
                        titlediary = diary.title
                        notediary = diary.note
                        labelcomments = diary.comments ?? []
                        tagslabel = diary.labels ?? []
                        scheduletime = homePlannerViewModel.selectedDateTime
//                        let selectedLabelIDs = tagslabel.map { $0.labelId }
//                        print("selectedLabelIDs\(selectedLabelIDs)")
                        if let theme = diary.theme {
                            themeImage = theme
                            if let fileName = theme.components(separatedBy: "/").last?.replacingOccurrences(of: ".png", with: "") {
                                themeImage = fileName
                            }
                            print("themeImage   \(themeImage)")
                        } else {
                            themeImage = "" // Default value if theme is nil
                        }


                    }
                }
            }

            
            
            // Custom Bottom Sheet
            if isLabelSheetVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
//                    BottomSheetView(homePlannerViewModel: homePlannerViewModel, isLabelSheetVisible: $isLabelSheetVisible, comment: $comment, isCommentAdded: $isCommentAdded, selectedID: selectedID)
                    BottomSheetView(homePlannerViewModel: homePlannerViewModel, isLabelSheetVisible: $isLabelSheetVisible, selectedID: selectedID)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isLabelSheetVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            if isNotificationSheetVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    BottomSheetNotificationView(isNotificationSheetVisible: $isNotificationSheetVisible, DiarynotificationTime: $DiarynotificationTime, isDiaryViewActive: $isDiaryViewActive, selectedID: selectedID)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isNotificationSheetVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            
            if isTagSheetVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    BottomTagSheetView(isTagSheetVisible: $isTagSheetVisible, isActive: $isActive, selectedNewDiaryTag: $homePlannerViewModel.selectedLabelID, selectedNames: $selectedNames, selectedID: selectedID,  isclicked: $isclicked)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isTagSheetVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
            if isBackgroundSheetVisible {
                VStack {
                    Spacer() // Pushes the sheet to the bottom
                    BottomBackgroundSheetView(themeimage: $BackgroundThemeimage, selectedIconIndex: themeImage, isBackgroundSheetVisible: $isBackgroundSheetVisible, selectedID: selectedID, onTapTheme: $onTapTheme)
                        .transition(.move(edge: .bottom)) // Smooth transition
                        .animation(.easeInOut)
                }
                .background(
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isBackgroundSheetVisible = false // Dismiss the sheet
                            }
                        }
                )
            }
        }
    }

    private func canEdit() -> Bool {
        homePlannerViewModel.listData.firstIndex(where: { $0.id == selectedID }) == 0
    }
    func canbeEdit() -> Bool {
        // Add your logic here
        return true // Replace this with your actual condition
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

struct BottomSheetView: View {
    @ObservedObject var homePlannerViewModel: HomePlannerViewModel
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var isLabelSheetVisible: Bool
//    @State var comment: String = ""
//    @Binding var comment: String
//    @Binding var isCommentAdded: Bool
    var selectedID: Int
    @State private var subtasks: [Subtask] = [] // State to store subtasks
    @State private var comment: String = "" // State for comment input
    @State private var isCommentAdded: Bool = false // Flag for comment addition    
    struct Subtask {
        var text: String
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Add Comment")
                    .font(.headline)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .padding(.top, 20)
                    .padding(.leading , 20)
                Spacer()


                Button(action: {
                    // Only add the comment if it's not empty
                    if !comment.isEmpty {
                        // Append the new comment to the subtasks array
                        subtasks.append(Subtask(text: comment))
                        
                        print("Added comment: \(comment)") // Debugging print statement
                        print("Current subtasks: \(subtasks)") // Debugging print statement

                        // Assuming you're calling the function to add the comment to the backend
                        homePlannerViewModel.addComment(comment: comment, selectedID: selectedID)

                        // Reset the comment field and close the sheet
                        isCommentAdded = true
                        comment = "" // Clear the comment field
                        self.isLabelSheetVisible = false
                        
                        print("isCommentAdded: \(isCommentAdded)")
                        print("Subtasks after addition: \(subtasks)") // Final state of subtasks
                    }
                    print("Subtasks array: \(subtasks)") // Final state of subtasks
                }, label: {
                    Text("Add Comment")
                        .foregroundColor(themesviewModel.currentTheme.colorAccent)
                        .padding(.top, 20)
                        .padding(.leading , 20)
                })

            }
            .padding()

            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(Color.gray)
                .padding(.trailing, 16)
                .padding(.leading , 16)

            TextField("Enter Comment", text: $comment)
                .padding()
                .foregroundColor(themesviewModel.currentTheme.textColor)
                .background(themesviewModel.currentTheme.windowBackground)
                .cornerRadius(8) // Rounded corners
                .overlay( // Add a border
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themesviewModel.currentTheme.attachmentBGColor, lineWidth: 1) // Gray border
                )
                .padding(.horizontal)
            Spacer()
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity)
.frame(height: 161) // Adjust height as per design
        .background(themesviewModel.currentTheme.windowBackground)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
    func toggleLabelSheetVisibility() {
        isLabelSheetVisible = false
    }

}

struct BottomSheetNotificationView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var isNotificationSheetVisible: Bool
    @Binding var DiarynotificationTime: Int?
    @Binding var isDiaryViewActive: Bool
    @State var comment: String = ""
    var selectedID: Int
    @State private var selectedDate = Date() // Holds the current date or time
    @State private var isDatePickerVisible = false // Controls date picker dialog
    @State private var isTimePickerVisible = false
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
                        if isDiaryViewActive {
                            if let selectedDateTime = homePlannerViewModel.selectedDateTime {
                                // Convert the Date to an Int (e.g., timestamp)
                                DiarynotificationTime = Int(selectedDateTime.timeIntervalSince1970)
                                homePlannerViewModel.onclickDone(selectedID: id, reminder: DiarynotificationTime!)
                                print("DiarynotificationTime  \(DiarynotificationTime!)")
                                self.isNotificationSheetVisible = false
                            }
                        }
                        else {
                            if let selectedDateTime = homePlannerViewModel.selectedDateTime {
                                let reminderInt = Int(selectedDateTime.timeIntervalSince1970)
                                homePlannerViewModel.onclickDone(selectedID: id, reminder: reminderInt)
                                print("reminderInt  \(reminderInt)")
                                self.isNotificationSheetVisible = false
                            }
                        }
                    }, label: {
                        Text("Done")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
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
                        print("")
                    }, label: {
                        Text("Tomorrow")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: {
                        print("")
                    }, label: {
                        Text("8:00 AM")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.trailing, 16)
                }
                .padding(.top, 10)
                
                HStack {
                    Button(action: {
                        print("")
                    }, label: {
                        Text("Next Week")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: {
                        print("")
                    }, label: {
                        Text("8:00 AM")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.trailing, 16)
                }
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .frame(width: 24, height: 24)
                        .padding(.leading, 16)
                        .onTapGesture {
                            print("Timer clicked")
                        }
                    
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
        .onAppear {
            options.withHands = true
                                        
                    if homePlannerViewModel.listData.isEmpty {
                        homePlannerViewModel.GetDiaryDataList()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let Diary = homePlannerViewModel.listData.first {
                            let incrementedId = Diary.id // `id` is a non-optional Int
                            id = incrementedId + 1
                            print("Let's check the first id: \(incrementedId), Incremented id: \(id)")
                        } else {
                            print("No diary found with ID: \((id))")
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
    
    private var selectedDateTimeFormatted: String {
        guard let dateTime = homePlannerViewModel.selectedDateTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
}




struct BottomTagSheetView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var isTagSheetVisible: Bool
    @Binding var isActive: Bool
    @Binding var selectedNewDiaryTag: [Int]
    @Binding var selectedNames: [String]
    @State var comment: String = ""
    var selectedID: Int
    @State private var searchText: String = ""
    @State private var isCreateLabelVisible: Bool = false // Tracks visibility of createLabelView
//    @State var labelname: String = ""
    @State private var Textfill: String = ""
    @State private var isChecked: Bool = false
    @Binding var isclicked: Bool
    @State var newid:Int = 0
    @State private var isDiaryTagActive: Bool = false
    @State private var HomeawaitingViewVisible: Bool = false
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
                                    selectedNewDiaryTag = homePlannerViewModel.selectedLabelID
                                    if !homePlannerViewModel.selectedLabelID.isEmpty { // Check if the array is not empty
                                        print("selectedLabelIDs: \(homePlannerViewModel.selectedLabelID)") // Print the array of selected IDs
                                        print("isActive    \(isActive)")
                                        print("selected Names :\(selectedNames)")
//                                        homePlannerViewModel.selectedLabelNames = selectedNames
                                        print("homePlannerViewModel.selectedLabelNames   \(homePlannerViewModel.selectedLabelNames)")
                                        if isActive {
                                            print("appears isActive ")
                                            isDiaryTagActive = true
                                            print("isDiaryTagActive \(isDiaryTagActive)")
                                            homePlannerViewModel.ApplyTag(listId: newid, tagIds: homePlannerViewModel.selectedLabelID) // Pass the array
                                            self.isTagSheetVisible = false // Dismiss the sheet
                                            isclicked = true
                                            print("isclicked\(isclicked)")
                                        //                                        print("homePlannerViewModel.selectedLabelID\(homePlannerViewModel.selectedLabelID)")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                                            if homePlannerViewModel.listData.isEmpty {
                                                print("get diary list api is calling")
                                                homePlannerViewModel.GetDiaryDataList()
                                                print("get diary list api is calling")
                                            }
                                        }
                                    }
                                        else {
                                            homePlannerViewModel.ApplyTag(listId: selectedID, tagIds: homePlannerViewModel.selectedLabelID) // Pass the array
                                            self.isTagSheetVisible = false // Dismiss the sheet
                                            isclicked = true
                                            print("isclicked\(isclicked)")
                                            //                                        print("homePlannerViewModel.selectedLabelID\(homePlannerViewModel.selectedLabelID)")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                                                if homePlannerViewModel.listData.isEmpty {
                                                    print("get diary list api is calling")
                                                    homePlannerViewModel.GetDiaryDataList()
                                                    print("get diary list api is calling")
                                                }
                                            }
                                        }
                                    } else {
                                        print("No labels selected") // Log if no labels are selected
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
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .frame(width: 24, height: 24)
                                .padding(.leading, 12)

                            TextField("Filter label", text: $searchText)
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
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .frame(width: 24, height: 24)
                                .padding(.leading, 25)
                                .onTapGesture {
                                    isCreateLabelVisible = true
                                }
                        
                            Button(action: {
                                withAnimation {
    //                                    isTagSheetVisible = false // Dismiss BottomTagSheetView
                                    isCreateLabelVisible = true
                                }
                            }, label: {
                                Text("Create Label")
                                    .foregroundColor(themesviewModel.currentTheme.colorAccent)
                            })
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 10)

                        // Scrollable list with filtered data
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(homePlannerViewModel.TagLabelData.filter { label in
                                    searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
                                }) { label in
                                    HStack {
                                        Button(action: {
                                            toggleCheck(for: label.id) // Toggle state based on the label's ID
                                            print("label.id: \(label.id)")
                                            if !label.isChecked{
                                                // Add the label name to the selectedNames array if it's checked
                                                print("label.labelName.lowercased(): \(label.labelName.lowercased())")
                                                if !selectedNames.contains(label.labelName.lowercased()) {
                                                    selectedNames.append(label.labelName.lowercased())
                                                    print("if case selected names \(selectedNames)")
                                                }
                                            } else {
                                                // Remove the label name from the selectedNames array if it's unchecked
                                                selectedNames.removeAll { $0 == label.labelName.lowercased() }
                                                print("else case selected names \(selectedNames)")
                                            }
                                        }) {
                                            Image(label.isChecked ? "checkbox" : "Check")
                                                .resizable()
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .frame(width: 24, height: 24)
                                                .padding(.leading, 25)
                                        }

                                        Button(action: {
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
                .frame(maxHeight: calculateTotalHeight())
                .background(themesviewModel.currentTheme.windowBackground)
                .cornerRadius(16)
                .shadow(radius: 10)
                .onAppear{
                    homePlannerViewModel.GetTagLabelList()
                    
                    if homePlannerViewModel.NotelistData.isEmpty {
                        homePlannerViewModel.GetDiaryDataList()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let Diary = homePlannerViewModel.listData.first {
                            let incrementedId = Diary.id
                            newid = incrementedId + 1
                            print("Let's check the first newid: \(incrementedId), Incremented newid: \(newid)")
                        } else {
                            print("No diary found with newid: \((newid))")
                        }
                    }
                }

            }

            if isCreateLabelVisible {
                createLabelView(iscreatelabelvisible: $isCreateLabelVisible, Textfill: $Textfill , HomeawaitingVisible: $HomeawaitingViewVisible)
                    .transition(.move(edge: .bottom)) // Smooth transition
                    .animation(.easeInOut)
            }
        }
        .background(
            Color.black.opacity(isCreateLabelVisible ? 0.4 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isTagSheetVisible = false // Dismiss the sheet
                    }
                }
        )
    }
    
    func toggleCheck(for id: Int) {
        if let index = homePlannerViewModel.TagLabelData.firstIndex(where: { $0.id == id }) {
            homePlannerViewModel.TagLabelData[index].isChecked.toggle()
            if homePlannerViewModel.TagLabelData[index].isChecked {
                homePlannerViewModel.selectedLabelID.append(id)
            } else {
                homePlannerViewModel.selectedLabelID.removeAll { $0 == id }
            }
        }
    }

    
//    func handleCheckedLabel(id: Int) {
//        print("Checked label ID: \(id)")
//    }

        
    func calculateTotalHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44 // Estimated height for each row in the list
        let maxHeight: CGFloat = 800 // Maximum height for the entire view
        let totalHeight = baseHeight + (CGFloat(homePlannerViewModel.TagLabelData.count) * rowHeight)
        return min(totalHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
    }
        


}



struct BottomBackgroundSheetView: View {
    
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
        
        // Food backgrounds

//                 
//               ],

    
    // Array of image names for icons


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
                                        print("selectedColor \(correctedHex)")
                                        print("selected ID : \(selectedID)")
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
                            //                                .background(Color.red) // Add this line for debugging
                                .clipShape(Circle())
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 0.5) // Add a border with your desired color and width
                                )
                                .onTapGesture {
                                    selectedToolTip = background.tooltip
                                    
                                    print("selectedToolTip \(selectedToolTip)")
                                    let subImages = background.subImages
                                    print("SubImages Bakcground images:      \(subImages)")
                                    let processedFileNames = subImages.map { image in
                                        image.value
                                            .components(separatedBy: "/")
                                            .last?
                                            .replacingOccurrences(of: ".png", with: "") ?? ""
                                    }
                                    themeimage = background.value
                                    subImage = processedFileNames
                                    print("Processed File Names: \(subImage)")
                                    
                                    print("background image : \(themeimage)")
                                    onTapTheme = true
                                    print("onTapTheme \(onTapTheme)")
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
                            //                                .background(Color.red) // Add this line for debugging
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
            if homePlannerViewModel.listData.isEmpty {
                homePlannerViewModel.GetDiaryDataList()
            }

            // Safely handle any logic without mutating `selectedID`
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let diary = homePlannerViewModel.listData.first(where: { $0.id == selectedID }) {
                    selectedID = diary.id
                    print("Diary found with ID: \(selectedID)")
//                    selectedIconIndex = diary.theme
                    if let theme = diary.theme {
                        selectedIconIndex = theme
                        if let fileName = theme.components(separatedBy: "/").last?.replacingOccurrences(of: ".png", with: "") {
                            selectedIconIndex = fileName
                        }
                        print("themeImage   \(selectedIconIndex)")
                    } else {
                        selectedIconIndex = "" // Default value if theme is nil
                    }
                }
            }
           
        }
    }
}

extension Color {
    // Custom initializer to convert hex color string to Color
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        guard hexSanitized.count == 6 else { return nil }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}


//
//struct BottomSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomSheetView()
//    }
//}

//struct createLabelView: View {
//    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
//    @StateObject var themesviewModel = themesViewModel()
//    @Binding var iscreatelabelvisible: Bool
////    @State private var Textfill: String = ""
//    @Binding var Textfill: String
//
//    var body: some View {
//        ZStack {
//            themesviewModel.currentTheme.windowBackground
//                .ignoresSafeArea() // Ensure the color extends to the edges of the screen
//            
//            VStack {
//                HStack(alignment: .top) {
//                    // Left-aligned close button
//                    Button(action: {
//                        Textfill = ""
//                        iscreatelabelvisible = false
//                    }, label: {
//                        Image("wrongmark")
//                            .renderingMode(.template)
//                            .frame(width: 30 , height: 30)
//                            .padding(.leading , 16)
//                            .foregroundColor(themesviewModel.currentTheme.iconColor)
//                    })
//                    .padding(.leading, 16)
//                    .frame(height: 44) // Ensure consistent height
//                    
//                    // Centered "Create Label" text
//                    Spacer()
//                    Text("Create Label")
//                        .padding() // Add padding around the text
//                        .frame(height: 44) // Ensure consistent height
//                        .foregroundColor(themesviewModel.currentTheme.textColor)
//                    Spacer()
//                    
//                    // Conditionally display "Create" text
//                    if Textfill.count >= 1 {
//                        Text("Create")
//                            .padding() // Add padding around the text
//                            .frame(height: 44) // Ensure consistent height
//                            .foregroundColor(themesviewModel.currentTheme.AllGray)
//                            .padding(.trailing, 16)
//                            .onTapGesture {
//                                homePlannerViewModel.CreateLabelDiary(title: Textfill)
//                                print("CreateLabelDiary")
//                                iscreatelabelvisible = false
//                                Textfill = ""
//                            }
//                    }
//                }
//                .frame(maxWidth: .infinity) // Stretch HStack to full width
//
//                VStack(alignment: .leading) {
//                    Text("Name")
//                        .padding() // Add padding around the text
//                        .padding(.top, 10) // Add top padding
//                        .padding(.leading, 16)
//                        .foregroundColor(themesviewModel.currentTheme.textColor)
//                    
//                    TextField("", text: $Textfill)
//                        .padding()
//                        .foregroundColor(themesviewModel.currentTheme.textColor)
//                        .background(themesviewModel.currentTheme.attachmentBGColor)
//                        .cornerRadius(8) // Rounded corners
//                        .padding(.horizontal)
//                }
//                .frame(maxWidth: .infinity, alignment: .leading) // Make the VStack take up full width and align content to the leading
//
//                Spacer() // Push content up to fill space below
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(themesviewModel.currentTheme.windowBackground)
//        }
//    }
//}

struct DialogView<Content: View>: View {
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
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.clear.edgesIgnoringSafeArea(.all))
    }
}



//#Preview {
//    DiaryView(isDiaryVisible: .constant(true))
//}
