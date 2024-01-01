//
//  CardDetailView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftData
import SwiftUI

struct CardDetailView: View {
    let card: CreditCard
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var showEditCardForm = false
    @State private var showDeleteConfirmation = false
    
    @Query private var rewards: [Reward]
    
    func deleteCard() {
        modelContext.delete(card)
        dismiss()
    }
    
    func removeReward(_ reward: Reward) {
        modelContext.delete(reward)
    }
    
    var body: some View {
        let rewards = rewards.filter {
            $0.card == card
        }
        NavigationStack {
            List {
                HStack {
                    CardLogoView(cardType: card.type, size: 60.0)
                    Text(card.nickname)
                        .font(.headline)
                }
                
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
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, Reward.self, configurations: config)
        let example = CreditCard(nickname: "My Amex Card", type: .amex, rewardType: .points)
        return CardDetailView(card: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
