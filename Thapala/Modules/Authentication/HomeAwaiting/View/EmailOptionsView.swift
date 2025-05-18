//
//  EmailOptionsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 20/08/24.
//

import SwiftUI

struct EmailOptionsView: View {
    var replyAction: () -> Void
    var replyAllAction: () -> Void
    var forwardAction: () -> Void
    var markAsReadAction: () -> Void
    var markAsUnReadAction: () -> Void
    var createLabelAction: () -> Void
    var moveToFolderAction: () -> Void
    var starAction: () -> Void
    var snoozeAction: () -> Void
    var trashAction: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView{
                ActionItem(icon: "arrowshape.turn.up.left", label: "Reply", action: replyAction)
                ActionItem(icon: "arrowshape.turn.up.left.2", label: "Reply all", action: replyAllAction)
                ActionItem(icon: "arrowshape.turn.up.right", label: "Forward", action: forwardAction)
                ActionItem(icon: "envelope.open", label: "Mark as read", action: markAsReadAction)
                ActionItem(icon: "envelope", label: "Mark as unread", action: markAsUnReadAction)
                ActionItem(icon: "tag", label: "Label", action: createLabelAction)
                ActionItem(icon: "folder", label: "Move to", action: moveToFolderAction)
                ActionItem(icon: "star", label: "Add Star", action: starAction)
                ActionItem(icon: "clock", label: "Snooze", action: snoozeAction)
                ActionItem(icon: "trash", label: "Trash", action: trashAction)
                Spacer()
            }
        }
        .padding()
    }
}

struct ActionItem: View {
    var icon: String
    var label: String
    var action: () -> Void
    
    var body: some View {
        HStack(spacing:20){
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
                .padding(.leading,20)
            Text(label)
                .font(.custom(.poppinsRegular, size: 18))
                .foregroundColor(.black)
            Spacer()
        }
        .padding(.vertical, 5)
        .onTapGesture {
            action()
        }
    }
}

struct MultiEmailOptionsView: View {
    var markAsReadAction: () -> Void
    var markAsUnReadAction: () -> Void
    var createLabelAction: () -> Void
    var moveToFolderAction: () -> Void
    var snoozeAction: () -> Void
    var trashAction: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ScrollView{
                ActionItem(icon: "envelope.open", label: "Mark as read", action: markAsReadAction)
                ActionItem(icon: "envelope", label: "Mark as unread", action: markAsUnReadAction)
                ActionItem(icon: "tag", label: "Label", action: createLabelAction)
                ActionItem(icon: "folder", label: "Move to", action: moveToFolderAction)
                ActionItem(icon: "clock", label: "Snooze", action: snoozeAction)
                ActionItem(icon: "trash", label: "Trash", action: trashAction)
                Spacer()
            }
        }
        .padding()
    }
}


