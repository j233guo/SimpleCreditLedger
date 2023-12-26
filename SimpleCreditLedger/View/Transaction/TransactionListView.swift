//
//  TransactionListView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftData
import SwiftUI

struct TransactionListView: View {
    var transactions: [Transaction]
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                Text(formatAsCurrency(transaction.amount))
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Transaction.self, configurations: config)
        let example1 = Transaction(amount: 100.00, transactionType: .expense, category: .dining, Date: .distantFuture, note: "")
        let example2 = Transaction(amount: 500.00, transactionType: .income, category: .salary, Date: .now, note: "")
        return TransactionListView(transactions: [example1, example2])
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
