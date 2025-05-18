//
//  MoveTo.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import SwiftUI

struct MoveTo: View {
    @ObservedObject var BottomsheetviewModel = BottomSheetViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @State private var isMoveVisible: Bool = false
    @Binding var isMoveToSheetVisible: Bool
    var body: some View {
        ZStack {
            // Main BottomTagSheetView content
            if !isMoveVisible {
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image("back")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .padding(.leading, 10)
                            Text("Move to")
                                .font(.headline)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.leading, 16)
                          }
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundColor(themesviewModel.currentTheme.strokeColor)
                            .padding(.horizontal, 16)
                        
                        HStack {
                            Image("Moveto")
                                .renderingMode(.template)
                                .foregroundColor(Color.blue)
                                .padding(.leading, 10)
                            Text("Work")
                                .fontWeight(.bold)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.leading, 5)
                            Spacer()
                            Button(action: {
//                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Move")
                                    .padding(.all ,5)
                                    .fontWeight(.bold)
                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .background(themesviewModel.currentTheme.colorPrimary)
                                    .cornerRadius(10)
                            }
                            
                            .padding(.trailing , 16)
                        }
                        HStack {
                            Image("Moveto")
                                .renderingMode(.template)
                                .foregroundColor(Color.blue)
                                .padding(.leading, 10)
                            Text("archive")
                                .fontWeight(.bold)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.leading, 5)
                            Spacer()
                            Button(action: {
//                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Move")
                                    .padding(.all ,5)
                                    .fontWeight(.bold)
                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .background(themesviewModel.currentTheme.colorPrimary)
                                    .cornerRadius(10)
                            }
                            .padding(.trailing , 16)
                        }
                        HStack {
                            Image("Moveto")
                                .renderingMode(.template)
                                .foregroundColor(Color.blue)
                                .padding(.leading, 10)
                            Text("locker")
                                .fontWeight(.bold)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.leading, 5)
                            Spacer()
                            Button(action: {
//                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Move")
                                    .padding(.all ,5)
                                    .fontWeight(.bold)
                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .background(themesviewModel.currentTheme.colorPrimary)
                                    .cornerRadius(10)
                            }
                            .padding(.trailing , 16)
                        }
                            
                     }
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: calculateTotalHeight())
                .background(themesviewModel.currentTheme.windowBackground)
                .cornerRadius(16)
                .shadow(radius: 10)
             }
       }
        .background(
            Color.black.opacity(isMoveVisible ? 0.4 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isMoveToSheetVisible = false // Dismiss the sheet
                    }
                }
        )
                                         
    }
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
//    MoveTo(isMoveToSheetVisible: $isMoveToSheetVisible)
//}
