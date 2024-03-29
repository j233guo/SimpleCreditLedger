//
//  CardDetailView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftData
import SwiftUI

fileprivate struct CardRewardsSection: View {
    @Query private var rewards: [Reward]
    
    init(predicate: Predicate<Reward>) {
        _rewards = Query(filter: predicate)
    }
    
    var body: some View {
        Section {
            ForEach(rewards) { reward in
                HStack {
                    Text("\(reward.category.rawValue)")
                    Spacer()
                    Text("\(formattedRewardMultiplier(reward.type, reward.multiplier))")
                    Text("\(reward.type == .cashback ? "Cashback" : "Point")")
                }
            }
        } header: {
            Text("Rewards")
        } footer: {
            if rewards.count == 0 {
                Text("You have not registered any reward on this card.")
            }
        }
    }
}

struct CardDetailView: View {
    let card: CreditCard
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var creditCardViewModel: CreditCardViewModel
    
    @State private var showEditCardForm = false
    @State private var showDeleteConfirmation = false
    
    func deleteCard() {
        modelContext.delete(card)
        dismiss()
    }
    
    func removeReward(_ reward: Reward) {
        modelContext.delete(reward)
    }
    
    var rewardPredicate: Predicate<Reward> {
        let cardName = card.nickname
        return #Predicate<Reward> { reward in
            reward.card.nickname == cardName
        }
    }
    
    var transactionPredicate: Predicate<Transaction> {
        let cardName = card.nickname
        return #Predicate<Transaction> { transaction in
            transaction.creditCard?.nickname == cardName
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    CardLogoView(cardType: card.type, size: 60.0)
                    Text(card.nickname)
                        .font(.headline)
                }
                
                CardRewardsSection(predicate: rewardPredicate)
                
                Section {
                    NavigationLink(destination: CardTransactionsView(predicate: transactionPredicate)) {
                        Text("Transactions on This Card")
                    }
                }
                
                Section {
                    Button("Edit Card") {
                        showEditCardForm = true
                    }
                    Button("Remove This Card", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
                
            }
            .navigationTitle("\(card.nickname)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showEditCardForm) {
            EditCardView(card: card)
        }
        .confirmationDialog("Confirm Delete", isPresented: $showDeleteConfirmation) {
            Button("Confirm Delete", role: .destructive, action: deleteCard)
        }
        .onAppear {
            creditCardViewModel.currentCard = card
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, Reward.self, configurations: config)
        let example = CreditCard(nickname: "My Amex Card", type: .amex, rewardType: .points)
        return CardDetailView(card: example)
            .modelContainer(container)
            .environmentObject(CreditCardViewModel())
    } catch {
        fatalError("Failed to create model container")
    }
}
