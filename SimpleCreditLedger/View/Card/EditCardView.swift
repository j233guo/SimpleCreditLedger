//
//  EditCardView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-28.
//

import SwiftData
import SwiftUI

fileprivate struct AddRewardView: View {
    @Binding var expanded: Bool
    @Binding var tempRewardMultiplier: Double
    @Binding var tempRewardCategory: TransactionCategory
    
    let rewardType: RewardType
    
    let addAction: () -> Void
    
    var body: some View {
        if expanded {
            Group {
                Picker("\(rewardType == .cashback ? "Cash Back" : "Point") Multiplier", selection: $tempRewardMultiplier) {
                    ForEach(Array(stride(from: 0, through: 6, by: 0.25)), id: \.self) { number in
                        Text(formattedRewardMultiplier(rewardType, number))
                    }
                }
                Picker("Category", selection: $tempRewardCategory) {
                    ForEach(expenseCategories, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                HStack {
                    Button {
                        withAnimation {
                            expanded = false
                        }
                    } label: {
                        Text("Cancel")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                    Divider()
                    Button {
                        withAnimation {
                            addAction()
                            expanded = false
                        }
                    } label: {
                        Text("Add")
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }
                }
            }
        } else {
            Button {
                expanded = true
            } label: {
                Text("Add a Reward")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct EditCardView: View {
    var card: CreditCard
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var tempCardNickname: String = "My VISA Card"
    @State private var tempCardType: CardType = .visa
    @State private var tempRewardType: RewardType = .cashback
    @State private var expandAddReward = false
    @State private var tempRewardMultiplier: Double = 1.0
    @State private var tempRewardCategory: TransactionCategory = .misc
    
    @Query private var rewards: [Reward]
    
    var validateCardName: Bool { tempCardNickname.isEmpty == false }
    
    func updateDefaultCardName(for cardType: CardType) {
        func isDefaultName(_ str: String) -> Bool {
            let pattern = "^My\\s.+\\sCard$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
            return predicate.evaluate(with: str)
        }
        guard isDefaultName(tempCardNickname) else { return }
        tempCardNickname = "My \(tempCardType.rawValue) Card"
    }
    
    func saveCard() {
        guard validateCardName else { return }
        card.nickname = tempCardNickname
        card.type = tempCardType
        dismiss()
    }
    
    func saveReward() {
        let newReward = Reward(type: card.rewardType, category: tempRewardCategory, multiplier: tempRewardMultiplier, card: card)
        modelContext.insert(newReward)
        print(card.rewards)
    }
    
    func removeReward(_ reward: Reward) {
        modelContext.delete(reward)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Card Network", selection: $tempCardType) {
                        ForEach(CardType.allCases, id: \.self) { type in
                            HStack {
                                CardLogoView(cardType: type)
                                Text(type.rawValue)
                            }.tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                .onChange(of: tempCardType) {
                    updateDefaultCardName(for: tempCardType)
                }
                
                Section {
                    TextField("Enter a Name for the Card", text: $tempCardNickname)
                } header: {
                    Text("Card Nickname")
                } footer: {
                    if !validateCardName {
                        Text("You must have a name for your card.")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Picker("Card Reward Type", selection: $tempRewardType) {
                        ForEach(RewardType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }
                
                Section {
                    let rewards = rewards.filter {
                        $0.card == card
                    }
                    List {
                        ForEach(rewards) { reward in
                            Text("\(reward.category.rawValue)")
                        }
                    }
                } header: {
                    Text("Rewards")
                }
                
                Section {
                    AddRewardView(expanded: $expandAddReward, tempRewardMultiplier: $tempRewardMultiplier, tempRewardCategory: $tempRewardCategory, rewardType: tempRewardType) {
                        saveReward()
                    }
                }
            }
            .navigationTitle("Edit Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: saveCard)
                }
            }
        }
        .onAppear {
            tempCardType = card.type
            tempCardNickname = card.nickname
            tempRewardType = card.rewardType
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, Reward.self, configurations: config)
        let example = CreditCard(nickname: "My Amex Card", type: .amex, rewardType: .points)
        return EditCardView(card: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
