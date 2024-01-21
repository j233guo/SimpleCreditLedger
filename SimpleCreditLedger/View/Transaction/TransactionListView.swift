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
                Text("No transaction found based on the filter criteria.")
            } else {
                let groupedTransactions: [Date: [Transaction]] = Dictionary(grouping: transactions) { data in
                    Calendar.current.startOfDay(for: data.date)
                }
                ForEach(groupedTransactions.keys.sorted { $0 > $1 }, id: \.self) { date in
                    Section(header: Text("\(date, formatter: sectionDateFormatter)")) {
                        ForEach(groupedTransactions[date]!, id: \.id) { data in
                            NavigationLink {
                                TransactionDetailView(transaction: data)
                            } label: {
                                TransactionListRowView(transaction: data)
                            }
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
        return TransactionListView(transactions: [example1, example2], filterExpanded: Binding.constant(true), startDate: Binding.constant(.now), endDate: Binding.constant(.now))
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
