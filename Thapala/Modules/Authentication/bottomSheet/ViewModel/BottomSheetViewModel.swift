//
//  BottomSheetViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import Foundation
import SwiftUI

class BottomSheetViewModel: ObservableObject {
    @Published var selectedLabelID: [Int] = []
    @Published var selectedLabelNames: [String] = []
    @Published var isLabelView:Bool = false
    @Published var isMoveToView:Bool = false
}
