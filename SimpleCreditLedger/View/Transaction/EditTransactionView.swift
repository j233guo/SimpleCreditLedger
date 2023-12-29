//
//  EditTransactionView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-28.
//

import SwiftData
import SwiftUI

struct EditTransactionView: View {
    var transaction: Transaction
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query var creditCards: [CreditCard]
    
    @State private var tempTransactionType: TransactionType = .expense
    @State private var tempPaymentType: PaymentType? = .cash
    @State private var tempTransactionCategory: TransactionCategory = .dining
    @State private var tempTransactionAmount: Double = 0.0
    @State private var tempTransactionDate: Date = .now
    @State private var tempTransactionNote: String = ""
    @State private var tempPaymentCreditCard: CreditCard? = nil
    
    @FocusState private var amountIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    
    func save() {
        transaction.transactionType = tempTransactionType
        transaction.paymentType = tempTransactionType == .expense ? tempPaymentType : nil
        transaction.category = tempTransactionCategory
        transaction.amount = tempTransactionAmount
        transaction.date = tempTransactionDate
        transaction.note = tempTransactionNote
        transaction.creditCard = tempTransactionType == .expense ? tempPaymentType == .credit ? tempPaymentCreditCard : nil : nil
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Transaction Type", selection: $tempTransactionType) {
                        Text("Expense")
                            .tag(TransactionType.expense)
                        Text("Income")
                            .tag(TransactionType.income)
                    }
                    .pickerStyle(.segmented)
                    CategorySelectorView(type: tempTransactionType, category: $tempTransactionCategory)
                }
                .onChange(of: tempTransactionType) {
                    tempTransactionCategory = tempTransactionType == .income ? .salary : .dining
                }
                
                Section {
                    TextField("Amount", value: $tempTransactionAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .multilineTextAlignment(.center)
                        .focused($amountIsFocused)
                        .font(.system(size: 30))
                        .keyboardType(.decimalPad)
                } header: {
                    Text("Amount")
                }
                
                Section {
                    DatePicker("Date", selection: $tempTransactionDate, displayedComponents: .date)
                    if tempTransactionType == .expense {
                        Picker("Payment Type", selection: $tempPaymentType) {
                            Text("Cash")
                                .tag(PaymentType.cash as PaymentType?)
                            Text("Debit")
                                .tag(PaymentType.debit as PaymentType?)
                            if creditCards.count != 0 {
                                Text("Credit Card")
                                    .tag(PaymentType.credit as PaymentType?)
                            }
                        }
                        if tempPaymentType == .credit {
                            Picker("Credit Card", selection: $tempPaymentCreditCard) {
                                Text("Select a Card")
                                    .tag(nil as CreditCard?)
                                ForEach(creditCards) { card in
                                    Text("\(card.nickname)")
                                        .tag(card as CreditCard?)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    TextField("Notes", text: $tempTransactionNote)
                        .focused($noteIsFocused)
                } header: {
                    Text("Notes")
                }
            }
            .navigationTitle("Edit Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                }
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            amountIsFocused = false
                            noteIsFocused = false
                        }
                    }
                }
            }
        }
        .onAppear {
            tempTransactionType = transaction.transactionType
            tempPaymentType = transaction.paymentType
            tempTransactionCategory = transaction.category
            tempTransactionAmount = transaction.amount
            tempTransactionDate = transaction.date
            tempTransactionNote = transaction.note
            tempPaymentCreditCard = transaction.creditCard
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Transaction.self, configurations: config)
        let example = Transaction(amount: 100.00, transactionType: .expense, category: .dining, date: .distantFuture, note: "")
        return EditTransactionView(transaction: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
