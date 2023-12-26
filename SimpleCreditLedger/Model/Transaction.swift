//
//  Transaction.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import Foundation
import SwiftData

enum TransactionType: Codable {
    case income, expense
}

enum PaymentType: Codable {
    case cash, debit, credit
}

enum TransactionCategory: String, Codable {
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

@Model
final class Transaction {
    var amount: Double
    var transactionType: TransactionType
    var paymentType: PaymentType?
    var category: TransactionCategory
    var Date: Date
    var creditCard: CreditCard?
    
    init(amount: Double, transactionType: TransactionType, paymentType: PaymentType? = nil, category: TransactionCategory, Date: Date, creditCard: CreditCard? = nil) {
        self.amount = amount
        self.transactionType = transactionType
        self.paymentType = paymentType
        self.category = category
        self.Date = Date
        self.creditCard = creditCard
    }
}
