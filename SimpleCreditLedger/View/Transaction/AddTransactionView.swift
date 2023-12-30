//
//  AddTransactionView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftData
import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query var creditCards: [CreditCard]
    
    @State private var tempTransactionType: TransactionType = .expense
    @State private var tempPaymentType: PaymentType = .cash
    @State private var tempTransactionCategory: TransactionCategory = .dining
    @State private var tempTransactionAmount: Double = 0.0
    @State private var tempTransactionDate: Date = .now
    @State private var tempTransactionNote: String = ""
    @State private var tempPaymentCreditCard: CreditCard? = nil
    @State private var showAmountEmptyWarning = false
    @State private var showCreditCardWarning = false
    
    @FocusState private var amountIsFocused: Bool
    @FocusState private var noteIsFocused: Bool
    
    var validateAmount: Bool { tempTransactionAmount > 0.0 }
    
    var validateCreditCard: Bool {
        if tempPaymentType == .credit {
            guard tempPaymentCreditCard != nil else { return false }
        }
        return true
    }
    
    func turnAmountEmptyWarning(_ value: Bool) {
        withAnimation {
            showAmountEmptyWarning = value
        }
    }
    
    func turnCreditCardWarning(_ value: Bool) {
        withAnimation {
            showCreditCardWarning = value
        }
    }
    
    func save() {
        guard validateAmount && validateCreditCard else {
            if !validateAmount {
                turnAmountEmptyWarning(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    turnAmountEmptyWarning(false)
                }
            }
            if !validateCreditCard {
                turnCreditCardWarning(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    turnCreditCardWarning(false)
                }
            }
            return
        }
        let newTransaction = Transaction(
            amount: tempTransactionAmount,
            transactionType: tempTransactionType,
            category: tempTransactionCategory,
            date: tempTransactionDate,
            note: tempTransactionNote
        )
        newTransaction.paymentType = tempTransactionType == .expense ? tempPaymentType : nil
        newTransaction.creditCard = tempTransactionType == .expense ? tempPaymentType == .credit ? tempPaymentCreditCard : nil : nil
        modelContext.insert(newTransaction)
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
                } footer: {
                    if showAmountEmptyWarning {
                        Text("Amount cannot be zero.")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    DatePicker("Date", selection: $tempTransactionDate, displayedComponents: .date)
                    if tempTransactionType == .expense {
                        Picker("Payment Type", selection: $tempPaymentType) {
                            Text("Cash")
                                .tag(PaymentType.cash)
                            Text("Debit")
                                .tag(PaymentType.debit)
                            if creditCards.count != 0 {
                                Text("Credit Card")
                                    .tag(PaymentType.credit)
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
                } footer: {
                    if showCreditCardWarning {
                        Text("Please select a credit card.")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    TextField("Notes", text: $tempTransactionNote)
                        .focused($noteIsFocused)
                } header: {
                    Text("Notes")
                }
            }
            .navigationTitle("New Transaction")
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
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, Transaction.self, configurations: config)
        return AddTransactionView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
