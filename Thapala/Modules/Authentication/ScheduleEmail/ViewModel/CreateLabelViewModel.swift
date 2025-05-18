//
//  CreateLabelViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import Foundation
class CreateLabelViewModel:ObservableObject{
    @Published var filterLabelTF = ""
    @Published var moveToCreateNewlabelView:Bool = false
    
}
