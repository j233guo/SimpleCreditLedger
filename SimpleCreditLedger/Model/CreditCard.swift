//
//  CreditCard.swift
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
    var rewardType: RewardType
    @Relationship(deleteRule: .nullify, inverse: \Transaction.creditCard) var transactions = [Transaction]()
    @Relationship(deleteRule: .cascade, inverse: \Reward.card) var rewards = [Reward]()
    
    init(nickname: String, type: CardType, rewardType: RewardType) {
        self.nickname = nickname
        self.type = type
        self.rewardType = rewardType
    }
}
