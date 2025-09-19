//
//  PlannerAddTaskView.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import SwiftUI

struct PlannerAddTaskView: View {
    @Binding var isAddTaskVisible: Bool
    @StateObject private var plannerAddTaskViewModel = PlannerAddTaskViewModel()
    @StateObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @Binding var type: String
    @Binding var search: String
    @Binding var selectState: String
    @Binding var searchText: String
    @Binding var reminderText: String
    @Binding var StartDateTimeInterval: Int
    @Binding var EndDateTimeInterval: Int
    @State private var startDate: String = ""
    @State private var EndDate: String = ""
    @State private var listView: Bool = false
    @State private var isDatePickerVisible = false
    @State private var isEndDatePickerVisible = false
    @State private var selectedDate = Date()
    @State private var selectedEndDate = Date()
    @State private var notificationPressed: Bool = false

    var body: some View {
        ZStack {
            
            VStack(spacing: 16) {
                // Header Section
                HStack {
                    TextField("", text: $search, prompt: Text("Search").foregroundColor(themesviewModel.currentTheme.textColor))
                        .background(themesviewModel.currentTheme.windowBackground)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .cornerRadius(5)
                        .padding(.horizontal , 16)
                    Spacer()
                    Button(action: {
                        self.isAddTaskVisible = false
                    }, label: {
                        Image("cross")
                            .resizable()
                            .frame(width: 20 , height: 20)
                    })
                }
                .padding(.top, 25)
                .padding(.trailing, 15)
                
                Divider()
                    .frame(height: 1)
                    .background(themesviewModel.currentTheme.strokeColor.opacity(0.5))
                    .padding(.horizontal, 10)
                                
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        plannerSearchTextField(placeHolder: "Start Date", text: $startDate){}
                            .onTapGesture {
                                isDatePickerVisible = true
                            }
                        
                        plannerSearchTextField(placeHolder: "Select Label", text: $searchText) {

                                Image("arrowDown")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .padding(.leading, 5)
                                    .onTapGesture {
                                         listView = true
                                     }
                        }
                        .onChange(of: searchText) { newValue in
                            // Show dropdown only if user is typing and hasn't selected a label yet
                            if !newValue.isEmpty && listView == false {
                                listView = true
                            }
                        }
                    }
                    .padding(.leading , 16)
                    
                    
                    Spacer()
                        .frame(width: 10)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        plannerSearchTextField(placeHolder: "End Date", text: $EndDate){}
                            .onTapGesture {
                                isEndDatePickerVisible = true
                            }
                        
                        Menu {
                            Button("Todo") { selectState = "todo" }
                            Button("InProgress") { selectState = "inprogress" }
                            Button("Completed") { selectState = "completed" }
                        } label: {
                            plannerSearchTextField(placeHolder: "Select State", text: $selectState) {
                                Image("arrowDown")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .padding(.leading, 5)
                            }
                        }


                    }
                    .padding(.leading , 16)
                }
                
                // Action Buttons Section
                HStack(spacing: 16) {
                    Button(action: {
                        notificationPressed.toggle()
                        if notificationPressed {
                            reminderText =  "reminder"
                        }
                    }) {
                        Image("bellnotification")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 22)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .padding(10) // Add padding to make the circle bigger than icon
                            .background(notificationPressed ? Color.gray : Color.clear)
                            .clipShape(Circle())
                    }
                    .padding(.leading, 15)
                    
                    Spacer()
                    
                    Text("Reset")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(themesviewModel.currentTheme.allBlack)
                        .padding()
                        .frame(width: 100, height: 40)
                        .background(themesviewModel.currentTheme.attachmentBGColor)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                        )
                        .padding(.trailing, 5)
                        .onTapGesture {
                            startDate = ""
                            EndDate = ""
                            searchText = ""
                            selectState = ""
                            search = ""
                            listView = false
                        }
                    
                    Text("Search")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding()
                        .frame(width: 100, height: 40)
                        .background(themesviewModel.currentTheme.colorPrimary)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.trailing, 16)
                        .onTapGesture{
                            homePlannerViewModel.GetSearchList(query: search, type: type, page: 1, pageSize: 30, searchType: reminderText, status: selectState, labelname: searchText, startdate: StartDateTimeInterval, enddate: EndDateTimeInterval)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.isAddTaskVisible = false
                            }
                        }

                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .padding(.top, 10)
            }
            .background(themesviewModel.currentTheme.windowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 15.3))
            .padding(.horizontal, 25)
            .padding(.vertical, 25)
            .onAppear{
                homePlannerViewModel.GetTagDoitLabelList()
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
                                    let timestamp = Int(selectedDate.timeIntervalSince1970) // seconds
                                    StartDateTimeInterval = timestamp
                                    homePlannerViewModel.selectedDateTime = selectedDate
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd-MMM-yyyy"
                                    startDate = formatter.string(from: selectedDate)
                                    isDatePickerVisible = false
                                }
                            )
                            .offset(y: 100)
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
                                    let timestamp = Int(selectedEndDate.timeIntervalSince1970) // seconds
                                    EndDateTimeInterval = timestamp
                                    homePlannerViewModel.selectedEndDateTime = selectedEndDate
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "dd-MMM-yyyy"
                                    EndDate = formatter.string(from: selectedEndDate)
                                    isEndDatePickerVisible = false
                                          print("EndDate  \(EndDate)")
                                }
                            )
                            .offset(y: 100)
                        }

                    }
                )
            
            
            if listView {
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(homePlannerViewModel.tagLabelDoItData.filter { label in
                                searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
                            }) { label in
                                Button(action: {
                                    withAnimation {
                                        searchText = label.labelName // update textfield
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        listView = false
                                    }
                                }) {
                                    Text(label.labelName)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14))
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: calculateDropdownHeight())
                .padding(.horizontal, 40)
                .padding(.top, 220)
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func calculateDropdownHeight() -> CGFloat {
        let filteredCount = homePlannerViewModel.tagLabelDoItData.filter { label in
            searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
        }.count
        
        let rowHeight: CGFloat = 40  // each label button height
        let spacing: CGFloat = 10    // spacing between rows
        let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.5
        
        let totalHeight = CGFloat(filteredCount) * (rowHeight + spacing)
        
        return min(totalHeight, maxHeight)
    }

}

//#Preview {
//    PlannerAddTaskView(isAddTaskVisible: .constant(true))
//}








//struct ContentView: View {
//    @ObservedObject var consoleViewModel = ConsoleViewModel()
//    @ObservedObject var themesviewModel = ThemesViewModel()
//    @StateObject var mailComposeViewModel = MailComposeViewModel()
//    @State private var isMailViewActive = false
//    @State private var isBluePrintViewActive = false
//    @State private var isQuickAccessViewActive = false
//    @State private var isPlannerViewActive = false
//    @State private var isConsoleViewActive = false
//    @State private var conveyedView: Bool = false
//    @State private var PostBoxView: Bool = false
//    @State private var SnoozedView: Bool = false
//    @State private var AwaitingView: Bool = false
//    @State private var markAs : Int = 0
//    var body: some View {
//        TabView {
//            HomeAwaitingView(imageUrl: "")
//                .tabItem {
//                    VStack(alignment: .leading, spacing: 5) {
//                        Button(action: {
//                            if !isMailViewActive {
//                                isMailViewActive = true
//                            }
//                        }) {
//                            Image("mailicon")
//                                .resizable()
//                                .renderingMode(.template)
//                                .scaledToFit()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(isMailViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                        }
//                        Text("Mail")
//                            .font(.system(size: 16))
//                            .foregroundColor(isMailViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 20)
//                }
//            
//            BlueprintView(imageUrl: "")
//                .tabItem {
//                    VStack(alignment: .leading, spacing: 5) {
//                        Button(action: {
//                            if !isBluePrintViewActive {
//                                isBluePrintViewActive = true
//                            }
//                        }) {
//                            Image("plannerImage")
//                                .resizable()
//                                .renderingMode(.template)
//                                .scaledToFit()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(isBluePrintViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                        }
//                        Text("Blue Print")
//                            .font(.system(size: 12))
//                            .foregroundColor(isBluePrintViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 20)
//                }
//            
//            MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView, conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars, markAs: $markAs)
//                .tabItem {
//                    VStack(alignment: .leading, spacing: 5) {
//                        Button(action: {
//                            if !isQuickAccessViewActive {
//                                isQuickAccessViewActive = true
//                            }
//                        }) {
//                            Image("QuickAcces")
//                                .resizable()
//                                .renderingMode(.template)
//                                .scaledToFit()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(isQuickAccessViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                        }
//                        Text("Quick Access")
//                            .font(.system(size: 12))
//                            .foregroundColor(isQuickAccessViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 20)
//                }
//            
//            HomePlannerView()
//                .tabItem {
//                    VStack(alignment: .leading, spacing: 5) {
//                        Button(action: {
//                            if !isPlannerViewActive {
//                                isPlannerViewActive = true
//                            }
//                        }) {
//                            Image("plannerIcon")
//                                .resizable()
//                                .renderingMode(.template)
//                                .scaledToFit()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(isPlannerViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                        }
//                        Text("Planner")
//                            .font(.system(size: 12))
//                            .foregroundColor(isPlannerViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 20)
//                }
//            
//            BlueprintView(imageUrl: "")
//                .tabItem {
//                    VStack(alignment: .leading, spacing: 5) {
//                        Button(action: {
//                            if !isConsoleViewActive {
//                                isConsoleViewActive = true
//                            }
//                        }) {
//                            Image("ConsoleIcon")
//                                .resizable()
//                                .renderingMode(.template)
//                                .scaledToFit()
//                                .frame(width: 24, height: 24)
//                                .foregroundColor(isConsoleViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                        }
//                        Text("Console")
//                            .font(.system(size: 12))
//                            .foregroundColor(isConsoleViewActive ? themesviewModel.currentTheme.tabIndicatorColor: themesviewModel.currentTheme.iconColor)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 20)                }
//            
//        }
//        .background(themesviewModel.currentTheme.bottomSheetBG)
//    }
//}

