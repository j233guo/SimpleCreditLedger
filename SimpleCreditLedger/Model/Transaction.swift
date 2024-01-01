//
//  Transaction.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import Foundation
import SwiftData
import SwiftUI

enum TransactionType: Codable {
    case income, expense
}

enum PaymentType: Codable {
    case cash, debit, credit
}

enum TransactionCategory: String, Codable, CaseIterable {
    case salary = "Salary"
    case investment = "Investment"
    case gift = "Gift"
    case refund = "Refund"
    
    case bill = "Bill"
    case dining = "Dining"
    case drugstore = "Drug Store"
    case entertainment = "Entertainment"
    case gas = "Gas"
    case grocery = "Grocery"
    case transit = "Transit"
    case travel = "Travel"
    case subscription = "Subscription"
    
    case misc = "Other"
}

fileprivate let categoryImageSystemNameDictionary: [TransactionCategory : String] = [
    .salary: "banknote",
    .investment: "chart.line.uptrend.xyaxis",
    .gift: "gift",
    .refund: "dollarsign.arrow.circlepath",
    .bill: "doc.plaintext",
    .dining: "fork.knife",
    .drugstore:  "cross.vial",
    .entertainment: "music.mic",
    .gas: "fuelpump",
    .grocery: "basket",
    .transit: "tram",
    .travel: "airplane.circle",
    .subscription: "music.note.tv",
    .misc: "cart.badge.questionmark"
]

fileprivate let categoryColorDictionary: [TransactionCategory : Color] = [
    .salary: .green,
    .investment: .green,
    .gift: .green,
    .refund: .green,
    .bill: .gray,
    .dining: .orange,
    .drugstore: .pink,
    .entertainment: .gray,
    .gas: .yellow,
    .grocery: .orange,
    .transit: .teal,
    .travel: .teal,
    .subscription: .gray,
    .misc: .gray
]

let incomeCategories: [TransactionCategory] = [.salary, .investment, .gift, .refund]
let expenseCategories: [TransactionCategory] = [.bill, .dining, .drugstore, .entertainment, .gas, .grocery, .transit, .travel, .subscription, .misc]

func categoryImageName(_ category: TransactionCategory) -> String {
    return categoryImageSystemNameDictionary[category] ?? "cart.badge.questionmark"
}

func categoryColor(_ category: TransactionCategory) -> Color {
    return categoryColorDictionary[category] ?? .gray
}

@Model
final class Transaction {
    var amount: Double
    var transactionType: TransactionType
    var paymentType: PaymentType?
    var category: TransactionCategory
    var date: Date
    var creditCard: CreditCard?
    var note: String
    
    init(amount: Double, transactionType: TransactionType, paymentType: PaymentType? = nil, category: TransactionCategory, date: Date, creditCard: CreditCard? = nil, note: String) {
        self.amount = amount
        self.transactionType = transactionType
        self.paymentType = paymentType
        self.category = category
        self.date = date
        self.creditCard = creditCard
        self.note = note
    }
}
