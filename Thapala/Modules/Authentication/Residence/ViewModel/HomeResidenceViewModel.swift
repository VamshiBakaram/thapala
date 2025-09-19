//
//  HomeResidenceViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 18/06/24.
//

import Foundation
class HomeResidenceViewModel:ObservableObject{
    @Published var isDirectorySelected = true
    @Published var isFamilySelected = false
    @Published var isAddNewGroupSelected = false
    @Published var selectedOption: ResidenceOptions? = .directory
    
    @Published var isLoading = false
    @Published var error: String?
    
    @Published var isComposeEmail:Bool = false
    @Published var isDetailedData:Bool = false
    @Published var isCreateNewGroup:Bool = false
    @Published var groupName = ""
    @Published var directoryData:[DummyData] = [.init(image: "person", title: "Coopoer", subTitle: "Doctor", finalTitle: "Palwancha.India"),.init(image: "person", title: "Coopoer", subTitle: "Doctor", finalTitle: "Palwancha.India"),.init(image: "person", title: "Coopoer", subTitle: "Doctor", finalTitle: "Palwancha.India"),.init(image: "person", title: "Coopoer", subTitle: "Doctor", finalTitle: "Palwancha.India")]
    
}



enum ResidenceOptions {
    case directory
    case family
    case addNewGroup
}
