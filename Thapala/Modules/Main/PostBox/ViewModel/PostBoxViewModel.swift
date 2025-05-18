//
//  PostBoxViewModel.swift
//  Thapala
//
//  Created by ahex on 08/08/24.
//

import Foundation

class PostBoxViewModel: ObservableObject {
    @Published private (set) var postBoxOptions: [PostBoxOption] = [.init(name: "Emails", selectedImage: "selectedEmail", unSelectedImage: "selectedEmail", isSelected: true), .init(name: "Print", selectedImage: "selectedEmail", unSelectedImage: "selectedEmail", isSelected: false), .init(name: "Chat box", selectedImage: "selectedChatBox", unSelectedImage: "selectedEmail", isSelected: false)]
}
