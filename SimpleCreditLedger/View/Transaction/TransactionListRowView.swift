//
//  TransactionListRowView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftData
import SwiftUI

struct TransactionListRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            CategoryLogoView(category: transaction.category, size: 30)
                .padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text(transaction.category.rawValue)
                    .font(.headline)
            }
            Spacer()
            let sign = transaction.transactionType == .expense ? "-" : "+"
            Text("\(sign)\(formatAsCurrency(transaction.amount))")
                .font(.headline)
                .foregroundStyle(transaction.transactionType == .expense ? .primary : Color.green)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Transaction.self, configurations: config)
        let example = Transaction(amount: 100.00, transactionType: .expense, category: .dining, date: .distantFuture, note: "")
        return TransactionListRowView(transaction: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
