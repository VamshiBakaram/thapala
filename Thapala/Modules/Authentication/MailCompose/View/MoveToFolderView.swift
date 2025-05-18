//
//  MoveToFolderView.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/08/24.
//

import SwiftUI

struct MoveToFolderView: View {
    @State private var expandedIndex: Int? = nil
    @State private var selectedChildIndex: UUID? = nil  // Use UUID to track selected child
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var moveToFolderViewModel = MoveToFolderViewModel()
    
    let emailId: [Int]
    
    var body: some View {
        VStack {
            headerView

            Spacer()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .background(Color(red: 112/255, green: 112/255, blue: 112/255))
                .padding(.top, 5)
                .padding([.leading, .trailing], 25)

            folderListView
                .scrollContentBackground(.hidden)
                .offset(y: -20)
        }
        .toast(message: $moveToFolderViewModel.error)
    }

    private var headerView: some View {
        HStack {
            Text("Move To")
                .font(.custom(.poppinsSemiBold, size: 14))
                .padding([.leading, .top], 20)
            Spacer()
            Button {
                moveSelectedItem()
              //  presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Move")
                    .font(.custom(.poppinsRegular, size: 14))
                    .padding([.trailing, .top], 20)
            }
            .disabled(selectedChildIndex == nil)
        }
    }

    private var folderListView: some View {
        List {
            ForEach(moveToFolderViewModel.folderData.indices, id: \.self) { index in
                folderRow(for: index)
            }
            .listRowSeparator(.hidden)
        }
    }

    private func folderRow(for index: Int) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image("folder")
                Text(moveToFolderViewModel.folderData[index].folderName ?? "")
                    .font(.custom(.poppinsBold, size: 14))
                    .padding(.leading, 10)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    toggleExpandedIndex(for: index)
                }
            }

            if expandedIndex == index {
                if let children = moveToFolderViewModel.folderData[index].children {
                    childrenView(children: children)
                }
            }
        }
    }

    private func childrenView(children: [FolderModel]) -> some View {
        ForEach(children) { child in
            childFolderRow(for: child)
        }
    }

    private func childFolderRow(for child: FolderModel) -> some View {
        Text(child.folderName ?? "")
            .font(.custom(.poppinsRegular, size: 14))
            .padding([.leading,.trailing], 50)
            .padding(.top, 5)
            .background(
                    RoundedRectangle(cornerRadius: 10) // Set the desired corner radius
                        .fill(selectedChildIndex == child.idm ? Color(red: 69/255, green: 86/255, blue: 225/255).opacity(0.26) : Color.clear)
                )
            .onTapGesture {
                withAnimation {
                    toggleSelectedChild(for: child)
                }
            }
    }

    private func toggleExpandedIndex(for index: Int) {
        if expandedIndex == index {
            expandedIndex = nil
        } else {
            expandedIndex = index
        }
    }

    private func toggleSelectedChild(for child: FolderModel) {
        if selectedChildIndex == child.idm {
            selectedChildIndex = nil
        } else {
            selectedChildIndex = child.idm
        }
    }

    private func moveSelectedItem() {
        if let selectedChild = moveToFolderViewModel.folderData
            .flatMap({ $0.children ?? [] }) 
            .first(where: { $0.idm == selectedChildIndex }) {

            let folderId = selectedChild.id ?? 0
            let recordName = selectedChild.type?.rawValue ?? ""
            let selectedThreadIDs = emailId

            moveToFolderViewModel.moveToFolder(folderId: folderId, recordName: recordName, selectedThreadIDs: selectedThreadIDs)
        }
    }
}




/*
struct FirstItem: Identifiable {
    let id = UUID()
    let name: String
    let subItems: [SubItem]
}

struct SubItem: Identifiable {
    let id = UUID()
    let name: String
}

let firstListItems = [
    FirstItem(name: "Archive", subItems: [
        SubItem(name: "Files"),
        SubItem(name: "Mails"),
        SubItem(name: "Pictures"),
        SubItem(name: "Videos")
    ]),
    FirstItem(name: "Locker", subItems: [
        SubItem(name: "Files"),
        SubItem(name: "Mails"),
        SubItem(name: "Pictures"),
        SubItem(name: "Videos")
    ]),
    FirstItem(name: "Work", subItems: [
        SubItem(name: "Files"),
        SubItem(name: "Mails"),
        SubItem(name: "Pictures"),
        SubItem(name: "Videos")
    ])
]
*/
struct MoveToFolderView_Previews: PreviewProvider {
    static var previews: some View {
        MoveToFolderView( emailId: [1,2])
    }
}
