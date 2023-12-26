//
//  Card.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import Foundation
import SwiftData

enum CardType: String, Codable, CaseIterable {
    case visa = "VISA"
    case mastercard = "Mastercard"
    case amex = "American Express"
}

@Model
final class CreditCard {
    var nickname: String
    var type: CardType
    @Relationship(deleteRule: .nullify, inverse: \Transaction.card) var transactions = [Transaction]()
    
    init(nickname: String, type: CardType, transactions: [Transaction] = [Transaction]()) {
        self.nickname = nickname
        self.type = type
        self.transactions = transactions
    }
}
