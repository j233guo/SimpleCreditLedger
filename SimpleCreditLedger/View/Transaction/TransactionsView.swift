//
//  TransactionsView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftData
import SwiftUI

struct TransactionsView: View {
    @Query private var transactions: [Transaction]
    
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
                    TransactionListView(transactions: transactions)
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
