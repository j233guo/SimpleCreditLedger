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

fileprivate struct PaymentInfoSection: View {
    let transaction: Transaction
    
    var calculatedReward: Double? {
        if incomeCategories.contains(transaction.category) {
            return nil
        }
        if let card = transaction.creditCard {
            return calculateReward(card: card, transaction: transaction)
        }
        return nil
    }
    
    var body: some View {
        if transaction.paymentType == .cash {
            Text("Cash")
                .foregroundStyle(.secondary)
        } else if transaction.paymentType == .debit {
            Text("Debit")
                .foregroundStyle(.secondary)
        } else if transaction.paymentType == .credit {
            if let card = transaction.creditCard {
                VStack {
                    HStack {
                        CardLogoView(cardType: card.type)
                        Text(card.nickname)
                            .foregroundStyle(.secondary)
                    }
                    .frame(height: 30)
                    Group {
                        if card.rewardType == .points {
                            if let points = calculatedReward {
                                Text("You earned \(String(Int(points))) points on this card.")
                            }
                        } else if card.rewardType == .cashback {
                            if let cash = calculatedReward {
                                Text("You earned \(formatAsCurrency(cash)) on this card.")
                            }
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }
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
                    if transaction.transactionType == .expense {
                        Divider()
                        PaymentInfoSection(transaction: transaction)
                    }
                    if transaction.note.isEmpty == false {
                        Divider()
                        Text(transaction.note)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            Section {
                Button("Edit Transaction") {
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
