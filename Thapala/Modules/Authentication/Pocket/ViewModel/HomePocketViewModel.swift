//
//  HomePocketViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 19/06/24.
//

import Foundation
class HomePocketViewModel:ObservableObject{
    @Published var isLoading = false
    @Published var error: String?
    
    @Published var isComposeEmail:Bool = false
    @Published var selectedOption: PocketOptions? = .earnings
    
    @Published var isEarningSelected = true
    @Published var isPaymentSelected = false
    @Published var isBankDeatilsSelected = false
    
    @Published var earningData:[DummyDataEarning] = [.init(image: "credit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "debit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "credit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "debit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "credit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "debit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "credit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "debit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "debit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "credit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "credit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29"),.init(image: "credit", tCode: "7158880987", type: "Mail", money: "23", subMoney: "Debited", time: "Aug 15 10:29")]
    
    @Published var bankData:[BankDetailed] = [.init(tCode: "1230987654", owner: "Nani"),.init(tCode: "1230987654", owner: "oiu"),.init(tCode: "1230987654", owner: "loe"),.init(tCode: "1230987654", owner: "Low")]
}


enum PocketOptions {
    case earnings
    case payments
    case bankDetails
}


struct DummyDataEarning:Identifiable{
    let id = UUID()
    let image:String
    let tCode:String
    let type:String
    let money:String
    let subMoney:String
    let time:String
}

struct BankDetailed:Identifiable{
    let id = UUID()
    let tCode:String
    let owner:String
}
