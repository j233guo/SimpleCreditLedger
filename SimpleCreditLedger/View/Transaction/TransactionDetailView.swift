//
//  TransactionDetailView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftData
import SwiftUI

fileprivate struct TransactionInfoSection: View {
    let transaction: Transaction
    
    var body: some View {
        VStack {
            let sign = transaction.transactionType == .expense ? "-" : "+"
            Text("\(sign)\(formatAsCurrency(transaction.amount))")
                .font(.system(size: 45))
                .bold()
                .fontDesign(.rounded)
                .padding()
            HStack {
                CategoryLogoView(category: transaction.category, size: 20)
                    .padding(.trailing, 5)
                Text(transaction.category.rawValue)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            Text(transaction.date.formatted(date: .long, time: .omitted))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct TransactionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var showDeleteConfirmation = false
    @State private var showEditTransactionForm = false
    
    var transaction: Transaction
    
    func deleteTransaction() {
        modelContext.delete(transaction)
        dismiss()
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .center) {
                    TransactionInfoSection(transaction: transaction)
                }
                .frame(maxWidth: .infinity)
            }
            Section {
                Button("Edit Transaction Info") {
                    showEditTransactionForm = true
                }
                Button("Delete This Transaction", role: .destructive) {
                    showDeleteConfirmation = true
                }
            }
        }
        .scrollDisabled(true)
        .navigationTitle("Transaction Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEditTransactionForm) {
            EditTransactionView(transaction: transaction)
        }
        .confirmationDialog("Confirm Delete", isPresented: $showDeleteConfirmation) {
            Button("Confirm Delete", role: .destructive, action: deleteTransaction)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, Transaction.self, configurations: config)
        let example = Transaction(amount: 500.00, transactionType: .income, category: .salary, date: .now, note: "lorem ipsum")
        return TransactionDetailView(transaction: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
