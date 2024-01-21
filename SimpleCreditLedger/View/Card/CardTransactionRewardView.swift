//
//  CardTransactionRewardView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2024-01-20.
//

import SwiftData
import SwiftUI

fileprivate struct CardTransactionRewardRowView: View {
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    
    @State private var calculatedReward: Double = 0.0
    
    let transaction: Transaction
    
    func calculateRewards() {
        if let card = creditCardViewModel.currentCard {
            calculatedReward = calculateReward(card: card, transaction: transaction)
        }
    }
    
    var body: some View {
        HStack {
            CategoryLogoView(category: transaction.category, size: 30)
                .padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text(transaction.category.rawValue)
                    .font(.headline)
            }
            Spacer()
            if let card = creditCardViewModel.currentCard {
                if card.rewardType == .points {
                    let formattedReward = String(Int(calculatedReward))
                    Text("+ \(formattedReward) pts")
                        .font(.headline)
                        .foregroundStyle(.green)
                } else if card.rewardType == .cashback {
                    let formattedReward = formatAsCurrency(calculatedReward)
                    Text("+ \(formattedReward)")
                        .font(.headline)
                        .foregroundStyle(.green)
                }
            }
        }
        .onAppear {
            calculateRewards()
        }
        .onChange(of: transaction) {
            calculateRewards()
        }
    }
}

struct CardTransactionRewardView: View {
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    
    var transactions: [Transaction]
    
    @Binding var filterExpanded: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @State private var calculatedRewards: Double = 0.0
    
    private let sectionDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    func calculateRewards() {
        if let card = creditCardViewModel.currentCard {
            var reward = 0.0
            transactions.forEach { transaction in
                reward += calculateReward(card: card, transaction: transaction)
            }
            calculatedRewards = reward
        }
    }
    
    var body: some View {
        List {
            Section {
                FilterView(isExpanded: $filterExpanded, startDate: $startDate, endDate: $endDate)
            }
            
            Section {
                if let card = creditCardViewModel.currentCard {
                    let formattedRewards = card.rewardType == .points ? String(Int(calculatedRewards)) : formatAsCurrency(calculatedRewards)
                    Text("Total Rewards: \(formattedRewards) \(card.rewardType.rawValue)")
                }
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
        .onAppear {
            calculateRewards()
        }
        .onChange(of: transactions) {
            calculateRewards()
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
            .environmentObject(CreditCardViewModel())
    } catch {
        fatalError("Failed to create model container")
    }
}
