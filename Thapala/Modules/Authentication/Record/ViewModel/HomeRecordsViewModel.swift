//
//  HomeRecordsViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 19/06/24.
//

import Foundation
class HomeRecordsViewModel:ObservableObject{
    @Published var isLoading = false
    @Published var error: String?
    
    @Published var isComposeEmail:Bool = false
    @Published var selectedOption: RecordsOptions? = .work
    
    @Published var isWorkSelected:Bool = true
    @Published var isArchiveSelected:Bool = false
    @Published var isLockerSelected:Bool = false
    @Published var isSubMenu:Bool = false
    @Published var isNewFolder:Bool = false
    @Published var isFileUpload:Bool = false
    @Published var isPlusBtn:Bool = false
    
}


enum RecordsOptions {
    case work
    case archive
    case locker
}
