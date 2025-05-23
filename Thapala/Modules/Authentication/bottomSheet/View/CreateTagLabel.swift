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
    @ObservedObject var LabelsMailViewModel = LabelledMailsViewModel()
    @ObservedObject private var homePostboxViewModel = HomePostboxViewModel()
    @Binding var isTagSheetVisible: Bool
    @Binding var isActive: Bool
    @Binding var selectedNewBottomTag: [Int]
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
    @State private var isBottomTagActive: Bool = false
    @State var Tag: String = ""
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
                                        print("selectedLabelIDs: \(LabelsMailViewModel.selectedLabelID)") // Print the array of selected IDs
                                        print("isActive    \(isActive)")
                                        print("selected Names :\(selectedNames)")
//                                        homePlannerViewModel.selectedLabelNames = selectedNames
                                        print("LabelsMailViewModel.selectedLabelNames   \($LabelsMailViewModel.selectedLabelNames)")
                                        if isActive {
                                            print("appears isActive ")
                                            isBottomTagActive = true
                                            print("isBottomTagActive \(isBottomTagActive)")
//                                            BottomsheetviewModel.ApplyTag(listId: newid, tagIds: homePlannerViewModel.selectedLabelID) // Pass the array
                                            self.isTagSheetVisible = false // Dismiss the sheet
                                            isclicked = true
                                            print("isclicked\(isclicked)")
                                        //                                        print("homePlannerViewModel.selectedLabelID\(homePlannerViewModel.selectedLabelID)")
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                                            if homePostboxViewModel.postBoxEmailData.isEmpty {
                                                print("get diary list api is calling")
                                                homePostboxViewModel.getPostEmailData()
                                                print("get diary list api is calling")
                                            }
                                        }
                                    }
                                        else {
//                                            homePlannerViewModel.ApplyTag(listId: selectedID, tagIds: homePlannerViewModel.selectedLabelID) // Pass the array
                                            self.isTagSheetVisible = false // Dismiss the sheet
                                            isclicked = true
                                            print("isclicked\(isclicked)")
                                            //                                        print("homePlannerViewModel.selectedLabelID\(homePlannerViewModel.selectedLabelID)")
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 200 / 1000.0) {
                                                if homePostboxViewModel.postBoxEmailData.isEmpty {
                                                    print("get diary list api is calling")
                                                    homePostboxViewModel.getPostEmailData()
                                                    print("get diary list api is calling")
                                                }
                                            }                                   }
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
                                let filteredLabels = LabelsMailViewModel.labelledMailsDataModel.filter { label in
                                    searchText.isEmpty || label.labelName.lowercased().contains(searchText.lowercased())
                                }

                                ForEach(filteredLabels) { label in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("hello vamshi")
                                                .foregroundColor(.red)
                                            Text("hey vamshi")
                                                .foregroundColor(.red)
                                        }

                                        HStack {
                                            Button(action: {
                                                toggleCheck(for: label.id)
                                                print("Tapped on label.id: \(label.id)")

                                                if !label.isChecked {
                                                    if !selectedNames.contains(label.labelName.lowercased()) {
                                                        selectedNames.append(label.labelName.lowercased())
                                                        print("Added: \(selectedNames)")
                                                    }
                                                } else {
                                                    selectedNames.removeAll { $0 == label.labelName.lowercased() }
                                                    print("Removed: \(selectedNames)")
                                                }
                                            }) {
                                                Image(systemName: label.isChecked ? "checkmark.square" : "square")
                                                    .resizable()
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .frame(width: 24, height: 24)
                                                    .padding(.leading, 25)
                                            }

                                            Button(action: {
                                                print("Label name tapped: \(label.labelName)")
                                            }) {
                                                Text(label.labelName)
                                                    .foregroundColor(.red)
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


                    LabelsMailViewModel.getLabelledEmailData()
//                    if LabelsMailViewModel.labelledMailsDataModel.isEmpty {
//                        LabelsMailViewModel.getLabelledEmailData()
//                    }
                    if homePostboxViewModel.postBoxEmailData.isEmpty {
                        homePostboxViewModel.getPostEmailData()
                    }
//
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let Diary = homePostboxViewModel.postBoxEmailData.first {
                            let incrementedId = Diary.id
                            newid = incrementedId! + 1
                            print("Let's check the first newid: \(incrementedId), Incremented newid: \(newid)")
                        }
                            else {
                            print("No diary found with newid: \((newid))")
                        }
                    }
                }

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
        if let index = LabelsMailViewModel.labelledMailsDataModel.firstIndex(where: { $0.id == id }) {
            LabelsMailViewModel.labelledMailsDataModel[index].isChecked.toggle()
            if LabelsMailViewModel.labelledMailsDataModel[index].isChecked {
                LabelsMailViewModel.selectedLabelID.append(id)
            } else {
                LabelsMailViewModel.selectedLabelID.removeAll { $0 == id }
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
        let totalHeight: CGFloat = 500
        return min(totalHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
    }
        


}
//#Preview {
//    CreateTagLabel()
//}
