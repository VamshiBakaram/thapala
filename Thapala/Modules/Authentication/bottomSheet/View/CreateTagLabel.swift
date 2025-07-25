//
//  CreateTagLabel.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import SwiftUI

struct CreateTagLabel: View {
    @StateObject var BottomsheetviewModel = BottomSheetViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @StateObject var LabelsMailViewModel = LabelledMailsViewModel()
    @StateObject private var homePostboxViewModel = HomePostboxViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var mailFullViewModel = MailFullViewModel()
    @Binding var isTagSheetVisible: Bool
    @Binding var isActive: Bool
    @Binding var HomeawaitingViewVisible: Bool
    @Binding var selectedNewBottomTag: [Int]
    @Binding var selectedNames: [String]
    @State var comment: String = ""
    @Binding var selectedID: [Int]
    @Binding var isclicked: Bool
    @Binding var isCheckedLabelID: [Int]
    @State private var searchText: String = ""
    @State private var isCreateLabelVisible: Bool = false // Tracks visibility of createLabelView
//    @State var labelname: String = ""
    @State private var Textfill: String = ""
    @State private var isChecked: Bool = false
    @State var newid:Int = 0
    @State private var isBottomTagActive: Bool = false
    @State private var passwordHash: String = ""
    @State var Tag: String = ""
    @State private var emailData: EmailsByIdModel?
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .contentShape(Rectangle())
                .onTapGesture {
                    if isCreateLabelVisible == false {
                        withAnimation {
                            isTagSheetVisible = false
                        }
                    }
                }

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
                                    selectedNewBottomTag = LabelsMailViewModel.selectedLabelID
                                    if !LabelsMailViewModel.selectedLabelID.isEmpty { // Check if the array is not empty
                                        if isActive {
                                            isBottomTagActive = true
                                            self.isTagSheetVisible = false // Dismiss the sheet
                                            isclicked = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                                            if homePostboxViewModel.postBoxEmailData.isEmpty {
                                                homePostboxViewModel.getPostEmailData()
                                            }
                                        }
                                    }
                                        
//                                        else if HomeawaitingViewVisible {
//                                            homeAwaitingViewModel.ApplyLabel(LabelId:  LabelsMailViewModel.selectedLabelID, threadId: [selectedID])
//                                        }
                                            
                                        else {
                                            homeAwaitingViewModel.ApplyLabel(LabelId:  LabelsMailViewModel.selectedLabelID, threadId: selectedID)
                                            self.isTagSheetVisible = false // Dismiss the sheet
                                            isclicked = true


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
                                let filteredLabels = LabelsMailViewModel.labelledMailsDataModel.filter { label in
                                    searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
                                }

                                ForEach(filteredLabels) { label in
                                    VStack(alignment: .leading) {

                                        HStack {
                                            Button(action: {
                                                toggleCheck(for: label.id)
                                                
                                                if !label.isChecked {
                                                    if !selectedNames.contains(label.labelName.lowercased()) {
                                                        selectedNames.append(label.labelName.lowercased())
                                                    }
                                                } else {
                                                    selectedNames.removeAll { $0 == label.labelName.lowercased() }
                                                }
                                            }) {
                                                Image(systemName: LabelsMailViewModel.selectedLabelID.contains(label.id) ? "checkmark.square" : "square")
                                                    .resizable()
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .frame(width: 24, height: 24)
                                                    .padding(.leading, 25)
                                            }

                                            Button(action: {
                                            }) {
                                                Text(label.labelName)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14))
                                            }
                                            .padding(.trailing, 16)
                                        }
                                        .padding(.top, 8)
                                    }
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
                    LabelsMailViewModel.selectedLabelID = isCheckedLabelID
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        LabelsMailViewModel.getLabelledEmailData()
                    }
                    
                    if homePostboxViewModel.postBoxEmailData.isEmpty {
                        homePostboxViewModel.getPostEmailData()
                    }
//
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let Diary = homePostboxViewModel.postBoxEmailData.first {
                            let incrementedId = Diary.id
                            newid = incrementedId! + 1
                        }
                    }
                }

            }

            if isCreateLabelVisible {
                createLabelView(iscreatelabelvisible: $isCreateLabelVisible, Textfill: $Textfill,HomeawaitingVisible: $HomeawaitingViewVisible)
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
        if let index = LabelsMailViewModel.labelledMailsDataModel.firstIndex(where: { $0.id == id }) {
            LabelsMailViewModel.labelledMailsDataModel[index].isChecked.toggle()
            if LabelsMailViewModel.labelledMailsDataModel[index].isChecked ?? false {
                LabelsMailViewModel.selectedLabelID.append(id)
            } else {
                LabelsMailViewModel.selectedLabelID.removeAll { $0 == id }
            }
            // keep in sync!
        }
    }

        
    func calculateTotalHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Space for title, search, create button, paddings
        let rowHeight: CGFloat = 50 // Approx height for each label row (button + text)
        let spacing: CGFloat = 10 // Spacing between rows

        let labelCount = LabelsMailViewModel.labelledMailsDataModel.filter { label in
            searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
        }.count

        let listHeight = CGFloat(labelCount) * (rowHeight + spacing)

        let totalHeight = baseHeight + listHeight

        let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.65 // For safety, max 80% of screen

        return min(totalHeight, maxHeight)
    }
}



struct createLabelView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @Binding var iscreatelabelvisible: Bool
//    @State private var Textfill: String = ""
    @Binding var Textfill: String
    @Binding var HomeawaitingVisible: Bool
    var body: some View {
        ZStack {
            themesviewModel.currentTheme.windowBackground
                .ignoresSafeArea() // Ensure the color extends to the edges of the screen
            
            VStack {
                HStack(alignment: .top) {
                    // Left-aligned close button
                    Button(action: {
                        Textfill = ""
                        iscreatelabelvisible = false
                    }, label: {
                        Image("wrongmark")
                            .renderingMode(.template)
                            .frame(width: 30 , height: 30)
                            .padding(.leading , 16)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    })
                    .padding(.leading, 16)
                    .frame(height: 44) // Ensure consistent height
                    
                    // Centered "Create Label" text
                    Spacer()
                    Text("Create Label")
                        .padding() // Add padding around the text
                        .frame(height: 44) // Ensure consistent height
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    Spacer()
                    
                    // Conditionally display "Create" text
                    if Textfill.count >= 1 {
                        Text("Create")
                            .padding() // Add padding around the text
                            .frame(height: 44) // Ensure consistent height
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .padding(.trailing, 16)
                            .onTapGesture {
                                if HomeawaitingVisible {
                                    homeAwaitingViewModel.createLabel(createLabelName: Textfill)
                                }
                                else {
                                    homePlannerViewModel.CreateLabelDiary(title: Textfill)
                                }
                                iscreatelabelvisible = false
                                Textfill = ""
                            }
                    }
                }
                .frame(maxWidth: .infinity) // Stretch HStack to full width

                VStack(alignment: .leading) {
                    Text("Name")
                        .padding() // Add padding around the text
                        .padding(.top, 10) // Add top padding
                        .padding(.leading, 16)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    
                    TextField("", text: $Textfill)
                        .padding()
                        .foregroundColor(themesviewModel.currentTheme.AllBlack)
                        .background(themesviewModel.currentTheme.attachmentBGColor)
                        .cornerRadius(8) // Rounded corners
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Make the VStack take up full width and align content to the leading

                Spacer() // Push content up to fill space below
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(themesviewModel.currentTheme.windowBackground)
        }
    }
}
//#Preview {
//    CreateTagLabel()
//}
