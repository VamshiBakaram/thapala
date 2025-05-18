//
//  CreateTagLabel.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import SwiftUI

struct CreateTagLabel: View {
    @ObservedObject var BottomsheetviewModel = BottomSheetViewModel()
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
                                    selectedNewDiaryTag = BottomsheetviewModel.selectedLabelID
                                    if !BottomsheetviewModel.selectedLabelID.isEmpty { // Check if the array is not empty
                                        print("selectedLabelIDs: \(BottomsheetviewModel.selectedLabelID)") // Print the array of selected IDs
                                        print("isActive    \(isActive)")
                                        print("selected Names :\(selectedNames)")
//                                        homePlannerViewModel.selectedLabelNames = selectedNames
                                        print("BottomsheetviewModel.selectedLabelNames   \(BottomsheetviewModel.selectedLabelNames)")
                                        if isActive {
                                            print("appears isActive ")
                                            isDiaryTagActive = true
                                            print("isDiaryTagActive \(isDiaryTagActive)")
//                                            BottomsheetviewModel.ApplyTag(listId: newid, tagIds: homePlannerViewModel.selectedLabelID) // Pass the array
                                            self.isTagSheetVisible = false // Dismiss the sheet
                                            isclicked = true
                                            print("isclicked\(isclicked)")
                                        //                                        print("homePlannerViewModel.selectedLabelID\(homePlannerViewModel.selectedLabelID)")
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
//                                            if homePlannerViewModel.listData.isEmpty {
//                                                print("get diary list api is calling")
//                                                homePlannerViewModel.GetDiaryDataList()
//                                                print("get diary list api is calling")
//                                            }
//                                        }
                                    }
                                        else {
//                                            homePlannerViewModel.ApplyTag(listId: selectedID, tagIds: homePlannerViewModel.selectedLabelID) // Pass the array
                                            self.isTagSheetVisible = false // Dismiss the sheet
                                            isclicked = true
                                            print("isclicked\(isclicked)")
                                            //                                        print("homePlannerViewModel.selectedLabelID\(homePlannerViewModel.selectedLabelID)")
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
//                                                if homePlannerViewModel.listData.isEmpty {
//                                                    print("get diary list api is calling")
//                                                    homePlannerViewModel.GetDiaryDataList()
//                                                    print("get diary list api is calling")
//                                                }
//                                            }
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
//                            VStack(alignment: .leading, spacing: 10) {
//                                ForEach(BottomsheetviewModel.TagLabelData.filter { label in
//                                    searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
//                                }) { label in
//                                    HStack {
//                                        Button(action: {
//                                            toggleCheck(for: label.id) // Toggle state based on the label's ID
//                                            print("label.id: \(label.id)")
//                                            if !label.isChecked{
//                                                // Add the label name to the selectedNames array if it's checked
//                                                print("label.labelName.lowercased(): \(label.labelName.lowercased())")
//                                                if !selectedNames.contains(label.labelName.lowercased()) {
//                                                    selectedNames.append(label.labelName.lowercased())
//                                                    print("if case selected names \(selectedNames)")
//                                                }
//                                            } else {
//                                                // Remove the label name from the selectedNames array if it's unchecked
//                                                selectedNames.removeAll { $0 == label.labelName.lowercased() }
//                                                print("else case selected names \(selectedNames)")
//                                            }
//                                        }) {
//                                            Image(label.isChecked ? "checkbox" : "Check")
//                                                .resizable()
//                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
//                                                .frame(width: 24, height: 24)
//                                                .padding(.leading, 25)
//                                        }
//
//                                        Button(action: {
//                                        }) {
//                                            Text(label.labelName)
//                                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                        }
//                                        .padding(.trailing, 16)
//                                    }
//                                    .padding(.top, 10)
//                                }
//                            }
//                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: calculateTotalHeight())
                .background(themesviewModel.currentTheme.windowBackground)
                .cornerRadius(16)
                .shadow(radius: 10)
//                .onAppear{
//                    homePlannerViewModel.GetTagLabelList()
//                    
//                    if homePlannerViewModel.NotelistData.isEmpty {
//                        homePlannerViewModel.GetDiaryDataList()
//                    }
//                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        if let Diary = homePlannerViewModel.listData.first {
//                            let incrementedId = Diary.id
//                            newid = incrementedId + 1
//                            print("Let's check the first newid: \(incrementedId), Incremented newid: \(newid)")
//                        } else {
//                            print("No diary found with newid: \((newid))")
//                        }
//                    }
//                }

            }

            if isCreateLabelVisible {
                createLabelView(iscreatelabelvisible: $isCreateLabelVisible, Textfill: $Textfill)
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
//        if let index = homePlannerViewModel.TagLabelData.firstIndex(where: { $0.id == id }) {
//            homePlannerViewModel.TagLabelData[index].isChecked.toggle()
//            if homePlannerViewModel.TagLabelData[index].isChecked {
//                homePlannerViewModel.selectedLabelID.append(id)
//            } else {
//                homePlannerViewModel.selectedLabelID.removeAll { $0 == id }
//            }
//        }
    }

    
//    func handleCheckedLabel(id: Int) {
//        print("Checked label ID: \(id)")
//    }

        
    func calculateTotalHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44 // Estimated height for each row in the list
        let maxHeight: CGFloat = 800 // Maximum height for the entire view
//        let totalHeight = baseHeight + (CGFloat(homePlannerViewModel.TagLabelData.count) * rowHeight)
        let totalHeight: CGFloat = 200
        return min(totalHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
    }
        


}
//#Preview {
//    CreateTagLabel()
//}
