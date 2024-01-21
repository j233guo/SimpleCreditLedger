//
//  CardTransactionsView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2024-01-08.
//

import SwiftData
import SwiftUI

struct CardTransactionsView: View {
    @Query private var transactions: [Transaction]
    
    @State private var filterExpanded = false
    @State private var startDate: Date
    @State private var endDate: Date
    
    init(predicate: Predicate<Transaction>) {
        _transactions = Query(filter: predicate)
        if let date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
            _startDate = State(initialValue: date)
        } else {
            _startDate = State(initialValue: Date())
        }
        if let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            _endDate = State(initialValue: date)
        } else {
            _endDate = State(initialValue: Date())
        }
    }
    
    var body: some View {
        NavigationStack {
            let transactions = filterExpanded ? transactions.filter { transaction in
                isDate(transaction.date, greaterThanOrEqualTo: startDate) && isDate(transaction.date, lessThanOrEqualTo: endDate)
            } : transactions
            CardTransactionRewardView(transactions: transactions, filterExpanded: $filterExpanded, startDate: $startDate, endDate: $endDate)
                .navigationTitle("Transactions")
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, Transaction.self, configurations: config)
        let predicate = #Predicate<Transaction> { transaction in
            return true
        }
        return CardTransactionsView(predicate: predicate)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
