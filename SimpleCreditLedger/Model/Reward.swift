//
//  Reward.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-31.
//

import SwiftData
import Foundation

enum RewardType: String, CaseIterable, Codable {
    case cashback = "Cash Back"
    case points = "Reward Points"
}

extension Double {
    /// Converts `Double` to a string with up to 2 decimal places if needed.
    /// Removes trailing zeros for cleaner display.
    /// - Returns: String with the formatted number.
    func asMinimalDecimalString() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}


func formattedRewardMultiplier(_ rewardType: RewardType, _ number: Double) -> String {
    switch rewardType {
    case .cashback:
        return "\(number.asMinimalDecimalString())%"
    case .points:
        return "\(number.asMinimalDecimalString())x"
    }
}

@Model
final class Reward {
    var type: RewardType
    var category: TransactionCategory
    var multiplier: Double
    var card: CreditCard
    
    init(type: RewardType, category: TransactionCategory, multiplier: Double, card: CreditCard) {
        self.type = type
        self.category = category
        self.multiplier = multiplier
        self.card = card
    }
}
