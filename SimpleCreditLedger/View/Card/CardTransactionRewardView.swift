//
//  CardTransactionRewardView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2024-01-20.
//

import SwiftData
import SwiftUI

fileprivate struct CardTransactionRewardRowView: View {
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

struct CardTransactionRewardView: View {
    var transactions: [Transaction]
    
    @Binding var filterExpanded: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    private let sectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        List {
            Section {
                FilterView(isExpanded: $filterExpanded, startDate: $startDate, endDate: $endDate)
            }
            
            if transactions.count == 0 {
                Text("No transaction found.")
            } else {
                let groupedTransactions: [Date: [Transaction]] = Dictionary(grouping: transactions) { data in
                    Calendar.current.startOfDay(for: data.date)
                }
                ForEach(groupedTransactions.keys.sorted { $0 > $1 }, id: \.self) { date in
                    Section(header: Text("\(date, formatter: sectionDateFormatter)")) {
                        ForEach(groupedTransactions[date]!, id: \.id) { data in
                            CardTransactionRewardRowView(transaction: data)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Transaction.self, configurations: config)
        let example1 = Transaction(amount: 100.00, transactionType: .expense, category: .dining, date: .distantFuture, note: "")
        let example2 = Transaction(amount: 500.00, transactionType: .income, category: .salary, date: .now, note: "")
        return CardTransactionRewardView(transactions: [example1, example2], filterExpanded: Binding.constant(true), startDate: Binding.constant(.now), endDate: Binding.constant(.now))
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
