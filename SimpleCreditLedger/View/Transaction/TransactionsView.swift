//
//  TransactionsView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftData
import SwiftUI

struct TransactionsView: View {
    @State private var filterExpanded = false
    @State private var startDate: Date
    @State private var endDate: Date = .now
    
    @Query private var transactions: [Transaction]
    
    init() {
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
            Group {
                if transactions.count == 0 {
                    VStack {
                        Text("Empty Transaction List")
                            .font(.title)
                        Text("Tap on \"+\" to log a new transaction")
                            .font(.caption)
                    }
                } else {
                    let transactions = filterExpanded ? transactions.filter { transaction in
                        isDate(transaction.date, greaterThanOrEqualTo: startDate) && isDate(transaction.date, lessThanOrEqualTo: endDate)
                    } : transactions
                    TransactionListView(transactions: transactions, filterExpanded: $filterExpanded, startDate: $startDate, endDate: $endDate)
                }
            }
            .foregroundStyle(.secondary)
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, Transaction.self, configurations: config)
        return TransactionsView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
