//
//  HomeScreenViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 04/06/24.
//

import Foundation
import SwiftUI

class HomeScreenViewModel:ObservableObject{
  
    @Published var isMenuVisible:Bool = false
    @Published var isComposeEmail:Bool = false
    @Published var error: String?
    @Published var isPlusBtn:Bool = false
    
}

class NavigationViewModel: ObservableObject {
    @Published var currentView: AnyView?
}
