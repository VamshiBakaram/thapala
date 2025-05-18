//
//  postBoxMoreSheet.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import SwiftUI

struct postBoxMoreSheet: View {
    @ObservedObject var BottomsheetviewModel = BottomSheetViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @State private var isMoreVisible: Bool = false
    @Binding var isMoreSheetVisible: Bool
    @Binding var conveyedView: Bool
    var body: some View {
        ZStack {
            // Main BottomTagSheetView content
            if !isMoreVisible {
                if conveyedView {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("Reply")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                Text("Reply")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                            HStack {
                                Image("Forward")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                Text("Forward")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                            HStack {
                                Image("emptystar")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                Text("Add Star")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)  // stretch HStack full-width
                        .padding(.leading, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: calculateTotalHeight())
                    .background(themesviewModel.currentTheme.windowBackground)
                    .cornerRadius(16)
                    .shadow(radius: 10)
                }
                else {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("Reply")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                Text("Reply")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                            HStack {
                                Image("Forward")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                Text("Forward")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                            HStack {
                                Image("Tags")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                Text("Label")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                            HStack {
                                Image("emptystar")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                Text("Add Star")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                            HStack {
                                Image("timer")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                Text("Snooze")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                         }
                        .frame(maxWidth: .infinity, alignment: .leading)  // stretch HStack full-width
                        .padding(.leading, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: calculateTotalHeight())
                    .background(themesviewModel.currentTheme.windowBackground)
                    .cornerRadius(16)
                    .shadow(radius: 10)

                }
             }
       }
        .background(
            Color.black.opacity(isMoreVisible ? 0.4 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isMoreSheetVisible = false // Dismiss the sheet
                    }
                }
        )
                                         
    }
    func calculateTotalHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44 // Estimated height for each row in the list
        let maxHeight: CGFloat = 800 // Maximum height for the entire view
//        let totalHeight = baseHeight + (CGFloat(homePlannerViewModel.TagLabelData.count) * rowHeight)
        let totalHeight: CGFloat = 250
        return min(totalHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
    }
}

//#Preview {
//    postBoxMoreSheet(isMoreSheetVisible: false)
//}
